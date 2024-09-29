library(here)
library(tidyverse)
rawdat <-read.csv(here("data/original","maternalmortality.csv"), header = TRUE)

data_wide <- rawdat %>% 
  select(Country.Name,X2000:X2019)

data_long <- pivot_longer(data_wide, X2000:X2019, names_to="Year") %>%
  mutate(Year=as.integer(gsub("X","",Year))) %>%
  rename(MatMor=value)

