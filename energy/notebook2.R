library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)

data <- read.csv("Renewable_energy.csv", stringsAsFactors = FALSE)

colnames(data) <- tolower(trimws(colnames(data)))

world_data <- data %>%
  filter(country == "Norway")

year_cols <- names(data)[grepl("^f\\d+$", names(data))]

world_data[year_cols] <- lapply(world_data[year_cols], as.numeric)

convert_to_mwh <- function(value, unit) {
  if (unit == "Gigawatt-hours (GWh)") {
    return(value * 1000)
  } else if (unit == "Megawatt (MW)") {
    return(value * 8760)
  } else {
    return(value)
  }
}

world_data <- world_data %>%
  rowwise() %>%
  mutate(
    total_mwh = sum(c_across(all_of(year_cols)), na.rm = TRUE),
    total_mwh = convert_to_mwh(total_mwh, unit)
  ) %>%
  ungroup()

summary_data <- world_data %>%
  filter(energy_type %in% c("Total Renewable", "Total Non-Renewable")) %>%
  group_by(Energy_Type = energy_type) %>%
  summarise(Total_MWh = sum(total_mwh, na.rm = TRUE))

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

print(plot)

png(filename = "Energy_Type_Summary_MWh_Norway.png", width = 2400, height = 1600, res = 300)
print(plot)
dev.off()