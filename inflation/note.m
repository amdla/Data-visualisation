try
    df = readtable('Economic Indicators And Inflation.csv');
catch
    error('Could not read the file Economic Indicators And Inflation.csv. Make sure it is in the correct directory.');
end
df_up_to_2023 = df(df.Year <= 2023, :);
df_2023 = df_up_to_2023(df_up_to_2023.Year == 2023, :);
df_2023_gdp_sorted = sortrows(df_2023, 'GDP_inBillionUSD_');
countries_gdp_sorted = df_2023_gdp_sorted.Country;
categories = {'Lowest', 'Low', 'Medium', 'Highest'};
group_indices = {[1, 4], [5, 9], [10, 14], [15, 19]};
encountered_countries = {};
unique_countries_ordered = {};
for k = 1:height(df_up_to_2023)
    current_country = df_up_to_2023.Country{k};
    if ~ismember(current_country, encountered_countries)
        unique_countries_ordered{end+1} = current_country;
        encountered_countries{end+1} = current_country;
    end
end
rgb_values = [
    31, 119, 180;
    174, 199, 232;
    255, 127, 14;
    255, 187, 120;
    44, 160, 44;
    152, 223, 138;
    214, 39, 40;
    255, 152, 150;
    148, 103, 189;
    197, 176, 213;
    140, 86, 75;
    196, 156, 148;
    227, 119, 194;
    247, 182, 210;
    127, 127, 127;
    199, 199, 199;
    188, 189, 34;
    219, 219, 141;
    23, 190, 207;
    158, 218, 229
];
cmap_tab20 = rgb_values / 255;
for i = 1:length(group_indices)
    start_idx_gdp = group_indices{i}(1);
    end_idx_gdp = group_indices{i}(2);
    current_countries_gdp_group = countries_gdp_sorted(start_idx_gdp:end_idx_gdp);
    current_gdp_2023 = df_2023_gdp_sorted.GDP_inBillionUSD_(start_idx_gdp:end_idx_gdp);
    min_gdp_2023 = min(current_gdp_2023);
    max_gdp_2023 = max(current_gdp_2023);
    figure('Position', [100, 100, 1000, 500]);
    hold on;
    legend_entries = {};
    for j = 1:length(current_countries_gdp_group)
        country = current_countries_gdp_group{j};
        country_df = df_up_to_2023(strcmp(df_up_to_2023.Country, country), :);
        plot(country_df.Year, country_df.GDP_inBillionUSD_, 'DisplayName', country, 'LineWidth', 1.5);
        legend_entries{end+1} = country;
    end
    hold off;
    xlabel('Year', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('GDP (in billion USD)', 'FontSize', 14, 'FontWeight', 'bold');
    if length(current_countries_gdp_group) > 1
        title_text = sprintf('GDP Over Time (%s GDP: %.2f - %.2f billion USD)', categories{i}, min_gdp_2023, max_gdp_2023);
    else
        title_text = sprintf('GDP Over Time (%s GDP: %.2f billion USD)', categories{i}, min_gdp_2023);
    end
    title(title_text, 'FontSize', 16, 'FontWeight', 'bold');
    set(gca, 'FontSize', 12);
    grid on;
    legend(legend_entries, 'Location', 'eastoutside', 'FontSize', 10);
    pos = get(gca, 'Position');
    set(gca, 'Position', [pos(1), pos(2), pos(3)*0.8, pos(4)]);
end
unique_years = unique(df_up_to_2023.Year);
inflation_matrix = zeros(length(unique_years), length(unique_countries_ordered));
for i = 1:length(unique_countries_ordered)
    country = unique_countries_ordered{i};
    country_df = df_up_to_2023(strcmp(df_up_to_2023.Country, country), :);
    country_df = sortrows(country_df, 'Year');
    [~, year_indices] = ismember(country_df.Year, unique_years);
    inflation_matrix(year_indices, i) = country_df.InflationRate___;
end
figure('Position', [100, 100, 1000, 500]);
h_bar = bar(unique_years, inflation_matrix, 'stacked');
for k = 1:length(h_bar)
    h_bar(k).FaceColor = cmap_tab20(k, :);
end
xlabel('Year', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Inflation Rate (%)', 'FontSize', 14, 'FontWeight', 'bold');
title('Inflation Rate Over Time (Stacked Bar Chart)', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 12);
xticks(unique_years);
legend(unique_countries_ordered, 'Location', 'eastoutside', 'FontSize', 10);
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1), pos(2), pos(3)*0.8, pos(4)]);
figure('Position', [100, 100, 800, 500]);
hold on;
legend_entries = {};
for i = 1:length(unique_countries_ordered)
    country = unique_countries_ordered{i};
    country_df = df_up_to_2023(strcmp(df_up_to_2023.Country, country), :);
    country_color_idx = find(strcmp(unique_countries_ordered, country));
    color_index = mod(country_color_idx-1, size(cmap_tab20, 1)) + 1;
    plot(country_df.Year, country_df.InflationRate___, '-o', 'DisplayName', country, 'Color', cmap_tab20(color_index, :), 'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', cmap_tab20(color_index, :), 'MarkerEdgeColor', cmap_tab20(color_index, :));
    legend_entries{end+1} = country;
