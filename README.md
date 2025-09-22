# DIA-NN Parallel Workflow Guide for Puhti

This guide explains how to use our automated workflow to run DIA-NN on a large number of samples in parallel on the Puhti.csc.fi cluster.

The idea is based on Brett S. Phinney's Youtube video [Running DIA-NN on an HPC cluster](https://youtu.be/75Gk6uQclc8?si=zZqzikGoCqnogNtn)

-----

## Overview

This system automates the 4-step DIA-NN workflow to maximize speed and ensure consistent results. You don't need to edit the core scripts or submit jobs manually. You only need to:

1.  Organize your data.
2.  Fill out a simple configuration file.
3.  Run a single submission command.

-----

## How This Workflow Works

This workflow is designed to first build a high-quality, experiment-specific spectral library from your data, and then use that library to get the best possible quantification.

Step 1: Initial Parallel Search

All your raw files are searched simultaneously against a large, general "predicted" library. The goal is to quickly identify every peptide that could possibly be in your samples.

Step 2: Create a Project-Specific Library

The results from all the initial searches are combined into a single, smaller library that is tailored to your specific experiment. It only contains peptides that were actually observed in your samples.

Step 3: Second Parallel Search

All your raw files are searched again, but this time against the smaller, high-quality project library created in Step 2. This re-analysis is faster and more accurate.

Step 4: Generate Final Report

The refined results from the second search are combined to generate the final quantification tables for your analysis.

-----

### Folder Structure

The entire system is organized to keep shared files separate from your individual projects.

```
DIA-NN/
├── 01_containers/         (Contains the DIA-NN .sif file)
├── 02_scripts/            (Contains the master scripts)
├── 03_resources/          (Contains shared lib files, etc.)
└── projects/              (This is where you'll create your project folders)
     └── userA/
           └── projectX/
                ├── raw_data/
                │   ├── sample1.d
                │   └── sample2.d
                ├── config.sh
                └── output/
                        ├── logs/
                        ├── lib/
                        ├── quant_step1/
                        ├── quant_step3/
                        └── report/
```
-----

## How to Run a New Project

Follow these four steps for each new analysis you want to run.

### Step 1: Set Up Your Project Folder

First, create a new directory for your project inside the `projects` folder. It's best practice to also create `config`, `raw_data`, and `output` subdirectories.

```bash
# Example for a new project called 'mouse_brain'
cd /scratch/project_2000752/DIA-NN/projects/
mkdir -p mouse_brain/config mouse_brain/raw_data mouse_brain/output
```

### Step 2: Prepare Your Data

Upload all your raw data files (`.d` files) into your project's `raw_data` directory.

Also remember upload FASTA files(.fasta)

### Step 3: Create and Edit Your `config.sh` File

This is the most **important** step. It tells the workflow where your files are and what DIA-NN settings to use.

1.  Copy the configuration template into your project's `config` folder.

    ```bash
    cp /scratch/project_2000752/DIA-NN/04_projects/dichengr/test/example_config.sh /scratch/project_2000752/DIA-NN/projects/your/project/
    ```

2.  Open your new `config.sh` file and edit the paths and parameters(Pay close attention to the variables marked with "CHANGE THIS").

      * `DATA_DIR`: Full path to your project's `raw_data` folder.
      * `OUTPUT_DIR`: Full path to your project's `output` folder.
      * `LIB_FILE`: Full path to the main spectral library you want to use.
      * `FASTA_FILE`: Full path to the FASTA file for your search.
      * `DIANN_SEARCH_PARAMS`: A single line containing all the command-line flags for your DIA-NN search (check Parameter Reference).

    **Note: Cluster resource settings (CPUs, memory, time) are pre-set in the master script for consistency.**

### Step 4: Submit the Workflow

You're now ready to launch the entire workflow. Run the master submission script from any location on Puhti, providing the full path to **your project's config file**.

```bash
# The path to the master script will not change.
# The only thing that changes for each project is the path to its config file.

/scratch/project_2000752/DIA-NN/02_shared_scripts/submit_diann_workflow.sh /scratch/project_2000752/DIA-NN/projects/mouse_brain/config/config.sh
```

## What Happens Next?

After you run the command, the script will print the Job IDs for each of the four steps. The entire workflow will now run automatically.

  * **To monitor your jobs:** Use the `squeue --me` command or check on puhti website -> active jobs.
  * **To check your results:** Once the final job is complete, your final report files will be located in your project's `output/report/` directory.
  * **To check for errors:** All log files from the run are saved in `output/logs/`.

-----

## DIA-NN Parameter Reference

You can control the analysis by adding or changing flags in the `DIANN_SEARCH_PARAMS` variable in your `config.sh` file.

The full, official list of all command-line flags is available on the **[DIA-NN GitHub Page](https://github.com/vdemichev/DiaNN?tab=readme-ov-file#command-line-reference)**.

### Common Parameters

Here are some of the most common flags you might use:

| Parameter | Example Value | What It Does |
| :--- | :--- | :--- |
| `--qvalue` | `0.01` | Sets the Precursor FDR (q-value) cutoff. 0.01 is 1%. |
| `--missed-cleavages`| `1` | Sets the maximum number of missed enzyme cuts allowed. |
| `--met-excision` | (no value) | Tells DIA-NN to consider peptides with the N-terminal methionine removed. |
| `--mass-acc` | `15` | Sets the MS2 fragment mass accuracy in ppm. |
| `--mass-acc-ms1` | `15` | Sets the MS1 precursor mass accuracy in ppm. |
| `--min-pep-len` | `8` | Sets the minimum length for a peptide to be considered. |
| `--fixed-mod` | `UniMod:4,57.021464,C` | Sets a fixed modification. The example is for carbamidomethylation on Cysteine. |
| `--var-mod` | `UniMod:35,15.994915,M` | Sets a variable modification. The example is for Oxidation on Methionine. The format is `UniMod:ID,MassShift,AminoAcids`. |
| `--cut` | `K*,R*` | Defines the enzyme cleavage rule. The example is for Trypsin, which cuts after Lysine (K) and Arginine (R). |
-----

**If confused and want to add more customized parameters, AI(ChatGPT, Gemini) is very helpful, but remember double check the parameter is really exist on DIAN-NN Github page**

