library(here)
library(tidyverse)
library(countrycode)

# create a function to do the same procedure above
my_function <- function(rawdat, name){
  data_wide <- rawdat %>% 
    select(Country.Name,X2000:X2019)
  
  data_long <- pivot_longer(data_wide, X2000:X2019, names_to="Year") %>%
    mutate(Year=as.integer(gsub("X","",Year))) %>%
    rename_with(~ paste0(name, "Mor"), value)
  
  return(data_long)
}

data_names <- c("mat","inf","neo","under5")
mat <-read.csv(here("data/original","maternalmortality.csv"), header = TRUE)
inf <-read.csv(here("data/original","infantmortality.csv"), header = TRUE)
neo <-read.csv(here("data/original","neonatalmortality.csv"), header = TRUE)
under5 <-read.csv(here("data/original","under5mortality.csv"), header = TRUE)

# Apply the function to each of the four data sets
for (name in data_names) {
  data <- get(name)
  
  # Apply the function to the data and name the new data as "new_oldname"
  assign(paste0("new_",name), my_function(data, name))
}

# joining 4 tables
cleaned_mortality <- reduce(list(new_mat,new_inf,new_neo,new_under5),full_join)

cleaned_mortality$ISO <- countrycode(cleaned_mortality$Country.Name,
                            origin = "country.name",
                            destination = "iso3c")
cleaned_mortality <- cleaned_mortality %>% select(-Country.Name)

write.csv(cleaned_mortality, file = here("data", "analytical", "combined_mortality.csv"), row.names = FALSE)
