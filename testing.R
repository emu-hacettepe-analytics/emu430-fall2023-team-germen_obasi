library(readxl)
library(dplyr)
library(tidyr)
library(zoo)

#1st DATASET
data_literate <- read_xls("Population_by_literacy_and_gender.xls", col_names = TRUE, range = "A4:Q27")

data_literate_t <- t(data_literate)
data_literate_percentage <- data.frame(data_literate_t[-c(1,2), c(16,17)])
data_literate_end <- tibble::rownames_to_column(data_literate_percentage, "Year")
colnames(data_literate_end)[2:3] <- c("Literate(%)", "Illiterate(%)")

#2nd DATASET
data_population <- read_xls("Population.xls", col_names = TRUE, range = "A4:AA45")
data_population_clean <- data_population[-c(1,3,4,5,21,22,24,25,26), -c(2:12)]
data_population_clean_t <- t(data_population_clean)
colnames(data_population_clean_t) <- data_population_clean_t[1,1:32]
data_population_clean_t <- data_population_clean_t[-1,]
data_population_clean_t_sum <- data_population_clean_t

for (i in 1:16){
  data_population_clean_t_sum[,i] <- as.numeric(data_population_clean_t[,i]) + as.numeric(data_population_clean_t[,(i+16)])
}

data_population_clean_t_sum <- data_population_clean_t_sum[,-c(17:32)]
data_population_clean_t_sum[,"15-19"] <- round(as.numeric(data_population_clean_t_sum[,"15-19"]) * 2 / 5)
colnames(data_population_clean_t_sum)[colnames(data_population_clean_t_sum) == "15-19"] <- "18-19"

data_population_by_age <- data.frame(data_population_clean_t_sum)
data_population_by_age <- data_population_by_age |> mutate("18-24" = as.numeric(data_population_by_age[,2]) + as.numeric(data_population_by_age[,3])) |> 
  mutate("25-34" = as.numeric(data_population_by_age[,4]) + as.numeric(data_population_by_age[,5])) |>
  mutate("35-44" = as.numeric(data_population_by_age[,6]) + as.numeric(data_population_by_age[,7])) |>
  mutate("45-54" = as.numeric(data_population_by_age[,8]) + as.numeric(data_population_by_age[,9])) |>
  mutate("55-64" = as.numeric(data_population_by_age[,10]) + as.numeric(data_population_by_age[,11])) |>
  mutate("65+" = as.numeric(data_population_by_age[,12]) + as.numeric(data_population_by_age[,13]) + as.numeric(data_population_by_age[,14]) + as.numeric(data_population_by_age[,15]) + as.numeric(data_population_by_age[,16]))

data_population_by_age <- data_population_by_age[,-c(2:16)]
column_names <- c("Pop(Total)", "Pop(18-24)", "Pop(25-34)", "Pop(35-44)", "Pop(45-54)", "Pop(55-64)", "Pop(65+)")
colnames(data_population_by_age) <- column_names
data_population_end <- tibble::rownames_to_column(data_population_by_age, "Year")

#3rd DATASET
data_happiness <- read_xls("Happiness-Age.xls", col_names = TRUE, range = "A5:H85")
data_happiness_no_Na <- data_happiness[-c(1:21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77),]
data_happiness_no_Na <- na.locf(data_happiness_no_Na, fromLast = FALSE)
data_happiness_no_Na_wider <- data_happiness_no_Na |> gather(key = "Age", value = "Percentage", 3,4,5,6,7,8) |> pivot_wider(names_from = c(2, "Age"), values_from = "Percentage")

column_names_happiness <- as.character(c("Year", "Happy(18-24)(%)", "Neutral(18-24)(%)", "Unhappy(18-24)(%)", "Happy(25-34)(%)", "Neutral(25-34)(%)", "Unhappy(25-34)(%)", "Happy(35-44)(%)", "Neutral(35-44)(%)", "Unhappy(35-44)(%)", "Happy(45-54)(%)", "Neutral(45-54)(%)", "Unhappy(45-54)(%)", "Happy(55-64)(%)", "Neutral(55-64)(%)", "Unhappy(55-64)(%)", "Happy(65+)(%)", "Neutral(65+)(%)", "Unhappy(65+)(%)"))
colnames(data_happiness_no_Na_wider) <- column_names_happiness
data_happiness_end <- data_happiness_no_Na_wider
data_happiness_end$Year <- as.character(data_happiness_end$Year)

#Final DATASET
literate_population <- left_join(data_literate_end, data_population_end, by = "Year")
literate_population_happiness <- left_join(literate_population, data_happiness_end, by = "Year")

final_data <- literate_population_happiness

save(final_data, file = "testing_data.RData")
