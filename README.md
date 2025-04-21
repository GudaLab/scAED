# scAED
We have developed the first active enhancer database at single-cell resolution for both normal and disease conditions, named the Single Cell Active Enhancer Database (scAED).

### Overview of scAED
Introduction to scAED: The Single Cell Active Enhancer Database (scAED) is designed to catalog active enhancers at the single-cell level for both normal and diseased conditions. It provides a comprehensive view of enhancers linked to specific transcription factors (TFs), promoters, and target genes.
Interface Explanation: The database is implemented as an R Shiny web application, offering an interactive and user-friendly experience. The primary interface displays a diagram of the enhancer-promoter-target gene relationship, helping users visualize how enhancers interact with other genetic elements.
Reading the Enhancer Data: The displayed figure shows various chromosomal regions, enhancer elements, transcription factors, and associated genes. Each strand (+ or -) is color-coded to indicate different genes, distances between genes, and specific enhancer-related information, like the nearest genes and transcription factor binding sites.
Data Tables: The lower section of the page contains data tables that list chromosomal locations, enhancers, associated genes, distances to the closest genes, and transcription factors involved.

![scAED](https://github.com/user-attachments/assets/16e1302c-986e-4f28-8145-bea088d7aac2)
Figure 1: Overview of the scAED interface.

### Using the scAED Search Interface
The Enhancers tab is the most interactive part of the interface and allows users to explore enhancer data in detail. The interface includes several dropdown menus to filter the data:
Filters in the Enhancers Tab

Organ: Users can select the organ of interest (e.g., brain, pancreas)

State: Choose between states such as healthy or diseased

Age: Filter data by the sample's age

Sex: Select the biological sex (male or female)

Region: Specify the genomic region to narrow down the results

Output Image Format: Select the output format for generated plots (e.g., JPG, PNG)

Setting Image Parameters: Below the filters, set the parameters for the plot you want to download. Set the dimensions (heights and width) of the image in inches and specify the resolution (DPI), with a range from 72 to 300. Click "Submit" to generate the plot. The bar plot images represent the enhancer count to each cell type based on the selected parameters at left side panel

a)	Total Enhancer Count

•	Displays bar plots summarizing enhancer counts across different cell types.

•	Two plots are shown:

1.	Cell count per cell type: A bar plot showing the number of cells categorized by cell type.
2.	Enhancer count per cell type: A bar plot representing the number of enhancers identified for each cell type.
   
•	Users can customize the dimensions (height and width) and resolution (DPI) of the output plots before downloading them.

![2 1](https://github.com/user-attachments/assets/61ac608d-2f54-4596-9602-d1b277b6081c)

Figure 2.1: Total Enhancer Count Tool.

b)	Cell Type Table

•	This section provides a table listing the cell types alongside the number of enhancers identified for each type.

•	The table enables users to explore enhancer activity across various cellular contexts and is downloadable in CSV format for further analysis.

![2 2](https://github.com/user-attachments/assets/9e603e80-3d8b-4a73-a28d-83d2ec24b072)

Figure 2.2: Cell Type Table.

c)	 Enhancer Table

•	User can select the cell type from ‘Select Cell Type’ drop down tab. It displays detailed information about enhancers filtered by cell type.

•	Key columns in the table include:

o	Enhancer ID: The first column contains the enhancer IDs, such as En0100050273.

o	Enhancer name: Displays the name of the enhancer, e.g. chr1_10867180_10867323.

o	Chromosome: Indicates the chromosome where the enhancer is located, e.g., chr1.

o	Start: Shows the starting genomic coordinate of the enhancer.

o	End: Shows the ending genomic coordinate of the enhancer.

o	%Cells: Represents the percentage of cells where the enhancer is present.

o	Directionality: Indicates whether the enhancer can act bidirectionally. Enhancers with this property are labeled as Bidirectional.

o	Gene symbols: Lists the genes affected by the enhancer and specifies the DNA strand they are on, e.g., RRX1(+); GORAB(+). A plus sign (+) indicates the sense strand, while a minus sign (-) indicates the anti-sense strand.

o	Cell line: Provides information about the cell line used in the experiments.

o	Distance to nearest gene: Displays the distance of the enhancer from the nearest affected gene.

o	Transcription factor: Lists the transcription factors bound with the respective enhancer.

•	The table shows 20 entries by default, with the option to expand the view to 100 entries. Users can also download this table in CSV format.


 ![2 3](https://github.com/user-attachments/assets/632a8874-f1ef-4bdd-881a-a0bf83070e69)

Figure 2.3: Enhancer Table.

d)	 Overlaps Enhancers

•	This section allows users to explore enhancers that overlap with specific genomic regions.

•	By selecting a cell type and genomic region, users can retrieve detailed information about overlapping enhancers, including their IDs and associated data.

 ![2 4](https://github.com/user-attachments/assets/4365503a-769a-4942-89cb-6d77c663b614)

Figure 2.4: Overlaps Enhancers Section.

3.	Search Engine
   
The Search Engine tab provides a global search function for retrieving enhancer data. It includes four search options in a dropdown menu.

a)	 Chromosomal Position Search

•	Users can specify a genomic region by entering a start and end position for the chromosome of interest.

•	This search retrieves enhancer information associated with the specified chromosomal region, providing details such as enhancer IDs, coordinates, and associated genes.

 ![3 1](https://github.com/user-attachments/assets/f709e5ae-6943-4269-bb73-4f30370c83f4)

Figure 3.1: Chromosomal Position Query.

b)	Gene Search

•	This feature allows users to search for enhancers linked to a specific gene by entering the gene's name or identifier.

•	This query is useful for investigating how enhancers regulate the expression of specific genes.

 ![3 2](https://github.com/user-attachments/assets/3a3a1701-80f4-4102-86b8-0aaa835c2148)

Figure 3.2: Search by Gene Query.

c)	Transcription Factor Search

•	Users can input transcription factor identifiers to find enhancers regulated by or interacting with the selected transcription factors.

•	The results help in understanding the role of transcription factors in gene regulation.

 ![3 3](https://github.com/user-attachments/assets/22024a53-f111-4bc8-a117-6a5c6cb3196f)

Figure 3.3: Search by Transcription Factor.

d)	 Enhancer ID Search

•	This feature provides a targeted way to retrieve information about specific enhancers by entering their unique IDs.

•	This feature is particularly helpful for in-depth analysis of individual enhancers.

 ![3 4](https://github.com/user-attachments/assets/57cb259d-146a-4c1e-8aef-b254eb69ec6c)

Figure 3.4: Search by Transcription Factor.
