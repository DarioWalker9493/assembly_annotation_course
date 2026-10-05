#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=mummer
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/mummer_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/mummer_%j.err

set -euo pipefail

WORKDIR=/data/users/dwalker/assembly_annotation_course

FLYE=${WORKDIR}/assemblies/flye/assembly.fasta
HIFIASM=${WORKDIR}/assemblies/hifiasm/Lu-1.bp.p_ctg.fa
LJA=${WORKDIR}/assemblies/lja/assembly.fasta

REF=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa

CONTAINER=/containers/apptainer/mummer4_gnuplot.sif
OUTDIR=${WORKDIR}/mummer_results

mkdir -p ${OUTDIR}


run_comparison () {

    REF_FASTA=$1
    QUERY_FASTA=$2
    NAME=$3

    echo "===== ${NAME} ====="

    mkdir -p ${OUTDIR}/${NAME}
    cd ${OUTDIR}/${NAME}

    apptainer exec \
        --bind ${WORKDIR}:${WORKDIR} \
        --bind /data/courses:/data/courses \
        ${CONTAINER} \
        nucmer \
        --prefix=${NAME} \
        --breaklen 1000 \
        --mincluster 1000 \
        ${REF_FASTA} \
        ${QUERY_FASTA}

    apptainer exec \
        --bind ${WORKDIR}:${WORKDIR} \
        --bind /data/courses:/data/courses \
        ${CONTAINER} \
        mummerplot \
        --filter \
        --layout \
        --fat \
        --large \
        -t png \
        -R ${REF_FASTA} \
        -Q ${QUERY_FASTA} \
        --prefix=${NAME} \
        ${NAME}.delta
}


# Assemblies vs TAIR10
run_comparison ${REF} ${FLYE} flye_vs_TAIR10
run_comparison ${REF} ${HIFIASM} hifiasm_vs_TAIR10
run_comparison ${REF} ${LJA} lja_vs_TAIR10

# Assemblies against each other
run_comparison ${FLYE} ${HIFIASM} flye_vs_hifiasm
run_comparison ${FLYE} ${LJA} flye_vs_lja
run_comparison ${HIFIASM} ${LJA} hifiasm_vs_lja

echo "===== MUMMER FINISHED ====="