############################
# Demonstration of impact of using geodetic vs Euclidean (planar) 
# measurements for Reock and Convex Hull area-based ratios
############################

library(dplyr)
library(sf)
library(tmap)

source("compactness.R")

urlPA = "http://aws.redistricting.state.pa.us/Redistricting/Resources/GISData/Districts/Congressional/2011/SHAPE/PA-Congressional-Districts-2011.zip"

z = basename(urlPA)
layer = strsplit(z, "[.]")[[1]][1]
download.file(urlPA, z)
unzip(z, junkpaths = TRUE, exdir = "temp")
sfCdPa = read_sf("temp")
unlink(z)
unlink("temp", recursive = TRUE)

# Set PROJ4 string for custom Equal Area Albers projection used by 
# PA Dept of Environmental Projection 
crsPaDep = "+proj=aea +lat_1=40 +lat_2=42 +lat_0=39 +lon_0=-78 +x_0=0 +y_0=0 +ellps=GRS80 +units=m +no_defs"

# The difference between Reock calculated using an equal area or conformal 
# projection is negligible. World Mercator might perform poorly for a 
# geography that crosses many degrees of latitude, but this is unlikely for 
# Congressional Districts.
# 
# However, Reock calculated on lat-long coordinates is wildly incorrect, 
# because the minimum bounding circle algorithm treats lat-long coordinates
# as planar.
dfReockError = sfCdPa %>%
  select(District_N) %>%
  mutate(
    reock_equal_area = reock(st_transform(geometry, crsPaDep)),
    reock_mercator = reock(st_transform(geometry, 3395)),
    merc_ea_diff = reock_mercator - reock_equal_area,
    reock_lat_long = reock(st_transform(geometry, 4269)),
    gcs_ea_diff = reock_lat_long - reock_equal_area
    ) %>%
  as.data.frame() %>%
  select(-geometry)

# A view of the minimum bounding circles:
#   * dark gray is constructed in lat-long coordinates
#   * light gray is constructed in equal area coordinates
png("demo/reock_demo.png", width = 720, height = 400)
tm_shape(st_minimum_bounding_circle(st_convex_hull(sfCdPa))) +
  tm_polygons(col = "darkgray") +
  tm_facets("District_N") +
tm_shape(st_minimum_bounding_circle(st_convex_hull(st_transform(sfCdPa, crsPaDep)))) +
  tm_polygons() +
  tm_facets("District_N") +
tm_shape(sfCdPa) +
  tm_polygons(col = "#1b9e77") +
  tm_facets("District_N")
dev.off()

# There is not a comparable difference in the convex hull
png("demo/convex_hull_demo.png", width = 720, height = 400)
tm_shape(st_convex_hull(sfCdPa)) +
  tm_borders(col = "red") +
  tm_facets("District_N") +
tm_shape(st_convex_hull(st_transform(sfCdPa, crsPaDep))) +
  tm_borders(col = "blue") +
  tm_facets("District_N") +
tm_shape(sfCdPa) +
  tm_polygons(col = "#1b9e77") +
  tm_facets("District_N")
dev.off()
