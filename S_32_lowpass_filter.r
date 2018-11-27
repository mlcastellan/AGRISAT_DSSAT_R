################################################
### este script contiene la funcion lowpass ####
### con un window size ajustable por ej 7x7 ####
### Tiene como input un raster,window size  ####
### y la funcion a usar por el kernel       ####
################################################

#n is the row size of kernel
n=51
#m is the col size of kernel
m=51
#Raster in es el raster a filtrar
raster_in=raster(file.choose())

### inicio de funcion #########################
lowpass_filter=function(n,m,raster_in){
###
library(raster)
###funcion es la operacion a usar con el kernel
###
kernel=matrix(1,nrow=n,ncol=m)
##
raster_out=focal(raster_in,w=kernel,fun=median,na.rm=TRUE)
##
return(raster_out)

}
### fin funcion ###############################