library(here)
library(tidyverse)
rawdat <-read.csv(here("data/original","Disaster.csv"), header = TRUE)

filtered_data <- rawdat %>% filter(Year %in% c(2000:2019)) %>%
  filter(Disaster.Type %in% c("Earthquake","Drought")) %>%
  select(Year, ISO, Disaster.Type)

dummy_data <- filtered_data %>% mutate(Earthquake=ifelse(Disaster.Type=="Earthquake",1,0), Drought=ifelse(Disaster.Type=="Drought",1,0))

grouped_data <- dummy_data %>% group_by(Year, ISO) %>%
  # 1 if it happened at least once
  summarise(Drought=max(Drought),Earthquake=max(Earthquake))
