
##都有填色，有過的用*標示
rm(list = ls())

# 套件
library(ggplot2)
library(reshape2)

# 讀檔
cor_sparcc <- read.delim("cor_sparcc.txt",
                         row.names = 1, sep = '\t', check.names = FALSE)
pvals <- read.delim("two_sided.txt",
                    row.names = 1, sep = '\t', check.names = FALSE)

# 將矩陣轉為長格式
cor_melt <- melt(as.matrix(cor_sparcc), varnames = c("Var1", "Var2"), value.name = "cor")
pval_melt <- melt(as.matrix(pvals), varnames = c("Var1", "Var2"), value.name = "p")

# 合併相關性與p值
df <- merge(cor_melt, pval_melt, by = c("Var1", "Var2"))

# 標記顯著性：加 * 如果符合 |cor| >= 0.5 且 p < 0.01
df$label <- ifelse(abs(df$cor) >= 0.5 & df$p < 0.01, "*", "")

# 僅保留下三角（避免重複）
df <- df[as.numeric(factor(df$Var1, levels=rownames(cor_sparcc))) >
           as.numeric(factor(df$Var2, levels=colnames(cor_sparcc))), ]

# 畫圖
windows()
ggplot(df, aes(x = Var2, y = Var1, fill = cor)) +
  geom_tile(color = NA) +
  geom_text(aes(label = label), size = 6, color = "white") +  # 放大標籤字體
  scale_fill_gradient2(low = "#2166AC", mid = "white", high = "#B2182B",
                       midpoint = 0, limit = c(-1, 1), name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 12), # x軸字體放大
        axis.text.y = element_text(size = 12),                                    # y軸字體放大
        legend.title = element_text(size = 14),                                   # 圖例標題放大
        legend.text = element_text(size = 12),                                    # 圖例文字放大
        axis.title = element_blank(),
        panel.grid = element_blank()) +
  coord_fixed()


ggsave("heatmap.jpg", width = 10, height = 10, dpi = 300)
