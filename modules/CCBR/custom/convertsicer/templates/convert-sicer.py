#!/usr/bin/env python
import math
import platform


def main(infile, outbed, outpeak):
    with open(infile, "r") as f:
        intxt = f.readlines()
    # input columns if input-normalized: chrom, start, end, ChIP tag count, control tag count, p-value, fold-enrichment, q-value
    # input columns if no input: chrom, start, end, score
    outBroadPeak = [None] * len(intxt)
    outBed = [None] * len(intxt)
    for i in range(len(intxt)):
        tmp = intxt[i].strip().split("\\t")
        if len(tmp) == 8:
            # assuming that a p-value/q-value of 0 is super significant, -log10(1e-500)
            if tmp[5] == "0.0":
                pval = "500"
            else:
                pval = str(-(math.log10(float(tmp[5]))))
            if tmp[7] == "0.0":
                qval = "500"
                qvalScore = "5000"
            else:
                qval = str(-(math.log10(float(tmp[7]))))
                qvalScore = str(int(-10 * math.log10(float(tmp[7]))))
            outBroadPeak[i] = "\\t".join(
                tmp[0:3] + ["Peak" + str(i + 1), tmp[3], ".", tmp[6], pval, qval]
            )
            outBed[i] = "\\t".join(tmp[0:3] + ["Peak" + str(i + 1), qvalScore])
        else:
            score = str(int(float(tmp[3])))
            outBed[i] = "\\t".join(tmp[0:3] + ["Peak" + str(i + 1), score])
    # output broadPeak columns: chrom, start, end, name, ChIP tag count, strand, fold-enrichment, -log10 p-value, -log10 q-value
    with open(outbed, "w") as g:
        g.write("\\n".join(outBed))
    if outBroadPeak[0] != None:
        with open(outpeak, "w") as h:
            h.write("\\n".join(outBroadPeak))


def write_versions():
    with open("versions.yml", "w") as outfile:
        outfile.write('"${task.process}":\\\\n')
        outfile.write(f'  Python: "{platform.python_version()}"\\\\n')


if __name__ == "__main__":
    write_versions()
    main(
        "${sicer_peaks}",
        "${sicer_peaks.baseName}.converted.bed",
        "${sicer_peaks.baseName}.converted.broadPeak",
    )
