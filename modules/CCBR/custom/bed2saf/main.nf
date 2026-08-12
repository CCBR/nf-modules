process CUSTOM_BED2SAF {
    label 'process_single'
    container 'python:3.14'

    input:
    tuple val(meta), path(bed)

    output:
    tuple val(meta), path("*.saf"), emit: saf
    tuple val("${task.process}"), val('python'), eval('python --version 2>&1 | sed "s/^Python //"'), topic: versions, emit: versions_python

    when:
    task.ext.when == null || task.ext.when

    script:
    def saf = "${bed.baseName}.saf"
    """
    #!/usr/bin/env python

    with open("${saf}", 'w') as outfile:
        outfile.write('\\t'.join(['GeneID', 'Chr', 'Start', 'End', 'Strand']))
        with open("${bed}", 'r') as infile:
            for line in infile:
                line_strip = line.strip().split('\\t')
                chr, start, end = line_strip[:3]
                peak_id = f'{chr}:{start}-{end}'
                strand = '.' # no strand info available
                outfile.write('\\t'.join([peak_id, chr, start, end, strand]) + '\\n')

    """

    stub:
    """
    touch ${bed.baseName}.saf
    """
}
