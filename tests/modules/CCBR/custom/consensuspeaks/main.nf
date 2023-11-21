#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CUSTOM_CONSENSUSPEAKS } from '../../../../../modules/CCBR/custom/consensuspeaks/main.nf'

workflow test_custom_consensuspeaks {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    CUSTOM_CONSENSUSPEAKS ( input )
}
