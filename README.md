# 🧬 16S and 18S rRNA NGS Microbiome Analysis  

本專案專注於 **16S 和 18S rRNA 次世代定序 (NGS)** 的微生物組分析，從原始序列資料處理到生物多樣性分析與功能預測。  

---

## 📂 分析流程 (Pipeline)  

1. **資料輸入 (Input Data)**  
   - 原始序列檔案：`FASTQ.gz`  
   - 實驗 metadata：`metadata.tsv`  

2. **品質控制 (QC)**  

3. **序列處理 (Denoising / OTU / ASV)**  
   - DADA2 建立 **ASV (Amplicon Sequence Variants)**  

4. **分類學註解 (Taxonomic Assignment)**  
   - 使用參考資料庫：SILVA

5. **統計與生態分析**  
   - α-多樣性 
   - β-多樣性   

6. **差異分析 (Differential Abundance)**  
   - LEfSe

7. **功能預測 (Functional Profiling, optional)**
    - PICRUSt2

8. **熱圖與網絡相關聯性分析 (Heatmap and network correlation analysis )**
   - SparCC
   - 使用R與cytoscape 進行視覺化
  
     
# 🧬 16S and 18S rRNA NGS Microbiome Analysis  

This project focuses on **16S and 18S rRNA next-generation sequencing (NGS)** microbiome analysis, covering the workflow from raw sequence processing to diversity analysis and functional prediction.  

---

## 📂 Analysis Pipeline  

1. **Input Data**  
   - Raw sequence files: `FASTQ.gz`  
   - Experimental metadata: `metadata.tsv`  

2. **Quality Control (QC)**  

3. **Sequence Processing (Denoising / OTU / ASV)**  
   - **DADA2** for generating **ASVs (Amplicon Sequence Variants)**  

4. **Taxonomic Assignment**  
   - Reference database: **SILVA**  

5. **Statistical and Ecological Analysis**  
   - **Alpha diversity** 
   - **Beta diversity** 

6. **Differential Abundance Analysis**  
   - **LEfSe** for biomarker discovery  

7. **Functional Profiling (optional)**  
   - **PICRUSt2** for functional prediction based on 16S data  

8. **Heatmap and Network Correlation Analysis**  
   - **SparCC** for microbial correlation inference  
   - Visualization using **R**and **Cytoscape**  




