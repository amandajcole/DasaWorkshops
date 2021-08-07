library(tidyverse)
library(skimr)
library(janitor)
library(ggplot2)

# The original dataset come from Break free from Plastic and was put together by Sarah Sauve. This was featured in Tidy Tuesday in January 2021.

# read in the dataset
plastics <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv')

skim(plastics)

# There are two columns as character and the rest are numeric, looking at the data there are some missing variables
# and we need to work out how to use them. Do we replace them with zeros, or ignore them in the analysis. That depends on what question we are asking.


rename(plastics, other=o)

view(plastics)

plastics<-rename(plastics, other = o)
view(plastics)

# Lets look at the empty column to decide is we need it include this in the totals

plastics %>% 
  group_by(country) %>%
  count(empty)

oz <- plastics %>%
  filter(country == "Australia")

view(oz)

oz %>% count(empty)
#lets use janitor to clean up some of the duplicate records

oz %>% get_dupes(parent_company)


count_country <- plastics %>%
  group_by(year) %>%
  count(country)

# plot the 
ggplot(count_country, aes(n, country, colour = year))+
  geom_point()
  
count_company <- plastics %>%
  group_by(year) %>%
  count(parent_company)

count_company %>%
  arrange(desc(n))%>%
  head(50)%>% 
  ggplot(aes(n, parent_company, colour = year)) +
  geom_point()

company <- count_company %>%
  pivot_wider(names_from = year, values_from = n)
