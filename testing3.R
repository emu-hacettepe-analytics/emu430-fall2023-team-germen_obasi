# Install and load ggplot2 if not already installed
# install.packages("ggplot2")
library(ggplot2)

your_data <- get(load('testing_data.RData'))

# Melt the data frame for better compatibility with ggplot2
library(reshape2)
melted_data <- melt(your_data, id.vars = c("Year"), measure.vars = c(
  "Happy(18-24)(%)", "Neutral(18-24)(%)", "Unhappy(18-24)(%)",
  "Happy(25-34)(%)", "Neutral(25-34)(%)", "Unhappy(25-34)(%)",
  "Happy(35-44)(%)", "Neutral(35-44)(%)", "Unhappy(35-44)(%)",
  "Happy(45-54)(%)", "Neutral(45-54)(%)", "Unhappy(45-54)(%)",
  "Happy(55-64)(%)", "Neutral(55-64)(%)", "Unhappy(55-64)(%)",
  "Happy(65+)(%)", "Neutral(65+)(%)", "Unhappy(65+)(%)"
))

# Plotting Boxplots for Happiness Levels with ggplot2
ggplot(melted_data, aes(x = variable, y = value, fill = variable)) +
  geom_boxplot() +
  labs(title = "Boxplots for Happiness Levels Across Age Groups",
       x = "Age Group",
       y = "Percentage",
       fill = "Happiness Level") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))