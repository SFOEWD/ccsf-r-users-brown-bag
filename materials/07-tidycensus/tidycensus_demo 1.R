library(tidyverse)
library(tidylog)
library(tidycensus)


# LOAD DATA

## https://data.sfgov.org/Economy-and-Community/San-Francisco-Population-and-Demographic-Census-Da/4qbq-hvtt/about_data
census_datasf <- read_csv("data/San_Francisco_Population_and_Demographic_Census_Data_20251027.csv")

## https://data.sfgov.org/Geographic-Locations-and-Boundaries/Analysis-Neighborhoods-2020-census-tracts-assigned/sevw-6tgi/about_data
tract_cw <- read_csv("https://data.sfgov.org/resource/sevw-6tgi.csv") %>% 
  rename(GEOID = geoid)


var_5yr <- load_variables(2022, "acs5", cache = TRUE)
var_5yrsubject <- load_variables(2022, "acs5/subject", cache = TRUE)
var_1yr <- load_variables(2022, "acs1", cache = TRUE)
var_1yrsubject <- load_variables(2022, "acs1/subject", cache = TRUE)


# ANALYSIS

## Population 5yr 836,321 (datasf)
B01001_5yr23_county <- get_acs(
  geography = "county",
  state = "CA",
  county = "San Francisco",
  table = "B01001",
  year = 2023,
  survey = "acs5"
)

B01001_5yr23_county %>% 
  filter(variable == "B01001_001")

## UNEMPLOYMENT RATE 2022 (DataSF 3.7%, cv8.2%)
s2301_1yr2022 <- get_acs(
  geography = "county",
  state = "CA",
  county = "San Francisco",
  table = "S2301",
  year = 2022,
  survey = "acs1"
)

s2301_1yr2022 %>% 
  filter(variable == "S2301_C04_001") %>% 
  mutate(cv = (moe / (estimate * 1.645)))



## POPULATION - Aggregating from Census Tracts
B01001_5yr23_tract <- get_acs(
  geography = "tract",
  state = "CA",
  county = "San Francisco",
  table = "B01001",
  year = 2023,
  survey = "acs5"
)

B01001_5yr23_tract %>% 
  filter(variable == "B01001_001") %>% 
  summarize(estimate = sum(estimate),
            moe = moe_sum(moe, estimate),
            cv = (moe / (estimate * 1.645)))


B01001_5yr23_tract %>% 
  filter(variable == "B01001_001") %>% 
  left_join(tract_cw,
            by = "GEOID") %>% 
  group_by(sup_dist_2022) %>% 
  summarize(estimate = sum(estimate),
            moe = moe_sum(moe, estimate),
            cv = (moe / (estimate * 1.645)))



## EDUCATIONAL ATTAINMENT

