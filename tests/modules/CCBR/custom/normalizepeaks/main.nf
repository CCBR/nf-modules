#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CAT_CAT                    } from '../../../../../modules/CCBR/cat/cat/main.nf'
include { BEDOPS_BEDMAP              } from '../../../../../modules/CCBR/bedops/bedmap/main.nf'
include { BEDTOOLS_SORT as SORT_CAT
          BEDTOOLS_SORT as SORT_PEAK } from '../../../../../modules/CCBR/bedtools/sort/main.nf'
include { BEDTOOLS_MERGE             } from '../../../../../modules/CCBR/bedtools/merge/main.nf'
include { CUSTOM_COMBINEPEAKCOUNTS   } from '../../../../../modules/CCBR/custom/combinepeakcounts/main.nf'
include { CUSTOM_NORMALIZEPEAKS      } from '../../../../../modules/CCBR/custom/normalizepeaks/main.nf'

workflow test_custom_normalizepeaks {

    ch_peaks = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                                 file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }
    // prepare reference
    peaks_grouped = ch_peaks
            .map{ meta, peak ->
                [ [id: meta.group], peak ]
            }
            .groupTuple()
        peaks_grouped | CAT_CAT
    SORT_CAT(CAT_CAT.out.file_out, [])
    SORT_CAT.out.sorted | BEDTOOLS_MERGE

    // map peaks to reference
    SORT_PEAK(ch_peaks, [])
    SORT_PEAK.out.sorted.combine(BEDTOOLS_MERGE.out.bed) | BEDOPS_BEDMAP

    counts_grouped = BEDOPS_BEDMAP.out.bed
            .map { meta, bed ->
                [ [id: meta.group], bed ]
            }
            .groupTuple()
    counts_grouped | CUSTOM_COMBINEPEAKCOUNTS

    ch_count_peak = CUSTOM_COMBINEPEAKCOUNTS.out.bed
        .cross(SORT_CAT.out.sorted)
        .map{ it ->
            it.flatten()
        }
        .map{ meta1, count, meta2, peak ->
            assert meta1.id == meta2.id
            [ meta1, count, peak ]
        }
    ch_count_peak | CUSTOM_NORMALIZEPEAKS
}
