
process FILTER_BLACKLIST {
    '''
    Given a bam file, filter out reads that aligned.
    '''
    tag { meta.id }
    label 'align'
    label 'process_higher'

    container 'nciccbr/ccbr_ubuntu_base_20.04:v5'

    input:
        tuple val(meta), path(bam)

    output:
        tuple val(meta), path("${meta.id}.no_blacklist.bam"), emit: bam

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def filter_flag = meta.single_end ? '4' : '12'
    """
    samtools view \\
      -@ ${task.cpus} \\
      -f${filter_flag} \\
      -b \\
      ${prefix}.bam > ${meta.id}.no_blacklist.bam
    """

    stub:
    """
    touch ${meta.id}.no_blacklist.bam
    """
}
