#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CAT_CAT                    } from '../../../../../modules/CCBR/cat/cat/main.nf'
include { BEDOPS_BEDMAP              } from '../../../../../modules/CCBR/bedops/bedmap/main.nf'
include { BEDTOOLS_SORT as SORT_CAT
          BEDTOOLS_SORT as SORT_PEAK } from '../../../../../modules/CCBR/bedtools/sort/main.nf'
include { BEDTOOLS_MERGE             } from '../../../../../modules/CCBR/bedtools/merge/main.nf'
include { CUSTOM_COMBINEPEAKCOUNTS   } from '../../../../../modules/CCBR/custom/combinepeakcounts/main.nf'
include { CUSTOM_NORMALIZEPEAKS      } from '../../../../../modules/CCBR/custom/normalizepeaks/main.nf'

workflow test_custom_normalizepeaks {

    ch_peaks = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                                 file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }
    ch_peaks | CUSTOM_NORMALIZEPEAKS
}
