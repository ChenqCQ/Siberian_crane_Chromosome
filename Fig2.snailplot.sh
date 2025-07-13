#!/bin/bash
#SBATCH -p gpu

## snail plot 
#conda activate btk

echo 'plot start'

###get busco results
busco -m genome -i "SC2025V2.fa" -o SC.chrom -l path/to/aves_odb10/ --offline
#get jsonfile
blobtools add --busco path/to/full_table.tsv --fasta SC2025V2.fa --threads 8 ./snailplot/
#sanil plot
blobtools view  --format png --plot --view snail ./snailplot/
echo 'plot end'