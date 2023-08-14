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
spss_poblacion <- read.csv2(spssPoblacion, header = TRUE, sep = ";")
names(spss_poblacion) <- tolower(names(spss_poblacion))
variables <- names(spss_poblacion)
names(spss_poblacion)
spss <- spss_poblacion[spss_poblacion$prov_insc == provincia, variables]

library(Boruta)
library(mlbench)
library(caret)
library(randomForest)
set.seed(111)
library(Hmisc)
colSums(is.na(spss))

#----------------------ENTRENAMIENTO
spss$numeración <- factor(spss$numeración)
spss$prov_insc <- factor(spss$prov_insc)
spss$cant_insc <- factor(spss$cant_insc)
spss$parr_insc <- factor(spss$parr_insc)

spss$anio_insc <- factor(spss$anio_insc)
spss$mes_insc <- factor(spss$mes_insc)
spss$dia_insc <- factor(spss$dia_insc)

spss$fecha_insc <- factor(spss$fecha_insc)
spss$sexo <- factor(spss$sexo)
spss$anio_fall <- factor(spss$anio_fall)

spss$mes_fall <- factor(spss$anio_fall)
spss$mes_fall <- factor(spss$mes_fall)
spss$dia_fall <- factor(spss$dia_fall)

spss$fecha_fall <- factor(spss$fecha_fall)
spss$anio_nac <- factor(spss$anio_nac)
spss$mes_nac <- factor(spss$mes_nac)

spss$dia_nac <- factor(spss$dia_nac)
spss$fecha_nac <- factor(spss$fecha_nac)
spss$edad <- factor(spss$edad)


spss$prov_fall <- factor(spss$prov_fall)
spss$cant_fall <- factor(spss$cant_fall)



spss$parr_fall <- factor(spss$parr_fall)
spss$area_fall <- factor(spss$area_fall)
spss$nac_fall <- factor(spss$nac_fall)


spss$cod_pais <- factor(spss$cod_pais)
spss$etnia <- factor(spss$etnia)
spss$est_civil <- factor(spss$est_civil)


spss$niv_inst <- factor(spss$niv_inst)
spss$sabe_leer <- factor(spss$sabe_leer)
spss$autopsia <- factor(spss$autopsia)


spss$lugar_ocur <- factor(spss$lugar_ocur)
spss$prov_res <- factor(spss$prov_res)
spss$area_res <- factor(spss$prov_res)

spss$causa <- factor(spss$causa)
spss$residente <- factor(spss$residente) 

spss$mor_viol <- NULL
spss$cod_edad <- NULL
spss$lc1 <- NULL
spss$causa103 <- NULL
spss$causa80 <- NULL
spss$causa67a <- NULL
spss$causa67b <- NULL
spss$mor_viol <- NULL
spss$lug_viol <- NULL
spss$cer_por <- NULL
spss$numeración <- NULL
spss$causa..v <- NULL
str(spss)



boruta <- Boruta(causa ~ ., data = spss, doTrace = 1, maxRuns = 15)
print(boruta)

bor <- TentativeRoughFix(boruta)
print(bor)

# Obtener las variables seleccionadas
variables_seleccionadas <- names(bor$finalDecision[bor$finalDecision == "Confirmed"])

variables_seleccionadas
# Guardar las variables seleccionadas en una variable
write.csv(variables_seleccionadas, file = "variables_seleccionadas.csv", row.names = FALSE)
