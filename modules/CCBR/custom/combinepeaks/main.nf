process CUSTOM_COMBINEPEAKS {
    """
    A helper script for the consensus_peaks subworkflow
    """
    tag { meta.id }
    label 'process_single'

    container 'nciccbr/spacesavers2:0.1.1'

    input:
    tuple val(meta), path(peakcounts)

    output:
    tuple val(meta), path("*.consensus.bed"), emit: bed
    path "versions.yml"                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def outfile = "${prefix}.consensus.bed"
    def count_files = peakcounts.join(' ')
    template 'combine_peaks.R'
    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        : \$(echo \$(R --version | grep 'R version' | sed 's/R version //; s/ (.*//'))
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.consensus.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        : \$(echo \$(R --version | grep 'R version' | sed 's/R version //; s/ (.*//'))
    END_VERSIONS
    """
}
