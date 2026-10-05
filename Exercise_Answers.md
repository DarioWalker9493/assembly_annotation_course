# Answers to Exercise Questions

## Week 1 — Read QC and k-mer analysis

### Q1. What can you say about the read lengths and read quality?

#### PacBio HiFi reads

The PacBio HiFi reads range from **62 to 46,056 bp**. This broad length distribution is expected for long-read sequencing.

The HiFi reads show good overall sequence quality and are suitable for genome assembly.

#### Illumina RNA-seq reads

The Illumina RNA-seq data consist of **101 bp paired-end reads**.

The raw RNA-seq data show good overall quality, but FastQC reported reduced per-base quality in read 2 as well as sequence-content bias, duplication and overrepresented sequences. Therefore, trimming and filtering with fastp was appropriate before transcriptome assembly.

---

### Q2. What changed after filtering/trimming, and what is the approximate PacBio coverage?

#### RNA-seq filtering and trimming

fastp reduced the dataset from **45,241,360 reads** to **39,807,212 reads**.

This corresponds to:

- **5,434,148 filtered reads**
- **12.0% of reads removed**
- **3,510,455 adapter-trimmed reads**

Read quality improved after processing:

| Metric | Before | After |
|---|---:|---:|
| Q20 | 88.9% | 93.8% |
| Q30 | 78.6% | 83.6% |

FastQC after trimming showed that the previously detected overrepresented sequences were no longer present and the per-base sequence quality of read 2 improved from **FAIL to PASS**.

Overall, the RNA-seq data quality improved clearly after fastp processing.

#### PacBio coverage

The PacBio HiFi dataset contains:

- **570,354 reads**
- approximately **9.90 Gb** of sequence data

Assuming an *Arabidopsis thaliana* genome size of approximately **135 Mb**:

`9.90 Gb / 135 Mb ≈ 73×`

The approximate sequence coverage is therefore **~73×**.

---

### Q3. GenomeScope analysis

GenomeScope output:

http://genomescope.org/genomescope2.0/analysis.php?code=I7GNN5lXW5JLtggInrp1

#### 1. Is the estimated genome size expected?

Yes.

GenomeScope estimated a haploid genome size of approximately **135.24–135.32 Mb** for Lu-1.

This is close to the expected size of an *A. thaliana* genome and is consistent with the genome sizes reported for different accessions in the pan-genome study.

#### 2. Is the percentage of heterozygosity expected?

Yes.

GenomeScope estimated a heterozygosity of approximately **0.047–0.058%**, with a model estimate of about **0.052%**.

This very low heterozygosity is expected for *A. thaliana*, which is predominantly self-fertilizing and therefore usually highly homozygous.

#### 3. Is the coverage expected?

Yes, broadly.

GenomeScope estimated:

`kmercov = 31.96`

For a diploid genome, the major homozygous k-mer peak is expected at approximately:

`2 × 31.96 ≈ 64×`

This is reasonably close to the independent sequence-depth estimate of approximately **73×** calculated from the total amount of PacBio sequence data.

The values do not need to be identical because k-mer coverage is affected by sequencing errors, read ends, coverage variation and repetitive sequence.

#### Bonus: Why are canonical k-mers used?

Canonical k-mers are used because sequencing reads can originate from either DNA strand.

A k-mer and its reverse complement are treated as the same sequence and represented by one standardized form. This avoids counting the same genomic sequence twice depending on strand orientation and produces a strand-independent k-mer spectrum.

---

# Week 2 — Assembly

### 1. What is the difference between a contig and a scaffold?

A **contig** is one continuous assembled DNA sequence without gaps.

A **scaffold** consists of multiple contigs that have been ordered and oriented relative to each other. Unknown sequence between contigs can be represented by gaps, usually written as `N`s.

---

### 2. Why can repetitive sequences make genome assembly difficult? Why is long-read sequencing particularly useful?

Repetitive sequences are difficult because an assembler may not be able to determine where a read originating from a repeat belongs in the genome.

If a repeat is longer than the reads, several genomic positions can appear identical.

Long reads are particularly useful because they can span an entire repetitive region and also contain unique sequence on both sides. This makes it easier to place the repeat correctly and generally improves assembly contiguity.

---

