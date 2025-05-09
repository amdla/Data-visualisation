# Load required libraries
library(dplyr)
library(ggplot2)
library(readr)

# Read the CSV file (adjust the filename/path)
data <- read_csv("Renewable_energy.csv")  # Replace with your actual file path

# Replace "Hydropower (excl. Pumped Storage)" with "Hydropower"
data <- data %>%
  mutate(Technology = ifelse(Technology == "Hydropower (excl. Pumped Storage)", "Hydropower", Technology))

# Filter data to keep only rows that contain 'World' in the Country column
data <- data %>%
  filter(grepl("Advanced Economies", Country, ignore.case = TRUE))

# Process the data:
# If the Unit column contains "MWh", convert F2021 by dividing by 1000; otherwise, keep as is.
data <- data %>%
  mutate(
    Energy_GWh = ifelse(grepl("MWh", Unit, ignore.case = TRUE), F2021 / 1000, F2021)
  )

# Define common Technology levels from the updated dataset for consistent color mapping
common_technologies <- sort(unique(data$Technology))

# ----------------------------
# Plot 1: Electricity Generation
# ----------------------------

# Filter and factorize data for Indicator "Electricity Generation"
data_generation <- data %>%
  filter(Indicator == "Electricity Generation") %>%
  mutate(Technology = factor(Technology, levels = common_technologies))

# Summarize total energy generation by Technology
tech_summary_generation <- data_generation %>%
  group_by(Technology) %>%
  summarise(Total_Energy = sum(Energy_GWh, na.rm = TRUE))

# Create bar plot for Electricity Generation, sorting bars by Total_Energy
p_generation <- ggplot(tech_summary_generation, aes(x = reorder(Technology, Total_Energy), y = Total_Energy, fill = Technology)) +
  geom_bar(stat = "identity") +
  xlab("Technology") +
  ylab("Total Energy Generation (GWh)") +
  ggtitle("Electricity Generation by Technology (Advanced Economies)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
    # Axis text remains horizontal by default
  ) +
  scale_fill_brewer(palette = "Set2")

# Save the Electricity Generation plot to a PNG file
png(filename = "Electricity_Generation_Adv.png", width = 2400, height = 1600, res = 300)
print(p_generation)
dev.off()

# ----------------------------
# Plot 2: Electricity Installed Capacity
# ----------------------------

# Filter and factorize data for Indicator "Electricity Installed Capacity"
data_installed <- data %>%
  filter(Indicator == "Electricity Installed Capacity") %>%
  mutate(Technology = factor(Technology, levels = common_technologies))

# Summarize total installed capacity by Technology
tech_summary_installed <- data_installed %>%
  group_by(Technology) %>%
  summarise(Total_Energy = sum(Energy_GWh, na.rm = TRUE))

# Create bar plot for Electricity Installed Capacity, sorting bars by Total_Energy
p_installed <- ggplot(tech_summary_installed, aes(x = reorder(Technology, Total_Energy), y = Total_Energy, fill = Technology)) +
  geom_bar(stat = "identity") +
  xlab("Technology") +
  ylab("Total Installed Capacity (GWh)") +
  ggtitle("Electricity Installed Capacity by Technology (Advanced Economies)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
    # Axis text remains horizontal by default
  ) +
  scale_fill_brewer(palette = "Set2")  # Same palette as the generation plot

# Save the Electricity Installed Capacity plot to a PNG file
png(filename = "Electricity_Installed_Capacity_Adv.png", width = 2400, height = 1600, res = 300)
print(p_installed)
dev.off()