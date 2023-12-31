process BEDTOOLS_SORT {
    tag { meta.id }
    label 'process_single'

    container 'nciccbr/ccbr_ubuntu_base_20.04:v6.1'

    input:
    tuple val(meta), path(intervals)
    path genome_file

    output:
    tuple val(meta), path("*.${extension}"), emit: sorted
    path  "versions.yml"                   , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args       = task.ext.args   ?: ''
    def prefix     = task.ext.prefix ?: "${intervals.baseName}.sorted"
    def genome_cmd = genome_file     ?  "-g $genome_file" : ""
    extension      = task.ext.suffix ?: intervals.extension
    if ("$intervals" == "${prefix}.${extension}") {
        error "Input and output names are the same, use \"task.ext.prefix\" to disambiguate!"
    }
    """
    bedtools \\
        sort \\
        -i ${intervals} \\
        ${genome_cmd} \\
        ${args} \\
        > ${prefix}.${extension}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$(bedtools --version | sed -e "s/bedtools v//g")
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}.sorted"
    extension  = task.ext.suffix ?: intervals.extension
    """
    touch ${prefix}.${extension}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedtools: \$(bedtools --version | sed -e "s/bedtools v//g")
    END_VERSIONS
    """
}
