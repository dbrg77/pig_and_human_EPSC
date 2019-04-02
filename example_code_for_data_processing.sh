# This script contains example codes to process ChIP-seq and RNA-seq data from the human samples.
#cChange the reference genome to work with the pig samples.

## ChIP-seq data processing

### mapping reads to reference genome

bowtie2 -p 6 -x iGenome/Homo_sapiens/UCSC/hg38/Sequence/Bowtie2Index/genome -q H1-EPSC-H3K4me3.fastq | \
samtools view -ShuF 4 -q 30 - | \
samtools sort - -T H1-EPSC-H3K4me3_tmp -o H1-EPSC-H3K4me3_q30_sorted.bam

### peak calling with macs2

macs2 callpeak -t H1-EPSC-H3K4me3_q30_sorted.bam -c H1-Input_q30_sorted.bam \
               -g hs -g hs -q 0.01 -f BAM --nomodel --extsize 200 -B --SPMR \
               -n H1_EPSC_H3K4me3

## RNA-seq data processing

salmon quant --no-version-check -q -p 6 --useVBOpt --numBootstraps 100 --posBias --seqBias --gcBias \
             -i SalmonIndex -l A -1 H1-EPSC_day_0_rep1_r1.fastq -2 H1-EPSC_day_0_rep1_r2.fastq
             -g gene_map.tsv -o salmon_gencode_v27_quant/H1-EPSC_day_0_rep1
