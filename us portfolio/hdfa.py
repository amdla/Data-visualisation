import csv

TOTAL_COLUMNS = 34


def clean_csv(input_file, output_file):
    cleaned_data = []

    with open(input_file, newline='', encoding='utf-8') as csvfile:
        raw_content = csvfile.readlines()

    for line in raw_content:
        line = line.replace('"', '').strip()
        parts = line.split(',')

        new_row = []
        merged_name = []

        for part in parts:
            part = part.strip()

            # Special hardcoded check: single-letter "C" must NOT merge into country name
            if part == 'C':
                if merged_name:
                    new_row.append(" ".join(merged_name))
                    merged_name = []
                new_row.append(part)

            # If text but not single-letter, consider part of country name
            elif part and not part.replace('.', '', 1).isdigit() and len(part) > 1:
                merged_name.append(part)

            else:
                if merged_name:
                    new_row.append(" ".join(merged_name))
                    merged_name = []
                # Remove floating point values (convert to integer)
                if part.replace('.', '', 1).isdigit():
                    part = str(int(float(part)))
                new_row.append(part)

        # Add remaining merged text
        if merged_name:
            new_row.append(" ".join(merged_name))

        # Ensure exactly 34 columns by padding empty values if needed
        while len(new_row) < TOTAL_COLUMNS:
            new_row.append("")

        # Trim to exactly 34 columns if too long
        new_row = new_row[:TOTAL_COLUMNS]

        cleaned_data.append(new_row)

    # Save the cleaned data to a new CSV
    with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(cleaned_data)


# Example usage
input_csv = "data.csv"  # Replace with your input file path
output_csv = "NAZWY.csv"  # Replace with desired output file path
clean_csv(input_csv, output_csv)

print(f"Cleaned CSV file saved as {output_csv}")
