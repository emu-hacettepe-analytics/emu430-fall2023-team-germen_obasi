library(corrplot)

# Assuming your_data is your dataset loaded from the RData file
your_data <- get(load('testing_data.RData'))
# Select relevant columns for correlation analysis
selected_columns <- c("Literate(%)", "Illiterate(%)", "Pop(Total)",
                       "Pop(18-24)", "Pop(25-34)", "Pop(35-44)",
                       "Pop(45-54)", "Pop(55-64)", "Pop(65+)",
                       "Happy(18-24)(%)", "Neutral(18-24)(%)", "Unhappy(18-24)(%)",
                       "Happy(25-34)(%)", "Neutral(25-34)(%)", "Unhappy(25-34)(%)",
                       "Happy(35-44)(%)", "Neutral(35-44)(%)", "Unhappy(35-44)(%)",
                       "Happy(45-54)(%)", "Neutral(45-54)(%)", "Unhappy(45-54)(%)",
                       "Happy(55-64)(%)", "Neutral(55-64)(%)", "Unhappy(55-64)(%)",
                       "Happy(65+)(%)", "Neutral(65+)(%)", "Unhappy(65+)(%)")

# Subset the data
selected_data <- your_data[, selected_columns]

# Convert non-numeric columns to numeric
selected_data[] <- lapply(selected_data, function(x) as.numeric(as.character(x)))

# Calculate the correlation matrix
correlation_matrix <- cor(selected_data, use = "complete.obs")

# Create a correlation heatmap
corrplot(correlation_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45)
