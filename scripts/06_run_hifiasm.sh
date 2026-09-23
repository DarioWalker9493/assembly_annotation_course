#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifiasm
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/hifiasm_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/hifiasm_%j.err


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course

READS=${WORKDIR}/Lu-1/ERR11437310.fastq.gz
OUTDIR=${WORKDIR}/assemblies/hifiasm
PREFIX=${OUTDIR}/Lu-1

CONTAINER=/containers/apptainer/hifiasm_0.25.0.sif


# ----------------------------
# Create output directory
# ----------------------------

mkdir -p ${OUTDIR}


# ----------------------------
# Run hifiasm
# ----------------------------

apptainer exec \
    --bind /data \
    ${CONTAINER} \
    hifiasm \
    -o ${PREFIX} \
    -t 16 \
    ${READS}


# ----------------------------
# Convert primary contigs GFA to FASTA
# ----------------------------

awk '/^S/{print ">"$2;print $3}' \
    ${PREFIX}.bp.p_ctg.gfa \
    > ${PREFIX}.bp.p_ctg.fa