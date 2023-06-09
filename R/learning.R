# Load packages

library(tidyverse)
library(NHANES)


# Looking at data; NHANES er et datasæt der ligger i en pakke man kan bruge.
glimpse(NHANES)

# Selecting columns

select(NHANES, Age)

select(NHANES, Age, Weight, BMI)

select(NHANES, -HeadCirc)

select(NHANES, starts_with("BP"))

select(NHANES, ends_with("Day"))

select(NHANES, contains("Age"))


# Nu vil vi danne et datasæt og ikke bare se det, men gemme det til brug:
# Create smaller NHANES datasæt
nhanes_small <- select(
  NHANES, Age, Gender, BMI, Diabetes,
  PhysActive, BPSysAve, BPDiaAve, Education
)


# Renaming columns
nhanes_small <- rename_with(
  nhanes_small,
  snakecase::to_snake_case
)

# Renaming specific columns

nhanes_small <- rename(nhanes_small, sex = gender)

# så skal vi til at pippe!! :) ctrl shift m = pipen

colnames(nhanes_small)

nhanes_small %>%
  colnames()

nhanes_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)

# opgave 7.8
# 1
nhanes_small %>%
  select(bp_sys_ave, education)

# 2
nhanes_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )
# 3
nhanes_small %>%
  select(bmi, contains("age"))

# 4

blood_pressure <- select(nhanes_small, starts_with("bp_"))
rename(blood_pressure, bp_systolic = bp_sys_ave)
# rewrite:

nhanes_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)


# Filtering (nu blir det spændende, dplyr, 7.9)
nhanes_small %>%
  filter(phys_active == "No")
# filter alle med bmi 25
nhanes_small %>%
  filter(bmi == 25)

# filter alle med bmi 25 eller over ! OBS bemærk rækkefølge >=
nhanes_small %>%
  filter(bmi >= 25)

# combining logical operators

nhanes_small %>%
  filter(bmi >= 25 & phys_active == "No")

nhanes_small %>%
  filter(bmi >= 25 | phys_active == "No")


# arrange data

nhanes_small %>%
  arrange(age)
# desenting:
nhanes_small %>%
  arrange(desc(age))

nhanes_small %>%
  arrange(education, age)


# Creating new columnes and transforming:
######################
# Transform data
nhanes_small %>%
  mutate(
    age = age * 12,
    logge_bmi = log(bmi)
  )

nhanes_small %>%
  mutate(old = if_else(age >= 30, "Yes", "No"))



# 7.12 Exercise: Piping, filtering, and mutating --------------------------

# 1. BMI between 20 and 40 with diabetes
nhanes_small %>%
    # Format should follow: variable >= number or character
    filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# Pipe the data into mutate function and:
nhanes_modified <- nhanes_small %>% # Specifying dataset
    mutate(
        # 2. Calculate mean arterial pressure
        mean_arterial_pressure = ((2*bp_dia_ave)+bp_sys_ave)/3,
        # 3. Create young_child variable using a condition
        young_child = if_else(age < 6, "Yes", "No")
    )

nhanes_modified


# creating summary statistics, 7.14 ---------------------------------------

nhanes_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE),
              min_bmi = min (bmi, na.rm = TRUE))
#na.rm = TRUE, siger slet missing values, ellers virker funktionen ikke

#men kan vi se på bmi i grupper ?

nhanes_small %>%
    filter(!is.na(diabetes)) %>% #ikke (!) missing i diabetes, dvs na i diabetes filtres fra
    group_by(diabetes) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE)) %>%
    ungroup() #sikre vi ophæver grupperne

#saving data 7.16:
readr::write_csv(nhanes_small,
                 here::here("data/nhance_small.csv"))

# nyt datasæt hente 7.17-------------------------------------------------------


nhanes_small <- readr::read_csv(here::here("data/nhanes_small.csv")


