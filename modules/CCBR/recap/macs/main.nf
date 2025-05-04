process RECAP_MACS {

    container 'nciccbr/recap:0.3.2'

    input:
        tuple val(meta), path(chip), path(input)

    output:
        tuple val(meta), path("${meta.id}/MACS_RECAP/*.xls"),                                        emit: recap
        //tuple val(meta), path("${meta.id}/MACS_RECAP/${chip.baseName}.RECAP.bootstrap_1_peaks.bed"), emit: peaks

    script:
    def args      = task.ext.args ?: '-b 1 -e 29 -s 20241211'
    def outdir    = "${meta.id}"
    def recap_out = "${outdir}/MACS_RECAP/${chip.baseName}.RECAP.bootstrap_1_peaks.xls"
    //recap_bed = "${outdir}/MACS_RECAP/${chip.baseName}.RECAP.bootstrap_1_peaks.bed"
    """
    mkdir -p ${outdir}
    RECAP_MACS.sh \\
        -i ./ \\
        -t ${chip} \\
        -c ${input} \\
        -o ${outdir} \\
        ${args}
    """

    stub:
    """
    mkdir -p "${meta.id}/MACS_RECAP"
    touch "${meta.id}/MACS_RECAP/${chip.baseName}.RECAP.bootstrap_1_peaks.xls"
    """
}
