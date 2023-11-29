include { CAT_CAT        } from '../../../modules/CCBR/cat/cat/'
include { BEDTOOLS_SORT  } from '../../../modules/CCBR/bedtools/sort/' // TODO use unix sort for better performance
include { BEDTOOLS_MERGE } from '../../../modules/CCBR/bedtools/merge/'
include { BEDOPS_BEDMAP  } from '../../../modules/CCBR/bedops/bedmap/'
include { CUSTOM_COMBINEPEAKCOUNTS  } from '../../../modules/CCBR/custom/combinepeakcounts/'
include { CUSTOM_NORMALIZEPEAKS     } from '../../../modules/CCBR/custom/normalizepeaks/'

workflow CONSENSUS_PEAKS {

    take:
        // channel: [ val(meta), peak ]
        // meta should contain a group variable by which the peaks will be grouped
        // peaks should already be sorted by chromosome name then by start pos
        ch_peaks
        // whether to normalize p-values and q-values
        normalize

    main:

        ch_versions = Channel.empty()

        peaks_grouped = ch_peaks
            .map{ meta, peak ->
                [ [id: meta.group], peak ]
            }
            .groupTuple()
        peaks_grouped | CAT_CAT
        BEDTOOLS_SORT( CAT_CAT.out.file_out, [] )
        peaks_cat_sorted = BEDTOOLS_SORT.out.sorted
        peaks_cat_sorted | BEDTOOLS_MERGE
        ch_peaks.combine(BEDTOOLS_MERGE.out.bed) | BEDOPS_BEDMAP

        counts_grouped = BEDOPS_BEDMAP.out.bed
            .map { meta, bed ->
                [ [id: meta.group], bed ]
            }
            .groupTuple()
        counts_grouped | CUSTOM_COMBINEPEAKCOUNTS
        consensus_peaks = CUSTOM_COMBINEPEAKCOUNTS.out.bed

        if (normalize) {
            ch_count_peak = CUSTOM_COMBINEPEAKCOUNTS.out.bed
                .cross(peaks_cat_sorted)
                .map{ it ->
                    it.flatten()
                }
                .map{ meta1, count, meta2, peak ->
                    assert meta1.id == meta2.id
                    [ meta1, count, peak ]
                }
            ch_count_peak | CUSTOM_NORMALIZEPEAKS
            consensus_peaks = CUSTOM_NORMALIZEPEAKS.out.bed
            ch_versions = ch_versions.mix(CUSTOM_NORMALIZEPEAKS.out.versions)
        }

        ch_versions = ch_versions.mix(
            CAT_CAT.out.versions,
            BEDTOOLS_SORT.out.versions,
            BEDTOOLS_MERGE.out.versions,
            BEDOPS_BEDMAP.out.versions,
            CUSTOM_COMBINEPEAKCOUNTS.out.versions
        )

    emit:
        peaks    = consensus_peaks
        versions = ch_versions
}
