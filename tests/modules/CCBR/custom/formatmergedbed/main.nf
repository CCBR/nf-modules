#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CAT_CAT                    } from '../../../../../modules/CCBR/cat/cat/main.nf'
include { BEDTOOLS_SORT  } from '../../../../../modules/CCBR/bedtools/sort/main.nf'
include { BEDTOOLS_MERGE             } from '../../../../../modules/CCBR/bedtools/merge/main.nf'
include { CUSTOM_FORMATMERGEDBED } from '../../../../../modules/CCBR/custom/formatmergedbed/main.nf'

workflow test_custom_formatmergedbed {

    ch_peaks = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                                 file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }

    peaks_grouped = ch_peaks
        .map{ meta, peak ->
            [ [id: meta.group], peak ]
        }
        .groupTuple()
    peaks_grouped | CAT_CAT
    BEDTOOLS_SORT(CAT_CAT.out.file_out, [])
    BEDTOOLS_MERGE( BEDTOOLS_SORT.out.sorted, ' -c 1,5,6,7,8,9 -o count,collapse,collapse,collapse,collapse,collapse ' )

    CUSTOM_FORMATMERGEDBED ( BEDTOOLS_MERGE.out.bed )
}
