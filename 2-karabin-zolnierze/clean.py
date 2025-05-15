import pandas as pd
import numpy as np

# Load the dataset
df = pd.read_csv('baza_danych.csv')

# Strip whitespace from column names
df.columns = df.columns.str.strip()


# Function to count non-NaN values in a row
def count_non_nan(row):
    return row.notna().sum()


# Group by columns 0, 1, and 4
group_cols = [df.columns[0], df.columns[1], df.columns[4]]
df['non_nan_count'] = df.apply(count_non_nan, axis=1)

# To store indices to drop
drop_indices = []

# Iterate over duplicate groups
for _, group in df.groupby(group_cols):
    if len(group) > 1:
        # Sort by number of non-NaN values (descending)
        sorted_group = group.sort_values(by='non_nan_count', ascending=False)
        # Keep the first one, drop the rest
        keep = sorted_group.iloc[0]
        for idx, row in sorted_group.iloc[1:].iterrows():
            print("Found duplicate lines:")
            print(keep[group_cols].to_string(index=False, header=False))
            print(row[group_cols].to_string(index=False, header=False))
            print(
                f"\nRemoving line {row[group_cols].to_string(index=False, header=False)} as it has more NaN values.\n")
            drop_indices.append(idx)

# Drop the marked rows
df_cleaned = df.drop(index=drop_indices).drop(columns='non_nan_count')

# Optionally save or display
# df_cleaned.to_csv('cleaned_baza_danych.csv', index=False)

print("Cleanup complete. Final dataframe:")
print(df_cleaned)

df_cleaned.to_csv('cleaned_baza_danych.csv', index=False)
