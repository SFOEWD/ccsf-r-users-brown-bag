# Brown Bag # 7: Tidycensus with Vincent Ta

1. Online Resources
    * [tidycensus documentation](https://walker-data.com/tidycensus/index.html)
    * [Census.data.gov](https://data.census.gov/)
    * [Using American Community Survey (ACS) Data - Digital Services](https://sfdigitalservices.gitbook.io/using-american-community-survey-acs-data)
    * [Analyzing US Census Data - Kyle Walker](https://walker-data.com/census-r/index.html)
    * [San Francisco Population and Demographic Census Data](https://data.sfgov.org/Economy-and-Community/San-Francisco-Population-and-Demographic-Census-Da/4qbq-hvtt/about_data)
    * [Crosswalk for Census data and SF neighborhood/supervisor district](https://data.sfgov.org/Geographic-Locations-and-Boundaries/Analysis-Neighborhoods-2020-census-tracts-assigned/sevw-6tgi/about_data)

2. tidycensus demo R script **(DAVID PLEASE LINK IT HERE)**

3. Basic Usage
    1. [Request a U.S. Census Data API Key](https://api.census.gov/data/key_signup.html)
    2. Visit [Census.data.gov](https://data.census.gov/) to view data

    ![Alt text](https://sfdigitalservices.gitbook.io/using-american-community-survey-acs-data/~gitbook/image?url=https%3A%2F%2F780490582-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fb2Dq7SxuLdQhFFxehXqC%252Fuploads%252Fgit-blob-d8921511994030be0caac329ba70c7948ae1a0c4%252F0%3Falt%3Dmedia&width=768&dpr=1&quality=100&sign=6b93a041&sv=2)

    3. Load package and view available data elements
        ```r
        library(tidycensus)
        
        var_5yr <- load_variables(2022, "acs5", cache = TRUE)
        var_5yrsubject <- load_variables(2022, "acs5/subject", cache = TRUE)
        ```
    4. Load city/county-level data (San Francisco Population)
        ```r
        library(tidycensus)
        library(tidyverse)


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
        ```
    5. Load tract-level data to aggregate up to supervisor district
        ```r
        library(tidycensus)
        library(tidyverse)

        tract_cw <- read_csv("https://data.sfgov.org/resource/sevw-6tgi.csv") %>% 
            rename(GEOID = geoid)


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
            left_join(tract_cw,
                        by = "GEOID") %>% 
            group_by(sup_dist_2022) %>% 
            summarize(estimate = sum(estimate),
                        moe = moe_sum(moe, estimate),
                        cv = (moe / (estimate * 1.645)))
        ```        