end
hold off;
xlabel('Year', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Inflation Rate (%)', 'FontSize', 14, 'FontWeight', 'bold');
title('Inflation Rate Over Time', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 12);
grid on;
legend(legend_entries, 'Location', 'eastoutside', 'FontSize', 10);
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1), pos(2), pos(3)*0.8, pos(4)]);
figure('Position', [100, 100, 1000, 500]);
hold on;
legend_entries = {};
for i = 1:length(unique_countries_ordered)
    country = unique_countries_ordered{i};
    country_df = df_up_to_2023(strcmp(df_up_to_2023.Country, country), :);
    country_color_idx = find(strcmp(unique_countries_ordered, country));
    color_index = mod(country_color_idx-1, size(cmap_tab20, 1)) + 1;
    plot(country_df.Year, country_df.InflationRate___, '-o', 'DisplayName', country, 'Color', cmap_tab20(color_index, :), 'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', cmap_tab20(color_index, :), 'MarkerEdgeColor', cmap_tab20(color_index, :));
    legend_entries{end+1} = country;
end
hold off;
xlabel('Year', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Inflation Rate (%)', 'FontSize', 14, 'FontWeight', 'bold');
title('Inflation Rate Over Time', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 12);
grid on;
legend(legend_entries, 'Location', 'eastoutside', 'FontSize', 10);
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1), pos(2), pos(3)*0.8, pos(4)]);
df_2023_unemployment_sorted = sortrows(df_2023, 'UnemploymentRate___');
countries_unemployment_sorted = df_2023_unemployment_sorted.Country;
unemployment_2023_sorted = df_2023_unemployment_sorted.UnemploymentRate___;
for i = 1:length(group_indices)
    start_idx_unemployment = group_indices{i}(1);
    end_idx_unemployment = group_indices{i}(2);
    current_countries_unemployment_group = countries_unemployment_sorted(start_idx_unemployment:end_idx_unemployment);
    current_unemployment_2023_range = unemployment_2023_sorted(start_idx_unemployment:end_idx_unemployment);
    min_unemployment_2023 = min(current_unemployment_2023_range);
    max_unemployment_2023 = max(current_unemployment_2023_range);
    figure('Position', [100, 100, 1000, 500]);
    hold on;
    legend_entries = {};
    for j = 1:length(current_countries_unemployment_group)
        country = current_countries_unemployment_group{j};
        country_df = df_up_to_2023(strcmp(df_up_to_2023.Country, country), :);
        plot(country_df.Year, country_df.UnemploymentRate___, 'DisplayName', country, 'LineWidth', 1.5);
        legend_entries{end+1} = country;
    end
    hold off;
    xlabel('Year', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('Unemployment Rate (%)', 'FontSize', 14, 'FontWeight', 'bold');
    if length(current_countries_unemployment_group) > 1
         title_text = sprintf('Unemployment Rate Over Time (%s Unemployment Rate: %.2f - %.2f (%%))', categories{i}, min_unemployment_2023, max_unemployment_2023);
    else
        title_text = sprintf('Unemployment Rate Over Time (%s Unemployment Rate: %.2f (%%))', categories{i}, min_unemployment_2023);
    end
    title(title_text, 'FontSize', 16, 'FontWeight', 'bold');
    set(gca, 'FontSize', 12);
    grid on;
    legend(legend_entries, 'Location', 'eastoutside', 'FontSize', 10);
    pos = get(gca, 'Position');
    set(gca, 'Position', [pos(1), pos(2), pos(3)*0.8, pos(4)]);
end
figure('Position', [100, 100, 800, 500]);
hold on;
legend_entries = {};
for i = 1:length(unique_countries_ordered)
    country = unique_countries_ordered{i};
    country_df = df_up_to_2023(strcmp(df_up_to_2023.Country, country), :);
    country_color_idx = find(strcmp(unique_countries_ordered, country));
    color_index = mod(country_color_idx-1, size(cmap_tab20, 1)) + 1;
    plot(country_df.Year, country_df.EconomicGrowth___, 'DisplayName', country, 'Color', cmap_tab20(color_index, :), 'LineWidth', 1.5);
    legend_entries{end+1} = country;
end
hold off;
xlabel('Year', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Economic Growth (%)', 'FontSize', 14, 'FontWeight', 'bold');
title('Economic Growth Rate Over Time', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'FontSize', 12);
grid on;
legend(legend_entries, 'Location', 'eastoutside', 'FontSize', 10);
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1), pos(2), pos(3)*0.8, pos(4)]);
unique_countries_heatmap = unique(df_up_to_2023.Country);
unique_years_heatmap = unique(df_up_to_2023.Year);
growth_matrix = NaN(length(unique_countries_heatmap), length(unique_years_heatmap));
for i = 1:height(df_up_to_2023)
    country = df_up_to_2023.Country{i};
    year = df_up_to_2023.Year(i);
    growth_value = df_up_to_2023.EconomicGrowth___(i);
    country_idx = find(strcmp(unique_countries_heatmap, country));
    year_idx = find(unique_years_heatmap == year);
    if ~isempty(country_idx) && ~isempty(year_idx)
        growth_matrix(country_idx, year_idx) = growth_value;
    end
