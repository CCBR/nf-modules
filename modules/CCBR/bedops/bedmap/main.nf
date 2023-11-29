process BEDOPS_BEDMAP {
    tag "${meta.id}.${refmeta.id}"
    label 'process_single'
    container 'nciccbr/ccbr_ubuntu_base_20.04:v6.1'

    input:
    tuple val(meta), path(mapbed), val(refmeta), path(refbed)

    output:
    tuple val(meta), path("*.mapped.bed"), emit: bed
    path "versions.yml"                  , emit: versions

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
        > ${meta.id}.${refmeta.id}.mapped.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedops: \$(echo \$(bedops --version 2>&1 | grep version | sed 's/version: //'))
    END_VERSIONS
    """

    stub:
    """
    touch ${meta.id}.${refmeta.id}.mapped.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bedops: \$(echo \$(bedops --version 2>&1 | grep version | sed 's/version: //'))
    END_VERSIONS
    """
}
