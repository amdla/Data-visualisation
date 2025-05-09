# Load required libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)

# Load the CSV file
data <- read.csv("Renewable_energy.csv", stringsAsFactors = FALSE)

# Clean column names
colnames(data) <- tolower(trimws(colnames(data)))

# Filter for rows where Country == "World"
world_data <- data %>%
  filter(country == "Norway")

# Check if any rows match "World"
if (nrow(world_data) == 0) {
  stop("No records found with Country = 'World'")
}

# Identify yearly columns (F2000 to F2023)
year_cols <- names(data)[grepl("^f\\d+$", names(data))]

# Convert year columns to numeric
world_data[year_cols] <- lapply(world_data[year_cols], as.numeric)

# Function to convert energy values to MWh
convert_to_mwh <- function(value, unit) {
  if (unit == "Gigawatt-hours (GWh)") {
    return(value * 1000) # GWh to MWh
  } else if (unit == "Megawatt (MW)") {
    return(value * 8760) # MW to MWh/year (approx 8760 hours/year)
  } else {
    return(value) # Default, no conversion
  }
}

# Apply conversion and sum yearly values
world_data <- world_data %>%
  rowwise() %>%
  mutate(
    total_mwh = sum(c_across(all_of(year_cols)), na.rm = TRUE),
    total_mwh = convert_to_mwh(total_mwh, unit)
  ) %>%
  ungroup()

# Extract and sum totals by energy type
summary_data <- world_data %>%
  filter(energy_type %in% c("Total Renewable", "Total Non-Renewable")) %>%
  group_by(Energy_Type = energy_type) %>%
  summarise(Total_MWh = sum(total_mwh, na.rm = TRUE))

# Print summary for debugging
print("Summary of Total MWh by Energy Type:")
print(summary_data)

# Plot with ggplot2
plot <- ggplot(summary_data, aes(x = Energy_Type, y = Total_MWh, fill = Energy_Type)) +
  geom_bar(stat = "identity", color = "black") +
  labs(
    title = "Total Energy (MWh) by Type (Norway)",
    x = "Energy Type",
    y = "Total Energy (MWh)",
    fill = "Energy Type"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("Total Renewable" = "lightgreen", "Total Non-Renewable" = "lightcoral")) +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )

# Print the plot
print(plot)

png(filename = "Energy_Type_Summary_MWh_Norway.png", width = 2400, height = 1600, res = 300)
print(plot)
dev.off()
# Save the plot as a high-quality PNG file
# ggsave(
#   filename = "Energy_Type_Summary_MWh.png",
#   plot = plot,
#   dpi = 300,
#   width = 8,
#   height = 6,
#   units = "in"
# )