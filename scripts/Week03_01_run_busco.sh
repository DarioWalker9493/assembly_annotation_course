#!/usr/bin/env bash

#SBATCH --time=06:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=busco
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/logs/busco_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/logs/busco_%j.err

WORKDIR=/data/users/dwalker/assembly_annotation_course
BUSCO=/containers/apptainer/busco_5.7.1.sif

cd ${WORKDIR}

mkdir -p busco_results

echo "===== Flye ====="
apptainer exec ${BUSCO} busco \
    -i assemblies/flye/assembly.fasta \
    -o flye \
    --out_path busco_results \
    -m genome \
    -l brassicales_odb10 \
    -c 16

echo "===== hifiasm ====="
apptainer exec ${BUSCO} busco \
    -i assemblies/hifiasm/Lu-1.bp.p_ctg.fa \
    -o hifiasm \
    --out_path busco_results \
    -m genome \
    -l brassicales_odb10 \
    -c 16

echo "===== LJA ====="
apptainer exec ${BUSCO} busco \
    -i assemblies/lja/assembly.fasta \
    -o lja \
    --out_path busco_results \
    -m genome \
    -l brassicales_odb10 \
    -c 16

echo "===== Trinity ====="
apptainer exec ${BUSCO} busco \
    -i assemblies/trinity.Trinity.fasta \
    -o trinity \
    --out_path busco_results \
    -m transcriptome \
    -l brassicales_odb10 \
    -c 16

echo "===== ALL BUSCO RUNS FINISHED ====="