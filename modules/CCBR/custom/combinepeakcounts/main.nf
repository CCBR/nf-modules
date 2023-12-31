process CUSTOM_COMBINEPEAKCOUNTS {
    """
    A helper script for the consensus_peaks subworkflow
    """
    tag { meta.id }
    label 'process_single'

    container 'nciccbr/consensus_peaks:v1.1'

    input:
    tuple val(meta), path(counts)

    output:
    tuple val(meta), path("*.consensus.bed"), emit: bed
    path "versions.yml"                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    prefix = task.ext.prefix ?: "${meta.id}"
    outfile = "${prefix}.consensus.bed"
    count_files = "${counts.join(',')}"
    template 'combine_peaks.R'

    stub:
    prefix = task.ext.prefix ?: "${meta.id}"
    outfile = "${prefix}.consensus.bed"
    """
    touch ${outfile}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        : \$(echo \$(R --version | grep 'R version' | sed 's/R version //; s/ (.*//'))
    END_VERSIONS
    """
}
