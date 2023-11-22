#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CUSTOM_CONSENSUSPEAKS } from '../../../../../modules/CCBR/custom/consensuspeaks/main.nf'

workflow test_custom_consensuspeaks {

    input = [
        [ id: 'test', group: 'macs_broad' ], // meta map
        [ file(params.test_data['macs_peaks_1'], checkIfExists: true),
          file(params.test_data['macs_peaks_2'], checkIfExists: true),
        ]
    ]

    CUSTOM_CONSENSUSPEAKS ( input )
}
