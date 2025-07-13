#!/bin/bash
#SBATCH -p deimos
#SBATCH -c 8
#SBATCH --mem=24G
#SBATCH --output=slurm-bwa2-%j.out
#SBATCH --error=slurm-bwa2-%j.err

module load bwa/0.7.18-gcc-11.4.0
module load samtools/1.20-gcc-11.4.0
module load GATK/4.5.0.0-gcc-11.4.0
module load bedtools/v2.31.1-gcc-11.4.0
echo =========== bwa starts at: `date` ============

genome=/path/to/FINAL.fa
fq1=/path/to/SC08A_1.fq.gz
fq2=/path/to/SC08A_2.fq.gz
output=/path/to
covpathway=/path/to/coerage
software="/software/bamdst-master"

##construct index
bwa index $genome
##samtools faidx $genome
samtools dicit $genome
##alignment
bwa mem -t 4 -R '@RG\tID:SC08A\tPL:BGI\tLB:library\tSM:SC08A'  $genome $fq1 $fq2 | samtools view -S -b - > $output/SC08A.bam
##sort
samtools sort -O bam -o $output/SC08A.sorted.bam $output/SC08A.bam
##duplicate
gatk MarkDuplicates --REMOVE_DUPLICATES true -I $output/SC08A.sorted.bam -O $output/SC08A.sorted.remarkdup.bam -M $output/SC08A.sorted.markdup_metrics.txt
samtools index $output/SC08A.sorted.remarkdup.bam

mkdir $covpathway/SC08A
##generate bedfile
bedtools bamtobed -i $output/SC08A.sorted.remarkdup.bam > $covpathway/SC08A.bed

##calculating coverage
$software/bamdst -p $covpathway/SC08A.bed  -o $covpathway/SC08A $output/SC08A.sorted.remarkdup.bam

echo =========== bwa ends at: `date` ============