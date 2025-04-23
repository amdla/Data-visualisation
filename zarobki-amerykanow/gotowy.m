% Set global defaults for figures and axes
set(0, 'DefaultAxesFontSize', 16, ...
       'DefaultAxesXColor', 'w', ...            % White X axis
       'DefaultAxesYColor', 'w', ...            % White Y axis
       'DefaultAxesZColor', 'w', ...            % White Z axis (if needed)
       'DefaultAxesGridColor', 'w', ...         % White grid lines
       'DefaultAxesMinorGridColor', 'w')    % White minor grid lines

set(0, 'DefaultAxesColor', [0.1 0.1 0.1]);  % Dark axes background
% Figure background color
set(0, 'DefaultFigureColor', [0.1 0.1 0.1]);    % Darker gray/black figure background

column_names = ["age", "workclass", "final_weight", "education", "education_num", ...
                "marital_status", "occupation", "relationship", "race", ...
                "sex", "capital_gain", "capital_loss", "hours_per_week", ...
                "native_country", "income"];



df = readtable('adult.csv', 'ReadVariableNames', false); % No headers
df.Properties.VariableNames = column_names;


%-------------------------------------------------------


histogram(df.age, 'FaceColor', 'c');
title('Age Distribution', 'Color', 'w');
xlabel('Age');
ylabel('Count');
grid on;
xlim([17, 90]);
figure;


%-------------------------------------------------------


histogram(df.hours_per_week, ...
    'FaceColor', 'm', ...
    'BinMethod', 'integers', ... 
    'BinEdges', 0.5:1:100.5);     

title('Hours Worked per Week', 'Color', 'w');
xlabel('Hours', 'Color', 'w');
ylabel('Count', 'Color', 'w');
grid on;
xlim([0, 100]);


%-------------------------------------------------------


income_counts = groupcounts(df.income);
income_labels = categories(categorical(df.income));

figure;
h = pie(income_counts, income_labels);
colormap([0.1 0.9 0.1; 0.6 0.4 0.8]);

title('Income Class Distribution', 'Color', 'w', 'FontSize', 16);

for i = 2:2:length(h)
    h(i).Color = 'w';
    h(i).FontSize = 16;
    percent_value = 100*income_counts(i/2)/sum(income_counts);
    h(i).String = [income_labels{i/2} ' (' sprintf('%.1f', percent_value) '%)'];
end


%-------------------------------------------------------


sex_counts = groupcounts(df.sex);
sex_labels = categories(categorical(df.sex));

figure;
h = pie(sex_counts, sex_labels);
colormap([0.8 0.2 0.5; 0.2 0.5 0.8]);  % Pink and blue colors

title('Gender Distribution', 'Color', 'w', 'FontSize', 16, 'FontWeight', 'bold');

for i = 2:2:length(h)
    percent_value = 100*sex_counts(i/2)/sum(sex_counts);
    h(i).String = [sex_labels{i/2} ' (' sprintf('%.1f%%', percent_value) ')'];
    h(i).Color = 'w';  % Changed to white
    h(i).FontSize = 16;
    h(i).FontWeight = 'bold';
end

% Set dark background
set(gcf, 'Color', [0.1 0.1 0.1]);
set(gca, 'Color', 'none');


%-------------------------------------------------------


workclass_counts = groupcounts(df.workclass);
[counts_sorted, idx] = sort(workclass_counts, 'ascend');
labels_sorted = categories(categorical(df.workclass));
labels_sorted = labels_sorted(idx);

figure;
b = barh(counts_sorted, 'FaceColor', [0.7 0.2 0.8]);  % Purple bars
title('Workclass Distribution', 'Color', 'w', 'FontSize', 16);
xlabel('Count', 'Color', 'w');
ylabel('Workclass', 'Color', 'w');
set(gca, 'YTickLabel', labels_sorted, 'FontSize', 16);
grid on;

% Add numeric values to bars
for i = 1:length(counts_sorted)
    text(counts_sorted(i)+max(counts_sorted)*0.01, i, num2str(counts_sorted(i)),...
        'Color', 'w', 'FontSize', 14, 'VerticalAlignment', 'middle');
end

% Adjust x-axis limit to accommodate text labels
xlim([0 max(counts_sorted)*1.1]);


%-------------------------------------------------------


