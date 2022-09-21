###
#This code creates a figure with the thermal image and the xeno attachment points (Figure 4)
###

library(raster)
library(rgdal)

irb <- raster("no_background.tiff")

load("tpoints.RData")  
load("new_key.RData")

tp <- coordinates(tpoints)

#need to convert tpoints axes to image axes

rescale_x <- function(x, oldmax, newmax) {((x-0)/(oldmax - 0) * newmax)} 

rescale_y <- function(x, oldmax, newmax) {newmax - ((x-0)/(oldmax - 0) * newmax) } 

x2 <- rescale_x(tp[,1], 912, 1620)
y2 <- rescale_y(tp[,2], 608, 900)
plot(irb, 
     col=gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))
points(x2, y2)
points(x2[237:239], y2[237:239], col="red", pch=16) #anchor points on thermal image

#Put rescaled points back into spatial points object
scaled_points <- SpatialPoints(coords=cbind(x2, y2))

#get values from the raster of xeno points
scale<-extract(irb, scaled_points)

##Match to key, interpolate key values
load("new_key.RData")
range(key$scalevalues)
length(2:253)
realtemp <- seq(26.4, 35.6, length.out=252)

bigkey <- data.frame(pixelvalue=2:253, realtemp)

temp_coord <- data.frame(x2,
                         y2,
                         scale)

temp_coord$realtemp <- bigkey$realtemp[match(round(temp_coord$scale,0), 
                                             bigkey$pixelvalue)]

#Merge pixels so that each pixel represents an are of about 1cm2
#Tolley et al 1995 (doi:10.2307/1382611) has some dorsal fin measurements
#Dorsal fin surface area ranged from 347-999 cm2, so we'll just aim
#for something within that range

#current number of non-NA pixels
current_pixels <- ncell(irb)-freq(irb, value=NA)

sqrt(current_pixels/600) # factor to adjust cell size

irb <- aggregate(irb, fact=7) #resize

#remove background from allcells
plot(irb)
irb[irb[]==0] <- NA
allcells <- data.frame(cellnumber = 1:length(irb@data@values), 
                       pixelvalue = irb@data@values)

allcells <- allcells[!is.na(allcells$pixelvalue),] #only non-NA cells

#get coordinates for each non-background cell
coords <- xyFromCell(irb, cell = allcells$cellnumber)

#####find the width of the fin at each y value#####
max_x <- aggregate(x=coords[,1],
          by=list(coords[,2]),
          FUN=max)
min_x <-aggregate(x=coords[,1],
                      by=list(coords[,2]),
                      FUN=min)
#combine into one table
colnames(max_x)[2] <- "max_x"
colnames(max_x)[1] <- "y"
colnames(min_x)[2] <- "min_x"
"min_max" <- data.frame(max_x$y, max_x$max_x, min_x$min_x)
colnames(min_max)[2] <- "max_x"
colnames(min_max)[1] <- "y"
colnames(min_max)[3] <- "min_x"
#get a width of fin at each x
min_max$width <- min_max$max_x - min_max$min_x
"width" <- data.frame(min_max$y, min_max$width, min_max$min_x)

#######get x and y values for anchor points and section off fin leading and trailing
anchor_pts <- data.frame(temp_coord[237:239,])
rownames(anchor_pts) = NULL
anchor_pts[["type"]] = c("tip", "back","front")
### fin chord is distance from leading to trailing edge
fin_chord <- anchor_pts$x[2] - anchor_pts$x[3]
#fin chord is 898.8158 units long
#leading edge according to FF definition
width$leading_edge <- width$min_max.width*.10
#add the minimum x to get the coordinate of the leading edge
width$leading_edge <- width$leading_edge + width$min_max.min_x
#find x cooordinate for trailing edge cutoff (Using FF definition)
width$trailing_edge <- .80*width$min_max.width
width$trailing_edge <- + width$min_max.min_x + width$trailing_edge

#> head(width)
#min_max.y min_max.width min_max.min_x leading_edge trailing_edge
#1       0.5          1246           3.5        128.1        1000.3
#2       7.5          1246           3.5        128.1        1000.3
#3      14.5          1246           3.5        128.1        1000.3

### vertical distance is difference in y values between tip and fin chord
vert_dist <- anchor_pts$y[1] - anchor_pts$y[2]
# tip is top 20 percent of vertical distance (Using FF definition)
tip <- (.80*vert_dist) + anchor_pts$y[2]

#tip y-value is 434.6053 units 

plot(irb)
points(x2, y2)
points(x2[237:239], y2[237:239], col=c("red", "blue", "black"), pch=16) #anchor points

