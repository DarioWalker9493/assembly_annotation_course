#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc_trimmed
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/read_QC/fastqc/fastqc_trimmed_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/read_QC/fastqc/fastqc_trimmed_%j.err


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course
FASTP_DIR=${WORKDIR}/read_QC/fastp
OUTDIR=${WORKDIR}/read_QC/fastqc/trimmed

R1=${FASTP_DIR}/ERR754081_1.trimmed.fastq.gz
R2=${FASTP_DIR}/ERR754081_2.trimmed.fastq.gz


# ----------------------------
# Load software
# ----------------------------

module load FastQC/0.11.9-Java-11


# ----------------------------
# Create output directory
# ----------------------------

mkdir -p ${OUTDIR}


# ----------------------------
# Run FastQC
# ----------------------------

fastqc \
    --threads 4 \
    --outdir ${OUTDIR} \
    ${R1} \
    ${R2}