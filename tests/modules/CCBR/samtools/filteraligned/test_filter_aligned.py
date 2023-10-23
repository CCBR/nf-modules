import pathlib
import pysam
import pytest


@pytest.mark.workflow("samtools filter_aligned test_filter_aligned_paired_end")
def test_unaligned_paired(workflow_dir):
    unaligned_bam_file = pysam.AlignmentFile(
        pathlib.Path(workflow_dir, "output/filter/test.unaligned.bam"), "rb"
    )
    reads_are_good = list()
    for read in unaligned_bam_file:
        reads_are_good.append(
            read.is_paired and read.is_unmapped and read.mate_is_unmapped
        )
    assert all(reads_are_good)


@pytest.mark.workflow("samtools filter_aligned test_filter_aligned_single_end")
def test_unaligned_single(workflow_dir):
    unaligned_bam_file = pysam.AlignmentFile(
        pathlib.Path(workflow_dir, "output/filter/test.unaligned.bam"), "rb"
    )
    reads_are_good = list()
    for read in unaligned_bam_file:
        reads_are_good.append(not read.is_paired and read.is_unmapped)
    assert all(reads_are_good)
