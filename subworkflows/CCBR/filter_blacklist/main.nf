

include { BWA_MEM        } from '../../../../modules/ccbr/bwa/mem'
include { FILTER_ALIGNED } from '../../../../modules/ccbr/samtools/filter_aligned'
include { BAM2FASTQ   } from '../../../../modules/ccbr/custom/bam2fastq'

workflow FILTER_BLACKLIST {
    take:
        ch_fastq_input      // channel: [ val(meta), path(fastq) ]
        ch_blacklist_index  // channel: [ val(meta), path(bwa/*) ]

    main:
        ch_versions = Channel.empty()

        BWA_MEM ( ch_fastq_input, ch_blacklist_index )
        FILTER_ALIGNED( BWA_MEM.out.bam )
        BAM2FASTQ( BWA_MEM.out.bam )

        ch_versions = ch_versions.mix(
            BWA_MEM.out.versions,
            FILTER_ALIGNED.out.versions,
            BAM2FASTQ.out.versions
        )

    emit:
        reads =  BAM2FASTQ.out.reads  // channel: [ val(meta), path(fastq) ]
        versions = ch_versions           // channel: [ path(versions.yml) ]
}
