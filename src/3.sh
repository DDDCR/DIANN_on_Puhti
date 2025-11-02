#!/bin/bash
#SBATCH --job-name=diann_s3_research
#SBATCH --account=project_2000752
#SBATCH --partition=small
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=40
#SBATCH --mem=128G

source $1 # Load user config
QUANT_DIR_STEP3=$2
NEW_LIB_FILE=$3

D_FILES=("$DATA_DIR"/*.d)
D_PATH="${D_FILES[$SLURM_ARRAY_TASK_ID]}"

module load apptainer
apptainer exec -B /scratch:/scratch "$CONTAINER_SIF" /diann-2.2.0/diann-linux \
 --f "$D_PATH" \
 --lib "$NEW_LIB_FILE" \
 --fasta "$FASTA_FILE" \
 --threads $SLURM_CPUS_PER_TASK \
 --temp "$QUANT_DIR_STEP3" \
 --quant-ori-names \
 --out "$TMPDIR/disposable_report" \
 $DIANN_PARAMS
