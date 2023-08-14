rm(list=ls())
install.packages("dummy")
install.packages('kohonen')
install.packages("tictoc")
install.packages("ggplot2")

library(kohonen)
library(dummy)
library(tictoc)
library(ggplot2)

editor <- rstudioapi::getSourceEditorContext()
ruta_dir <- dirname(editor$path)
print(ruta_dir)
#Cargas de datos al directorio
setwd(file.path(ruta_dir,"/DATASET"))
setwd(file.path(ruta_dir,"/DATASET/salidas"))

dataset_total <- read.csv2(file="mortalidad-hospitalaria-gye.csv")
datset_original <- dataset_total
colSums(is.na(dataset_total))
variables <- "variables_seleccionadas.csv"
var <- read.csv2(file=variables)


dataset <- lapply(dataset, as.factor)


dataset<- dataset_total # carga del data set solo con las variables

dataset <- dummy(dataset)

dataset.sc<- data.matrix(dataset)
set.seed(0)

som_grid <- somgrid(xdim=5,ydim = 5, topo= "rectangular") 
tic("Time to run SOM: ") # Inicia el tiempo
som_model <- som(X=dataset.sc, grid=som_grid, rlen = 100, alpha = c(0.05, 0.01), keep.data=TRUE)
toc() # Finaliza el tiempo


#generar clusters
clusters <- som_model$unit.classif
conteo <- table(clusters)
conteo_frame <- as.data.frame(conteo)

#graficar
#preparar la paleta de colores
colBlueHotRed <- function(n, alpha = 1){
  rainbow(n, end = , alpha = alpha)[n:1]
}
pretty_palette <- c("#1f77b4",'#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2')

colors <- function(n, alpha=1){
  rev(heat.colors(n,alpha))
}


#Histograma
plot(som_model, type4 = "changes")
#mapa de calor
plot(som_model, type = "count", pallete.name = colors, heatkey = TRUE)
# tipo de mappeo
plot(som_model, type = "mapping", pchs = 1, main = "Mapping Type SOM")
plot(som_model, type = "mapping", pchs = 2, main = "Mapping Type SOM")
# por defecto
plot(som_model, main = "default SOM model")
# calidad distancia
plot(som_model, main = "Node Quality SOM", type = "quality", palette.name = colors)
#distancia a vecinos
plot(som_model, type = "dist.neighbours", palette.name = terrain.colors, main="Distance")
#grafica suponiendo valores binomiales 
code<-getCodes(som_model)
var1<- 1
var2<- 2
par(mfrow = c(1,2))
plot(som_model, type = "property", property = code [,var1], main = colnames (code)[var1], heatkey = TRUE,palette.name = colors) 
plot(som_model, type = "property",property = code [,var2], main = colnames (code)[var2], heatkey = TRUE,palette.name = colors)
par(mfrow = c(1,1))




plot(som_model$grid$pts)
cluster_details <-  data.frame(cluster= som_model$unit.classif,dataset_total)
conteo <- table(cluster_details$cluster)
conteo_frame <- as.data.frame(conteo)



ggplot(conteo_frame, aes(x = as.factor(Var1),y=as.factor(Freq)) )+
  geom_bar(fill="blue", stat="identity")+
  labs(x="Clùster", y="Total observaciones")+
  ggtitle("som -Total elementos por celda")



#METODO DE CODO
cluster1 <- cluster_details[cluster_details$cluster==1,]
table(cluster1$urp)

mydata <- getCodes(som_model)
wss <- (nrow(mydata-1)* sum(apply(mydata,2, var)))
for(i in 2:15){
  wss[i]<- sum(kmeans(mydata,centers = i)$withinss)
  
  
}

par(mar=c(5.1, 4.1, 4.1, 2.1))
plot(1:15, wss, type="b", 
     xlab = "Number of clusters",
     ylab="within gorups sum of squares",
     main = "within cluster sum of squars(WCSS)")

#PROBAR ENB LOS DOS CODOS PARA VER O LANZAR EN BRECHASS
#SELECCION DE VARIABLES CON REGRESION LINEAL METODO DE ELIMINACION PARA ATRAS

num_cluster <- 8
som_cluster <-
  cutree(hclust(dist(getCodes(som_model))),
         num_cluster)



pretty_palette <- c("#1f77b4",'#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2')



conteo <- table(cluster_details$cluster)
conteo_frame <- as.data.frame(conteo)



plot(som_model,
     bgcol=pretty_palette[som_cluster],
     main="Cluster")
add.cluster.boundaries(som_model, som_cluster)

plot(som_model, type="codes", 
     bgcol = pretty_palette[som_cluster],
     main = "Cluster")
add.cluster.boundaries(som_model, som_cluster)



cluster_details<- data.frame(cluster=som_cluster[som_model$unit.classif],
                             datset_original)


#ENCERRAR CLUSTER
ggplot(conteo_frame,aes(x=as.factor(var1), y=as.factor(Freq))+
         geom_bar(fill="blue", stat= "identity")+
         labs(x="Clúster",
              y="Total observaciones")+
         ggtitle("Total elementos por cluster"))



cluster1 <- cluster_details[cluster_details$cluster==1,]
write.csv2(cluster1,"cluster1.csv")
