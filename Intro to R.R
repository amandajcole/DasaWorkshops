# install.packages("tidyverse")
#install.packages('knitr')
#install.packages("janitor")
library(tidyverse)
library(ggplot2)
library(knitr)
library(janitor)
# CTRL + SHIFT + C to comment multiple lines (Windows)

#We are going to work with the Starwars data set that is inbuilt in R, this is a relatively clean data set with not many missing values
#you will learn some base functions that will start you on the road to becoming a data-jedi



view(starwars)

#Assign the dataset starwars to the dataframe "data"
str(starwars)

#Assign the first 11 columns to dataframe "data"
data <- select(starwars, c(1:11)) 

#now the data set shows up in the environment with 87 observations of 11 variables

view(data)

#head and tail to see the first n lines or the last n lines of the dataset

head(data, 10)
tail(data,15)

# Basic data manipulation functions

filter()
slice()
arrange()

data %>% count(species, homeworld, sort = TRUE)


data %>% count(homeworld, species, sort = TRUE)

data %>% count(species, eye_color, sort = TRUE)
data %>% count(eye_color, species, sort = TRUE)

filter(data, homeworld == "Tatooine")

# This shows a tibble with the 10 characters that were from Tatooine but has no effect on the original dataset


filter(data, homeworld == "Tatooine", sex == "male") 

# This shows a tibble with the 6 male characters that were from Tatooine but has no effect on the original dataset


# we can assign these observations to their own dataframe

Tatooine <- filter(data, homeworld == "Tatooine")

male_tatooine <- filter(data, homeworld == "Tatooine", sex == "male")

# Or using the "pipe" function we can achieve a similar outcome:
# The pipe function %>% to combine nested functions into one section of code
female_characters <- data %>%
  filter(sex == "female") %>%
  arrange(homeworld)

kable(female_characters)


test<- starwars %>%
 select(name, species,sex, homeworld, films) %>%
  filter(species == "Droid" & films =="The Empire Strikes Back" ) %>%
  arrange(name)

test2<- starwars %>%
  select(name, species,sex, homeworld, films) %>%
  filter(species == "Droid") %>%
  arrange(name)

str(starwars)
class(starwars$films)


# lets look at the tallest characters

data %>% slice_max(height, n=10)

data %>% slice_min(mass, n=10)

data %>% slice_max(mass, n=10)

# Notice that IG-88 is a Droid with NA as a homeworld - is this the case for all droids?

slice_min()
droid <- data %>%
 filter(species == "Droid") %>%
  select(name, height, mass, homeworld) %>%
  arrange(height)

#adding new columns with mutate

data %>% mutate(height_m = height / 100)

data %>%
  mutate(height_m = height / 100) %>%
  select(height_m, height, everything())

# lets assign this to the data set
data2 <- data %>%
  mutate(height_m = height / 100) %>%
  select(height_m, height, everything())

# Lets look at the BMI for each of the characters and assign it to a new dataset
data3 <- data2 %>% mutate(
  BMI = mass/ (height_m^2)) %>%
  select(BMI, everything())

#lets deal with the missing values

data3 <- data2 %>% 
  filter(!is.na(mass)) %>%
  mutate(BMI = mass/ (height_m^2)) %>%
  select(BMI, everything())

#
ggplot(starwars, aes(species)) +
  geom_bar() +
  coord_flip()

ggplot(starwars, aes(homeworld)) +
  geom_bar() +
  coord_flip()

human <-data %>%
  filter(species == "Human" & homeworld == "Naboo" | homeworld == "Tatooine")

ggplot(human, aes(homeworld)) +
  geom_bar()+
  coord_flip()

ggplot(starwars, aes(homeworld, fill = gender)) +
  geom_bar() +
  coord_flip()

starwars %>% 
  filter(!is.na(homeworld)) %>% 
  ggplot(aes(homeworld, fill=gender))+
  geom_bar() +
  coord_flip()

starwars %>% 
  filter(!is.na(homeworld)) %>% 
  ggplot(aes(homeworld, fill=gender))+
  geom_bar(position='stack') +
  coord_flip()
  

#using the janitor package

tabyl(starwars, homeworld)

# remove empty rows
clean_data <-remove_empty(starwars, which = c("rows", "cols"))

tabyl(clean_data, homeworld)  

# we still have the NA's, theres no completely empty rows or columns

# cross tablulation
clean_data %>% filter(sex != "female") %>%
  tabyl(height,species)

clean_data %>% tabyl(height,gender)
