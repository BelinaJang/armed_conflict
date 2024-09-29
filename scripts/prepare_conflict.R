library(here)
library(tidyverse)
rawdata <-read.csv(here("data/original","conflictdata.csv"), header = TRUE)

cleaned_conflict <- rawdata %>%  group_by(ISO, year) %>%
  summarize(totaldeath=sum(best)) %>%
  mutate(armed_conflict=ifelse(totaldeath>=25,1,0)) %>%
  ungroup() %>%
  mutate(year=year+1)

write.csv(cleaned_conflict, file = here("data", "analytical", "cleaned_conflict.csv"), row.names = FALSE)