### 3. What happens when sequencing coverage is very low? What about extremely high coverage?

With **low coverage**, some regions of the genome may not be represented by enough reads. This can lead to:

- gaps
- fragmented assemblies
- missing sequence
- lower consensus confidence

Higher coverage usually improves assembly because more overlapping reads are available.

However, **extremely high coverage** can increase:

- runtime
- memory usage
- redundancy
- graph complexity

Depending on the assembler, very high coverage may therefore increase computational cost without providing much additional information.

---

### 4. What is the role of error correction in an assembly workflow? Is it always necessary with PacBio HiFi reads?

Error correction reduces sequencing errors before or during assembly.

This makes overlaps between reads easier to detect and reduces the probability that sequencing errors are incorporated into the final consensus sequence.

Separate error correction was especially important for older long-read technologies with relatively high error rates.

PacBio HiFi reads already have very high per-read accuracy, so a separate correction step is often not necessary. Modern HiFi assemblers can usually work directly with the HiFi reads and perform the required correction or consensus steps internally.

---

### 5. Why is it important to keep track of the exact command, software version and parameters used?

Assembly results depend on:

- software version
- parameters
- input files
- preprocessing steps
- software environment

Recording the exact commands and versions makes the analysis reproducible and allows other people, or ourselves later, to repeat the workflow and understand how each result was generated.

It also makes it easier to explain why two analyses may produce different results.

---

### 6. If two students obtain different assemblies from the same reads, what technical reasons could explain this?

Possible reasons include:

- different assembler versions
- different command-line parameters
- different preprocessing or filtering
- different input files
- different random seeds or non-deterministic steps
- different software environments or dependencies
- different handling of intermediate files
- restarted or partially failed jobs

---

### 7. What is the fundamental difference between genome assembly and transcriptome assembly?

Genome assembly aims to reconstruct the DNA sequence of the complete genome.

Transcriptome assembly reconstructs RNA transcripts from RNA-seq reads. It therefore represents genes that were expressed in the sampled tissue and condition rather than the complete genome.

---

### 8. Why can transcriptome assembly be more complicated than simply assembling all RNA reads into one sequence?

Transcriptome assembly is complicated because:

- different genes are expressed at very different levels
- transcript coverage varies strongly
- one gene can produce several isoforms through alternative splicing
- closely related genes can have highly similar sequences
- repetitive regions can create ambiguous overlaps

The assembler therefore has to distinguish different genes and transcript isoforms instead of simply joining all overlapping RNA reads into one sequence.

---

# Week 3 — Assembly Evaluation and Genome Comparison

## BUSCO

### 1. How do the genome assemblies look according to the BUSCO results? Is one genome assembly better than the others?

All three genome assemblies show very high BUSCO completeness.

| Assembly | Complete (%) | Single-copy (%) | Duplicated (%) | Fragmented (%) | Missing (%) |
|---|---:|---:|---:|---:|---:|
| Flye | 99.9 | 93.9 | 6.0 | 0.1 | 0.0 |
| hifiasm | 99.8 | 98.9 | 0.9 | 0.1 | 0.1 |
| LJA | 99.9 | 93.4 | 6.5 | 0.1 | 0.0 |

All three assemblies are highly complete.

Flye and LJA both contain **99.9% complete BUSCOs**, while hifiasm contains **99.8%**.

The main difference is the duplicated BUSCO fraction. Hifiasm has the highest single-copy fraction (**98.9%**) and only **0.9% duplicated BUSCOs**, whereas Flye and LJA contain **6.0%** and **6.5% duplicated BUSCOs**, respectively.

According to BUSCO alone, hifiasm has the cleanest single-copy representation, while all three assemblies are essentially complete.

---

### 2. How does the transcriptome assembly look? Are there many duplicated genes? Can you explain the differences with the whole-genome assemblies?

The Trinity transcriptome assembly has:

- **78.9% complete BUSCOs**
- **39.3% single-copy BUSCOs**
- **39.6% duplicated BUSCOs**
- **3.5% fragmented BUSCOs**
- **17.6% missing BUSCOs**

The duplicated BUSCO fraction is much higher than in the genome assemblies.

This is expected because one gene can produce several transcript isoforms, and Trinity can reconstruct multiple transcripts from the same gene. Redundant transcript reconstruction can also increase the duplicated BUSCO fraction.

