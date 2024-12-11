process RECAP_MACS {

    container 'nciccbr/recap:0.3.0'

    input:
        tuple val(meta), path(chip), path(input)

    output:
        tuple val(meta), path("${meta.id}/MACS_RECAP/*.xls"),                                        emit: recap
        tuple val(meta), path("${meta.id}/MACS_RECAP/${chip.baseName}.RECAP.bootstrap_1_peaks.bed"), emit: peaks

    script:
    def outdir = "${meta.id}"
    def recap_out = "${outdir}/MACS_RECAP/${chip.baseName}.RECAP.bootstrap_1_peaks.xls"
    def recap_bed = "${outdir}/MACS_RECAP/${chip.baseName}.RECAP.bootstrap_1_peaks.bed"
    """
    mkdir -p ${outdir}
    RECAP_MACS.sh \\
        -i `realpath ./` \\
        -t ${chip} \\
        -c ${input} \\
        -o `realpath ${outdir}` \\
        -b 1 -e 29 \\
        -s 20241211
    recap_to_bed.py ${recap_out} ${recap_bed}
    """
}
