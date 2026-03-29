#!/usr/bin/env bash

mkdir -p ${outdir}
RECAP_MACS.sh \\
    -i `realpath ./` \\
    -t ${chip} \\
    -c ${input} \\
    -o `realpath ${outdir}` \\
    -b 1 -e 29 \\
    -s 20241211
#./recap_to_bed.py ${recap_out} ${recap_bed}
