###################################################
### Este script filtra y da formato a los     #####
### datos del archivo OVERVIEW.OUT de DSSAT   #####
###################################################
rm(list=ls())
setwd("D:/Sean/Trabajo/Fontar")
####
library(stringr)
library(Dasst)
library(data.table)
library(tidyr)
library(reshape2)
####
#### leo el archivo OVERVIEW.OUT
text=readLines(file.choose())
#### genero una tabla de indices para ubicar la tabla que necesito
table_index=data.frame(index=seq(1,length(text),1),TITLE=FALSE,TABLE_START=FALSE,TABLE_END=FALSE)
#### genero los titulos de salida que necesito
ROW_TITLE=c("DAY","MONTH","CROP AGE","GROWTH STAGE","BIOMASS kg/ha","LAI","LEAF NUM","CROP N kg/ha","N%","STRESS %H2O","STRESS Nitr","STRESS Phos1","STRESS Phos2","RSTG")

##### busco las tablas a lo largo de OVERVIEW.OUT y remuevo las lineas que no necesito
for(i in 1:length(text)){
  if(str_detect(string=text[i],pattern="SIMULATED CROP AND SOIL STATUS AT MAIN DEVELOPMENT STAGES")){
    table_index[i,"TITLE"]=TRUE
    table_index[i+7,"TABLE_START"]=TRUE
    table_index[i+21,"TABLE_END"]=TRUE
  }
  if(str_detect(string=text[i],pattern="\\*\\*\\* SIMULATION ABORTED\\, ERROR CODE  30 \\*\\*\\*")){text[i]=""}
  if(str_detect(string=text[i],pattern="\\*\\*\\* SIMULATION ABORTED\\, ERROR CODE  29 \\*\\*\\*")){text[i]=""}
  if(str_detect(string=text[i],pattern="See Warning.OUT file for additional information.")){text[i]=""}
  if(str_detect(string=text[i],pattern="\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*")){text[i]=""}
  if(str_detect(string=text[i],pattern="^\\*")){text[i]=""}
  
}
##### genero vectores de inicio y fin de cada tabla
TABLE_START=table_index[table_index$TABLE_START==TRUE,]
TABLE_START=as.vector(TABLE_START[,1])
TABLE_END=table_index[table_index$TABLE_END==TRUE,]
TABLE_END=as.vector(TABLE_END[,1])
###################
TABLE_N=length(TABLE_END)
####

#### creo un objeto de texto para colocar los contenidos de las tablas
OUT_TEXT=""
for(j in 1:TABLE_N ){
  OUT_TEXT=append(OUT_TEXT,text[TABLE_START[j]:TABLE_END[j]])
}
#######
###saco las lineas en blanco del texto
OUT_TEXT<- OUT_TEXT[OUT_TEXT!= ""]
### reemplazo espacios por ;
OUT_TEXT=gsub('  +',';',OUT_TEXT) 
OUT_TEXT=gsub("^\\;", " 0",OUT_TEXT)
### exporto el texto como txt
writeLines(OUT_TEXT,"TESTEO_SALIDA_TABLE.csv")
###reimporto el dataframe desde el csv
tabla_df=read.csv(file="TESTEO_SALIDA_TABLE.csv",sep=";",stringsAsFactors=FALSE,header=FALSE)
names(tabla_df)=seq(1,ncol(tabla_df),1)
#### separo las columnas que necesito separar
tabla_df=separate(tabla_df,col="1",into=c("1","13"),sep = "\\b\\s\\b",remove=FALSE)
tabla_df=separate(tabla_df,col="2",into=c("A","B","C"),sep = " ",remove=FALSE,fixed=TRUE)
#### Vuelvo a pegar las columnas con lo que necesito
tabla_df$`B`=paste(tabla_df$`B`,tabla_df$`C`,sep=" ")
##### saco los valores NA
tabla_df$`B`=gsub(pattern="NA",replacement="",tabla_df$`B`)
##### reordeno las columnas 
names(tabla_df)=seq(1,ncol(tabla_df),1)
tabla_df=tabla_df[,c(-1,-4)]
##### reordeno las columnas para usar ROW_TITLE
names(tabla_df)=seq(1,ncol(tabla_df),1)
tabla_df=tabla_df[c(3,4,1,2,5,6,7,8,9,10,11,12,13,14)]
names(tabla_df)=seq(1,ncol(tabla_df),1)
##### saco las lineas que son startsym
tabla_df=tabla_df[tabla_df$`4`!="Start Sim",]
##### renombro las col con ROW_TITLE
names(tabla_df)=ROW_TITLE
##### remuevo las col que no son necesarias
tabla_df=tabla_df[,-c(12,13)]
##### exporto los datos a un archivo csv
write.csv(tabla_df,file="OVERVIEW_OUT_FILTRADO.csv",col.names=TRUE)
