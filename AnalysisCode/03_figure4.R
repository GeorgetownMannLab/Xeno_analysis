# This code produces plots xeno points onto thermal image (Figure 4)

library(raster)
library(rgdal)
ir <- raster("newSfb218-75.tif")


pdf("Figure_4.pdf")
par(mar = c(5.1, 4.1, 4.1, 2.1))
plot(ir,
     col = gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL),
     xlim = c(0, 1245),
     axes = FALSE, legend = FALSE, box = FALSE)
points(x2, y2, cex = 0.75, pch = 21, bg = adjustcolor("blue", 0.5))
points(x2[237:239], y2[237:239], col = "red", pch = 16) # anchor points on thermal image

r.range <- c(minValue(ir), maxValue(ir))
plot(ir, legend.only = TRUE, col = gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL),
     legend.width = 1.5, legend.shrink = 1,
     axis.args = list(at = seq(r.range[1], r.range[2], length.out = 12),
                      labels = rev(round(key$temperature, 1)),
                      cex.axis = 0.8),
     legend.args = list(text = 'Temperature (°C)', side = 3, font = 2, line = 1, cex = 0.8))

dev.off()
