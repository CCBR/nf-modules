

Original files downloaded from https://github.com/nf-core/test-datasets/tree/modules/data/genomics/sarscov2/illumina/fastq

How subsets were created:

```sh
grep "^@" test_1.fastq | wc -l
grep -n "^@" test_1.fastq
head -n 40 test_1.fastq > test_1.subset.fastq
grep -n "^@" test_2.fastq
head -n 40 test_2.fastq > test_2.subset.fastq
```

Check tails of subset files to make sure they don't end with fastq headers:

```sh
tail -n 1 *subset.fastq
```