end
figure('Position', [100, 100, 1000, 600]);
h_growth = heatmap(unique_years_heatmap, unique_countries_heatmap, growth_matrix);
h_growth.XLabel = 'Year';
h_growth.YLabel = 'Country';
h_growth.FontSize = 12;
h_growth.ColorScaling = 'scaled';
n_colors = 64;
n_half = round(n_colors/2);
R1 = linspace(1, 1, n_half)';
G1 = linspace(0, 1, n_half)';
B1 = linspace(0, 1, n_half)';
cmap1 = [R1 G1 B1];
R2 = linspace(1, 0, n_colors - n_half)';
G2 = linspace(1, 1, n_colors - n_half)';
B2 = linspace(1, 0, n_colors - n_half)';
cmap2 = [R2 G2 B2];
my_diverging_cmap = [cmap1; cmap2];
my_diverging_cmap(my_diverging_cmap < 0) = 0;
my_diverging_cmap(my_diverging_cmap > 1) = 1;
colormap(h_growth, my_diverging_cmap);
h_growth.ColorbarVisible = 'on';
h_growth.GridVisible = 'on';
h_growth.CellLabelFormat = '%.2f';
h_growth.MissingDataColor = [0.9 0.9 0.9];
h_growth.MissingDataLabel = 'NaN';
h_growth.Title = 'Economic Growth Heatmap';
h_growth.FontSize = 14;
gdp_matrix = NaN(length(unique_countries_heatmap), length(unique_years_heatmap));
for i = 1:height(df_up_to_2023)
    country = df_up_to_2023.Country{i};
    year = df_up_to_2023.Year(i);
    gdp_value = df_up_to_2023.GDP_inBillionUSD_(i);
    country_idx = find(strcmp(unique_countries_heatmap, country));
    year_idx = find(unique_years_heatmap == year);
    if ~isempty(country_idx) && ~isempty(year_idx)
        gdp_matrix(country_idx, year_idx) = gdp_value;
    end
