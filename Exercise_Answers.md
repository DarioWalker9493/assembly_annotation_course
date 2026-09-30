# Answers to Exercise Questions

## Week 1

### Q1

**Read lengths:**  
PacBio HiFi reads range from 62 to 46,056 bp. The Illumina RNA-seq reads are 101 bp paired-end reads.

**Quality:**  
The PacBio HiFi reads show good overall sequence quality. The variable read-length distribution is expected for long-read sequencing.

The RNA-seq data show good overall per-sequence quality, but FastQC reports reduced per-base quality as well as sequence-content bias, duplication and overrepresented sequences. Therefore, filtering/trimming with fastp is appropriate before downstream analysis.

### Q2

**RNA-seq filtering and trimming:**  
fastp reduced the dataset from 45,241,360 to 39,807,212 reads, meaning that 5,434,148 reads (12.0%) were filtered. Adapter sequences were trimmed from 3,510,455 reads.

Read quality improved, with the Q20 rate increasing from 88.9% to 93.8% and the Q30 rate from 78.6% to 83.6%. FastQC after trimming showed that overrepresented sequences were no longer detected and the per-base sequence quality of read 2 improved from FAIL to PASS.

Overall, the quality improved after fastp processing.

**PacBio coverage:**  
The PacBio HiFi dataset contains 570,354 reads and approximately 9.90 Gb of sequence data.

Assuming an *Arabidopsis thaliana* genome size of approximately 135 Mb, the expected genome coverage is about 73×.

### Q3

GenomeScope output:  
http://genomescope.org/genomescope2.0/analysis.php?code=I7GNN5lXW5JLtggInrp1

#### 1. Is the estimated genome size expected?

Yes. GenomeScope estimated a haploid genome size of approximately 135.24–135.32 Mb for Lu-1.

This is very close to the expected genome size of *Arabidopsis thaliana*. In the pan-genome study used for this course, the 69 accessions had assembly sizes between 128 and 148 Mb, with an average of approximately 135 Mb. Therefore, the estimated genome size is well within the expected range.

#### 2. Is the percentage of heterozygosity expected?

Yes. GenomeScope estimated a heterozygosity of approximately 0.047–0.058% (model estimate ≈ 0.052%), which is very low.

This is expected for *A. thaliana*, since it is predominantly self-fertilizing and natural accessions are usually highly homozygous. Population studies estimate that *A. thaliana* self-fertilizes approximately 97% of the time, strongly reducing heterozygosity within individuals.

#### 3. Is the coverage expected?

Yes, broadly. GenomeScope estimated `kmercov = 31.96`. For a diploid genome, this corresponds to the single-copy/heterozygous k-mer coverage; the major homozygous peak is therefore expected at approximately:

`2 × 31.96 ≈ 64×`

This is also visible in the k-mer spectrum.

Independently, the PacBio HiFi dataset contained 9.90 Gb of sequence. Using a genome size of about 135.3 Mb gives:

`9.90 Gb / 135.3 Mb ≈ 73×`

Thus, the ~64× homozygous k-mer peak is reasonably consistent with the ~73× coverage calculated directly from total sequenced bases. The values do not have to be identical because k-mer coverage is affected by sequencing errors, read ends, coverage variation and repetitive sequence.

#### Bonus: Why are we using canonical k-mers?

Canonical k-mers are used because sequencing reads can originate from either strand of the DNA molecule.

For each k-mer, the canonical representation treats the k-mer and its reverse complement as the same sequence, typically by storing only one standardized representation. This prevents the same genomic sequence from being counted separately depending on strand orientation and produces a strand-independent k-mer spectrum.

GenomeScope therefore recommends counting canonical k-mers with Jellyfish using the `-C` option.


## Week 2 - Assembly

### 1. What is the difference between a contig and a scaffold?

A **contig** is one continuous assembled DNA sequence without gaps.

A **scaffold** consists of multiple contigs that have been ordered and oriented relative to each other. The exact sequence between the contigs may still be unknown and is usually represented by gaps (`N`s).

### 2. Why can repetitive sequences make genome assembly difficult? Why is long-read sequencing particularly useful?