#shift Xeno points off of fin slightly to the left

scale <- extract(irb, scaled_points)

temp_coord <- data.frame(x2,
                         y2,
                         scale)

temp_coord$realtemp <- bigkey$realtemp[match(round(temp_coord$scale,0), 
                                             bigkey$pixelvalue)]

#shift points outside of fin one pixel to the left to get on fin 
temp_coord$x2[is.na(temp_coord$realtemp)] <- temp_coord$x2[is.na(temp_coord$realtemp)]-7

points(temp_coord$x2, temp_coord$y2, pch=16)

#temp_coord[239] is the tip

#get count of points on each pixel
counts = table(cellFromXY(irb,temp_coord[,c("x2", "y2")]))

allcells$countXeno <- counts[match(allcells$cellnumber, names(counts))]

#Cells which have a count of 57 are the anchor points
allcells$countXeno[which(allcells$countXeno==57)] <- 0

allcells$countXeno[is.na(allcells$countXeno)] <- 0 

allcells$realtemp <- bigkey$realtemp[match(round(allcells$pixelvalue,0), 
                                           bigkey$pixelvalue)]

allcells <- allcells[!is.na(allcells$pixelvalue),] #only non-NA cells

#add in location on fin column using FF's 4 categories
# 1 is leading
# 2 is trailing
# 3 is tip
# 4 is fin plane


allcells$x <- coords[,1]
allcells$y <- coords[,2]


#match each y value to leading and trailing edge x value
allcells$leading_edge <- width$leading_edge[match(round(allcells$y,0), 
                                                  round(width$min_max.y))]

allcells$trailing_edge <- width$trailing_edge[match(round(allcells$y,0), 
                                                   round(width$min_max.y))]

allcells <- allcells[!is.na(allcells$realtemp),]

allcells[,"location"] <- NA  

#remove bottom of the image
allcells <- allcells[which(allcells$y >= anchor_pts$y[2]),]

#assign location for each cell
for (i in 1:nrow(allcells)) {
  allcells[i,"location"] = (if (allcells[i,"y"] >= tip){
    3
  }
  else if (allcells[i,"x"] <= allcells[i,"leading_edge"] & allcells[i,"y"] <= tip){
    1}
  else if (allcells[i,"x"] >= allcells[i,"trailing_edge"] & allcells[i,"y"] <= tip){
    2}
  else {4})
}


allcells$location <- as.factor(allcells$location)

#> head(allcells)
#     cellnumber pixelvalue countXeno realtemp     x   y leading_edge trailing_edge location
#2441       2441   5.489796         0 26.50996 913.5 854        912.8         956.9        3
#2442       2442  14.122449         0 26.83984 920.5 854        912.8         956.9        3
#2443       2443  17.102041         0 26.94980 927.5 854        912.8         956.9        3

#######
#Model
#######

#relevel so that trailing edge is the reference in the model
allcells$location <- relevel(allcells$location, ref="2")

#Use a poisson model to estimate counts of Xeno per grid cell of fin based on temperature and location
#Model just the tip and trailing edge

Variation_A <- allcells[which(allcells$location==3|allcells$location==2),]
Variation_A$location <- relevel(Variation_A$location, ref="2")
modA1 <- glm(countXeno ~ realtemp + location, data=Variation_A , family="poisson")

summary(modA1) 

#extract key statistics for summary table
p <- summary(modA1)$coefficients[,4]
standard_error <-summary(modA1)$coefficients[,2]
model_coefficient <-summary(modA1)$coefficients[,1]
summary_table <- as.data.frame(t(rbind(model_coefficient, standard_error, p)))
row.names(summary_table) <- c("intercept", "maximum temperature", "location:tip")

#export summary table
write.csv(summary_table, 'poisson_summary.csv', row.names=TRUE)

#find average temperature and variation for each section of the fin
means<-with(allcells, tapply(realtemp, location, mean))

#> means
#3        2        4        1 
#31.46782 33.05056 30.61863 28.16157 

#tip and trailing edge are the warmest places on the fin

#calculate variation in temperature for each section
variation <- with(allcells, tapply(realtemp, location, IQR))
#> variation
#3          2          4          1 
#3.48207171 1.75936255 2.23585657 0.03665339 
variation_2 <- with(allcells, tapply(realtemp, location, quantile))

#predict effect size 

temp_var <- data.frame(realtemp=c(32,33), location=c(3,3))
temp_var$location <- as.factor(temp_var$location)
predict(modA1, newdata=temp_var, type="response")

#         1           2 
#0.001425580 0.003582956 

#> 0.003582956 /0.001425580 
#[1] 2.513332