The higher missing fraction is also expected because a transcriptome only contains genes that were expressed in the sampled tissue and condition. Genes that were not expressed, or were expressed at very low levels, may therefore be absent from the transcriptome assembly even though they are present in the genome.

---

## QUAST

### 1. How do the genome assemblies look according to the QUAST results? Is one genome assembly better than the others?

| Metric | Flye | hifiasm | LJA |
|---|---:|---:|---:|
| Total length | 138,067,424 bp | 158,432,934 bp | 149,680,743 bp |
| Number of contigs (>=500 bp) | 98 | 591 | 911 |
| Largest contig | 17,993,159 bp | 21,673,890 bp | 21,673,899 bp |
| N50 | 8,527,977 bp | 14,384,264 bp | 14,515,111 bp |
| L50 | 6 | 5 | 5 |
| N90 | 1,650,967 bp | 48,263 bp | 1,638,094 bp |
| Genome fraction (%) | 91.718 | 91.821 | 91.980 |
| Duplication ratio | 1.088 | 1.272 | 1.184 |
| Misassemblies vs TAIR10 | 4,668 | 5,480 | 5,600 |

The assemblies have different strengths.

**Flye**
- fewest contigs
- assembly size closest to the GenomeScope estimate
- lowest duplication ratio
- lower N50 than hifiasm and LJA

**hifiasm**
- high N50
- high largest-contig size
- highest duplication ratio
- very low N90, indicating many smaller contigs in addition to the large contigs

**LJA**
- highest N50
- highest genome fraction
- high contiguity
- more contigs than the other assemblies

There is therefore no single best assembly according to QUAST alone.

Flye is the most compact and least redundant, whereas LJA shows the strongest contiguity and slightly highest reference coverage.

The large number of reference-based misassemblies should be interpreted cautiously because Lu-1 and TAIR10 are different *A. thaliana* accessions. Some apparent differences may represent true biological variation rather than assembly errors.

---

### 2. What additional information do you get if you have a reference available?

Without a reference, QUAST mainly provides assembly statistics such as:

- total length
- number of contigs
- largest contig
- N50 / N90
- L50 / L90

With a reference genome, QUAST can additionally calculate:

- genome fraction
- duplication ratio
- misassemblies and local misassemblies
- mismatches
- indels
- aligned and unaligned sequence
- reference-based contiguity statistics such as NG50 and NGA50

These metrics allow the assembly to be compared with the expected genome structure.

Since Lu-1 and TAIR10 correspond to different *A. thaliana* accessions, not every difference from the reference should be interpreted as an assembly error.

---

## Merqury

### 1. What are the consensus quality QV and error-rate values of the assemblies?

| Assembly | Error k-mers | Total k-mers | QV | Estimated error rate (per base) | Approx. 1 error per |
|---|---:|---:|---:|---:|---:|
| Flye | 837 | 138,065,779 | 65.40 | 2.887 × 10^-7 | 3,464,007 bp |
| hifiasm | 8,751 | 158,421,114 | 55.80 | 2.630 × 10^-6 | 380,157 bp |
| LJA | 112,120 | 149,662,523 | 44.47 | 3.569 × 10^-5 | 28,022 bp |

Flye has the highest consensus QV and the lowest estimated error rate.

Hifiasm is intermediate.

LJA has substantially more assembly-only error k-mers and the lowest QV.

According to consensus accuracy, **Flye performs clearly best**.

---

### 2. What is the estimated completeness of the assemblies?

| Assembly | k-mer completeness (%) |
|---|---:|
| Flye | 99.23 |
| hifiasm | 98.81 |
| LJA | 99.34 |

All three assemblies recover a very high proportion of reliable read k-mers.

LJA has the highest k-mer completeness at **99.34%**, followed closely by Flye at **99.23%**.

Hifiasm is slightly lower at **98.81%**.

---

### 3. How does the copy-number spectrum look? Does it confirm the expected coverage?

From Week 1, GenomeScope estimated:

`kmercov = 31.96`

For a diploid genome, this corresponds to a major homozygous k-mer peak around approximately:

`2 × 31.96 ≈ 64×`

The independent sequence-depth estimate from the total PacBio HiFi data was approximately **73×**.

