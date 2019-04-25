## Descriptive Table (Table 1) for Final Project
## J. Shearston
## April 23, 2019

library(tidyverse)

# Load data
aamehs_data <- read_csv("aamehs_data.csv")
names(aamehs_data)

total<-1977

# Sex
table (aamehs_data$gender, useNA = "ifany")
959/total
1018/total

# Age
mean(aamehs_data$age, useNA = "ifany")
sd(aamehs_data$age)

# Age Categories
age_cat <- case_when(
  aamehs_data$age <20  ~ "12-19",
  aamehs_data$age >=20 ~ "20+"
)
table (age_cat, useNA = "ifany")
349/total
1628/total

# Race / Ethnicity
table (aamehs_data$race_ethnicity, useNA = "ifany")
363/total
256/total
616/total
437/total
220/total
85/total

# Houshold Education
table (aamehs_data$hh_education, useNA = "ifany")
205/total
230/total
400/total
615/total
456/total
71/total

# BMI
mean(aamehs_data$bmi)
sd(aamehs_data$bmi)

# BMI Crosstabs
aamehs_data %>% 
  mutate(gender = as.factor(gender)) %>% 
  dplyr::group_by(gender) %>% 
  dplyr::summarise(mean = mean(bmi),
                   sd = sd(bmi))

aamehs_data %>% 
  mutate(age_cat = case_when(
    aamehs_data$age <20  ~ "12-19",
    aamehs_data$age >=20 ~ "20+"
    )) %>% 
  dplyr::group_by(age_cat) %>% 
  dplyr::summarise(mean = mean(bmi),
                   sd = sd(bmi))

aamehs_data %>% 
  mutate(race_ethnicity = as.factor(race_ethnicity)) %>% 
  dplyr::group_by(race_ethnicity) %>% 
  dplyr::summarise(mean = mean(bmi),
                   sd = sd(bmi))

aamehs_data %>% 
  mutate(hh_education = as.factor(hh_education)) %>% 
  dplyr::group_by(hh_education) %>% 
  dplyr::summarise(mean = mean(bmi),
                   sd = sd(bmi))

# PFOA
aamehs_data %>% 
  summarise(median = median(n_pfoa),
            IQR = IQR(n_pfoa))

# PFOA Crosstabs
aamehs_data %>% 
  mutate(gender = as.factor(gender)) %>% 
  dplyr::group_by(gender) %>% 
  dplyr::summarise(median = median(n_pfoa),
                   IQR = IQR(n_pfoa))

aamehs_data %>% 
  mutate(age_cat = case_when(
    aamehs_data$age <20  ~ "12-19",
    aamehs_data$age >=20 ~ "20+"
  )) %>% 
  dplyr::group_by(age_cat) %>% 
  dplyr::summarise(median = median(n_pfoa),
                   IQR = IQR(n_pfoa))

aamehs_data %>% 
  mutate(race_ethnicity = as.factor(race_ethnicity)) %>% 
  dplyr::group_by(race_ethnicity) %>% 
  dplyr::summarise(median = median(n_pfoa),
                   IQR = IQR(n_pfoa))

aamehs_data %>% 
  mutate(hh_education = as.factor(hh_education)) %>% 
  dplyr::group_by(hh_education) %>% 
  dplyr::summarise(median = median(n_pfoa),
                   IQR = IQR(n_pfoa))

# PFOS
aamehs_data %>% 
  summarise(median = median(n_pfos),
            IQR = IQR(n_pfos))

# PFOS Crosstabs
aamehs_data %>% 
  mutate(gender = as.factor(gender)) %>% 
  dplyr::group_by(gender) %>% 
  dplyr::summarise(median = median(n_pfos),
                   IQR = IQR(n_pfos))

aamehs_data %>% 
  mutate(age_cat = case_when(
    aamehs_data$age <20  ~ "12-19",
    aamehs_data$age >=20 ~ "20+"
  )) %>% 
  dplyr::group_by(age_cat) %>% 
  dplyr::summarise(median = median(n_pfos),
                   IQR = IQR(n_pfos))

aamehs_data %>% 
  mutate(race_ethnicity = as.factor(race_ethnicity)) %>% 
  dplyr::group_by(race_ethnicity) %>% 
  dplyr::summarise(median = median(n_pfos),
                   IQR = IQR(n_pfos))

aamehs_data %>% 
  mutate(hh_education = as.factor(hh_education)) %>% 
  dplyr::group_by(hh_education) %>% 
  dplyr::summarise(median = median(n_pfos),
                   IQR = IQR(n_pfos))
