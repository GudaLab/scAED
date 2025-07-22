# scAED

Single Cell Active Enhancer Database (scAED)

We have developed the first active enhancer database at single‑cell resolution for both normal and disease conditions, named the Single Cell Active Enhancer Database (scAED).

---

## Table of Contents

- [Overview](#overview)
- [Interface](#interface)
- [Using the Enhancers Tab](#using-the-enhancers-tab)
  - [a. Total Enhancer Count](#a-total-enhancer-count)
  - [b. Cell Type Table](#b-cell-type-table)
  - [c. Enhancer Table](#c-enhancer-table)
  - [d. Overlapping Enhancers](#d-overlapping-enhancers)
- [Search Engine](#search-engine)
  - [a. Chromosomal Position Search](#a-chromosomal-position-search)
  - [b. Gene Search](#b-gene-search)
  - [c. Transcription Factor Search](#c-transcription-factor-search)
  - [d. Enhancer ID Search](#d-enhancer-id-search)
- [License](#license)

## Overview

scAED catalogs active enhancers at single‑cell resolution across normal and disease conditions, linking enhancers, transcription factors (TFs), promoters, and target genes in an interactive R Shiny application.

## Interface

The database is implemented as an R Shiny web application, offering:

- **Diagram view** of enhancer–promoter–gene relationships  
- **Data tables** listing chromosomal locations, enhancer IDs, coordinates, distances to nearest genes, and bound transcription factors  

![scAED Interface](https://github.com/user-attachments/assets/16e1302c-986e-4f28-8145-bea088d7aac2)
*Figure 1. Overview of the scAED interface.*

## Using the Enhancers Tab

The **Enhancers** tab lets you explore enhancer data with these filters:

- **Organ**: e.g., Brain, Pancreas  
- **State**: Healthy or Diseased  
- **Age**: Sample age  
- **Sex**: Male or Female  
- **Region**: Genomic region  
- **Output Image Format**: JPG, PNG  

Below the filters, set:

- **Dimensions** (inches)  
- **Resolution** (DPI: 72–300)  

Click **Submit** to generate plots.

### a. Total Enhancer Count

- **Cell Count per Cell Type**: Bar plot showing number of cells by type.  
- **Enhancer Count per Cell Type**: Bar plot showing number of enhancers per cell type.  

![Total Enhancer Count](https://github.com/user-attachments/assets/61ac608d-2f54-4596-9602-d1b277b6081c)
*Figure 2.1: Total Enhancer Count Tool.*

### b. Cell Type Table

Lists cell types alongside enhancer counts. Downloadable in CSV format.

![Cell Type Table](https://github.com/user-attachments/assets/9e603e80-3d8b-4a73-a28d-83d2ec24b072)
*Figure 2.2: Cell Type Table.*

### c. Enhancer Table

Select a cell type to view enhancers:

| Column                  | Description                                                     |
|-------------------------|-----------------------------------------------------------------|
| **Enhancer ID**         | e.g., En0100050273                                              |
| **Enhancer Name**       | e.g., chr1_10867180_10867323                                     |
| **Chromosome**          | e.g., chr1                                                      |
| **Start / End**         | Genomic coordinates                                             |
| **% Cells**             | Percentage of cells containing the enhancer                     |
| **Directionality**      | Bidirectional if applicable                                     |
| **Gene Symbols**        | Affected genes with strand (e.g., RRX1(+); GORAB(+))             |
| **Cell Line**           | Experimental cell line                                          |
| **Distance to Gene**    | Distance from nearest gene                                      |
| **Transcription Factor**| Bound transcription factors                                     |

Default view: 20 entries (expandable to 100). Download as CSV.

![Enhancer Table](https://github.com/user-attachments/assets/632a8874-f1ef-4bdd-881a-a0bf83070e69)
*Figure 2.3: Enhancer Table.*

### d. Overlapping Enhancers

Explore enhancers overlapping a specified genomic region by cell type and region.

![Overlaps Enhancers](https://github.com/user-attachments/assets/4365503a-769a-4942-89cb-6d77c663b614)
*Figure 2.4: Overlapping Enhancers.*

## Search Engine

The **Search Engine** tab provides four global search options:

### a. Chromosomal Position Search

Specify chromosome, start, and end positions to retrieve enhancers.

![Chromosomal Position Search](https://github.com/user-attachments/assets/f709e5ae-6943-4269-bb73-4f30370c83f4)
*Figure 3.1: Chromosomal Position Query.*

### b. Gene Search

Search by gene name or ID to find associated enhancers.

![Gene Search](https://github.com/user-attachments/assets/3a3a1701-80f4-4102-86b8-0aaa835c2148)
*Figure 3.2: Gene Search.*

### c. Transcription Factor Search

Input TF identifiers to find regulated enhancers.

![Transcription Factor Search](https://github.com/user-attachments/assets/22024a53-f111-4bc8-a117-6a5c6cb3196f)
*Figure 3.3: Transcription Factor Search.*

### d. Enhancer ID Search

Enter unique enhancer IDs to retrieve detailed information.

![Enhancer ID Search](https://github.com/user-attachments/assets/57cb259d-146a-4c1e-8aef-b254eb69ec6c)
*Figure 3.4: Enhancer ID Search.*

| Step (script) | Input | Output | Purpose |
| --- | --- | --- | --- |
| Step_1.1_ENotract_BAM_AT_SC.py | Pooled ATAC-seq BAM file (atac_possorted_bam.bam)Barcode text files per cell type (e.g., cell_type_name.txt) | Per-barcode BAM files organized by cell type | Filters reads from pooled BAM based on barcodes to create individual per-cell BAM files. |
| Step_1.2_Sorting_IndeNo.sh | Each per-barcode BAM file | Sorted BAM files (coordinate-sorted and name-sorted) with indexes | Uses samtools to sort and index BAM files for downstream peak calling and footprinting. |
| Step_2a_Genrich.shStep_2b_Genrich.sh | Name-sorted BAM files | NarrowPeak files per cell barcode | Runs Genrich to call accessible chromatin peaks from each BAM file in parallel batches. |
| Step_3_Filter_narrowPeak_files.py | Generated narrowPeak files | Filtered peak files | Cleans peak files for quality or region-based filtering before footprinting. |
| Step_4_ATACorrect.sh | BAM files, peak files, genome reference, blacklist regions | Corrected bigWig signal files per barcode | Uses TOBIAS ATACorrect to correct Tn5 insertion bias in ATAC-seq signals. |
| Step_5_ScoreBigwig.sh | Corrected bigWig files, narrowPeak files | Footprint score bigWig files | Runs TOBIAS FootprintScores to identify potential TF footprints in accessible regions. |
| Step_6_BINDetect.sh | Footprint score files, motif files (e.g. JASPAR), genome FASTA, peak files | BINDetect results per barcode (motif binding predictions) | Uses TOBIAS BINDetect to infer motif binding activity per cell type/barcode. |
| Step_7.1_Renaming_bindetect_results_with_cell_name.py | BINDetect result files | Renamed results with standardized or cell-specific names | Renames outputs to include cell names for clarity in aggregation and interpretation. |
| Step_7.2_Find_Copy_all_bed_files_to_bound_output.sh | All BINDetect output directories containing *_bound.bed files | Copies of bound.bed files in a unified output folder | Gathers all final predicted bound motif files for summary or visualization. |
| Step_7.3_Merge_ALL_bound.bed_files_into_one_named_after_the_directory.sh | Multiple *_bound.bed files in each BINDetect output directory | Single merged BED file per directory | Concatenates per-cell bound.bed files into one merged BED per directory. |
| Step_7.4_Copy_All_Merged-Bed_Files.sh | Merged BED files from all directories | Copies of all merged BED files in a centralized destination directory | Collects all merged BEDs into a single folder for integration analysis. |
| Step_7.5_Enhancers_Intersect_with_ED.py | Merged BED files; Enhancer annotation BED file(s) | Intersection result files (overlaps between predicted bound regions and enhancers) | Uses bedtools intersect (contextual assumption) to identify overlaps between binding sites and known enhancers. |
| Step_7.6_Enhancer_Overlaps_Summary.py | Intersection output files from Step 7.5 | Summarized counts or tables reporting enhancer overlaps per cell/type | Aggregates intersection results into summary tables for visualization or statistical interpretation. |

### Definition

*   **atac\_possorted\_bam.bam**: This is the pooled ATAC-seq BAM file output by the 10x Cell Ranger pipeline, containing all reads from all cells, position-sorted across the genome.
*   **Barcode**: A unique nucleotide sequence assigned to each cell during single-cell sequencing, enabling identification and separation of reads per cell.
*   **Coordinate-sorted BAM file**: BAM file sorted by genomic coordinates (chromosome and position). Necessary for downstream tools like peak callers or visualization software that require position-ordered input.
*   **Name-sorted BAM file**: BAM file sorted by read names instead of genomic coordinates. Required by some tools (e.g. Genrich) that operate based on read pairs or read groupings.
*   **NarrowPeak files**: Standard output format from peak callers (e.g. Genrich) representing regions of accessible chromatin (peaks) with associated scores and statistics.
*   **Filtered peak files**: NarrowPeak files that have undergone additional filtering based on quality metrics or genomic regions to remove low-confidence or irrelevant peaks.
*   **Corrected bigWig signal files**: Continuous signal tracks (bigWig format) produced after correcting ATAC-seq signals for Tn5 transposase insertion bias using tools like TOBIAS ATACorrect.
*   **Footprint score bigWig files**: bigWig files containing footprinting scores, indicating potential transcription factor (TF) binding footprints within accessible chromatin regions.
*   **BINDetect results**: Output from TOBIAS BINDetect containing predicted TF binding sites per motif, including bound and unbound regions along with binding scores.
*   **bound.bed files**: BED files listing genomic coordinates of predicted bound TF motifs, indicating where a motif is likely bound by a TF in the analyzed sample.
*   **Single merged BED file**: A concatenated BED file combining multiple bound.bed files within a directory to represent all predicted TF binding events for that cell type or condition.
*   **Summarized counts or tables reporting enhancer overlaps**: Tables that report the number of TF binding sites overlapping known enhancer regions, summarizing these intersections per cell type for further interpretation or visualization.

## License

<!-- Add your license information here, e.g., MIT License -->

