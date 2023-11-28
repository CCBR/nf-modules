#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CAT_CAT                    } from '../../../../../modules/CCBR/cat/cat/main.nf'
include { BEDOPS_BEDMAP              } from '../../../../../modules/CCBR/bedops/bedmap/main.nf'
include { BEDTOOLS_SORT as SORT_CAT
          BEDTOOLS_SORT as SORT_PEAK } from '../../../../../modules/CCBR/bedtools/sort/main.nf'
include { BEDTOOLS_MERGE             } from '../../../../../modules/CCBR/bedtools/merge/main.nf'

workflow test_bedops_bedmap {

    ch_peaks = Channel.fromPath([file(params.test_data['macs_peaks_1'], checkIfExists: true),
                                 file(params.test_data['macs_peaks_2'], checkIfExists: true)])
        .map { peak ->
            [ [ id: 'test', group: 'macs_broad' ], peak ]
        }
    // prepare reference
    CAT_CAT(ch_peaks.groupTuple())
    SORT_CAT(CAT_CAT.out.file_out, [])
    SORT_CAT.out.sorted | BEDTOOLS_MERGE

    // map peaks to reference
    SORT_PEAK(ch_peaks, [])
    BEDOPS_BEDMAP( BEDTOOLS_MERGE.out.bed, SORT_PEAK.out.sorted )
}