B15001_5yr2023_tract <- get_acs(geography = "tract",
                         variables = c(h_1 = "B15001_004",
                                       h_2 = "B15001_005",
                                       h_3 = "B15001_006",
                                       h_4 = "B15001_012",
                                       h_5 = "B15001_013",
                                       h_6 = "B15001_014",
                                       h_7 = "B15001_020",
                                       h_8 = "B15001_021",
                                       h_9 = "B15001_022",
                                       h_10 = "B15001_028",
                                       h_11 = "B15001_029",
                                       h_12 = "B15001_030",
                                       h_13 = "B15001_036",
                                       h_14 = "B15001_037",
                                       h_15 = "B15001_038",
                                       h_16 = "B15001_045",
                                       h_17 = "B15001_046",
                                       h_18 = "B15001_047",
                                       h_19 = "B15001_053",
                                       h_20 = "B15001_054",
                                       h_21 = "B15001_055",
                                       h_22 = "B15001_061",
                                       h_23 = "B15001_062",
                                       h_24 = "B15001_063",
                                       h_25 = "B15001_069",
                                       h_26 = "B15001_070",
                                       h_27 = "B15001_071",
                                       h_28 = "B15001_077",
                                       h_29 = "B15001_078",
                                       h_30 = "B15001_079",
                                       s_1 = "B15001_007",
                                       s_2 = "B15001_015",
                                       s_3 = "B15001_023",
                                       s_4 = "B15001_031",
                                       s_5 = "B15001_039",
                                       s_6 = "B15001_048",
                                       s_7 = "B15001_056",
                                       s_8 = "B15001_064",
                                       s_9 = "B15001_072",
                                       s_10 = "B15001_080",
                                       a_1 = "B15001_008",
                                       a_2 = "B15001_016",
                                       a_3 = "B15001_024",
                                       a_4 = "B15001_032",
                                       a_5 = "B15001_040",
                                       a_6 = "B15001_049",
                                       a_7 = "B15001_057",
                                       a_8 = "B15001_065",
                                       a_9 = "B15001_073",
                                       b_1 = "B15001_081",
                                       b_2 = "B15001_009",
                                       b_3 = "B15001_017",
                                       b_4 = "B15001_025",
                                       b_5 = "B15001_033",
                                       b_6 = "B15001_041",
                                       b_7 = "B15001_050",
                                       b_8 = "B15001_058",
                                       b_9 = "B15001_066",
                                       b_10 = "B15001_074",
                                       b_11 = "B15001_082",
                                       g_1 = "B15001_010",
                                       g_2 = "B15001_018",
                                       g_3 = "B15001_026",
                                       g_4 = "B15001_034",
                                       g_5 = "B15001_042",
                                       g_6 = "B15001_051",
                                       g_7 = "B15001_059",
                                       g_8 = "B15001_067",
                                       g_9 = "B15001_075",
                                       g_10 = "B15001_083"),
                         state = "CA",
                         county = "San Francisco County",
                         year = 2023,
                         #survey = "acs5"
) %>%
  mutate(
    variable = case_when(
      str_sub(variable, 1, 1) == 'h' ~ "High School or Less",
      str_sub(variable, 1, 1) == 's' ~ "Some College",
      str_sub(variable, 1, 1) == 'a' ~ "Associate's Degree",
      str_sub(variable, 1, 1) == 'b' ~ "Bachelor's Degree",
      str_sub(variable, 1, 1) == 'g' ~ "Graduate Degree",
      TRUE ~ "review"
    )
  ) %>% 
  left_join(tract_cw %>% 
              select(GEOID,
                     sup_dist_2022), by = "GEOID")


educ_hsorless_dist <- B15001_5yr2023_tract %>% 
  filter(variable == "High School or Less") %>% 
  group_by(sup_dist_2022, 
           variable
           ) %>% 
  summarize(estimate = sum(estimate),
            moe = moe_sum(moe, estimate)) %>% 
  ungroup() %>% 
  mutate(cv = (moe / (estimate * 1.645)))



### Incorrect: Using B01001 for district population
B01001_5yr23_tract %>% 
  filter(variable == "B01001_001") %>%
  left_join(tract_cw,
            by = "GEOID") %>% 
  group_by(sup_dist_2022) %>% 
  summarize(estimate = sum(estimate),
            moe = moe_sum(moe, estimate),
            cv = (moe / (estimate * 1.645)))

### Correct: Using B15001 for 18+ district population
B15001_001_5yr2023_tract <- get_acs(geography = "tract",
                                variables = c(total = "B15001_001"),
                                state = "CA",
                                county = "San Francisco County",
                                year = 2023,
                                #survey = "acs5"
  ) %>% 
  left_join(tract_cw %>% 
              select(GEOID,
                     sup_dist_2022), by = "GEOID")


B15001_001_5yr2023_dist <- B15001_001_5yr2023_tract %>% 
  group_by(sup_dist_2022) %>% 
  summarize(estimate = sum(estimate),
            moe = moe_sum(moe, estimate)) %>% 
  ungroup() %>% 
  mutate(cv = (moe / (estimate * 1.645)))

educ_hsorless_dist %>% 
  left_join(B15001_001_5yr2023_dist,
            by = "sup_dist_2022") %>% 
  transmute(sup_dist_2022,
            variable,
            estimate = estimate.x / estimate.y,
            moe = moe_prop(num = estimate.x,
                           denom = estimate.y,
                           moe_num = moe.x,
                           moe_denom = moe.y)) %>% 
  ungroup() %>% 
  mutate(cv = (moe / (estimate * 1.645)))

