#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=lja
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/lja_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/lja_%j.err


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course

READS=${WORKDIR}/Lu-1/ERR11437310.fastq.gz
OUTDIR=${WORKDIR}/assemblies/lja

CONTAINER=/containers/apptainer/lja-0.2.sif


# ----------------------------
# Run LJA
# ----------------------------

apptainer exec \
    --bind /data \
    ${CONTAINER} \
    lja \
    -o ${OUTDIR} \
    --reads ${READS} \
    -t 16