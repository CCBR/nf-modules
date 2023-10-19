#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BWA_INDEX        } from "../../../../modules/CCBR/bwa/index"
include { FILTER_BLACKLIST } from '../../../../subworkflows/CCBR/custom/filter_blacklist'


workflow test_filter_blacklist_single {
    input = [ [ id:'test', single_end:true ], // meta map
              file('../../../../data/genomics/sarscov2/illumina/fastq/test_1.fastq.gz', checkIfExists: true),
    ]
    blacklist_reads = [ [ id:'test', single_end:true ], // meta map
              file('../../../../data/genomics/sarscov2/illumina/fastq/test_1.subset.fastq.gz', checkIfExists: true),
    ]
    BWA_INDEX(blacklist_reads)
    FILTER_BLACKLIST(input, blacklist_reads)
}

workflow test_filter_blacklist_paired {
    input = [ [ id:'test', single_end:false ], // meta map
              file('../../../../data/genomics/sarscov2/illumina/fastq/test_1.fastq.gz', checkIfExists: true),
              file('../../../../data/genomics/sarscov2/illumina/fastq/test_2.fastq.gz', checkIfExists: true),
    ]
    blacklist_reads = [ [ id:'test', single_end:false ], // meta map
              file('../../../../data/genomics/sarscov2/illumina/fastq/test_1.subset.fastq.gz', checkIfExists: true),
              file('../../../../data/genomics/sarscov2/illumina/fastq/test_2.subset.fastq.gz', checkIfExists: true),
    ]
    BWA_INDEX(blacklist_reads)
    FILTER_BLACKLIST(input, blacklist_reads)
}
