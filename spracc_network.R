rm(list = ls())

# 觀測值的相關矩陣
cor_sparcc <- read.delim('cor_sparcc.txt', row.names = 1, sep = '\t', check.names = FALSE)

# 伪p值矩陣
pvals <- read.delim("pvals.two_sided.txt", row.names = 1, sep = '\t', check.names = FALSE)

# 保留 |相關性| >= 0.8 且 p < 0.01 的值
cor_sparcc[abs(cor_sparcc) < 0.8] <- 0
pvals[pvals >= 0.01] <- -1
pvals[pvals < 0.01 & pvals >= 0] <- 1
pvals[pvals == -1] <- 0

# 篩選後的鄰接矩陣
adj <- as.matrix(cor_sparcc) * as.matrix(pvals)
diag(adj) <- 0

# 轉換為 igraph 物件
g <- graph_from_adjacency_matrix(adj, mode = 'undirected', weighted = TRUE)

# 設置邊屬性
E(g)$sparcc <- E(g)$weight
E(g)$weight <- abs(E(g)$weight)

# 計算 Louvain 群落模組性指數
louvain <- cluster_louvain(g)
modularity_index <- modularity(louvain)

# 評估網絡穩定性（去除關鍵物種影響）
key_nodes <- names(sort(degree(g), decreasing = TRUE)[1:5])  # 選取度數最高的前 5 個節點
g_removed <- delete_vertices(g, key_nodes)
stability_metric <- length(E(g_removed)) / length(E(g))  # 計算邊數變化比例

# 計算去除關鍵節點前後的連通子圖數量
original_components <- components(g)$no
new_components <- components(g_removed)$no

print(paste("去除關鍵節點前，網絡有", original_components, "個子網絡"))
print(paste("去除關鍵節點後，網絡有", new_components, "個子網絡"))

# 生成輸出
write.table(data.frame(degree = degree(g), betweenness = betweenness(g), closeness = closeness(g), cluster = membership(louvain)),
            "network.node_list_.txt", sep = '\t', row.names = TRUE, quote = FALSE)
write.table(data.frame(modularity_index, stability_metric, original_components, new_components),
            "network.analysis_.txt", sep = '\t', row.names = FALSE, quote = FALSE)

# 計算節點指標
deg <- degree(g)
btw <- betweenness(g)
cls <- closeness(g)
clu <- membership(louvain)

# 設定節點屬性
V(g)$degree <- deg
V(g)$betweenness <- btw
V(g)$closeness <- cls
V(g)$cluster <- clu

# 保存圖結構
write.graph(g, "network.graphml", format = 'graphml')
write.graph(g, "network.gml", format = 'gml')