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
variables <- c("prov_insc","cant_insc","parr_insc","nac_fall",
               "sexo", "fecha_fall", "edad",
               "etnia", "lugar_ocur", "mor_viol", "autopsia",
               "causa")
spss <- read.csv2(spssPoblacion, header = TRUE, sep = ";")
names(spss) <- tolower(names(spss))

#Filtrado - sbudataset
spss_poblacion <- spss[spss$prov_insc == provincia, variables]
write.csv2(spss_poblacion, salida, row.names = FALSE)

#****************************** MANEJO DE VALORES AUSENTES ****************************
install.packages("caTools")
install.packages("foreing")
install.packages("miscFuncs")

library(caTools)
library(foreing)
library(miscFuns)

rm(list = ls())

editor <- rstudioapi::getSourceEditorContext()
ruta_dir <- dirname(editor$path)
print(ruta_dir)
#Cargas de datos al directorio
setwd(file.path(ruta_dir,"/DATASET/Salidas"))
csvFileName <- "poblacion.csv"
poblacion <- read.csv2(csvFileName, header = TRUE, sep = ";")
variables <- c("prov_insc","cant_insc","parr_insc","nac_fall",
               "sexo", "fecha_fall", "edad",
               "etnia", "lugar_ocur", "mor_viol", "autopsia",
               "causa")
dataset <- poblacion[,variables]
#valores ausentes
colSums(is.na(dataset))

#eliminar valores ausentes
dataset$autopsia <- NULL
dataset$mor_viol <- NULL
row.has.na <- apply(dataset, 1, function(x){
  any(is.na(x))
})

dataset <- dataset[!row.has.na,]

write.csv2(dataset, file = "mortalidad-hospitalaria-gye.csv", row.names = FALSE)
