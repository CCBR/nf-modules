#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BWA_INDEX               } from '../../../../../modules/CCBR/bwa/index/main.nf'
include { BWA_MEM                 } from '../../../../../modules/CCBR/bwa/mem/main.nf'
include { SAMTOOLS_FILTERALIGNED } from '../../../../../modules/CCBR/samtools/filteraligned/main.nf'

//
// Test with single-end data
//
workflow test_filter_aligned_single_end {
    input = [
        [ id:'test', single_end:true ], // meta map
        [
            file(params.test_data['homo_sapiens']['illumina']['test_1_fastq_gz'], checkIfExists: true)
        ]
    ]
    fasta = [
        [id: 'test'],
        file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    ]

    BWA_INDEX ( fasta )
    BWA_MEM ( input, BWA_INDEX.out.index )
    SAMTOOLS_FILTERALIGNED( BWA_MEM.out.bam )
}

//
// Test with paired-end data
//
workflow test_filter_aligned_paired_end {
    input = [
        [ id:'test', single_end:false ], // meta map
        [
            file(params.test_data['homo_sapiens']['illumina']['test_1_fastq_gz'], checkIfExists: true),
            file(params.test_data['homo_sapiens']['illumina']['test_2_fastq_gz'], checkIfExists: true)
        ]
    ]
    fasta = [
        [id: 'test'],
        file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    ]

    BWA_INDEX ( fasta )
    BWA_MEM ( input, BWA_INDEX.out.index )
    SAMTOOLS_FILTERALIGNED( BWA_MEM.out.bam )
}
