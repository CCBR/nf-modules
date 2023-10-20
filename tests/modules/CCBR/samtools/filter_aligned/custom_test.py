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
    reads_single = list()
    reads_unmapped = list()
    for read in unaligned_bam_file:
        is_single = not read.is_paired
        reads_single.append(is_single)
        reads_unmapped.append(read.is_unmapped)
        if not is_single or not read.is_unmapped:
            print(
                f"{read.query_name}; is_single: {is_paired} is_unmapped: {read.is_unmapped}"
            )
    assert all(reads_single) and all(reads_unmapped)
