#------------------------INSTALACION DE PAQUETES-------------------------
install.packages("Boruta")
install.packages("mlbench")
install.packages("caret")
install.packages("randomForest")
install.packages("Hmisc")
install.packages("stringi")

#----------------------------------PREPARACION---------------------------
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

library(Boruta)
library(mlbench)
library(caret)
library(randomForest)
set.seed(111)

library(Hmisc)
#-------------------ANALISIS DE DATOS--------------------------------
#analizar la varianza primeroluego distribucion y luego hacer la imputacion de datos analizar la varianza de nuevo
boxplot(spss)

#------------------ IMPUTACION DE DATOS --------------------------------
spss$anio_insc <- impute(spss$anio_insc, mean)
spss$dia_insc <- impute(spss$dia_insc, mean)
spss$edad <- impute(spss$edad, mode)
spss$cod_edad <- impute(spss$cod_edad, mode)
spss$etnia <- impute(spss$etnia, mode)
spss$est_civil <- impute(spss$est_civil, mode)
spss$niv_inst <- impute(spss$niv_inst, mode)
spss$sabe_leer <- impute(spss$sabe_leer, mode)
spss$autopsia <- impute(spss$autopsia, mode)
spss$lugar_ocur <- impute(spss$lugar_ocur, mode)
spss$lug_viol <- impute(spss$lug_viol, mode)
spss$nac_fall <- impute(spss$nac_fall, mode)
spss$causa <- as.factor(spss$causa)

#----------------------ENTRENAMIENTO
boruta <- Boruta(causa ~ ., data = spss, doTrace = 2, maxRuns = 500)
print(boruta)