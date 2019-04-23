## Descriptive Table (Table 1) for Final Project
## J. Shearston
## April 23, 2019

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
age_cat

# Race / Ethnicity
table (aamehs_data$race_ethnicity, useNA = "ifany")

# Houshold Education
table (aamehs_data$hh_education, useNA = "ifany")