Repetitive sequences are difficult because the assembler may not be able to determine where a read originating from a repeat belongs in the genome. If a repeat is longer than the reads, several genomic positions may look identical.

Long reads are useful because they can span an entire repetitive region and also include unique sequence on both sides. This makes it easier to place the repeat correctly and generally improves assembly contiguity.

### 3. What happens when sequencing coverage is very low? What about extremely high coverage?

With **low coverage**, some parts of the genome may not be represented by enough reads. This can result in gaps, fragmented assemblies and missing sequences.

Higher coverage generally improves assembly because more overlapping reads are available. However, extremely high coverage can increase computational time and memory requirements and may add redundant information. Depending on the assembler, very high coverage can also make graph construction more complex.

### 4. What is the role of error correction in an assembly workflow? Is it always necessary with PacBio HiFi reads?

Error correction reduces sequencing errors before or during assembly. This makes overlaps between reads easier to detect and prevents sequencing errors from being incorporated into the final consensus sequence.

For older long-read technologies with relatively high error rates, error correction was especially important. PacBio HiFi reads already have very high per-read accuracy, so a separate correction step is often not necessary. Most modern HiFi assemblers can directly work with the raw HiFi reads and perform the required correction or consensus steps internally.

### 5. Why is it important to keep track of the exact command, software version and parameters used?

Assembly results depend on the software version and the parameters used. Recording the exact commands makes the analysis reproducible and allows other people, or ourselves later, to repeat the workflow and understand how a result was generated.

It also makes it easier to identify why two analyses produced different results.

### 6. If two students obtain different assemblies from the same reads, what technical reasons could explain this?

Possible technical reasons include:

- different assembler versions
- different command-line parameters
- different preprocessing or filtering of the reads
- different input files
- different random seeds or non-deterministic steps
- different software environments or dependencies
- different handling of intermediate files or failed/restarted jobs

### 7. What is the fundamental difference between genome assembly and transcriptome assembly?

Genome assembly aims to reconstruct the DNA sequence of the complete genome.

Transcriptome assembly reconstructs RNA transcripts from RNA-seq reads. It therefore represents genes that were expressed in the sampled tissue and condition rather than the complete genome.

### 8. Why can transcriptome assembly be more complicated than simply assembling all RNA reads into one sequence?

Different genes are expressed at very different levels, so transcript coverage can vary enormously.

In addition, one gene can generate several transcript isoforms through alternative splicing. Closely related genes and repetitive regions can also produce very similar transcripts. Therefore, the assembler has to distinguish different genes and isoforms instead of simply joining all overlapping RNA reads into one sequence.


## Week 3 - Assembly Evaluation and Genome Comparison

### BUSCO

#### 1. How do the genome assemblies look according to the BUSCO results? Is one genome assembly better than the others?

**Results pending.**

The main values to compare are:

- Complete BUSCOs (`C`)
- Complete single-copy BUSCOs (`S`)
- Complete duplicated BUSCOs (`D`)
- Fragmented BUSCOs (`F`)
- Missing BUSCOs (`M`)

A good genome assembly should contain a high proportion of complete BUSCOs and relatively few fragmented or missing BUSCOs.

| Assembly | Complete | Single-copy | Duplicated | Fragmented | Missing |
|---|---:|---:|---:|---:|---:|
| Flye |  |  |  |  |  |
| hifiasm |  |  |  |  |  |
| LJA |  |  |  |  |  |

#### 2. How does the transcriptome assembly look? Are there many duplicated genes? Can you explain the differences with the whole-genome assemblies?

**Results pending.**

More duplicated BUSCOs are expected in the Trinity transcriptome assembly than in the genome assemblies.

This can happen because a gene can produce several transcript isoforms, and Trinity may reconstruct multiple transcripts from the same gene. Allelic variants and fragmented/redundant transcript reconstructions can also increase the number of duplicated BUSCOs.

In addition, a transcriptome only contains genes that were expressed in the RNA-seq sample. Genes that were not expressed, or were expressed at very low levels, can therefore appear as missing even if they are present in the genome.


### QUAST

#### 1. How do the genome assemblies look according to the QUAST results? Is one genome assembly better than the others?

**Results pending.**

