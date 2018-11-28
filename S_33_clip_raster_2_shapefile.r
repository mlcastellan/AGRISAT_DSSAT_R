##########################################
### esta funcion realiza un crop sobre ###
### un raster basado en un shapefile   ###
### input:raster y shapefile           ###
### output: raster recortado           ###
##########################################
r <- raster(file.choose())
shp=readOGR(file.choose)

S_33_clip_raster_2_shapefile=function(r,shp){
##
library(raster)
library(sp)
library(rgdal)
### reprojecto el shapefile al crs del raster
r_crs=crs(r)
proj4string(shp)=spTransform(shp,crs=r_crs)
## recorto el raster al extent del raster
r2 <- crop(r,extent(shp)) 
## enmascaro el raster para solo tener los valores dentro del shapefile
r3 <- mask(r2,shp)
##
return(r3)

}
############### fin de la funcion #########