#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastp
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/read_QC/fastp/fastp_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/read_QC/fastp/fastp_%j.err


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course

PACBIO_READ=${WORKDIR}/Lu-1/ERR11437310.fastq.gz

RNASEQ_R1=${WORKDIR}/RNAseq_Sha/ERR754081_1.fastq.gz
RNASEQ_R2=${WORKDIR}/RNAseq_Sha/ERR754081_2.fastq.gz

OUTDIR=${WORKDIR}/read_QC/fastp

mkdir -p ${OUTDIR}


# ----------------------------
# Load software
# ----------------------------

module load fastp/0.23.4-GCC-10.3.0


# ----------------------------
# RNA-seq: filter and trim
# ----------------------------

fastp \
    --in1 ${RNASEQ_R1} \
    --in2 ${RNASEQ_R2} \
    --out1 ${OUTDIR}/ERR754081_1.trimmed.fastq.gz \
    --out2 ${OUTDIR}/ERR754081_2.trimmed.fastq.gz \
    --detect_adapter_for_pe \
    --thread 4 \
    --html ${OUTDIR}/RNAseq_fastp.html \
    --json ${OUTDIR}/RNAseq_fastp.json


# ----------------------------
# PacBio HiFi: statistics only
# no filtering or adapter trimming
# ----------------------------

fastp \
    --in1 ${PACBIO_READ} \
    --out1 /dev/null \
    --disable_adapter_trimming \
    --disable_quality_filtering \
    --disable_length_filtering \
    --thread 4 \
    --html ${OUTDIR}/PacBio_fastp.html \
    --json ${OUTDIR}/PacBio_fastp.json