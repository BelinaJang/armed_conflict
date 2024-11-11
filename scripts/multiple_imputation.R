library(tidyverse)
library(here)
library(texreg)
library(multgee)
library(plm)
library(mice)

# road the final data

final_data <- read.csv(here("data/analytical", "final_data.csv"), header = TRUE)

final_data <- final_data %>%
  mutate(loggdp = log(gdp1000),
         pctpopdens = popdens/100) %>%
  select(-popdens, -gdp1000)

# data set for MI

mi_data <- final_data %>%
  # Need to convert ISO to numeric
  mutate(ISOnum = as.numeric(as.factor(final_data$ISO))) %>%
  select(-country_name, -ISO, -region, -OECD2023)

# Dry run to get meth and pred

mice0  <- mice(mi_data, seed = 100, m = 5, maxit = 0, print = F)

# Edit meth and pred
meth <- mice0$method
meth[c("urban", "male_edu", "temp", "rainfall1000", "matmor", "infmor", "neomor", "un5mor", "loggdp", "pctpopdens")] <- "2l.lmer"

pred <- mice0$predictorMatrix
pred[c("urban", "male_edu", "temp", "rainfall1000", "matmor", "infmor", "neomor", "un5mor", "loggdp", "pctpopdens"), "ISOnum"] <- -2
