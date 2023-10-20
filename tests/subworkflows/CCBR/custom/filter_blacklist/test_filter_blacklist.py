import os
import pathlib
import pytest


@pytest.mark.workflow("filter_blacklist test_filter_blacklist_paired")
def test_unpaired_is_empty(workflow_dir):
    unpaired_fastq = pathlib.Path(
        workflow_dir, "output", "bam", "test.unpaired.fastq.gz"
    )
    assert os.stat(unpaired_fastq).st_size == 0
