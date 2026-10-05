#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=quast
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/quast_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/quast_%j.err

set -euo pipefail


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course

FLYE=${WORKDIR}/assemblies/flye/assembly.fasta
HIFIASM=${WORKDIR}/assemblies/hifiasm/Lu-1.bp.p_ctg.fa
LJA=${WORKDIR}/assemblies/lja/assembly.fasta

REF=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
GFF=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.57.gff3

QUAST=/containers/apptainer/quast_5.2.0.sif

OUTDIR=${WORKDIR}/quast_results

mkdir -p ${OUTDIR}


# ----------------------------
# QUAST without reference
# ----------------------------

echo "===== QUAST without reference ====="

apptainer exec ${QUAST} \
    quast.py \
    ${FLYE} \
    ${HIFIASM} \
    ${LJA} \
    --labels Flye,hifiasm,LJA \
    --eukaryote \
    --threads 16 \
    -o ${OUTDIR}/no_reference


# ----------------------------
# QUAST with TAIR10 reference
# ----------------------------

echo "===== QUAST with TAIR10 reference ====="

apptainer exec \
    --bind /data/courses:/data/courses \
    ${QUAST} \
    quast.py \
    ${FLYE} \
    ${HIFIASM} \
    ${LJA} \
    --labels Flye,hifiasm,LJA \
    --eukaryote \
    --threads 16 \
    -r ${REF} \
    --features ${GFF} \
    -o ${OUTDIR}/with_reference


echo "===== QUAST FINISHED ====="