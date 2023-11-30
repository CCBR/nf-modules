process CUSTOM_NORMALIZEPEAKS {
    """
    Normalize p-values and q-values for consensus peaks
    """
    tag { meta.id }
    label 'process_single'

    container 'nciccbr/spacesavers2:0.1.1'

    input:
    tuple val(meta), path(peak)

    output:
    tuple val(meta), path("*norm.bed"), emit: bed
    path "versions.yml"               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    prefix = task.ext.prefix ?: "${meta.id}"
    outfile = "${peak.baseName}.norm.bed"
    template 'normalize_peaks.R'

    stub:
    """
    touch ${peak.baseName}.norm.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        : \$(echo \$(R --version | grep 'R version' | sed 's/R version //; s/ (.*//'))
    END_VERSIONS
    """
}
