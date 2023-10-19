
process FILTER_ALIGNED {
    '''
    Given a bam file, filter out reads that aligned.
    '''
    tag { meta.id }
    label 'align'
    label 'process_higher'

    container 'nciccbr/ccbr_ubuntu_base_20.04:v5'

    input:
        tuple val(meta), path(bam), path(bai)

    output:
        tuple val(meta), path("*.unaligned.bam"), emit: bam
        path  "versions.yml"                    , emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def filter_flag = meta.single_end ? '4' : '12'
    """
    samtools view \\
      -@ ${task.cpus} \\
      -f ${filter_flag} \\
      -b \\
      -o ${prefix}.unaligned.bam \\
      ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """

    stub:
    """
    touch ${meta.id}.unaligned.bam versions.yml
    """
}
