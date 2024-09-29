library(here)
library(tidyverse)
rawdat <-read.csv(here("data/original","Disaster.csv"), header = TRUE)

filtered_disaster <- rawdat %>% filter(Year %in% c(2000:2019)) %>%
  filter(Disaster.Type %in% c("Earthquake","Drought")) %>%
  select(Year, ISO, Disaster.Type)

dummy_data <- filtered_disaster %>% mutate(Earthquake=ifelse(Disaster.Type=="Earthquake",1,0), Drought=ifelse(Disaster.Type=="Drought",1,0))

cleaned_disaster <- dummy_data %>% group_by(Year, ISO) %>%
  # 1 if it happened at least once
  summarise(Earthquake=max(Earthquake),Drought=max(Drought))

