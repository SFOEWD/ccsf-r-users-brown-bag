# packages.R - Load packages needed for analysis 
# Code adapted from https://grssnbchr.github.io/rddj-template/#define_packages



#install.packages('pacman')
library(pacman)

my_packages <- c("lubridate",  # date/time helper
                 "readxl",     # read in excel
                 "scales",     # ggplot formatting help
                 "DT",         # interactive tables
                 "cowplot",    # two plots side by side
                 "GGally",     # extra features for ggplot
                 "ggrepel",    # extra features for ggplot
                 "ggthemes",   # extra themes for ggplot
                 "ggExtra",    # extra features for ggplot
                 "plotly",     # interactive charts
                 "gridExtra",  # extra features for ggplot
                 "RColorBrewer",# extra color options for ggplot
                 "keyring", #store/access passwords on keychain
                 "glue",
                 "skimr",
                 "validate",
                 "here",
                 "feather",
                 "rpivotTable",
                 "data.table",
                 "tidyverse")

pacman::p_load(my_packages, character.only = TRUE)

rm(my_packages)
