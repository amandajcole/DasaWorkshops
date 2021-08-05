# install.packages("tidyverse")
library(tidyverse)

# CTRL + SHIFT + C to comment multiple lines (Windows)

#We are going to work with the Starwars data set that is inbuilt in R

view(starwars)

#Assign the dataset starwars to the dataframe "data"


data <- starwars

#now the data set shows up in the environment with 87 observations of 14 variables

view(data)

#head and tail to see the first n lines or the last n lines of the dataset

head(data, 10)
tail(data,15)

# Basic data manipulation functions

filter()
slice()
arrange()

# The pipe function %>% to combine nested functions into one section of code

filter(data, homeworld == "Tatooine")

# This shows a tibble with the 10 characters that were from Tatooine but has no effect on the original dataset


filter(data, homeworld == "Tatooine", sex == "male")

# This shows a tibble with the 6 male characters that were from Tatooine but has no effect on the original dataset





# we can assign these observations to their own dataframe

Tatooine <- filter(data, homeworld == "Tatooine")

male_tatooine <- filter(data, homeworld == "Tatooine", sex == "male")

# Or using the "pipe" function we can achieve a similar outcome:

female_characters <- data %>%
  filter(sex == "female") %>%
  arrange(homeworld)

data %>%
  filter(species == "Human" & films =="Attack of the Clones" )


# lets look at the tallest characters

data %>% slice_max(height, n=10)

data %>% slice_min(mass, n=10)

data %>% slice_max(mass, n=10)

# Notice that IG-88 is a Droid with NA as a homeworld - is this the case for all droids?

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
  BMI = mass/ (height_m^2)
) %>%
  select(BMI, everything())

#lets deal with the missing values

data3 <- data2 %>% 
  filter(!is.na(mass)) %>%
  mutate(BMI = mass/ (height_m^2)) %>%
  select(BMI, everything())
