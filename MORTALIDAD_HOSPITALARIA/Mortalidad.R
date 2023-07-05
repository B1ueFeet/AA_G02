#limpieza de datos

rm(list = ls())
library(foreign)

install.packages("rstudioapi")



editor <- rstudioapi::getSourceEditorContext()
ruta_dir <- dirname(editor$path)
print(ruta_dir)

#Cargas de datos al directorio


setwd(file.path(ruta_dir,"/DATASET"))

#Crear una variable
spssPoblacion <- "inec_defuncionesgenerales_2020.csv"

provincia <- 10

#crear un directorio de salidas
salida <- "Salidas/poblacion.csv"



#Variable a consideracion
variables <- c("prov_insc","cant_insc","parr_insc","nac_fall",
              "sexo","fecha_nac", "fecha_fall", "edad",
              "etnia", "lugar_ocur", "mor_viol", "autopsia",
              "causa")



spss <- read.spss(spssPoblacion, use.value.labels = FALSE, to.data.frame = TRUE)
names(spss) <- tolower(names(spss))

#Filtrado - sbudataset

spss_poblacion <- spss[spss$i01 == provincia, variables]



write.csv2(spss_poblacion, salida, row.names = FALSE)