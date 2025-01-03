# nf-modules

Reusable [modules](https://ccbr.github.io/nf-modules/docs/modules.html) and [subworkflows](https://ccbr.github.io/nf-modules/docs/subworkflows.html) for Nextflow pipelines

[![test](https://github.com/CCBR/nf-modules/actions/workflows/test.yml/badge.svg)](https://github.com/CCBR/nf-modules/actions/workflows/test.yml)
[![docs](https://img.shields.io/badge/docs-📖-blue)](https://ccbr.github.io/nf-modules/)
[![DOI](https://zenodo.org/badge/697904903.svg)](https://zenodo.org/doi/10.5281/zenodo.10223357)

## Usage

To re-use a module in your nextflow pipeline, first [install `nf-core tools`](https://nf-co.re/tools#installation), then run

```sh
nf-core modules \
  --git-remote https://github.com/CCBR/nf-modules \
  install [module]
```

replacing `[module]` with the name of the module you wish to install.

To update your local version of a module, run

```sh
nf-core modules \
  --git-remote https://github.com/CCBR/nf-modules \
  update [module]
```

Use the `subworkflows` command in place of the `modules` command to install or update subworkflows.

```sh
nf-core subworkflows \
  --git-remote https://github.com/CCBR/nf-modules \
  update [subworkflow]
```

View listings of available [modules](https://ccbr.github.io/nf-modules/docs/modules.html) and [subworkflows](https://ccbr.github.io/nf-modules/docs/subworkflows.html) on the [documentation website](https://ccbr.github.io/nf-modules/).

## Help & Contributing

Come across a **bug**? Open an [issue](https://github.com/CCBR/nf-modules/issues) and include a minimal reproducible example.

Have a **question**? Ask it in [discussions](https://github.com/CCBR/nf-modules/discussions).

Want to **contribute** to this project? Check out the [contributing guidelines](/.github/CONTRIBUTING.md).

## References

Many of the modules and subworkflows in this project reuse and adapt code from [nf-core/modules](https://github.com/nf-core/modules).
In those cases, credit is noted in the `meta.yml` file of the module/subworkflow and also listed here:

- [bedtools](modules/CCBR/bedtools) adapts the [nf-core bedtools module](https://github.com/nf-core/modules/tree/fff2c3fc7cdcb81a2a37c3263b8ace9b353af407/modules/nf-core/bedtools)
- [bwa](modules/CCBR/bwa) adapts the [nf-core bwa module](https://github.com/nf-core/chipseq/tree/51eba00b32885c4d0bec60db3cb0a45eb61e34c5/modules/nf-core/modules/bwa)
- [cat](modules/cat) adapts the [nf-core cat module](https://github.com/nf-core/modules/tree/9326d73af3fbe2ee90d9ce0a737461a727c5118e/modules/nf-core/cat)
- [cutadapt](modules/CCBR/cutadapt) adapts the [nf-core cutadapt module](https://github.com/nf-core/modules/tree/ef007b1ce5316506b8c27c3e7a62482409c6153c/modules/nf-core/cutadapt)
- [khmer](modules/CCBR/khmer) adapts the [nf-core khmer module](https://github.com/nf-core/modules/tree/b48a1efc8e067502e1a9bafbac788c1e0abdfc6a/modules/nf-core/khmer)
- [picard/samtofastq](modules/picard/samtofastq) adapts the [nf-core gatk4 samtofastq module](https://github.com/nf-core/modules/tree/ef007b1ce5316506b8c27c3e7a62482409c6153c/modules/nf-core/gatk4/samtofastq)
- [samtools/sort](modules/samtools/sort) adapts the [nf-core samtools sort module](https://github.com/nf-core/modules/tree/ef007b1ce5316506b8c27c3e7a62482409c6153c/modules/nf-core/samtools/sort/tests)
