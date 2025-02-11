# AnVILWorkflow

We introduce the AnVILWorkflow package for R users with limited computing 
resources. This package allows users to run workflows implemented in 
[Terra][] without writing any workflows, installing software, or managing 
cloud resources. Terra's computing resources rely on Google Cloud Platform 
(GCP), and to use AnVILWorkflow, you only need to setup the Terra account 
once at the beginning.

Along with the [AnVIL][] package, the AnVILWorkflow package allows users to 
access Terra and GCP through R session from a conventional laptop, 
significantly lowering the learning curve for high-performance, cloud-based 
genomics resources.

[Terra]: https://app.terra.bio/#
[AnVIL]: https://github.com/Bioconductor/AnVIL

<img src="https://github.com/shbrief/AnVILWorkflow/raw/devel/vignettes/runnable_workflow.png" width="90%" height="90%"/>

### Example 1. Microbiome analysis
[bioBakery workflows][] is a collection of workflows and tasks for executing 
common microbial community analyses using standardized, validated tools and 
parameters. bioBakery is built on Python and maintained by [Huttenhower lab][].
This workflow uses call caching and preemptive instances by default for cost 
efficiency. Processing six paired-end demo samples (mean file size ~380MB) 
with the optimized default setting without using preemptive instances took 
about 5 hours and cost around $6.50.

### Example 2. Bulk RNAseq analysis
[Salmon][] is a command-line tool for quantifying the expression of 
transcripts using RNA-seq data. Salmon workflow uses AnVIL’s data model 
and requires four essential inputs - fastq1, fastq2, fasta, and transcriptome 
index name. This workflow can be easily applied to the consortium data 
hosted in AnVIL, which follows AnVIL’s data model. With the default runtime 
environment configured for this workflow (1 CPU, 2GB memory, and 10GB SSD 
disk), processing 16 demo samples (32 fastq files, ~1GB per file) took about 
30 minutes and cost $0.12.

### Example 3. Histopathology image analysis
We implemented the hematoxylin-eosin (HE) stain normalization process of 
[PathML][] as an AnVIL workspace. This workflow accepts an SVS file as input 
and returns original and normalized images as PNG files. There are two 
required inputs - Google Cloud Storage URI, where the input SVS image file 
is stored, and the sample name. Processing one publicly available image 
(CMU-1_Small_Region.svs, 1.8MB) with the default runtime (4 CPU, 16GB memory) 
took about 8 minutes and cost $0.01. This simple but robust analysis setup 
can support clinical use cases, such as pathologists who process a large 
number of images in a short time, by offering guidance and cross-validation 
options.

[bioBakery workflows]: https://github.com/biobakery/biobakery_workflows
[Huttenhower lab]: http://huttenhower.sph.harvard.edu/
[Salmon]: https://combine-lab.github.io/salmon/
[PathML]: https://pubmed.ncbi.nlm.nih.gov/34880124/


------------------------------------------------------------------------

#### Citation
If you use *AnVILWorkflow* in publisehd research, please cite:

Oh S, Gravel-Pucillo K, Ramos M et al. AnVILWorkflow: A runnable workflow package for Cloud-implemented bioinformatics analysis pipelines [version 1; peer review: 2 approved]. F1000Research 2024, 13:1257 (https://doi.org/10.12688/f1000research.155449.1)
