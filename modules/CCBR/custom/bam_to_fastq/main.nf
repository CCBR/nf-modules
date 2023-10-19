process BAM_TO_FASTQ {
    tag { meta.id }
    label 'process_single'
    container "${ meta.single_end ? 'nciccbr/ccbr_ubuntu_base_20.04:v5' : 'nciccbr/ccbr_picard_2.27.5:v1' }"

    input:
        tuple val(meta), path(bam), path(bai)

    output:
        tuple val(meta), path("*.R?.fastq*"),       emit: reads
        tuple val(meta), path("*.unpaired.fastq*"), emit: unpaired, optional: true

    when:
        task.ext.when == null || task.ext.when

    script:
    if (meta.single_end) {
        """
        samtools bam2fq ${bam} | pigz -p ${task.cpus} > ${bam.baseName}.R1.fastq.gz
        """
    } else {
        """
        picard -Xmx${task.memory.toGiga()}G SamToFastq \\
            --VALIDATION_STRINGENCY SILENT \\
            --INPUT ${bam} \\
            --FASTQ ${bam.baseName}.R1.fastq \\
            --SECOND_END_FASTQ ${bam.baseName}.R2.fastq \\
            --UNPAIRED_FASTQ ${bam.baseName}.unpaired.fastq
        pigz -p ${task.cpus} *.fastq
        """
    }
    stub:
    """
    touch ${bam.baseName}.R1.fastq
    """
}
