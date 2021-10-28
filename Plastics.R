# Install packages and load libraries

library(tidyverse)
library(skimr)
library(ggplot2)
#library(janitor)


# The original dataset come from Break free from Plastic and was put together by 
#Sarah Sauve. This was featured in Tidy Tuesday in January 2021.

# https://github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-01-26/readme.md


# read in the dataset
plastics <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv')

skim(plastics)


# There are two columns as character and the rest are numeric, looking at the data
# there are some missing variables
# and we need to work out how to use them. 
# Do we replace them with zeros, or ignore them in the analysis. 
# That depends on what question we are asking.


rename(plastics, other=o)

view(plastics)


plastics<-rename(plastics, other = o)
view(plastics)

# Lets look at the empty column to decide is we need it include this in the totals

plastics %>% 
  group_by(country) %>%
  count(empty)

# Not sure what the data in Australia means - why is there 4 observations? 
# Look at Australian data to understand the dataset
oz<-plastics %>%
  filter(country == "Australia")

view(oz)

#Lets look at the countries in the dataset
count_country <- plastics %>%
  group_by(year) %>%
  count(country)

# Count the number of events
count_country %>% count(year)
# add the filter for Australia or pick another country 
# filter(country == "Australia") %>%

count_country %>% tabyl(year)


# plot count country
ggplot(count_country, aes(n, country, colour = year))+
  geom_point()

# its difficult to see the difference in the years lets make them a shape
ggplot(count_country, aes(n, country, shape = year))+
  geom_point()

# Error - R is treating the Year as a continuous variable - we need to make it a factor
# 
count_country$year <-as.factor(count_country$year)
  
skim(count_country)

# Year is now a factor

# lets try the plot again

ggplot(count_country, aes(n, country, colour = year))+
  geom_point()

# with a shape?
ggplot(count_country, aes(n, country, shape = year))+
  geom_point()


# Lets look at the companies 
count_company <- plastics %>%
  group_by(year) %>%
  count(parent_company)

count_company %>%
  arrange(desc(n))%>%
  head(50)%>% 
  ggplot(aes(n, parent_company, colour = year)) +
  geom_point()

# the same thing happened with the scale - that's because we factorized the year column in the count_country data frame and not the original plastics data frame.

plastics$year <-as.factor(plastics$year)

# try it again
count_company <- plastics %>%
  group_by(year) %>%
  count(parent_company)

count_company %>%
  arrange(desc(n))%>%
  head(50)%>% 
  ggplot(aes(n, parent_company, colour = year)) +
  geom_point()

view(count_company)

#Its not a tidy data frame

#use pivot_wider
company <- count_company %>%
  pivot_wider(names_from = year, values_from = n)

view(company)
#replace the NA's with 0's - why does this not work
company$2019[is.na(company$2019)] <- 0

company$'2019'[is.na(company$'2019')] <- 0
company$'2020'[is.na(company$'2020')] <- 0

view(company)
#company$yr2019[is.na(company$yr2019)] <- 0

company <-rename(company, yr2019='2019')
company <-rename(company, yr2020='2020')


# volunteers

volunteers <- plastics %>%
  group_by(country, year) %>%
  distinct(country, year, volunteers)

view(volunteers)


volunteers %>%
  ggplot(aes(country, volunteers, colour =year))+
  geom_point()+
  coord_flip()

volunteers %>%
  ggplot(aes(country, volunteers, shape= year))+
  geom_point()+
  coord_flip()+
  theme_light()

volunteers %>%
  ggplot(aes(country, volunteers, colour = year, shape = year))+
  geom_point()+
  coord_flip()+
  theme_light()

#Does Taiwan really have over 30 thousand volunteers?

Taiwan<-volunteers %>%
  filter(country == "Taiwan_ Republic of China (ROC)")

#Lets tidy up the dataframe

volunteers_by_year <- volunteers %>%
  pivot_wider(names_from = year, values_from = volunteers)

view(volunteers_by_year)

# oops those column names again - we should have done this in the original file

volunteers_by_year <-rename(volunteers_by_year, yr2019='2019')
volunteers_by_year <-rename(volunteers_by_year, yr2020='2020')

view(volunteers_by_year)

#look at the countries that only participated in one year
country_participants <- volunteers_by_year %>% 
  filter(is.na(yr2019) | is.na(yr2020)) 



volunteers_dif <-volunteers_by_year %>% mutate(difference = (yr2020-yr2019))

view(volunteers_dif)

# Lesson learned - those NA values need to be fixed again

volunteers_by_year$yr2019[is.na(volunteers_by_year$yr2019)] <- 0
volunteers_by_year$yr2020[is.na(volunteers_by_year$yr2020)] <- 0

volunteers_dif <-volunteers_by_year %>% mutate(difference = (yr2020-yr2019))

volunteers_dif %>%
 arrange(difference)%>%
 ggplot(aes(x=difference, y=reorder(country,-difference))) +
    geom_point() +
    ggtitle("The change in the number of volunteers (2019-2020) by country")

volunteers_dif %>%
  arrange(desc(difference))%>%
   head(20)%>% 
   ggplot(aes(x=difference, y=reorder(country,-difference))) +
   geom_point() +
   ggtitle("Countrys with an increase in volunteers from 2019-2020")
 

volunteers_dif %>%
   arrange(difference) %>%
   head(20)%>% 
  ggplot(aes(x=difference, y=reorder(country,-difference))) +
   geom_point() +
   ggtitle("Countrys with a decrease in volunteers from 2019-2020")


stats <- plastics %>% select(country, year, num_events, volunteers)%>%
  distinct(country, year, num_events, volunteers) %>%
  arrange(country)

ggplot(stats, aes(country, volunteers, fill = year)) +
  geom_bar(position="dodge2", stat = "identity", width = 0.7)+
  coord_flip()

  





