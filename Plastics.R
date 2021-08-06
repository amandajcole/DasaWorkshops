library(tidyverse)
library(skimr)

# The original dataset come from Break free from Plastic and was put together by Sarah Sauve. This was featured in Tidy Tuesday in January 2021.

# read in the dataset
plastics <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv')

skim(plastics)

# There are two columns as character and the rest are numeric, looking at the data there are some missing variables
# and we need to work out how to use them. Do we replace them with zeros, or ignore them in the analysis. That depends on what question we are asking.
