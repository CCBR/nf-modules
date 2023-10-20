process BAM2FASTQ {
    tag { meta.id }
    label 'process_single'
    container "${ meta.single_end ? 'nciccbr/ccbr_ubuntu_base_20.04:v5' : 'nciccbr/ccbr_picard_2.27.5:v1' }"

    input:
        tuple val(meta), path(bam), path(bai)

    output:
        tuple val(meta), path("*.R?.fastq*"),       emit: reads
        tuple val(meta), path("*.unpaired.fastq*"), emit: unpaired, optional: true
        path("versions.yml"),                       emit: versions

    when:
        task.ext.when == null || task.ext.when

    script:
    if (meta.single_end) {
        """
        samtools bam2fq ${bam} | pigz -p ${task.cpus} > ${bam.baseName}.R1.fastq.gz

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
        END_VERSIONS
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

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            picard: \$(picard FastqToSam --version 2>&1 | grep -o 'Version:.*' | cut -f2- -d:)
        END_VERSIONS
        """
    }
    stub:
    """
    touch ${bam.baseName}.R1.fastq versions.yml
    """
}
