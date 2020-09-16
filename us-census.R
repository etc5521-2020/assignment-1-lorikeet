library(tidycensus)
library(tidyverse)

#You need to get API key from US Census Bureau
#A key can be obtained: here http://api.census.gov/data/key_signup.html.
census_api_key("YOUR API KEY GOES HERE")

#Retrieving educational attainment data from US Census Bureau
educational_attainment <- get_acs(geography = "state",
                                  variables = c("B06009_005E", "B06009_003E", "B06009_002E", "B01003_001E"),
                                  year = 2018)

#Creating a new column to make variable names meaningful
educational_attainment <- educational_attainment %>%
  mutate(variable_description = case_when(
    variable == "B06009_005" ~ "Bachelor Degree",
    variable == "B06009_003" ~ "High School Graduates",
    variable == "B06009_002" ~ "Less than High School Graduates",
    variable == "B01003_001" ~ "Total Population"
  ))

#Saving the educational attainment as csv file to github repo
write.csv(educational_attainment, here::here("data/educational_attainment.csv"))

#Retrieving 2018 migration data from US Census Bureau
migration <- get_acs(geography = "state",
                     variables = c("B06001_049", "B01003_001"),
                     year = 2018)

#Creating a new column to make variable names meaningful
migration <- migration %>%
  mutate(variable_description = case_when(
    variable == "B06001_049" ~ "Total Foreign Born",
    variable == "B01003_001" ~ "Total Population"
  ))

#Saving the migration data frame as csv file to github repo
write.csv(migration, here::here("data/migration.csv"))

#Retrieving 2018 per capita income data from US Census Bureau
state_income <- get_acs(geography = "county",
                        variables = c("B19301_001"),
                        year = 2018)

#Creating a new column to make variable names meaningful
state_income <- state_income %>%
  mutate(variable_description = case_when(
    variable == "B19301_001" ~ "Income Per Capita"
  )) %>%
  separate(NAME, c("county", "na", "state")) %>%
  select(-na) %>%
  mutate(county_state = str_c(county, ", ", state))

#Saving the per capita income data frame as csv file to github repo
write.csv(state_income, here::here("data/state_income.csv"))
