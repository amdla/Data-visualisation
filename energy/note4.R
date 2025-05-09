library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Read data from CSV
data <- read_csv("Renewable_energy.csv")

# Data processing as per original script
data <- data %>%
  mutate(Technology = ifelse(Technology == "Hydropower (excl. Pumped Storage)", "Hydropower", Technology))

# Filter for World
data <- data %>%
  filter(grepl("Poland, Rep. of", Country, ignore.case = TRUE))

# Convert MWh to GWh where applicable
data <- data %>%
  mutate(across(starts_with("F"), ~ifelse(grepl("MWh", Unit, ignore.case = TRUE), . / 1000, .)))

# Pivot data to long format for plotting
data_long <- data %>%
  select(Indicator, Technology, starts_with("F")) %>%
  pivot_longer(cols = starts_with("F"), names_to = "Year", values_to = "Value") %>%
  mutate(Year = as.numeric(sub("F", "", Year)))

# Create separate plots for Generation and Installed Capacity
# Generation Plot
generation_plot <- ggplot(data_long %>% filter(Indicator == "Electricity Generation"), 
                         aes(x = Year, y = Value, color = Technology, group = Technology)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  xlab("Year") +
  ylab("Value (GWh)") +
  ggtitle("Electricity Generation by Technology (Poland, 2000-2023)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "bottom",
    legend.title = element_blank()
  ) +
  scale_color_brewer(palette = "Set2")

# Installed Capacity Plot
capacity_plot <- ggplot(data_long %>% filter(Indicator == "Electricity Installed Capacity"),
                       aes(x = Year, y = Value, color = Technology, group = Technology)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  xlab("Year") +
  ylab("Value (MW)") +
  ggtitle("Electricity Installed Capacity by Technology (Poland, 2000-2023)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "bottom",
    legend.title = element_blank()
  ) +
  scale_color_brewer(palette = "Set2")

png(filename = "Renewable_Energy_Generation_Line_Plot_Poland.png", width = 2400, height = 1600, res = 300)
print(generation_plot)
dev.off()

png(filename = "Renewable_Energy_Capacity_Line_Plot_Poland.png", width = 2400, height = 1600, res = 300)
print(capacity_plot)
dev.off()

# # Save the plots
# ggsave("Renewable_Energy_Generation_Line_Plot.png", plot = generation_plot, width = 10, height = 6, units = "in", dpi = 300)
# ggsave("Renewable_Energy_Capacity_Line_Plot.png", plot = capacity_plot, width = 10, height = 6, units = "in", dpi = 300)