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
