####################################################
### this function takes as arguments a folder    ###
### with rasters a shapefile and returns which   ###
### raster extent contains the shapefile within. ###
####################################################
raster_folder="C:/Users/MC1988/Documents/BIS_GOOGLE_DRIVE/S_XX_shp_into_raster/test_data/Rasters"
shape_path="C:/Users/MC1988/Documents/BIS_GOOGLE_DRIVE/S_XX_shp_into_raster/test_data/Shapefiles/belasco_cobos_15ene2018_shapefile.shp"
######
shp_into_raster=function(raster_folder,shape_path){
###
library(rgeos)
library(raster)
library(rgdal)
library(sp)
###### leo el shapefile y su crs
shapefile=readOGR(shape_path,verbose=FALSE)
shape_crs=crs(shapefile)
###### genero una lista con los rasters TIFF en raster_folder
###### chequear el formato de las imagenes sean TIF o IMG u otro
tif_list=list.files(path=raster_folder,pattern=".IMG$",ignore.case=TRUE,full.names=TRUE) 
###### genero una lista de rasters con la tif_list 
###### uso la primer banda para chequear el extent
raster_list=list()
i=1
for(i in 1:length(tif_list)){
  #r_name=paste("r_",i,sep="")
    raster_list[[i]]=raster(tif_list[[i]])
  }

###### I check if the polygon is within/intersect/outside raster
for(j in 1:length(tif_list)){
  #### genero el extent del raster
  ei <- as(extent(raster_list[[j]]), "SpatialPolygons")
  #### projecto el shapefile y extent al crs de raster
  proj4string(ei)=crs(raster_list[[j]])
  shapefile=spTransform(shapefile,proj4string(ei))
  
  ####### chequeo la situacion y devuelo la respuesta.
  if (gContainsProperly(ei, shapefile)) {
    raster_in=c("fully within",tif_list[[j]])
    #print (paste("fully within",as.character(tif_list[[j]])))
    return(raster_in)
    
  } else if (gIntersects(ei, shapefile)) {
    raster_intersect=c("intersection",tif_list[[j]])
    #print (paste("intersects",as.character(tif_list[[j]])))
    return(raster_intersect)
    
  } else {
    
    print (paste("fully without",as.character(tif_list[[j]])))
    raster_no_intersect=c("fully without")
    return(raster_no_intersect)
    
  }
}

}
#################### fin de la funcion ###############
######################################################