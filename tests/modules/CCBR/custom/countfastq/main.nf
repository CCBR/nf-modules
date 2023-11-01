#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CUSTOM_COUNTFASTQ } from '../../../../../modules/CCBR/custom/countfastq/main.nf'

workflow test_countfastq_single {
    input = [ [ id:'test', single_end:true ], // meta map
              [ file(params.test_data['test_1_fastq_gz'], checkIfExists: true) ]
            ]
    CUSTOM_COUNTFASTQ( input )
}

workflow test_countfastq_paired {
    input = [ [ id:'test', single_end:false ], // meta map
              [ file(params.test_data['test_1_fastq_gz'], checkIfExists: true),
                file(params.test_data['test_2_fastq_gz'], checkIfExists: true) ]
            ]

    CUSTOM_COUNTFASTQ ( input )
}

workflow test_countfastq_blank {
    input = [ [ id:'test', single_end:true ], // meta map
              [ file(params.test_data['test_blank_fastq_gz'], checkIfExists: true) ]
            ]
    CUSTOM_COUNTFASTQ( input )
}
