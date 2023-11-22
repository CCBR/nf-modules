process CONVERT_SICER {
    '''
    Convert SICER output to bed and broadPeak format.
    Adapted from https://github.com/CCBR/Pipeliner/blob/86c6ccaa3d58381a0ffd696bbf9c047e4f991f9e/Rules/ChIPseq.snakefile#L389-L431
    '''
    tag { meta.id }
    label 'process_single'

    container 'nciccbr/ccbr_ubuntu_base_20.04:v6.1'

    input:
        tuple val(meta), path(sicer_peaks)

    output:
        tuple val(meta), path("${sicer_peaks.baseName}.converted.bed"),        emit: bed
        tuple val(meta), path("${sicer_peaks.baseName}.converted.broadPeak"),  emit: peak, optional: true
        path("versions.yml"),                                                  emit: versions

    when:
        task.ext.when == null || task.ext.when

    script:
    template 'convert-sicer.py'

}
