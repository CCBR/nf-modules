#!/usr/bin/env python
"""
adapted from https://github.com/CCBR/ASPEN/blob/55f909d76500c3502c1c397ef3000908649b0284/workflow/scripts/ccbr_get_consensus_peaks.py
"""
import os
import uuid
import pandas


def main(peakfiles, outbed, filter, nofilter):
    deleteFiles = []

    rand_name = str(uuid.uuid4())

    # concat
    cmd = "cat"
    for p in peakfiles:
        cmd += " " + p
    cmd += " | cut -f1-3 > " + rand_name + ".concat.bed"

    deleteFiles.append(rand_name + ".concat.bed")
    print(cmd)
    os.system(cmd)

    # sort and merge
    cmd = (
        "bedSort "
        + rand_name
        + ".concat.bed "
        + rand_name
        + ".concat.bed && bedtools merge -i "
        + rand_name
        + ".concat.bed > "
        + rand_name
        + ".merged.bed"
    )

    deleteFiles.append(rand_name + ".merged.bed")
    print(cmd)
    os.system(cmd)

    # check merged count
    npeaks = len(open(rand_name + ".merged.bed").readlines())
    if npeaks == 0:
        exit("Number of merged peaks = 0")

    count = 0
    for p in peakfiles:
        count += 1
        sortedfile = p + ".sorted." + rand_name
        countfile = p + ".counts." + rand_name
        cmd = (
            "cut -f1-3 "
            + p
            + " > "
            + sortedfile
            + " && bedSort "
            + sortedfile
            + " "
            + sortedfile
        )
        print(cmd)
        os.system(cmd)
        cmd = (
            "bedmap --delim '\\t' --echo-ref-name --count "
            + rand_name
            + ".merged.bed "
            + sortedfile
            + "|awk -F'\\t' -v OFS='\\t' '{if (\$2>1){\$2=1}{print}}' > "
            + countfile
        )
        print(cmd)
        os.system(cmd)
        deleteFiles.append(countfile)
        deleteFiles.append(sortedfile)
        if count == 1:
            df = pandas.read_csv(countfile, delimiter="\\t")
            df.columns = ["peakid", countfile]
        else:
            dfx = pandas.read_csv(countfile, delimiter="\\t")
            dfx.columns = ["peakid", countfile]
            df = df.merge(dfx, on="peakid")

    df = df.set_index("peakid")
    df = df.sum(axis=1) / len(df.columns)
    df = pandas.DataFrame({"peakid": df.index, "score": df.values})

    with open(outbed, "w") as out:
        for index, row in df.iterrows():
            chrom, coords = row["peakid"].split(":")
            start, end = coords.split("-")
            if nofilter or float(row["score"]) > filter:
                out.write(
                    "%s\\t%s\\t%s\\t%s\\t%.3f\\t.\\tNA\\tNA\\tNA\\n"
                    % (chrom, start, end, row["peakid"], float(row["score"]))
                )

    for f in deleteFiles:
        os.remove(f)


if __name__ == "__main__":
    # arguments filled in via nextflow template
    main("${peakfiles}".split(), "${outbed}", float("${filter}"), bool("${nofilter}"))
