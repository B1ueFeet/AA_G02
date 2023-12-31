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
spssPoblacion <- "inec_defuncionesgenerales_2020.csv"
provincia <- 'Guayas'
spss <- read.csv2(spssPoblacion, header = TRUE, sep = ";")
names(spss) <- tolower(names(spss))

imputados <- spss


library(Boruta)
library(mlbench)
library(caret)
library(randomForest)
set.seed(111)

library(Hmisc)
#-------------------ANALISIS DE DATOS--------------------------------
#analizar la varianza primeroluego distribucion y luego hacer la imputacion de datos analizar la varianza de nuevo
library(dplyr)
library(modeest) 
library(moments)
summary(spss)

coef_var <- function(x, na.rm = FALSE) {
  sd(x, na.rm=na.rm) / mean(x, na.rm=na.rm)
}

medidas_variabilidad <- function(x, na.rm = FALSE) {
  lista <- c(format(coef_var(x, na.rm=na.rm), scientific = F),
             format(var(x, na.rm=na.rm), scientific = F),
             format(sd(x, na.rm=na.rm), scientific = F),
             format(range(x,na.rm = na.rm), scientific = F))
          #-------coeficiente de varianza----varianza --------desviacion estandar------rango
  lista
}

verificacion <- function(x, y, na.rm = FALSE, dispersion = mean) {
  y <- impute(x, dispersion)  
  lista <- c(medidas_variabilidad(x, na.rm=T),
             medidas_variabilidad(y, na.rm=T))
  matriz <- matrix(lista, nrow = 5, ncol = 2)
  matriz
}



colSums(is.na(spss))
# segun los valores ausentes se necesita hacer la imputacion de las columnas
#anio_insc   dia_insc edad   cod_edad  nac_fall  etnia   
#est_civil   niv_inst sabe_leer   autopsia     lugar_ocur    lug_viol 
colSums(is.na(imputados))
#------------------------revision de medidas de variabilidad--------------
#anio_insc
verificacion(spss$anio_insc, imputados$anio_insc, T, mean)

#dia_insc

verificacion(spss$dia_insc, imputados$dia_insc, T, mean)

#edad

verificacion(spss$edad, imputados$edad, T, mean)

#cod_edad

verificacion(spss$cod_edad, imputados$cod_edad, T, mode)

#nac_fall

verificacion(spss$nac_fall, imputados$nac_fall, T, mode)
#etnia 

verificacion(spss$etnia, imputados$etnia, T, mode)
#est_civil

verificacion(spss$est_civil, imputados$est_civil, T, mode)
#niv_inst

verificacion(spss$niv_inst, imputados$niv_inst, T, mode)
#sabe_leer

verificacion(spss$sabe_leer, imputados$sabe_leer, T, mode)
#autopsia

verificacion(spss$autopsia, imputados$autopsia, T, mode)
#lugar_ocur

verificacion(spss$lugar_ocur, imputados$lugar_ocur, T, mode)
#lug_viol

verificacion(spss$lug_viol, imputados$lug_viol, T, mode)



#------------------ IMPUTACION DE DATOS --------------------------------
imputados$anio_insc <- impute(spss$anio_insc, mean)
imputados$dia_insc <- impute(spss$dia_insc, mean)   
imputados$edad <- impute(spss$edad, mean)
imputados$cod_edad <- impute(spss$cod_edad, mode)
imputados$etnia <- impute(spss$etnia, mode)
imputados$est_civil <- impute(spss$est_civil, mode)
imputados$niv_inst <- impute(spss$niv_inst, mode)
imputados$sabe_leer <- impute(spss$sabe_leer, mode)
imputados$autopsia <- impute(spss$autopsia, mode)
imputados$lugar_ocur <- impute(spss$lugar_ocur, mode)
imputados$lug_viol <- impute(spss$lug_viol, mode)
imputados$nac_fall <- impute(spss$nac_fall, mode)

colSums(is.na(imputados))

#------------------- GUARDAR LOS DATOS IMPUTADOS ----------------

write.csv2(imputados, file = "bd-imputados.csv", row.names = FALSE)




