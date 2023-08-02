#------------------------INSTALACION DE PAQUETES-------------------------
install.packages("Boruta")
install.packages("mlbench")
install.packages("caret")
install.packages("randomForest")
install.packages("Hmisc")
install.packages("stringi")
install.packages("dplyr")
install.packages("modeest")
install.packages("moments")

#----------------------------------PREPARACION---------------------------
rm(list = ls())
library(foreign)

editor <- rstudioapi::getSourceEditorContext()
ruta_dir <- dirname(editor$path)
print(ruta_dir)
#Cargas de datos al directorio
setwd(file.path(ruta_dir,"/DATASET"))
#Crear una variable
spssPoblacion <- "bd-imputados.csv"
provincia <- 'Guayas'
spss <- read.csv2(spssPoblacion, header = TRUE, sep = ";")
names(spss) <- tolower(names(spss))

library(Boruta)
library(mlbench)
library(caret)
library(randomForest)
set.seed(111)

library(Hmisc)
colSums(is.na(spss))

#----------------------ENTRENAMIENTO
spss$causa <- factor(spss$causa)
boruta <- Boruta(causa ~ ., data = spss, doTrace = 2, maxRuns = 500)
print(boruta)