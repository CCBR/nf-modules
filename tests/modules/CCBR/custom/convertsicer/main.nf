#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CONVERT_SICER } from '../../../../../modules/CCBR/custom/convertsicer'

workflow test_convert_sicer {
    peaks = [
        [id: 'test'],
        file(params.test_data.sicer_peaks, checkIfExists: true)
    ]
    CONVERT_SICER(peaks)
}
