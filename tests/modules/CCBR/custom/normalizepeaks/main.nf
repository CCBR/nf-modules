#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CUSTOM_NORMALIZEPEAKS      } from '../../../../../modules/CCBR/custom/normalizepeaks/main.nf'

workflow test_custom_normalizepeaks {

    ch_peaks = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                                 file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }
    ch_peaks | CUSTOM_NORMALIZEPEAKS
}
