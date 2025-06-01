library(dplyr)
library(ggplot2)
library(readr)

data <- read_csv("Renewable_energy.csv")

data <- data %>%
  mutate(Technology = ifelse(Technology == "Hydropower (excl. Pumped Storage)", "Hydropower", Technology))

data <- data %>%
  filter(grepl("Advanced Economies", Country, ignore.case = TRUE))

data <- data %>%
  mutate(
    Energy_GWh = ifelse(grepl("MWh", Unit, ignore.case = TRUE), F2021 / 1000, F2021)
  )

common_technologies <- sort(unique(data$Technology))

data_generation <- data %>%
  filter(Indicator == "Electricity Generation") %>%
  mutate(Technology = factor(Technology, levels = common_technologies))

tech_summary_generation <- data_generation %>%
  group_by(Technology) %>%
  summarise(Total_Energy = sum(Energy_GWh, na.rm = TRUE))

p_generation <- ggplot(tech_summary_generation, aes(x = reorder(Technology, Total_Energy), y = Total_Energy, fill = Technology)) +
  geom_bar(stat = "identity") +
  xlab("Technology") +
  ylab("Total Energy Generation (GWh)") +
  ggtitle("Electricity Generation by Technology (Advanced Economies)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  ) +
  scale_fill_brewer(palette = "Set2")

png(filename = "Electricity_Generation_Adv.png", width = 2400, height = 1600, res = 300)
print(p_generation)
dev.off()

data_installed <- data %>%
  filter(Indicator == "Electricity Installed Capacity") %>%
  mutate(Technology = factor(Technology, levels = common_technologies))

tech_summary_installed <- data_installed %>%
  group_by(Technology) %>%
  summarise(Total_Energy = sum(Energy_GWh, na.rm = TRUE))

p_installed <- ggplot(tech_summary_installed, aes(x = reorder(Technology, Total_Energy), y = Total_Energy, fill = Technology)) +
  geom_bar(stat = "identity") +
  xlab("Technology") +
  ylab("Total Installed Capacity (MW)") +
  ggtitle("Electricity Installed Capacity by Technology (Advanced Economies)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  ) +
  scale_fill_brewer(palette = "Set2")

png(filename = "Electricity_Installed_Capacity_Adv.png", width = 2400, height = 1600, res = 300)
print(p_installed)
dev.off()