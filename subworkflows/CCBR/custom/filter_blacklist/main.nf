

include { BWA_MEM        } from '../../../modules/ccbr/bwa/mem'
include { FILTER_ALIGNED } from '../../../modules/ccbr/samtools/filter_aligned'
include { BAM_TO_FASTQ   } from '../../../modules/ccbr/custom/bam_to_fastq'

workflow FILTER_BLACKLIST {
    take:
        ch_fastq_input      // channel: [ val(meta), path(fastq) ]
        ch_blacklist_index  // channel: [ val(meta), path(bwa/*) ]

    main:
        ch_versions = Channel.empty()

        BWA_MEM ( ch_fastq, ch_blacklist_index )
        FILTER_ALIGNED( BWA_MEM.out.bam )
        BAM_TO_FASTQ( BWA_MEM.out.bam )

        ch_versions = ch_versions.mix(
            BWA_MEM.out.versions,
            FILTER_ALIGNED.out.versions,
        )

    emit:
        reads =  BAM_TO_FASTQ.out.reads  // channel: [ val(meta), path(fastq) ]
        versions = ch_versions           // channel: [ path(versions.yml) ]
}
