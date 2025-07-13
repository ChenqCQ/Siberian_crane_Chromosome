library(circlize)
library(RColorBrewer)
library(devtools)
devtools::install_github("jokergoo/circlize")
 install_github("jokergoo/ComplexHeatmap")
library(ComplexHeatmap)
setwd("D:/CQ_file/CQ_plot")
pdf("circos.pdf",width=8,heigh=6,pointsize = 12)
circos.clear()
coul <- colorRampPalette(brewer.pal(9, "Set3"))(12)
genome <- read.table('1_simplified.chromosome.chang.txt')
colnames(genome) <- c("chr","start","end")
circos.par("track.height" = 0.1, start.degree = 90 , gap.degree = 3 , cell.padding = c(0, 0, 0, 0))
# get chromosome regions
circos.genomicInitialize(genome, plotType = c("axis", "labels")) 

##set color
coul <- colorRampPalette(brewer.pal(11,"RdBu"))(33) 
# chromosome fill
circos.genomicTrackPlotRegion(
  genome,
  ylim = c(0, 1),
  track.height = 0.05,
  bg.border = NA,
  panel.fun = function(region, value, ...) {
    circos.rect(
      xleft = CELL_META$xlim[1],
      ybottom = 0,
      xright = CELL_META$xlim[2],
      ytop = 1,
      col = coul[CELL_META$sector.numeric.index %% length(coul)+1],
      border = "black"
    )
  }
)
# gc
GC <- read.table('3_circos.gc.density.change.txt')##bedtools nuc
colnames(GC) <- c("chr","start","end","value")
circos.genomicTrackPlotRegion(GC,track.height = 0.08, bg.border = NA,panel.fun = function(region, value, ...){
  circos.genomicLines(region, value, type = "l",area=TRUE, border='#3C5488cc', col='#3C5488cc',...)})

# gene
gene <- read.table('circos.gene.density.changeID2.txt')##bedtools coverage
head(gene)
colnames(gene) <- c("chr","start","end", "value")

circos.genomicTrackPlotRegion(gene,track.height = 0.08,bg.border = NA,panel.fun = function(region, value, ...) {
  circos.genomicLines(
    region, value, 
    type = "s",
    col = "#cb8e85",
    area = TRUE,
    baseline = 0,
    border = '#cb8e85',
    lwd = 0.8
  )
}
)

# repeat
rep <- read.table('repeatseq.base.overlap10kb.simplify')##bedtools intersect
colnames(rep) <- c("chr","start","end","base")
##aggregate windows when chr, start, ends coincide
repeat_desity_p_agg <- aggregate(.~chr+start+end, rep, sum)
##calculate fraction of the windows covered by repeats
repeat_desity_p_agg_percent <- data.frame(repeat_desity_p_agg$chr, repeat_desity_p_agg$start, repeat_desity_p_agg$end, (repeat_desity_p_agg$base/(repeat_desity_p_agg$end-repeat_desity_p_agg$start))*100)
colnames(repeat_desity_p_agg_percent) <- c("chr", "start", "end", "repeats")
##repeat trance
circos.genomicTrackPlotRegion(repeat_desity_p_agg_percent,track.height = 0.08, panel.fun = function(region, value, ...){
  circos.genomicLines(region, value, area=TRUE, type = "l", lwd =0.8, col='#f1707d',...)},bg.border=NA)

dev.off()
