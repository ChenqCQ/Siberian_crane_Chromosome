#!/bin/bash
#SBATCH -p mars
#SBATCH -c 8
#SBATCH --mem=24G
#SBATCH --output=slurm-ngenomesynplot-%j.out
#SBATCH --error=slurm-ngenomesynplot-%j.err


softewarepathway=/path/to
mapping=/path/to/minimap2-2.28/
output=/path/to
inputpathway=/path/to

###get alignment file
perl $softewarepathway/GetTwoGenomeSyn.pl -InGenomeA $inputpathway/GCA_964106855.1_bGruGru1.hap1.1_genomic.fna  -InGenomeB $inputpathway/GCF_028858705.1_bGruAme1.mat_genomic.fna -MinAlgLen 50000 -OutPrefix $output/mapping1/re_GrusGrus2GrusAmer -MappingBin minimap2 -BinDir $mapping
perl $softewarepathway/GetTwoGenomeSyn.pl -InGenomeA $inputpathway/GCF_028858705.1_bGruAme1.mat_genomic.fna  -InGenomeB $inputpathway/SC_scaffold33.fa -OutPrefix $output/mapping2/re_GruAmer2SC -MinAlgLen 50000 -MappingBin minimap2 -BinDir $mapping 
perl $softewarepathway/GetTwoGenomeSyn.pl -InGenomeA $inputpathway/SC_scaffold33.fa  -InGenomeB $inputpathway/GCA_011004875.1_bBalReg1.pri_genomic.fna -OutPrefix $output/mapping3/re_SC2BalReg -MinAlgLen 50000 -MappingBin minimap2 -BinDir $mapping 
perl $softewarepathway/GetTwoGenomeSyn.pl -InGenomeA $inputpathway/GCA_011004875.1_bBalReg1.pri_genomic.fna  -InGenomeB $inputpathway/GCA_964237585.1_bGalChl1.hap1.1_Gruiformes.fna -MinAlgLen 50000 -OutPrefix $output/mapping4/re_BalReg2GalChl -MappingBin minimap2 -BinDir $mapping

####set conf file and add species linkfile
###plot
$softewarepathway/NGenomeSyn	-InConf	allspecies.alignment.conf	-OutPut	OUT
