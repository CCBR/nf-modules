process BEDTOOLS_MAP {
    tag { meta.id }
    label 'process_single'

    container 'nciccbr/ccbr_ubuntu_base_20.04:v6.1'

    input:
    tuple val(meta), path(intervals1), path(intervals2)
    tuple val(meta2), path(chrom_sizes)

    output:
    tuple val(meta), path("*.${extension}"), emit: map
    path  "versions.yml"                   , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}.mapped"
    extension = intervals1.getExtension()
    def sizes = chrom_sizes ? "-g ${chrom_sizes}" : ''
    if ("$intervals1" == "${prefix}.${extension}" ||
        "$intervals2" == "${prefix}.${extension}")
        error "Input and output names are the same, use \"task.ext.prefix\" to disambiguate!"
    """
    bedtools \\
        map \\
        -a ${intervals1} \\
        -b ${intervals2} \\
        ${args} \\
        ${sizes} \\
        > ${prefix}.${extension}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$(bedtools --version | sed -e "s/bedtools v//g")
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}.mapped"
    extension = intervals1.getExtension()
    if ("${intervals1}" == "${prefix}.${extension}" ||
        "${intervals2}" == "${prefix}.${extension}")
        error "Input and output names are the same, use \"task.ext.prefix\" to disambiguate!"
    """
    touch ${prefix}.${extension}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$(bedtools --version | sed -e "s/bedtools v//g")
    END_VERSIONS
    """
}
