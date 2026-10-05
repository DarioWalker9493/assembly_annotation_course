#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=run_meryl
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/meryl_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/meryl_%j.err

set -euo pipefail

# Usage:
# sbatch Week03_03a_run_meryl.sh <reads.fastq.gz> <k>

READS=$(realpath "$1")
K=$2

WORKDIR=/data/users/dwalker/assembly_annotation_course
OUTDIR=$WORKDIR/merqury_results_final
CONTAINER=/containers/apptainer/merqury_1.3.sif

mkdir -p "$OUTDIR"
cd "$OUTDIR"

echo "===== Meryl ====="
echo "Reads: $READS"
echo "k: $K"

# Remove old/incomplete files
rm -rf reads.meryl
rm -f reads.fastq

# Meryl in this container cannot read .fastq.gz directly
echo "===== Decompressing reads ====="
gzip -dc "$READS" > reads.fastq

echo "===== Building meryl database ====="

apptainer exec \
    --bind "$WORKDIR":"$WORKDIR" \
    "$CONTAINER" \
    meryl \
    k="$K" \
    threads="$SLURM_CPUS_PER_TASK" \
    memory=60 \
    count \
    output reads.meryl \
    reads.fastq

echo "===== Meryl finished ====="

# FASTQ is only temporary
rm -f reads.fastq