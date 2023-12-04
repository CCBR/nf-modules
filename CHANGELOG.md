## Development version

### New modules

- bedops/bedmap (#37)
- bedtools/map (#37)
- bedtools/merge (#37,#39)
- bedtools/sort (#37)
- cat/cat (#37)
- cat/fastq (#37)
- custom/combinepeakcounts (#37)
- custom/consensuspeaks (#37)
- custom/formatmergedbed (#39,#41)
- custom/normalizepeaks (#37,#39,#41)
- sort/bed (#39)

### New subworkflows

- consensus_peaks (#37,#39)

## nf-modules 0.1.0

Our documentation website is now live: <https://ccbr.github.io/nf-modules/> (#16)

### New modules

- bwa/index
- bwa/mem
  - also runs samtools sort & outputs index in bai format. (#12)
- custom/bam2fastq (#14,#22)
- custom/convertsicer (#36)
- custom/countfastq (#32)
- cutadapt (#11)
- khmer/uniquekmers (#7)
- picard/samtofastq (#21)
- samtools/filteraligned (#13,#20)
- samtools/sort (#24,#28)

### New subworkflows

- filter_blacklist (#17,#27)
