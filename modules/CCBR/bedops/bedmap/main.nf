process BEDOPS_BEDMAP {
    tag { meta.id }
    label 'process_single'
    container 'nciccbr/ccbr_ubuntu_base_20.04:v6.1'

    input:
    tuple val(meta1), path(refbed)
    tuple val(meta2), path(mapbed)

    output:
    tuple val(meta2), path("*.mapped.bed"), emit: bed
    path "versions.yml"                   , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    bedmap \\
        --delim '\t' \\
        --echo-ref-name \\
        --count \\
        ${refbed} \\
        ${mapbed} \\
        > ${meta2.id}.mapped.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedops: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))
    END_VERSIONS
    """

    stub:
    """
    touch ${meta2.id}.mapped.bed versions.yml
    """
}
