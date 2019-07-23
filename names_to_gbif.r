# Find taxon on GBIF and plot map

i <- "Sceloporus arenicolus"
dat <- occ_search(scientificName=i, return='data', hasCoordinate=TRUE)
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed() + wm + 
	geom_point(data = dat, aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5) +
	theme_bw()
