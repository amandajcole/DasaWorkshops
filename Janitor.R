# install.packages("janitor")
# library(janitor)

view(mtcars)

mtcars %>%
  tabyl(am,cyl)%>%
  adorn_percentages("col") %>%
  adorn_pct_formatting() %>%
  adorn_ns(position = "front")


mtcars %>%
  tabyl(am,cyl)%>%
  adorn_percentages("col") %>%
  adorn_pct_formatting(digits = 3) %>%
  adorn_ns(position = "front") %>%
  adorn_title(placement = "top", row_name = "am", col_name = "cylinder")