The Merqury copy-number spectrum should therefore show the major reliable read k-mer peak in approximately this coverage range.

The Merqury numerical results already show that all three assemblies recover most reliable read k-mers, with completeness values between **98.81% and 99.34%**.

A precise statement about the shape and exact peak position should be made from the spectra-cn plots themselves.

---

### 4. Does one assembly perform better than the others?

Overall, **Flye performs best according to Merqury**.

It has:

- the highest QV (**65.40**)
- the lowest estimated consensus error rate
- the fewest assembly-only error k-mers
- very high k-mer completeness (**99.23%**)

LJA has the highest k-mer completeness (**99.34%**), but its QV is substantially lower (**44.47**).

Hifiasm has intermediate consensus accuracy and the lowest k-mer completeness of the three.

Considering BUSCO, QUAST and Merqury together, **Flye provides the best overall balance for Lu-1**.

Hifiasm performs best for single-copy BUSCO representation, while LJA performs best for contiguity and k-mer completeness.

---

## NUCmer and MUMmerplot

### 1. What does the dotplot show and what do the different colors mean?

A dotplot visualizes pairwise sequence alignments between two assemblies or between an assembly and a reference genome.

A strong diagonal from the lower left to the upper right indicates regions with the same order and orientation in both sequences.

Alignments with the opposite slope indicate reverse-complement matches and can represent inversions.

In the generated MUMmerplots:

- **purple** segments represent forward-strand alignments
- **cyan** segments represent reverse-strand alignments

Six comparisons were generated:

- Flye vs TAIR10
- hifiasm vs TAIR10
- LJA vs TAIR10
- Flye vs hifiasm
- Flye vs LJA
- hifiasm vs LJA

---

### 2. Do the genome assemblies look very different from the reference genome?

No.

All three Lu-1 genome assemblies show a strong main diagonal against the *A. thaliana* TAIR10 reference.

This indicates that the assemblies are broadly **collinear with TAIR10** and that the large-scale chromosome structure is conserved.

Flye and LJA show particularly clear diagonals.

Hifiasm also shows the same overall structure but appears somewhat more fragmented and contains more additional small alignments.

A number of short reverse-strand alignments are visible, but there is no obvious evidence in the plots for a major chromosome-scale rearrangement.

Some off-diagonal matches are expected to arise from:

- repetitive sequence
- small contigs
- true structural differences between Lu-1 and TAIR10
- assembler-specific differences

Because Lu-1 and TAIR10 are different accessions, these differences should not automatically be interpreted as assembly errors.

---

### 3. How different are the genome assemblies compared with each other?

The three assemblies are highly similar in their large-scale genome structure.

All pairwise dotplots are dominated by a strong main diagonal, showing that the same genomic regions are generally assembled in the same order and orientation.

**Flye vs LJA** appears to be the cleanest pairwise comparison, suggesting that these two assemblies are structurally very similar.

**Flye vs hifiasm** and **hifiasm vs LJA** also show the same overall structure, but the hifiasm comparisons contain more additional or fragmented alignments.

This agrees with the other evaluation results, where hifiasm shows a larger total assembly size and a higher duplication ratio.

Overall, the three assemblies differ mainly in:

- smaller contigs
- repeated regions
- redundant sequence
- local inversions or alternative alignments

rather than in the global genome structure.

---

### 4. Compare the different accessions from your group. Do you see any differences between the accessions?

For Lu-1, the major genome structure is highly conserved relative to TAIR10 and between the three assemblers.

Differences between accessions would be expected to appear as:

- insertions
- deletions
- inversions
- repeat-associated differences
- other structural variants

These accession-specific differences should be distinguished from assembler-specific effects by comparing the same type of assembly across several accessions.

Based on Lu-1 alone, no major chromosome-scale abnormality is apparent.

---

# Overall conclusion for Lu-1

All three genome assemblers produced highly complete *A. thaliana* assemblies.

- **hifiasm** has the best single-copy BUSCO representation.
- **LJA** has the highest contiguity and slightly highest k-mer completeness.
- **Flye** has the fewest contigs, the lowest duplication ratio, the highest Merqury QV and the lowest estimated consensus error rate.

Therefore, **Flye is the best overall assembly for Lu-1** when all evaluation metrics are considered together.
