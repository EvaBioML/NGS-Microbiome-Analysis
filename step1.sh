conda activate qiime2-2022.8

#��ʽվ�

filename="name"
filepath="/path/${filename}/"
manifest="manifest.txt"
echo "Finish import"

qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-format PairedEndFastqManifestPhred33V2 \
--input-path "${filepath}${manifest}" \
--output-path "${filepath}demux.qza" \
|| { echo "Error: artifacts failed"; exit 1; }
echo "Finish artifacts"

qiime demux summarize \
--i-data "${filepath}demux.qza"  \
--o-visualization "${filepath}demux.qzv" \
|| { echo "Error: demux.qzv failed"; exit 1; }
echo "Finish demux.qzv"




#�����{�� ". artifacts.sh"