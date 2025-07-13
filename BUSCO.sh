#!/bin/bash

#conda activate BUSCO

echo 'assessment start'

###assembly assessment
busco -m genome -i SC2025V2.fa -o SCassesmbly -l path/to/aves_odb10/ --offline
#use gffread to get protein sequences
gffread sc.gff -g SC2025V2.fa -x sc.cds.fa -y sc.protein.fa
#annotation assessment
busco -m protein -i sc.protein.fa -o SCannbusco -l path/to/aves_odb10/ --offline
echo 'assessment end'