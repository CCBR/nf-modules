import pathlib
import pysam
import pytest


@pytest.mark.workflow("samtools filter_aligned test_filter_aligned_paired_end")
def test_unaligned_paired(workflow_dir):
    unaligned_bam_file = pysam.AlignmentFile(
        pathlib.Path(workflow_dir, "output/filter/test.unaligned.bam"), "rb"
    )
    reads_paired = list()
    reads_unmapped = list()
    read_mates_unmapped = list()
    for read in unaligned_bam_file:
        reads_paired.append(read.is_paired)
        reads_unmapped.append(read.is_unmapped)
        read_mates_unmapped.append(read.mate_is_unmapped)
        if not read.is_paired or not read.is_unmappped or not read.mate_is_unmapped:
            print(
                f"{read.query_name}; is_paired: {read.is_paired} is_unmapped: {read.is_unmapped} mate_is_unmapped: {read.mate_is_unmapped}"
            )
    assert all(reads_paired) and all(reads_unmapped) and all(read_mates_unmapped)


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
