#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=flye
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/flye_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/flye_%j.err


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course

READS=${WORKDIR}/Lu-1/ERR11437310.fastq.gz
OUTDIR=${WORKDIR}/assemblies/flye

CONTAINER=/containers/apptainer/flye_2.9.5.sif


# ----------------------------
# Run Flye
# ----------------------------

apptainer exec \
    --bind /data \
    ${CONTAINER} \
    flye \
    --pacbio-hifi ${READS} \
    --out-dir ${OUTDIR} \
    --threads 16
