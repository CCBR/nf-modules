nextflow.enable.dsl = 2

include { SORT_BED } from '../../../../../modules/CCBR/sort/bed'


workflow test_sort_bed {

    input = Channel.fromPath([file(params.test_data.macs.broad.peaks_T0_1, checkIfExists: true),
                              file(params.test_data.macs.broad.peaks_T0_2, checkIfExists: true)])
        .map { peak ->
            [ [id: peak.baseName, group: 'macs_broad'], peak ]
        }
    SORT_BED(input)
}
