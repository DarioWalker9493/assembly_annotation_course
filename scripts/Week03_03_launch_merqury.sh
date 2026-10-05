#!/usr/bin/env bash
set -euo pipefail

# Usage:
# bash scripts/Week03_03_launch_merqury.sh <reads.fastq.gz> [k]
#
# Example:
# bash scripts/Week03_03_launch_merqury.sh \
#   Lu-1/ERR11437310.fastq.gz 21

WORKDIR=/data/users/dwalker/assembly_annotation_course
cd "$WORKDIR"

READS=$(realpath "$1")
K=${2:-21}

declare -A ASSEMBLIES=(
    [flye]="$WORKDIR/assemblies/flye/assembly.fasta"
    [hifiasm]="$WORKDIR/assemblies/hifiasm/Lu-1.bp.p_ctg.fa"
    [lja]="$WORKDIR/assemblies/lja/assembly.fasta"
)

echo "Reads: $READS"
echo "k: $K"
echo

# 1. Build read k-mer database
jid=$(sbatch --parsable \
    scripts/Week03_03a_run_meryl.sh \
    "$READS" "$K")

echo "meryl submitted: job $jid"

# 2. One Merqury job per assembly
for NAME in flye hifiasm lja; do

    mjid=$(sbatch --parsable \
        --dependency=afterok:$jid \
        scripts/Week03_03b_run_merqury.sh \
        "${ASSEMBLIES[$NAME]}" "$NAME")

    echo "merqury $NAME submitted: job $mjid (after $jid)"
done