conda activate qiime2-2022.8

#手動調整
filename="name"
filepath="/path/${filename}/"
forward="20"
reverse="280"
forward2="30"
reverse2="270"
rRNA="16s"
level="4"
mincount=""
maxcount=""
column="Identifier"
metadata="matadata.txt"
echo "Finish import"

#Trimming
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs "${filepath}demux.qza" \
  --p-trim-left-f "$forward" \
  --p-trim-left-r "$forward2" \
  --p-trunc-len-f "$reverse" \
  --p-trunc-len-r "$reverse2" \
  --o-table "${filepath}table-dada2_${forward}_${reverse}.qza" \
  --o-representative-sequences "${filepath}rep-seqs-dada2_${forward}_${reverse}.qza" \
  --o-denoising-stats "${filepath}stats-dada2_${forward}_${reverse}.qza" \
  --p-n-threads 8 \
|| { echo "Error: Trimming failed"; exit 1; }
echo "Finish Trimming"

#執行:. classifier.sh

classifier_18s="silva-138.1-ssu-nr99-V8-V9-classifier.qza"
classifier_16s="silva138_AB_V3-V4_classifier.qza"
rep="rep-seqs-dada2_${forward}_${reverse}.qza"
taxa="taxonomy_${filename}_${forward}_${reverse}.qza"
table="table-dada2_${forward}_${reverse}.qza"
echo "Finish import classifier"

# Choose classifier based on rRNA variable
if [ "$rRNA" == "18s" ]; then
  classifier="${classifier_18s}"
else
  classifier="${classifier_16s}"


#classification

qiime feature-classifier classify-sklearn \
  --i-classifier "/work1785/Hou/${classifier}" \
  --i-reads "${filepath}${rep}" \
  --o-classification "${filepath}${taxa}" \
|| { echo "Error: Classification failed"; exit 1; }
echo "Finish Classification"

#taxonomy barplot
qiime taxa barplot \
  --i-table "${filepath}${table}" \
  --i-taxonomy "${filepath}${taxa}" \
  --m-metadata-file "${filepath}${metadata}" \
  --o-visualization "${filepath}taxa-bar-plots_${filename}_${forward}_${reverse}.qzv"\
|| { echo "Error: Taxa bar plotting failed"; exit 1; }
echo "Finish Taxa bar plotting"

#krona pie chart
qiime krona collapse-and-plot \
  --i-table "${filepath}${table}" \
  --i-taxonomy "${filepath}${taxa}" \
  --o-krona-plot "${filepath}krona_${filename}_${forward}_${reverse}.qzv" \
|| { echo "Error: krona failed"; exit 1; }
echo "Finish krona plotting"

#Phylogenic tree
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences "${filepath}${rep}" \
  --o-alignment "${filepath}aligned-rep-seqs_${filename}_${forward}_${reverse}.qza" \
  --o-masked-alignment "${filepath}masked-aligned-rep-seqs_${filename}_${forward}_${reverse}.qza" \
  --o-tree "${filepath}unrooted-tree_${filename}_${forward}_${reverse}.qza" \
  --o-rooted-tree "${filepath}rooted-tree_${filename}_${forward}_${reverse}.qza" \
|| { echo "Error: Phylogenic tree failed"; exit 1; }
echo "Finish Phylogenic tree"

#Heat map
qiime taxa collapse \
  --i-table "${filepath}${table}" \
  --i-taxonomy "${filepath}${taxa}" \
  --p-level 4 \
  --o-collapsed-table "${filepath}col_table_4_${filename}_${forward}_${reverse}.qza" \
|| { echo "Error: collapse failed"; exit 1; }
echo "Finish collapse"


qiime feature-table heatmap \
  --i-table "${filepath}col_table_4_${filename}_${forward}_${reverse}.qza" \
  --o-visualization "${filepath}heatmap_4_${filename}_${forward}_${reverse}.qzv" \
  --p-color-scheme YlOrRd \
  --p-cluster features\
|| { echo "Error: Heat map failed"; exit 1; }
echo "Finish Heat map"

#Alpha and Beta diversity
qiime diversity alpha-rarefaction \
  --i-table "${filepath}${table}" \
  --i-phylogeny "${filepath}rooted-tree_${filename}_${forward}_${reverse}.qza" \
  --p-max-depth "${maxcount}" \
  --m-metadata-file "${filepath}${metadata}" \
  --o-visualization "${filepath}alpha-rarefaction${filename}_${forward}_${reverse}.qzv" \
|| { echo "Error: alpha-rarefaction failed"; exit 1; }
echo "Finish alpha-rarefaction"


qiime diversity core-metrics-phylogenetic \
  --i-phylogeny "${filepath}rooted-tree_${filename}_${forward}_${reverse}.qza" \
  --i-table "${filepath}${table}" \
  --p-sampling-depth "${mincount}" \
  --m-metadata-file "${filepath}${metadata}" \
  --output-dir "${filepath}core-metrics-results" \
|| { echo "Error: core-metrics-results failed"; exit 1; }
echo "Finish core-metrics-results"

#Box plot
qiime diversity alpha-group-significance \
  --i-alpha-diversity "${filepath}core-metrics-results/observed_features_vector.qza" \
  --m-metadata-file "${filepath}${metadata}" \
  --o-visualization "${filepath}observed_features_vector_${filename}_${forward}_${reverse}.qzv" \
|| { echo "Error: Box plot failed"; exit 1; }
echo "Finish Box plot"

#Beta diversity 的視覺化
qiime diversity beta-group-significance \
--i-distance-matrix "${filepath}core-metrics-results/unweighted_unifrac_distance_matrix.qza" \
--m-metadata-file "${filepath}${metadata}" \
--m-metadata-column "${column}" \
--o-visualization "${filepath}core-metrics-results/unweighted_unifrac_Sex_site_betasig_${filename}_${forward}_${reverse}.qzv" \
--p-pairwise \
|| { echo "Error: PCA plot failed"; exit 1; }
echo "Finish PCA plot"











