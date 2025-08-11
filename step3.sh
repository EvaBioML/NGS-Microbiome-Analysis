conda activate qiime2-2022.8
#手動調整
filename="name"
filepath="/path/${filename}/"
forward="20"
reverse="280"
echo "Finish import"

cd ${filepath}

#BIOM 檔案 (Biological Observation Matrix) 
qiime tools export \
  --input-path "${filepath}table-dada2_${forward}_${reverse}.qza" \
  --output-path ./ \
|| { echo "Error: feature-table.biom failed"; exit 1; }
echo "Finish feature-table.biom"

#FNA / FASTA 檔案 dna-sequences.fasta
qiime tools export \
  --input-path "${filepath}rep-seqs-dada2_${forward}_${reverse}.qza" \
  --output-path ./ \
|| { echo "Error: dna-sequences.fasta failed"; exit 1; }
echo "Finish dna-sequences.fasta"

conda activate picrust2

#執行 PICRUSt2 
picrust2_pipeline.py \
  -s dna-sequences.fasta \
  -i feature-table.biom \
  -o picrust2_out_pipeline \
  -p 12 \
|| { echo "Error: PICRUSt2 failed"; exit 1; }
echo "Finish PICRUSt2.fasta"

cd picrust2_out_pipeline

add_descriptions.py \
  -i EC_metagenome_out/pred_metagenome_unstrat.tsv.gz \
  -m EC \
  -o EC_metagenome_out/pred_metagenome_unstrat_descrip.tsv.gz
  
add_descriptions.py \
  -i KO_metagenome_out/pred_metagenome_unstrat.tsv.gz \
  -m KO \
  -o KO_metagenome_out/pred_metagenome_unstrat_descrip.tsv.gz
  
add_descriptions.py \
  -i pathways_out/path_abun_unstrat.tsv.gz \
  -m METACYC \
  -o pathways_out/path_abun_unstrat_descrip.tsv.gz
  
cd ..
cd ..

echo "ALL DONE"
#將此輸出的檔案path_abun_unstrat_descrip.tsv.gz、pred_metagenome_unstrat_descrip.tsv.gz拉到本機端並解壓縮，可以獲得分別含有 KO/EC/Pathway、註釋、樣本名、豐富度的 tsv 三個檔案。

#分別是以E.C、KO、Pathway :

#1. EC_metagenome_out/pred_metagenome_unstrat_descrip.tsv.gz
#2. KO_metagenome_out/pred_metagenome_unstrat_descrip.tsv.gz
#3. pathways_out/path_abun_unstrat_descrip.tsv.gz
