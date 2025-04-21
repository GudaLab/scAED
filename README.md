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

## License

<!-- Add your license information here, e.g., MIT License -->

