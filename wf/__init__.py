"""
perform reference-guided multiple sequence alignment of viral genomes.
"""

import subprocess
from pathlib import Path

from latch import small_task, workflow
from latch.types import LatchFile, LatchDir
from typing import Optional
import os


@small_task
def var_align_task(sequences: LatchFile, reference: str, email: str, output_dir: LatchDir, aligner: Optional[str] = "Minimap2", threads: str = str(-1)) -> LatchDir:

    # Defining outputs

    local_dir = "/root/var_output/"
    local_prefix = os.path.join(local_dir, "var")
    # Defining the subprocess
    var_cmd = [
        "ViralMSA.py",
        "-s",
        sequences.local_path,
        "-r",
        str(reference),
        "-e",
        str(email),
        "-o",
        str(local_prefix),
        "-a",
        str(aligner),
        "-t",
        str(threads),

    ]
    # Running the subprocess
    subprocess.run(var_cmd, check=True)
    return LatchDir(str(local_dir), output_dir.remote_path)


@workflow
def varalign(sequences: LatchFile, reference: str, email: str, output_dir: LatchDir, aligner: Optional[str] = "Minimap2", threads: str = str(-1)) -> LatchDir:
    """Perform reference-guided multiple sequence alignment of viral genomes.

    ViralMSA
    ----

    __metadata__:
        display_name: Assemble and Sort FastQ Files
        author:
            name:
            email:
            github:
        repository:
        license:
            id: MIT

    Args:

        sequences:
          Input file with sequences

          __metadata__:
            display_name: Sequences

        reference:
          Input the reference. *Tip, you can provide a GenBank accession number or simply use the name of the virus

          __metadata__:
            display_name: Reference 

        email:
          Input email

          __metadata__:
            display_name: Email

        threads:
          Number of threads

          __metadata__:
            display_name: Threads

        aligner:
          Choose aligner. Default is minimap2

          __metadata__:
            display_name: Aligner

        output_dir:
          Output directory. *Tip, creata a directory at the latch console

          __metadata__:
            display_name: Output directorys
    """

    return var_align_task(sequences=sequences, reference=reference, email=email, output_dir=output_dir, aligner=aligner, threads=threads)
