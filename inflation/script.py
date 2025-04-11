import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import numpy as np

# Load the data
df = pd.read_csv('Economic Indicators And Inflation.csv')  # replace 'your_file.csv' with your actual file name

# Remove leading spaces from column names
df.columns = [col.strip() for col in df.columns]

# Filter data up to 2023
df_up_to_2023 = df[df['Year'] <= 2023]

# Filter data for 2023
df_2023 = df_up_to_2023[df_up_to_2023['Year'] == 2023]

# Sort countries by GDP in 2023
df_2023 = df_2023.sort_values(by='GDP (in billion USD)')

# Create 4 plots with 5 countries each
countries = df_2023['Country'].tolist()
gdp_values = df_2023['GDP (in billion USD)'].tolist()

# Plot 1: Lowest GDP countries
plt.figure(figsize=(10, 6))
for country in countries[:4]:
    country_df = df_up_to_2023[df_up_to_2023['Country'] == country]
    plt.plot(country_df['Year'], country_df['GDP (in billion USD)'], label=country)
plt.xlabel('Year')
plt.ylabel('GDP (in billion USD)')
plt.title(f'GDP Over Time (Lowest GDP: {gdp_values[0]:.2f} - {gdp_values[3]:.2f} billion USD)')
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()

# Plot 2: Low GDP countries
plt.figure(figsize=(10, 6))
for country in countries[4:9]:
    country_df = df_up_to_2023[df_up_to_2023['Country'] == country]
    plt.plot(country_df['Year'], country_df['GDP (in billion USD)'], label=country)
plt.xlabel('Year')
plt.ylabel('GDP (in billion USD)')
plt.title(f'GDP Over Time (Low GDP: {gdp_values[4]:.2f} - {gdp_values[8]:.2f} billion USD)')
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()

# Plot 3: Medium GDP countries
plt.figure(figsize=(10, 6))
for country in countries[9:14]:
    country_df = df_up_to_2023[df_up_to_2023['Country'] == country]
    plt.plot(country_df['Year'], country_df['GDP (in billion USD)'], label=country)
plt.xlabel('Year')
plt.ylabel('GDP (in billion USD)')
plt.title(f'GDP Over Time (Medium GDP: {gdp_values[9]:.2f} - {gdp_values[13]:.2f} billion USD)')
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()

# Plot 4: Highest GDP countries
plt.figure(figsize=(10, 6))
for country in countries[14:]:
    country_df = df_up_to_2023[df_up_to_2023['Country'] == country]
    plt.plot(country_df['Year'], country_df['GDP (in billion USD)'], label=country)
plt.xlabel('Year')
plt.ylabel('GDP (in billion USD)')
plt.title(f'GDP Over Time (Highest GDP: {gdp_values[14]:.2f} - {gdp_values[-1]:.2f} billion USD)')
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()


# Bar chart
plt.figure(figsize=(10, 6))
for country in df_up_to_2023["Country"].unique():
    country_df = df_up_to_2023[df_up_to_2023["Country"] == country]
    plt.bar(country_df["Year"], country_df["Inflation Rate (%)"], label=country)
plt.xlabel("Year")
plt.ylabel("Inflation Rate (%)")
plt.title("Inflation Rate Over Time")
plt.legend()
plt.show()

# Line plot for Inflation Rate
plt.figure(figsize=(10, 6))
for country in df_up_to_2023["Country"].unique():
    country_df = df_up_to_2023[df_up_to_2023["Country"] == country]
    plt.plot(country_df["Year"], country_df["Inflation Rate (%)"], label=country)
plt.xlabel("Year")
plt.ylabel("Inflation Rate (%)")
plt.title("Inflation Rate Over Time")
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()

# Scatter plot with lines for Inflation Rate
plt.figure(figsize=(10, 6))
for country in df_up_to_2023["Country"].unique():
    country_df = df_up_to_2023[df_up_to_2023["Country"] == country]
    plt.plot(country_df["Year"], country_df["Inflation Rate (%)"], label=country, marker='o')
plt.xlabel("Year")
plt.ylabel("Inflation Rate (%)")
plt.title("Inflation Rate Over Time")
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()

# Scatter plot
plt.figure(figsize=(10, 6))
for country in df_up_to_2023["Country"].unique():
    country_df = df_up_to_2023[df_up_to_2023["Country"] == country]
    plt.scatter(country_df["GDP (in billion USD)"], country_df["Inflation Rate (%)"], label=country)
plt.xlabel("GDP (in billion USD)")
plt.ylabel("Inflation Rate (%)")
plt.title("GDP vs Inflation Rate")
plt.legend()
plt.show()

# Scatter plot with lines
plt.figure(figsize=(10, 6))
for country in df_up_to_2023["Country"].unique():
    country_df = df_up_to_2023[df_up_to_2023["Country"] == country]
    plt.plot(country_df["GDP (in billion USD)"], country_df["Inflation Rate (%)"], label=country, marker='o')
plt.xlabel("GDP (in billion USD)")
plt.ylabel("Inflation Rate (%)")
plt.title("GDP vs Inflation Rate")
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()

# Heatmap
pivot_df = df_up_to_2023.pivot_table(index="Country", columns="Year", values="GDP (in billion USD)")
plt.figure(figsize=(10, 6))
sns.heatmap(pivot_df, annot=True, cmap="Blues")
plt.title("GDP Heatmap")
plt.show()

# Create a pivot table for Inflation Rate
pivot_df_inflation = df_up_to_2023.pivot_table(index="Country", columns="Year", values="Inflation Rate (%)")
plt.figure(figsize=(10, 6))
sns.heatmap(pivot_df_inflation, annot=True, cmap="Blues")
plt.title("Inflation Rate Heatmap")
plt.show()

# Calculate the product of GDP and Inflation Rate for each country
df_up_to_2023['GDP_Inflation_Product'] = df_up_to_2023['GDP (in billion USD)'] * df_up_to_2023['Inflation Rate (%)']

# Sort the countries by the product of GDP and Inflation Rate
df_up_to_2023_sorted = df_up_to_2023.sort_values(by='GDP_Inflation_Product')

# Divide the countries into two groups
mid_point = len(df_up_to_2023_sorted) // 2
df_up_to_2023_group1 = df_up_to_2023_sorted.iloc[:mid_point]
df_up_to_2023_group2 = df_up_to_2023_sorted.iloc[mid_point:]

# Create a scatter plot for the first group
plt.figure(figsize=(10, 6))
for country in df_up_to_2023_group1["Country"].unique():
    country_df = df_up_to_2023_group1[df_up_to_2023_group1["Country"] == country]
    plt.plot(country_df["GDP (in billion USD)"], country_df["Inflation Rate (%)"], label=country, marker='o')
plt.xlabel("GDP (in billion USD)")
plt.ylabel("Inflation Rate (%)")
plt.title("GDP vs Inflation Rate (Lower GDP*Inflation Rate)")
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()

# Create a scatter plot for the second group
plt.figure(figsize=(10, 6))
for country in df_up_to_2023_group2["Country"].unique():
    country_df = df_up_to_2023_group2[df_up_to_2023_group2["Country"] == country]
    plt.plot(country_df["GDP (in billion USD)"], country_df["Inflation Rate (%)"], label=country, marker='o')
plt.xlabel("GDP (in billion USD)")
plt.ylabel("Inflation Rate (%)")
plt.title("GDP vs Inflation Rate (Higher GDP*Inflation Rate)")
plt.legend()
plt.grid(True, linestyle='-', alpha=0.5)  # Add grid
plt.show()
