rm(list = ls())
library(foreign)

editor <- rstudioapi::getSourceEditorContext()
ruta_dir <- dirname(editor$path)
print(ruta_dir)
#Cargas de datos al directorio
setwd(file.path(ruta_dir,"/DATASET"))
#Crear una variable
spssPoblacion <- "inec_defuncionesgenerales_2020.csv"
provincia <- 'Guayas'
spss <- read.csv2(spssPoblacion, header = TRUE, sep = ";")
names(spss) <- tolower(names(spss))



install.packages("randomForest")
library(randomForest)
dataset.sc<- data.matrix(spss)
modelo1 <- randomForest(class~.,as.matrix(spss),ntree=500,importance=TRUE,maxnodes=10,mtry=25)
#Creamos un objeto con las "importancias" de las variables
importancia=data.frame(importance(modelo1))
library(reshape)
importancia<-sort_df(importancia,vars='MeanDecreaseGini')
importancia