options(encoding = "utf-8")
#****************************** SELECCION DE VARIABLES ****************************
#limpieza de datos
rm(list = ls())
install.packages("rstudioapi")

library(foreign)

editor <- rstudioapi::getSourceEditorContext()
ruta_dir <- dirname(editor$path)
print(ruta_dir)
#Cargas de datos al directorio
setwd(file.path(ruta_dir,"/DATASET"))
#Crear una variable
spssPoblacion <- "inec_defuncionesgenerales_2020.csv"
provincia <- 'Guayas'
#crear un directorio de salidas
salida <- "Salidas/poblacion.csv"
#Variable a consideracion
variables <- "variables_seleccionadas.csv"
spss <- read.csv2(spssPoblacion, header = TRUE, sep = ";")
names(spss) <- tolower(names(spss))

var <- read.csv2(variables, header = TRUE, sep = ";")

var$x[26] <- "causa"


#Filtrado - sbudataset
spss_poblacion <- spss[spss$prov_fall == provincia, unlist(var)]
write.csv2(spss_poblacion, salida, row.names = FALSE)



#****************************** MANEJO DE VALORES AUSENTES ****************************
install.packages("caTools")
install.packages("foreing")
install.packages("miscFuncs")

library(caTools)
library(foreing)
library(miscFuncs)



#Cargas de datos al directorio
setwd(file.path(ruta_dir,"/DATASET/Salidas"))
csvFileName <- "poblacion.csv"
poblacion <- read.csv2(csvFileName, header = TRUE, sep = ";")
dataset <- poblacion[,unlist(var)]

#------------------------MANEJO VALORES AUSENTES-----------------------
#valores ausentes
colSums(is.na(dataset))

library(naniar)
library(visdat)
library(tidyverse)
library(simputation)

dataset <-replace_with_na_all(dataset, ~.x %in% c("N/A", "missing", "na", " "))

#eliminar valores ausentes
dataset$autopsia <- NULL

row.has.na <- apply(dataset, 1, function(x){
  any(is.na(x))
})

dataset <- dataset[!row.has.na,]

write.csv2(dataset, file = "mortalidad-hospitalaria-gye.csv", row.names = FALSE)
