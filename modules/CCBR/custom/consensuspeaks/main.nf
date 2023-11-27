process CUSTOM_CONSENSUSPEAKS {
    tag "${meta.id}.${meta.group}"
    label 'process_single'

    container 'nciccbr/ccbr_ucsc:v1'

    input:
    tuple val(meta), path(peaks)

    output:
    tuple val(meta), path("*.consensus_peaks.bed"), emit: peaks
    path "versions.yml"                           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    peakfiles = "${peaks.join(' ')}"
    outbed = "${meta.id}.${meta.group}.consensus_peaks.bed"
    filter = 0.5
    nofilter = false
    if (peaks.size() > 1) {
        template 'get_consensus_peaks.py'
    } else { // just copy the input if there's only one peak file
        """
        cp ${peakfiles} ${outbed}
        touch versions.yml
        """
    }


    stub:
    """
    touch ${meta.id}.${meta.group}.consensus_peaks.bed versions.yml
    """
}
