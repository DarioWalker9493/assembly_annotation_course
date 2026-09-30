#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/read_QC/fastqc/fastqc_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/read_QC/fastqc/fastqc_%j.err
#SBATCH --partition=pshort_el8


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course

PACBIO_READ=${WORKDIR}/Lu-1/ERR11437310.fastq.gz

RNASEQ_R1=${WORKDIR}/RNAseq_Sha/ERR754081_1.fastq.gz
RNASEQ_R2=${WORKDIR}/RNAseq_Sha/ERR754081_2.fastq.gz

OUTDIR=${WORKDIR}/read_QC/fastqc


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
    ${PACBIO_READ} \
    ${RNASEQ_R1} \
    ${RNASEQ_R2}

