#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=run_merqury
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/merqury_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/merqury_%j.err

set -euo pipefail

# Usage:
# sbatch Week03_03b_run_merqury.sh <assembly.fa> <name>

ASM=$(realpath "$1")
NAME=$2

WORKDIR=/data/users/dwalker/assembly_annotation_course
ROOTDIR=$WORKDIR/merqury_results_final
OUTDIR=$ROOTDIR/$NAME

CONTAINER=/containers/apptainer/merqury_1.3.sif

mkdir -p "$OUTDIR"
cd "$OUTDIR"

echo "===== Merqury: $NAME ====="
echo "Assembly: $ASM"

# Copy read database into assembly-specific directory
rm -rf reads.meryl
cp -r ../reads.meryl .

apptainer exec \
    --bind "$WORKDIR":"$WORKDIR" \
    --env MERQURY=/usr/local/share/merqury \
    "$CONTAINER" \
    merqury.sh \
    reads.meryl \
    "$ASM" \
    "$NAME"

echo "===== Merqury $NAME finished ====="