end
figure('Position', [100, 100, 1000, 600]);
h_gdp = heatmap(unique_years_heatmap, unique_countries_heatmap, gdp_matrix);
h_gdp.XLabel = 'Year';
h_gdp.YLabel = 'Country';
h_gdp.FontSize = 12;
h_gdp.ColorScaling = 'scaled';
h_gdp.ColorbarVisible = 'on';
h_gdp.GridVisible = 'on';
h_gdp.CellLabelFormat = '%.2f';
h_gdp.MissingDataColor = [0.9 0.9 0.9];
h_gdp.MissingDataLabel = 'NaN';
h_gdp.Title = 'GDP Heatmap';
h_gdp.FontSize = 14;
inflation_matrix_heatmap = NaN(length(unique_countries_heatmap), length(unique_years_heatmap));
for i = 1:height(df_up_to_2023)
    country = df_up_to_2023.Country{i};
    year = df_up_to_2023.Year(i);
    inflation_value = df_up_to_2023.InflationRate___(i);
    country_idx = find(strcmp(unique_countries_heatmap, country));
    year_idx = find(unique_years_heatmap == year);
    if ~isempty(country_idx) && ~isempty(year_idx)
        inflation_matrix_heatmap(country_idx, year_idx) = inflation_value;
    end
end
figure('Position', [100, 100, 1000, 600]);
custom_cmap = zeros(256, 3);
custom_cmap(1, :) = [1 1 1];
for i = 2:256
    custom_cmap(i, :) = [1, (256-i)/255, (256-i)/255];
end
h_inflation = heatmap(unique_years_heatmap, unique_countries_heatmap, inflation_matrix_heatmap);
h_inflation.XLabel = 'Year';
h_inflation.YLabel = 'Country';
h_inflation.FontSize = 12;
colormap(h_inflation, custom_cmap);
h_inflation.ColorScaling = 'scaled';
h_inflation.ColorLimits = [0, 56];
h_inflation.ColorbarVisible = 'on';
h_inflation.GridVisible = 'on';
h_inflation.CellLabelFormat = '%.2f';
h_inflation.MissingDataColor = [0.9 0.9 0.9];
h_inflation.MissingDataLabel = 'NaN';
h_inflation.Title = 'Inflation Rate Heatmap';
h_inflation.FontSize = 16;
log_inflation_matrix = log(inflation_matrix_heatmap + 1.5);
figure('Position', [100, 100, 1000, 600]);
h_log_inflation = heatmap(unique_years_heatmap, unique_countries_heatmap, log_inflation_matrix);
h_log_inflation.XLabel = 'Year';
h_log_inflation.YLabel = 'Country';
h_log_inflation.FontSize = 12;
h_log_inflation.ColorScaling = 'scaled';
h_log_inflation.ColorbarVisible = 'on';
h_log_inflation.GridVisible = 'on';
h_log_inflation.CellLabelFormat = '%.2f';
h_log_inflation.MissingDataColor = [0.9 0.9 0.9];
h_log_inflation.MissingDataLabel = 'NaN';
h_log_inflation.Title = 'Inflation Rate Heatmap (logarithm)';
h_log_inflation.FontSize = 16;
figure('Position', [100, 100, 1400, 600]);
hold on;
legend_entries = {};
for i = 1:length(unique_countries_ordered)
    country = unique_countries_ordered{i};
    country_df = df_up_to_2023(strcmp(df_up_to_2023.Country, country), :);
    country_color_idx = find(strcmp(unique_countries_ordered, country));
    color_index = mod(country_color_idx-1, size(cmap_tab20, 1)) + 1;
    plot(country_df.GDP_inBillionUSD_, country_df.InflationRate___, 'o-', ...
        'DisplayName', country, ...
        'Color', cmap_tab20(color_index, :), ...
        'LineWidth', 1.5, ...
        'MarkerSize', 5, ...
        'MarkerFaceColor', cmap_tab20(color_index, :), ...
        'MarkerEdgeColor', cmap_tab20(color_index, :));
    legend_entries{end+1} = country;
end
xlabel('GDP (in billion USD)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Inflation Rate (%)', 'FontSize', 14, 'FontWeight', 'bold');
title('GDP vs Inflation Rate', 'FontSize', 16, 'FontWeight', 'bold');
grid on;
set(gca, 'FontSize', 12);
legend(legend_entries, 'Location', 'eastoutside', 'FontSize', 10);
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1), pos(2), pos(3)*0.8, pos(4)]);
hold off;