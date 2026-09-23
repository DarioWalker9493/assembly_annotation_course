#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/trinity_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/trinity_%j.err


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course

LEFT=${WORKDIR}/read_QC/fastp/ERR754081_1.trimmed.fastq.gz
RIGHT=${WORKDIR}/read_QC/fastp/ERR754081_2.trimmed.fastq.gz

OUTDIR=${WORKDIR}/assemblies/trinity


# ----------------------------
# Load software
# ----------------------------

module load Trinity/2.15.1-foss-2021a


# ----------------------------
# Run Trinity
# ----------------------------

Trinity \
    --seqType fq \
    --left ${LEFT} \
    --right ${RIGHT} \
    --max_memory 60G \
    --CPU 16 \
    --output ${OUTDIR}