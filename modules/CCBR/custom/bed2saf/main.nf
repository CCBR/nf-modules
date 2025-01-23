process CUSTOM_BED2SAF {
    label 'process_single'

    input:
    tuple val(meta), path(bed)

    output:
    tuple val(meta), path("*.saf"), emit: saf
    path('versions.yml'), emit: versions

    script:
    def saf = "${bed.baseName}.saf"
    """
    #!/usr/bin/env python
    import platform

    with open("${saf}", 'w') as outfile:
        outfile.write('\\t'.join(['GeneID', 'Chr', 'Start', 'End', 'Strand']))
        with open("${bed}", 'r') as infile:
            for line in infile:
                (chr, start, end,) = line.strip().split('\\t')
                peak_id = f'{chr}:{start}-{end}'
                strand = '.' # no strand info available
                outfile.write('\\t'.join([peak_id, chr, start, end, strand]) + '\\n')

    with open("versions.yml", "w") as outfile:
        outfile.write('"${task.process}":\\n')
        outfile.write(f'  Python: "{platform.python_version()}"\\n')
    """

    stub:
    """
    touch ${bed.baseName}.saf versions.yml
    """
}
