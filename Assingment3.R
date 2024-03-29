library(tidyverse)

data <- get(load("final_data.RData"))
ages <- c("Happy(18-24)(%)","Happy(25-34)(%)","Happy(35-44)(%)","Happy(45-54)(%)","Happy(55-64)(%)","Happy(65+)(%)")
year_ages <- data |> select(Year, ages)
year_ages

ggplot(year_ages, aes(x = Year)) +
  geom_line(aes(y =`Happy(18-24)(%)`, color = ages[1], group=1)) +
  geom_line(aes(y =`Happy(25-34)(%)`, color = ages[2], group=1)) +
  geom_line(aes(y =`Happy(35-44)(%)`, color = ages[3], group=1)) +
  geom_line(aes(y =`Happy(45-54)(%)`, color = ages[4], group=1)) +
  geom_line(aes(y =`Happy(55-64)(%)`, color = ages[5], group=1)) +
  geom_line(aes(y =`Happy(65+)(%)`, color = ages[6], group=1)) +
  labs(title = "Happiness Rates by Age Groups by Year")


#GRAPH---2
rate_of_change <- c()

for (x in (1:14)) {
  ratio <- ((as.numeric(final_data[(x + 1), "Literate(%)"]) * 100) / as.numeric(final_data[x, "Literate(%)"])) - 100
  print(ratio)
  rate_of_change <- c(rate_of_change,ratio)
}

rate_of_change
x_axis = c("2008-2009","2009-2010","2010-2011","2011-2012","2012-2013","2013-2014","2014-2015","2015-2016","2016-2017","2017-2018","2018-2019","2019-2020","2020-2021","2021-2022")
mode(x_axis)
row_names <- c("rate_of_change", "x_axis")
df <- data.frame(rate_of_change, x_axis)

ggplot(df, aes(x = x_axis, y = as.numeric(rate_of_change))) + geom_col() +
  labs(title = "Rate of Increase in Literacy by Years") + 
  xlab("Rate of Change") + 
  ylab("Year") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#GRAPH---3
data$`Happy(55-64)(%)`[9] <- 62.3001

happy_18_24_pop <- sapply(data$`Happy(18-24)(%)`, function(x) {x * data$`Pop(18-24)`[which(data$`Happy(18-24)(%)` == x)]})
happy_25_34_pop <- sapply(data$`Happy(25-34)(%)`, function(x) {x * data$`Pop(25-34)`[which(data$`Happy(25-34)(%)` == x)]})
happy_35_44_pop <- sapply(data$`Happy(35-44)(%)`, function(x) {x * data$`Pop(35-44)`[which(data$`Happy(35-44)(%)` == x)]})
happy_45_54_pop <- sapply(data$`Happy(45-54)(%)`, function(x) {x * data$`Pop(45-54)`[which(data$`Happy(45-54)(%)` == x)]})
happy_55_64_pop <- sapply(data$`Happy(55-64)(%)`, function(x) {x * data$`Pop(55-64)`[which(data$`Happy(55-64)(%)` == x)]})
happy_65_pop <- sapply(data$`Happy(65+)(%)`, function(x) {x * data$`Pop(65+)`[which(data$`Happy(65+)(%)` == x)]})

happy_pop_df <- data.frame(happy_18_24_pop, happy_25_34_pop, happy_35_44_pop, happy_45_54_pop, happy_55_64_pop, happy_65_pop)
happy_pop_total_df <- happy_pop_df |> mutate(Total_Happy = rowSums(happy_pop_df))


happy_pop_total_ratio <- sapply(as.numeric(happy_pop_total_df$Total_Happy), function(x) {x / as.numeric(data$`Pop(Total)`[which(happy_pop_total_df$Total_Happy == x)])})
print(happy_pop_total_ratio)


ggplot(data, aes(x = Year)) +
    geom_line(aes(y = as.numeric(`Literate(%)`), color = "red", group=2)) +
  geom_line(aes(y = happy_pop_total_ratio, color = "blue", group=1)) + 
  labs(title = "Literacy and Happiness by Years") + ylab("Literate(%)") +
  scale_color_manual(values = c("red", "blue"),
                     labels = c("Literate",
                                "Happy Population Total"))
  


#Pie Plot

happiness_percentages <- data[11, c("Happy(18-24)(%)", "Happy(25-34)(%)", "Happy(35-44)(%)", 
                                    "Happy(45-54)(%)", "Happy(55-64)(%)", "Happy(65+)(%)")]
happiness_percentages
actual_populations <- as.numeric(happiness_percentages)

pie(actual_populations, labels = (c("Happy(18-24)(%)", "Happy(25-34)(%)", "Happy(35-44)(%)", 
                                            "Happy(45-54)(%)", "Happy(55-64)(%)", "Happy(65+)(%)")), main = "Population Distribution by Age Group (2018)")