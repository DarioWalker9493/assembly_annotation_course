#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=02:00:00
#SBATCH --job-name=kmer_counting
#SBATCH --partition=pshort_el8
#SBATCH --output=/data/users/dwalker/assembly_annotation_course/read_QC/kmer_counting/kmer_%j.out
#SBATCH --error=/data/users/dwalker/assembly_annotation_course/read_QC/kmer_counting/kmer_%j.err


# ----------------------------
# Directories and variables
# ----------------------------
# Use HiFi fastq as imput (RNA would not work as there have different transcription levels would not work!)
# Used k- value of 21

WORKDIR=/data/users/dwalker/assembly_annotation_course

PACBIO_READ=${WORKDIR}/Lu-1/ERR11437310.fastq.gz

OUTDIR=${WORKDIR}/read_QC/kmer_counting

JF_FILE=${OUTDIR}/Lu-1_k21.jf
HISTO_FILE=${OUTDIR}/Lu-1_k21.histo


# ----------------------------
# Create output directory
# ----------------------------

mkdir -p ${OUTDIR}


# ----------------------------
# Load software
# ----------------------------

module load Jellyfish/2.3.0-GCC-10.3.0


# ----------------------------
# Count canonical 21-mers
# ----------------------------

jellyfish count \
    -C \
    -m 21 \
    -s 5G \
    -t 4 \
    -o ${JF_FILE} \
    <(zcat ${PACBIO_READ})


# ----------------------------
# Create k-mer histogram
# ----------------------------

jellyfish histo \
    -t 4 \
    ${JF_FILE} \
    > ${HISTO_FILE}