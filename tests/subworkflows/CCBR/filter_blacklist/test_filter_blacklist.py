import Bio
import Bio.SeqIO
import gzip
import pathlib
import pytest


@pytest.mark.workflow("filter_blacklist test_filter_blacklist_paired")
def test_unpaired_is_empty(workflow_dir):
    unpaired_fastq = pathlib.Path(
        workflow_dir, "output", "picard", "test.unpaired.fastq.gz"
    )
    with gzip.open(unpaired_fastq, "rt") as infile:
        lines = infile.readlines()
    assert len(lines) == 0


def get_record_ids(fastq_path):
    with gzip.open(fastq_path, "rt") as file_handle:
        ids = {rec.id.split("/")[0] for rec in Bio.SeqIO.parse(file_handle, "fastq")}
    return ids


def jaccard(set_1, set_2):
    return len(set_1.intersection(set_2)) / len(set_1.union(set_2))


@pytest.mark.workflow("filter_blacklist test_filter_blacklist_paired")
def test_blacklist_filtered_out(workflow_dir):
    blacklist = get_record_ids(
        pathlib.Path(workflow_dir, "output", "blacklist.fastq.gz")
    )
    out_1 = get_record_ids(
        pathlib.Path(workflow_dir, "output", "picard", "test_1.fastq.gz")
    )
    out_2 = get_record_ids(
        pathlib.Path(workflow_dir, "output", "picard", "test_2.fastq.gz")
    )
    assert (
        not blacklist.intersection(out_1)
        and not blacklist.intersection(out_2)
        and jaccard(out_1, out_2) == 1
    )
