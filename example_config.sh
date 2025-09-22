#!/bin/bash

################################################################################
#                       DIA-NN WORKFLOW CONFIGURATION
################################################################################

# --- CORE PATHS ---
# (Required: Fill in the full paths for your project)

#CHANGE THIS: Directory containing your .d raw files
DATA_DIR="/scratch/project_2000752/DIA-NN/04_projects/dichengr/test/raw_data"

#CHANGE THIS: Directory where all output folders will be created
OUTPUT_DIR="/scratch/project_2000752/DIA-NN/04_projects/dichengr/test/output2"

#VERIFY THIS: Path to your main spectral library (.speclib file) for the first search
LIB_FILE="/scratch/project_2000752/DIA-NN/03_resources/lib/20250618_human_phospho_report-lib.predicted.speclib"

#CHANGE THIS: Path to your FASTA file
FASTA_FILE="/scratch/project_2000752/DIA-NN/04_project/Liu_20250618_uniprotkb_reviewed_human.fasta"

# Path to your DIA-NN Apptainer container (.sif file)
CONTAINER_SIF="/scratch/project_2000752/DIA-NN/01_containers/diann-2.2.0.sif"


# --- DIA-NN PARAMETERS ---
# (Customize the flags passed to DIA-NN)

#CUSTOMIZE THIS: Parameters for the search steps (1 and 3).
DIANN_SEARCH_PARAMS="--missed-cleavages 1 --cut K*,R* --met-excision --fixed-mod UniMod:4,57.021464,C --var-mod UniMod:21,79.966331,STY --var-mods 3 --mass-acc 15 --mass-acc-ms1 15 --window 0 --qvalue 0.01 --rt-profiling"

# Parameters for the library generation step (2).
DIANN_LIBGEN_PARAMS="--gen-spec-lib --use-quant"

# Parameters for the final reporting step (4).
DIANN_REPORT_PARAMS="--matrices"