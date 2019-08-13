library(ggplot2)
library(dplyr)
library(rnaturalearth)
library(broom)
library(maps)
library(XLConnect)

?borders


# setup dataset ----------------------------------------------------------------------------------------------

earth <- ne_countries()

tidyearth <- tidy(earth)
countries <- tibble(id=row.names(earth@data),country=earth$name)

earth_n <- left_join(tidyearth, countries, by = "id")
readr::write_csv(earth_n, "earth_data.csv")



# map --------------------------------------------------------------------------------------------------------

n <- as.character(sample(0:177, 178))

highlight <- earth_n %>% 
  filter(id == n[27])

focus <- highlight %>% 
  filter(piece == "1") %>% 
  summarise(lat = mean(lat), long = mean(long)) %>% 
  as.numeric()

earth_n %>% 
  ggplot(aes(long, lat, group = group)) +
  geom_polygon(fill = "green") +
  geom_polygon(data = highlight, fill = "purple") +
  theme_void() +
  coord_map(projection = "orthographic", orientation = c(focus, 0))
