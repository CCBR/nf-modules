#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BWA_INDEX      } from '../../../../../modules/CCBR/bwa/index/main.nf'
include { BWA_MEM        } from '../../../../../modules/CCBR/bwa/mem/main.nf'
include { CUSTOM_BAM2FASTQ   } from '../../../../../modules/CCBR/custom/bam2fastq/main.nf'

//
// Test with single-end data
//
workflow test_bam2fastq_single {
    input = [
        [ id:'test', single_end:true ], // meta map
        [
            file(params.test_data['sarscov2']['illumina']['test_1_fastq_gz'], checkIfExists: true)
        ]
    ]
    fasta = [
        [id: 'test'],
        file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
    ]

    BWA_INDEX ( fasta )
    BWA_MEM ( input, BWA_INDEX.out.index )
    CUSTOM_BAM2FASTQ( BWA_MEM.out.bam )
}

//
// Test with paired-end data
//
workflow test_bam2fastq_paired {
    input = [
        [ id:'test', single_end:false ], // meta map
        [
            file(params.test_data['sarscov2']['illumina']['test_1_fastq_gz'], checkIfExists: true),
            file(params.test_data['sarscov2']['illumina']['test_2_fastq_gz'], checkIfExists: true)
        ]
    ]
    fasta = [
        [id: 'test'],
        file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
    ]

    BWA_INDEX ( fasta )
    BWA_MEM ( input, BWA_INDEX.out.index )
    CUSTOM_BAM2FASTQ( BWA_MEM.out.bam )
}
