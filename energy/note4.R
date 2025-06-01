library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

data <- read_csv("Renewable_energy.csv")

data <- data %>%
  mutate(Technology = ifelse(Technology == "Hydropower (excl. Pumped Storage)", "Hydropower", Technology))

data <- data %>%
  filter(grepl("Poland, Rep. of", Country, ignore.case = TRUE))

data <- data %>%
  mutate(across(starts_with("F"), ~ifelse(grepl("MWh", Unit, ignore.case = TRUE), . / 1000, .)))

data_long <- data %>%
  select(Indicator, Technology, starts_with("F")) %>%
  pivot_longer(cols = starts_with("F"), names_to = "Year", values_to = "Value") %>%
  mutate(Year = as.numeric(sub("F", "", Year)))

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