Important metrics to compare include:

- number of contigs
- total assembly length
- largest contig
- N50 / L50
- genome fraction
- number of misassemblies
- mismatches and indels

A more contiguous assembly generally has fewer contigs and a larger N50. However, contiguity alone does not prove correctness, so the reference-based metrics should also be considered.

| Metric | Flye | hifiasm | LJA |
|---|---:|---:|---:|
| Total length |  |  |  |
| Number of contigs |  |  |  |
| Largest contig |  |  |  |
| N50 |  |  |  |
| L50 |  |  |  |
| Genome fraction (%) |  |  |  |
| Misassemblies |  |  |  |

#### 2. What additional information do you get if you have a reference available?

Without a reference, QUAST mainly provides assembly statistics such as total length, contig number and N50.

With a reference genome, it can additionally determine how much of the reference is covered and identify structural differences or possible assembly errors. This includes metrics such as genome fraction, misassemblies, mismatches, indels and reference-based contiguity measures such as NGA50.

Since Lu-1 and the TAIR10 reference correspond to different *A. thaliana* accessions, not every difference from the reference is necessarily an assembly error. Some differences can represent real biological variation.


### Merqury

#### 1. What are the consensus quality QV and error-rate values of the assemblies?

**Results pending.**

Merqury estimates consensus quality using k-mers from the original HiFi reads. A higher QV means a lower estimated consensus error rate.

| Assembly | QV | Estimated error rate |
|---|---:|---:|
| Flye |  |  |
| hifiasm |  |  |
| LJA |  |  |

#### 2. What is the estimated completeness of the assemblies?

**Results pending.**

K-mer completeness measures the percentage of reliable read k-mers that are also present in the assembly. Higher values indicate that a larger fraction of the sequence information present in the reads was recovered in the assembly.

| Assembly | k-mer completeness (%) |
|---|---:|
| Flye |  |
| hifiasm |  |
| LJA |  |

#### 3. How does the copy-number spectrum look? Does it confirm the expected coverage?

**Results pending.**

The copy-number spectrum shows how k-mers from the reads are represented in the assembly. The major read-coverage peak should broadly agree with the coverage estimated in Week 1.

For Lu-1, the expected coverage is approximately 70×, with the GenomeScope homozygous k-mer peak around 64×.

A large number of reliable read k-mers missing from the assembly could indicate incomplete sequence, while excessive higher-copy representation could indicate duplicated sequence.

#### 4. Does one assembly perform better than the others?

**Results pending.**

The assemblies should be compared using all Merqury metrics together rather than QV alone. In particular, QV, k-mer completeness and the copy-number spectrum should all be considered.


### NUCmer and MUMmerplot

#### 1. What does the dotplot show and what do the different colors mean?

A dotplot visualizes sequence alignments between two genomes.

A long diagonal from the lower left to the upper right indicates regions with the same order and orientation in both genomes. Alignments in the opposite orientation appear as diagonals with the opposite slope and can indicate inversions.

In MUMmerplot, the colors distinguish alignment orientation. Forward alignments and reverse-complement alignments are shown in different colors.

#### 2. Do the genome assemblies look very different from the reference genome?

**Results pending.**

The overall structure can be evaluated from the dotplots. A mostly continuous main diagonal would indicate that the assembly is broadly collinear with the TAIR10 reference.

Breaks, off-diagonal alignments or reverse alignments can indicate structural differences, repetitive regions, assembly fragmentation or possible misassemblies.

Because Lu-1 and TAIR10 are different *A. thaliana* accessions, some differences are expected to represent real biological variation.

#### 3. How different are the genome assemblies compared with each other?

**Results pending.**

Since Flye, hifiasm and LJA were generated from the same PacBio HiFi reads, the major genomic structure should be highly similar.

Differences may occur in repetitive regions, unresolved regions, contig breaks and the handling of alternative or duplicated sequences.

#### 4. Compare the different accessions from your group. Do you see any differences between the accessions?

**To be completed after comparison with the other group members.**

Differences between accessions may appear as insertions, deletions, inversions or other structural variants in the dotplots. These differences should be distinguished from assembler-specific differences by comparing several assemblies and accessions.
