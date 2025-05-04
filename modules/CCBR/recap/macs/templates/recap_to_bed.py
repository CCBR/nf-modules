#!/usr/bin/env python3
import sys


def main(input_filename, output_filename):
    comment_char = "#"
    header_line = "chr	start	end	length	abs_summit	pileup	-log10(pvalue)	fold_enrichment	-log10(qvalue)	name	1	1".split()
    header_found = False
    with open(input_filename, "r") as infile:
        with open(output_filename, "w") as outfile:
            for line in infile:
                if line.split() == header_line:
                    header_found = True
                elif header_found and not line.startswith(comment_char):
                    line_split = line.split()
                    (
                        chrom,
                        start,
                        end,
                        length,
                        abs_summit,
                        pileup,
                        pvalue,
                        fold_enrichment,
                        qvalue,
                        name,
                    ) = line_split[:10]
                    outfile.write("\t".join([chrom, start, end, name, pvalue]) + "\n")


if __name__ == "__main__":
    # arguments filled in via nextflow template
    main(sys.argv[1], sys.argv[2])
