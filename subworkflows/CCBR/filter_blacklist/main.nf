include { BWA_MEM                } from '../../../modules/CCBR/bwa/mem'
include { SAMTOOLS_FILTERALIGNED } from '../../../modules/CCBR/samtools/filteraligned'
include { SAMTOOLS_SORT          } from '../../../modules/CCBR/samtools/sort'
include { SAMTOOLS_FLAGSTAT      } from '../../../modules/CCBR/samtools/flagstat'
include { PICARD_SAMTOFASTQ      } from '../../../modules/CCBR/picard/samtofastq'

workflow FILTER_BLACKLIST {
    take:
        ch_fastq_input      // channel: [ val(meta), path(fastq) ]
        ch_blacklist_index  // channel: [ val(meta), path(bwa/*) ]

    main:
        ch_versions = Channel.empty()

        BWA_MEM ( ch_fastq_input, ch_blacklist_index )
        SAMTOOLS_FILTERALIGNED( BWA_MEM.out.bam )
        SAMTOOLS_SORT( SAMTOOLS_FILTERALIGNED.out.bam )
        SAMTOOLS_FLAGSTAT( SAMTOOLS_SORT.out.bam )
        PICARD_SAMTOFASTQ( SAMTOOLS_FILTERALIGNED.out.bam )

        ch_versions = ch_versions.mix(
            BWA_MEM.out.versions,
            SAMTOOLS_FILTERALIGNED.out.versions,
            SAMTOOLS_SORT.out.versions,
            SAMTOOLS_FLAGSTAT.out.versions,
            PICARD_SAMTOFASTQ.out.versions
        )

    emit:
        reads    =  PICARD_SAMTOFASTQ.out.paired  // channel: [ val(meta), path(fastq) ]
        flagstat = SAMTOOLS_FLAGSTAT.out.flagstat
        versions = ch_versions                    // channel: [ path(versions.yml) ]
}
