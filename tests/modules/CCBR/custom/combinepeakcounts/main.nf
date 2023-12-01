#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CAT_CAT                    } from '../../../../../modules/CCBR/cat/cat/main.nf'
include { BEDOPS_BEDMAP              } from '../../../../../modules/CCBR/bedops/bedmap/main.nf'
include { BEDTOOLS_SORT as SORT_CAT
          BEDTOOLS_SORT as SORT_PEAK } from '../../../../../modules/CCBR/bedtools/sort/main.nf'
include { BEDTOOLS_MERGE             } from '../../../../../modules/CCBR/bedtools/merge/main.nf'
include { CUSTOM_COMBINEPEAKCOUNTS        } from '../../../../../modules/CCBR/custom/combinepeakcounts/main.nf'

workflow test_custom_combinepeakcounts {

    ch_peaks = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                                 file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }
    // prepare reference
    ch_peaks
        .map{ meta, peak ->
            [ [id: 'test', group: 'macs_broad'], peak ]
        }
        .groupTuple() | CAT_CAT
    SORT_CAT(CAT_CAT.out.file_out, [])
    BEDTOOLS_MERGE( SORT_CAT.out.sorted, '' )

    // map peaks to reference
    SORT_PEAK(ch_peaks, [])
    SORT_PEAK.out.sorted.combine(BEDTOOLS_MERGE.out.bed) | BEDOPS_BEDMAP

    BEDOPS_BEDMAP.out.bed
        .map { meta, bed ->
            [ [id: meta.group], bed ]
        }
        .groupTuple() |
        CUSTOM_COMBINEPEAKCOUNTS
}
