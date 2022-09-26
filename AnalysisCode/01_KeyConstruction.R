#This code produces key.RData to translate raster cell color into cell temperature

library(raster)

ir <- raster("newSfb218-75.tif")

image(ir)

#manually select color scale increments
colorscale <- locator(12)
cs <- as.data.frame(colorscale)

scalevalues <- extract(ir, cs)

key <- data.frame(scalevalues, temperature=numeric(12))

#assign temperature to the scale values
key$temperature <- seq(35.6, 26.4, length.out=12)

save(key, file="key.RData")
