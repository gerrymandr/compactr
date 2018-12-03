############################
# Demonstration of impact of using geodetic vs Euclidean (planar) 
# measurements for Polsby-Popper and Schwartzberg shape indices
############################

library(dplyr)
library(sf)

source("compactness.R")

urlPA = "http://aws.redistricting.state.pa.us/Redistricting/Resources/GISData/Districts/Congressional/2011/SHAPE/PA-Congressional-Districts-2011.zip"

z = basename(urlPA)
layer = strsplit(z, "[.]")[[1]][1]
download.file(urlPA, z)
unzip(z, junkpaths = TRUE, exdir = "temp")
sfCdPa = read_sf("temp")
unlink(z)
unlink("temp", recursive = TRUE)

sfCdPa %>%
  select(District_N) %>%
  mutate(
    polsby_popper_geodetic = polsby_popper(geometry),
    polsby_popper_euclidean = polsby_popper(st_set_crs(geometry, 32601)),
    polsby_popper_error = (polsby_popper_euclidean - polsby_popper_geodetic) / polsby_popper_geodetic,
    schwartzberg_geodetic = schwartzberg(geometry),
    schwartzberg_euclidean = schwartzberg(st_set_crs(geometry, 32601)),
    schwartzberg_error = (schwartzberg_euclidean - schwartzberg_geodetic) / schwartzberg_geodetic
  ) %>%
 st_set_geometry(NULL)
