#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BEDTOOLS_SORT  } from '../../../modules/CCBR/bedtools/sort/'
include { CONSENSUS_PEAKS } from '../../../../subworkflows/CCBR/consensus_peaks'

workflow test_consensus_peaks_broad {

    input = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                              file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }
    BEDTOOLS_SORT(input, [])
    peaks = BEDTOOLS_SORT.out.sorted

    CONSENSUS_PEAKS( peaks, false )
}
