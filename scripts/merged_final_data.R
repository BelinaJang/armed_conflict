library(here)
library(tidyverse)
covariates <- read.csv(here("data/original","covariates.csv"), header = TRUE)

# read all the data sets created
source(here("scripts", "prepare_conflict.R"))
source(here("scripts", "prepare_disaster.R"))
source(here("scripts", "prepare_mortality.R"))

cleaned_conflict <- cleaned_conflict %>% rename(Year=year)

final_data <- reduce(list(cleaned_conflict, cleaned_disaster, cleaned_mortality), full_join, by=c('ISO','Year'))

final_data <- covariates %>% rename(Year=year) %>% left_join(final_data, by=c('ISO','Year'))

final_data <- final_data %>%
  mutate(armed_conflict = replace_na(armed_conflict, 0),
         Drought = replace_na(Drought, 0),
         Earthquake = replace_na(Earthquake, 0),
         totaldeath = replace_na(totaldeath, 0))

# save final data
write.csv(final_data, file = here("data", "analytical", "final_data.csv"), row.names = FALSE)
