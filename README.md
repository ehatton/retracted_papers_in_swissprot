# Retracted papers in SwissProt

A notebook to identify references in SwissProt which are tagged as "Retracted publication" in PubMed.

Generates an output file in tsv format. The columns names in the file are:

1. __accession:__ UniProt accession
2. __scope:__ UniProt data types annotated from the paper (RP line fields)
3. __pmid:__ PubMed identifier of the retracted paper
4. __title:__ the title of the retracted paper
5. __retraction_notice_pmid:__ PubMed identifier of the related retraction notice, if this exists 

## Requirements

- python version 3.8 or above (the [Anaconda](https://www.anaconda.com/products/individual) distribution is recommended)

- [jupyterlab](https://jupyter.org/install)

- [pandas](https://pandas.pydata.org/)

- [papermill](https://papermill.readthedocs.io/en/latest/) (optional, for running the notebook as a script)

- [requests](https://requests.readthedocs.io/en/master/)

## Installation

Clone or download this directory:

```bash
 git clone https://github.com/ehatton/retracted_papers_in_swissprot.git
```

From the directory root, run this conda command to create a conda environment from the environment.yml file:

```bash
conda env create -f environment.yml
```

## Usage

Activate the conda virtual environment:

```bash
conda activate retracted_papers_in_swissprot
```

The notebook can be run from the command line using Papermill. A copy of the notebook named "log.ipynb" (which serves as a log), will be generated, leaving the original notebook unchanged. The optional parameter "report_file" can included (default file path is "uncurated_retractions.tsv"):

```bash
papermill retracted_papers_in_swissprot.ipynb log.ipynb -p report_file report.tsv
```

## Author

Emma Hatton-Ellis, November 2020.

## Licence

See ``LICENSE`` for information.
