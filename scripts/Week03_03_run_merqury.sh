#!/usr/bin/env bash

#SBATCH --time=08:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=merqury
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/merqury_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/merqury_%j.err


# ----------------------------
# Directories and variables
# ----------------------------

WORKDIR=/data/users/dwalker/assembly_annotation_course

READS=${WORKDIR}/Lu-1/ERR11437310.fastq.gz

FLYE=${WORKDIR}/assemblies/flye/assembly.fasta
HIFIASM=${WORKDIR}/assemblies/hifiasm/Lu-1.bp.p_ctg.fa
LJA=${WORKDIR}/assemblies/lja/assembly.fasta

OUTDIR=${WORKDIR}/merqury_results
CONTAINER=/containers/apptainer/merqury_1.3.sif

K=18

mkdir -p ${OUTDIR}

export OMP_NUM_THREADS=16


# ----------------------------
# Build meryl read database
# ----------------------------

echo "===== Building meryl database, k=${K} ====="

apptainer exec ${CONTAINER} \
    meryl k=${K} count \
    output ${OUTDIR}/Lu1.k${K}.meryl \
    ${READS}


# ----------------------------
# Merqury: Flye
# ----------------------------

echo "===== Merqury Flye ====="

mkdir -p ${OUTDIR}/flye
cd ${OUTDIR}/flye

apptainer exec ${CONTAINER} bash -c "
    export MERQURY=/usr/local/share/merqury
    \$MERQURY/merqury.sh \
        ${OUTDIR}/Lu1.k${K}.meryl \
        ${FLYE} \
        flye
"


# ----------------------------
# Merqury: hifiasm
# ----------------------------

echo "===== Merqury hifiasm ====="

mkdir -p ${OUTDIR}/hifiasm
cd ${OUTDIR}/hifiasm

apptainer exec ${CONTAINER} bash -c "
    export MERQURY=/usr/local/share/merqury
    \$MERQURY/merqury.sh \
        ${OUTDIR}/Lu1.k${K}.meryl \
        ${HIFIASM} \
        hifiasm
"


# ----------------------------
# Merqury: LJA
# ----------------------------

echo "===== Merqury LJA ====="

mkdir -p ${OUTDIR}/lja
cd ${OUTDIR}/lja

apptainer exec ${CONTAINER} bash -c "
    export MERQURY=/usr/local/share/merqury
    \$MERQURY/merqury.sh \
        ${OUTDIR}/Lu1.k${K}.meryl \
        ${LJA} \
        lja
"


echo "===== MERQURY FINISHED ====="