race_counts = groupcounts(df.race);
[counts_sorted, idx] = sort(race_counts, 'ascend');
labels_sorted = race_labels(idx);

figure;
barh(counts_sorted, 'FaceColor', [0.4 0.6 0.8]);  % Blue bars
title('Race Distribution', 'Color', 'w', 'FontSize', 16);
ylabel('Race', 'Color', 'w');
xlabel('Count', 'Color', 'w');
set(gca, 'YTickLabel', labels_sorted, 'FontSize', 16);
grid on;

% Add numeric values at end of bars
for i = 1:length(counts_sorted)
    text(counts_sorted(i)+max(counts_sorted)*0.01, i, num2str(counts_sorted(i)),...
        'Color', 'w', 'FontSize', 16, 'VerticalAlignment', 'middle');
end

% Adjust x-axis limit to accommodate text labels
xlim([0 max(counts_sorted)*1.1]);

% Set dark background
set(gcf, 'Color', [0.1 0.1 0.1]);
set(gca, 'Color', [0.1 0.1 0.1], 'GridColor', 'w');
xlim([0, 30000]);


%-------------------------------------------------------


% Native Country Distribution (Filtered)
country_counts = groupcounts(df.native_country);
countries = categories(categorical(df.native_country));

% Filter for counts between 100 and 10,000
keep_idx = (country_counts >= 50) & (country_counts < 10000);
counts_filtered = country_counts(keep_idx);
countries_filtered = countries(keep_idx);

% Sort ascending
[counts_sorted, idx] = sort(counts_filtered, 'ascend');
labels_sorted = countries_filtered(idx);

% Create figure with adjusted size
figure('Position', [100 100 800 600]);

% Create horizontal bars with teal color
barh(counts_sorted, 'FaceColor', [0.2 0.8 0.8]);
title('Native Country Distribution (100 < Count < 10,000)', 'Color', 'w', 'FontSize', 16);
ylabel('Country', 'Color', 'w');

set(gca, 'YTick', 1:length(labels_sorted), ...  % Force tick for every item
         'YTickLabel', labels_sorted, ...
         'FontSize', 10); % Smaller font to fit
xlabel('Count', 'Color', 'w');
set(gca, 'YTickLabel', labels_sorted, 'FontSize', 14);
grid on;

% Add numeric values at end of bars
for i = 1:length(counts_sorted)
    text(counts_sorted(i)+max(counts_sorted)*0.01, i, num2str(counts_sorted(i)),...
        'Color', 'w', 'FontSize', 12, 'VerticalAlignment', 'middle');
end

% Adjust limits and appearance
xlim([0 max(counts_sorted)*1.1]);
set(gcf, 'Color', [0.1 0.1 0.1]);
set(gca, 'Color', [0.1 0.1 0.1], 'GridColor', 'w', 'XColor', 'w', 'YColor', 'w');
set(gca, 'TickLabelInterpreter', 'none');  % Prevents underscore interpretation
xlim([0,700])


%-------------------------------------------------------


% Age vs. Hours Worked
figure;
scatter(df.age, df.hours_per_week, 10, 'filled', 'MarkerFaceColor', 'y');
title('Age vs Weekly Hours Worked', 'Color', 'w');
xlabel('Age', 'Color', 'w');
ylabel('Hours/Week', 'Color', 'w');
grid on;
xlim([17 91])


%-------------------------------------------------------


% Marital Status Distribution
marital_counts = groupcounts(df.marital_status);
[counts_sorted, idx] = sort(marital_counts, 'ascend');
labels_sorted = categories(categorical(df.marital_status));
labels_sorted = labels_sorted(idx);

figure;
barh(counts_sorted, 'FaceColor', [0.3 0.7 0.3]);  % Green bars
title('Marital Status Distribution', 'Color', 'w', 'FontSize', 16);
xlabel('Count', 'Color', 'w');
ylabel('Marital Status', 'Color', 'w');
set(gca, 'YTickLabel', labels_sorted, 'FontSize', 14);
grid on;

% Add values
for i = 1:length(counts_sorted)
    text(counts_sorted(i)+max(counts_sorted)*0.01, i, num2str(counts_sorted(i)),...
        'Color', 'w', 'FontSize', 12, 'VerticalAlignment', 'middle');
end
xlim([0 15000]);


%-------------------------------------------------------


