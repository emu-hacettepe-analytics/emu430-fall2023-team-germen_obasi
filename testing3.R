library(ggplot2)

# Assuming your_data is your dataset loaded from the RData file
your_data <- get(load('testing_data.RData'))
# Define the age groups
age_groups <- c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")

# Create a list to store the ggplot objects for each age group
plots_list <- list()

# Loop through each age group
for (age_group in age_groups) {
  # Extract columns relevant to the current age group
  age_group_columns <- grep(paste0("(", age_group, ")"), colnames(your_data), value = TRUE)
  
  # Create a stacked bar chart for the current age group
  plot <- ggplot(your_data, aes(x = Year)) +
    geom_bar(aes(y = get(paste0("Pop","(", age_group,")")), fill = factor(age_group)),
             stat = "identity", position = "stack") +
    labs(title = paste("Population Distribution - Age Group", age_group),
         x = "Year",
         y = "Total Population") +
    theme_minimal() +
    theme(legend.position = "top")
  
  # Store the plot in the list
  plots_list[[age_group]] <- plot
}

# Print or display the plots
for (age_group in age_groups) {
  print(plots_list[[age_group]])
}
