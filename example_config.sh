#!/bin/bash

################################################################################
#                       DIA-NN WORKFLOW CONFIGURATION
################################################################################

# --- CORE PATHS ---
# (Required: Fill in the full paths for your project)

#CHANGE THIS: Directory containing your .d raw files
DATA_DIR="/scratch/project_2000752/DIA-NN/04_projects/dichengr/20250619_Phosphoenrichment_TIPS/raw_file"

#CHANGE THIS: Directory where all output folders will be created
OUTPUT_DIR="/scratch/project_2000752/DIA-NN/04_projects/dichengr/20250619_Phosphoenrichment_TIPS/output"

#CHANGE THIS: Path to your main spectral library (.speclib file) for the first search
LIB_FILE="/scratch/project_2000752/DIA-NN/03_resources/lib/20250618_human_phospho_report-lib.predicted.speclib"

#CHANGE THIS: Path to your FASTA file
FASTA_FILE="/scratch/project_2000752/DIA-NN/03_resources/fasta/Liu_20250618_uniprotkb_reviewed_human.fasta"

# Path to your DIA-NN Apptainer container (.sif file)
CONTAINER_SIF="/scratch/project_2000752/DIA-NN/01_containers/diann-2.2.0.sif"


# --- DIA-NN PARAMETERS ---
# (Customize the flags passed to DIA-NN)

DIANN_PARAMS="--verbose 2 --qvalue 0.01 --matrices --met-excision --cut K*,R* --missed-cleavages 1  --unimod4 --var-mod UniMod:21,79.966331,STY --var-mods 3 --mass-acc 15 --mass-acc-ms1 15 --peptidoforms --rt-profiling --pg-level 1 --min-pep-len 7 --max-pep-len 30 --min-pr-charge 2 --max-pr-charge 4 --min-pr-mz 300 --max-pr-mz 1600"
