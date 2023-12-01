#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CONSENSUS_PEAKS } from '../../../../subworkflows/CCBR/consensus_peaks'


workflow test_consensus_peaks_broad {

    input = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                              file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }
    CONSENSUS_PEAKS( input, false )
}

workflow test_consensus_peaks_mix_norm {

    broad = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                              file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }
    narrow = Channel.fromPath([file(params.test_data.macs.narrow.peaks_T0_1, checkIfExists: true),
                              file(params.test_data.macs.narrow.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_narrow'], peak ]
        }
    input = broad.mix(narrow)

    CONSENSUS_PEAKS( input, true )
}
