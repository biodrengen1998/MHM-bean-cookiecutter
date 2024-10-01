# MHM-bean-cookiecutter
Custom cookiecutter template for analysis with bean (https://github.com/pinellolab/crispr-bean)

This github repository is built for analysis of CRISPR Base Editing tiling screens in the Nilsson/Mailand groups at NNF Center for Protein Research, SUND KU. 

You should be familiar with basic linux commands, like navigating the terminal, making new files, and ssh-ing into servers

In this template i supply a complete setup for running bean, either on the CPRome cluster or locally on a sufficiently powerful laptop.

## Installation

First, install cookiecutter using PyPI:

"""
pip install cookiecutter jinja_ospath
"""

Then, navigate to the directory you want to store the environment in.

run the command:

"""
cookiecutter https://github.com/biodrengen1998/MHM-bean-cookiecutter
"""

## Required metafiles for running BEAN

To run bean, you need 3 files in order to run. these have quite specific requirements and naming conventions.

descriptions are here.

https://pinellolab.github.io/crispr-bean/input.html#input

These are found in **Project_name**/input/metafiles/

Example files for each with correct formatting are included in 

**sample list**:

has columns: \n
R1_filepath,R2_filepath,sample_id,replicate,condition,time \n
observations: \n
filepath should be absolute

**guide list**:

has columns:\n
name,Region,pos,strand,chrom,sequence,reporter,barcode,5-nt PAM,genomic_pos,target_start,guide_len,start_pos,target_group \n

important: names must be unique, use include guide sequence, target/control type, and other useful information for downstream analysis

**gene_symbols**:
newline delimited list of genes, used in filter step. Names should be the primary symbol corresponding to the MANE transcript, which may differ from Uniprots annotation. 




