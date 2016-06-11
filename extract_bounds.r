library(rgdal)
library(raster)

files=dir(pattern="shp")
files_no=gsub(".shp","",files)

# italian projection in WGS84 ellipsoid epgs 32632

CMProv2015_WGS84 <- readOGR(".", files_no[1])
Com2015_WGS84 <- readOGR(".", files_no[2])
Reg2015_WGS84 <- readOGR(".", files_no[3])

saveRDS(CMProv2015_WGS84,"comprovITA_epgs_32632.rds")
saveRDS(Com2015_WGS84,"comITA_epgs_32632.rds")
saveRDS(Reg2015_WGS84,"regITA_epgs_32632.rds")

CMProv2015_WGS84=readRDS("comprovITA_epgs_32632.rds")
Com2015_WGS84=readRDS("comITA_epgs_32632.rds")
Reg2015_WGS84=readRDS("regITA_epgs_32632.rds")

#################################################################
# Only Comuni 

res=list()
for ( i in 1:nrow(Com2015_WGS84@data)){
temp=Com2015_WGS84[i,]
res[[i]]=data.frame(t(c(as.vector(extent(temp)),as.vector(extent(spTransform(temp,CRS("+init=epsg:4326")))))))
}     

bounds=do.call("rbind",res)
ita_com_bounds=cbind(Com2015_WGS84@data[,1:6],bounds)
names(ita_com_bounds)[7:14]=c("E_EPGS32632","W_EPGS32632","S_EPGS32632","N_EPGS32632","E_EPGS4326","W_EPGS4326","S_EPGS4326","N_EPGS4326")

saveRDS(ita_com_bounds,"ita_com_bounds.rds")

write.csv(ita_com_bounds,"ISTAT_ita_com_bounds.csv",row.names=F)
                                  

