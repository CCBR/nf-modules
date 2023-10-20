#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BWA_INDEX        } from "../../../../../modules/CCBR/bwa/index/main"
include { FILTER_BLACKLIST } from "../../../../../subworkflows/CCBR/filter_blacklist/main"


workflow test_filter_blacklist_single {
    input = [ [ id:'test', single_end:true ], // meta map
               file(params.test_data['test_1_fastq_gz'], checkIfExists: true)
    ]
    blacklist_reads = [
            [ id:'test', single_end:true ], // meta map
            file(params.test_data['test_1_subset_fastq_gz'], checkIfExists: true)
    ]
    BWA_INDEX(blacklist_reads)
    FILTER_BLACKLIST(input, BWA_INDEX.out.index)
}

workflow test_filter_blacklist_paired {
    input = [ [ id:'test', single_end:false ], // meta map
              [ file(params.test_data['test_1_fastq_gz'], checkIfExists: true),
                file(params.test_data['test_2_fastq_gz'], checkIfExists: true) ]
    ]
    blacklist_reads = [
              [ id:'test', single_end:false ], // meta map
              file(params.test_data['test_1_subset_fastq_gz'], checkIfExists: true)
    ]
    BWA_INDEX(blacklist_reads)
    FILTER_BLACKLIST(input, BWA_INDEX.out.index)
}
