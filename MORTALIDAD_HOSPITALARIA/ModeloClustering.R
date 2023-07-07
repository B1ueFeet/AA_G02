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
setwd(file.path(ruta_dir,"/DATASET/Salidas"))

dataset_total <- read.csv2(file="mortalidad-hospitalaria-gye.csv")
datset_original <- dataset_total
colSums(is.na(dataset_total))

dataset_total$prov_insc<-factor(dataset_total$prov_insc)
dataset_total$cant_insc<-factor(dataset_total$cant_insc)
dataset_total$parr_insc<-factor(dataset_total$parr_insc)
dataset_total$nac_fall<-factor(dataset_total$nac_fall)
dataset_total$sexo<-factor(dataset_total$sexo)
dataset_total$fecha_nac<-factor(dataset_total$fecha_nac)
dataset_total$fecha_fall<-factor(dataset_total$fecha_fall)
dataset_total$edad<-factor(dataset_total$edad)
dataset_total$etnia<-factor(dataset_total$etnia)
dataset_total$lugar_ocur<-factor(dataset_total$lugar_ocur)
dataset_total$mor_viol<-factor(dataset_total$mor_viol)
dataset_total$causa<-factor(dataset_total$causa)

variables <- c(6:20)
