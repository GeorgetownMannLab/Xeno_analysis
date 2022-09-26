#This code performs an affine transformation on marked xeno attachment points and fin points (tip, back insertion, front insertion).
#The output of this code "tpoints.RData" can be used to extract temperature values for xeno attachment 

xeno <- read.csv("RawData/Xeno_pts_v2.csv", row.names = 1)

#Add columns
xeno$dolphin_id <- as.numeric(as.factor(xeno$image.name))

xeno$color<-ifelse(xeno$point.type=="fin", "black", "red")
xeno$finlab<-ifelse(xeno$point..==1 &
                      xeno$point.type=="fin", "tip", NA)

xeno$finlab<-ifelse(xeno$point..==2 &
                      xeno$point.type=="fin", "back", xeno$finlab)

xeno$finlab<-ifelse(xeno$point..==3 &
                      xeno$point.type=="fin", "front", xeno$finlab)

xeno$finlab<-ifelse(xeno$point.type=="xeno", "xeno", xeno$finlab)

#12 is thermal image

library(vec2dtransf)

#Pull out points by location
front<-xeno[xeno$finlab=="front",]
back<-xeno[xeno$finlab=="back",]
tip<-xeno[xeno$finlab=="tip",]


d2f<-front[which(front$dolphin_id==12),]
d2b<-back[which(back$dolphin_id==12),]
d2t<-tip[which(tip$dolphin_id==12),]

transformed <- list()

for(i in 1:length(unique(xeno$dolphin_id))){
  
  d<-unique(xeno$dolphin_id)[i]  
  
  d1t<-tip[which(tip$dolphin_id==d),]
  d1f<-front[which(front$dolphin_id==d),]
  d1b<-back[which(back$dolphin_id==d),]
 
  
  
  cpoints<-matrix(c(d1f$x, d1f$y, d2f$x, d2f$y, 
                    d1b$x, d1b$y, d2b$x, d2b$y, 
                    d1t$x, d1t$y, d2t$x, d2t$y), nrow=3, byrow = TRUE)
  
  cpoints<-data.frame(cpoints)
  
  aft<-AffineTransformation(cpoints)
  calculateParameters(aft)
  getParameters(aft)
  
  d1<-xeno[xeno$dolphin_id==d,]
  
  p2<-SpatialPointsDataFrame(coords=d1[,c("x", "y")], 
                             data=d1[,c("finlab", "color", "dolphin_id")])
  
  newLines = applyTransformation(aft, p2)
  
  transformed[[i]] <- newLines
  
}

tpoints<-do.call("rbind", transformed)

dev.new()
plot(tpoints@coords, type="n",
     xlim=(tpoints@bbox[1,]),
     ylim=(tpoints@bbox[2,]), 
     main="All Xeno")
text(tpoints@coords[,1], tpoints@coords[,2], label=tpoints$finlab, col=tpoints$color)

#save as RData file for intermediate data usage
#save(tpoints, file="tpoints.RData")
