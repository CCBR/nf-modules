#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BEDTOOLS_MERGE } from '../../../../../modules/CCBR/bedtools/merge/main.nf'

workflow test_bedtools_merge {
    input = [ [ id:'test'],
              file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true)
            ]

    BEDTOOLS_MERGE ( input, '' )
}

workflow test_bedtools_merge_args {
    input = [ [ id:'test'],
              file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true)
            ]

    BEDTOOLS_MERGE ( input, ' -c 1,5 -o count,mean ' )
}
