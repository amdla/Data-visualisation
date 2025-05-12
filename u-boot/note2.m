clear;
close all;
clc;

try
    df = readtable('uboats.csv');
catch
    disp('Error: uboats.csv not found. Please ensure the file is in the current directory.');
    return;
end

fprintf('Data loaded successfully from uboats.csv.\n');

figure('Position', [100, 100, 1600, 900], 'Renderer', 'Painters');

[uniqueYears, ~, yearIdx] = unique(df.Year);
yearCounts = accumarray(yearIdx, 1);

[yearSorted, sortOrder] = sort(uniqueYears);
yearCountsSorted = yearCounts(sortOrder);

plot(yearSorted, yearCountsSorted, '-o', ...
     'Color', [1 0.5 0], ...
     'MarkerSize', 5, ...
     'MarkerFaceColor', [1 0.5 0], ...
     'LineWidth', 2);

title('Number of U-boats by Year', 'FontSize', 20, 'FontWeight', 'bold', ...
      'Units', 'normalized', 'Position', [0.5 1.05 0]);
xlabel('Year', 'FontSize', 16);
ylabel('Count of U-boats', 'FontSize', 16, ...
       'Units', 'normalized', 'Position', [-0.05 0.5 0]);

set(gca, 'FontSize', 16, 'LineWidth', 1.5);
xlim([1935, 1945]);
xticks([1936, 1938, 1940, 1942, 1944]);
grid on;

print(gcf, 'uboats_by_year.png', '-dpng', '-r300');
fprintf('Generated uboats_by_year.png\n');

type_threshold = 30;

[uniqueTypes, ~, typeIdx] = unique(df.Type);
typeCounts = accumarray(typeIdx, 1);
typeCountsTable = table(uniqueTypes, typeCounts, 'VariableNames', {'Type', 'Count'});

typeCountsMain = typeCountsTable(typeCountsTable.Count >= type_threshold, :);
othersCount = sum(typeCountsTable.Count(typeCountsTable.Count < type_threshold));

typeCountsFiltered = sortrows(typeCountsMain, 'Count', 'descend');
if othersCount > 0
    othersRow = table({'Others'}, othersCount, 'VariableNames', {'Type', 'Count'});
    typeCountsFiltered = [typeCountsFiltered; othersRow];
end

figure('Position', [100, 100, 1600, 900], 'Renderer', 'Painters');

bar(categorical(typeCountsFiltered.Type, typeCountsFiltered.Type), typeCountsFiltered.Count, ...
    'FaceColor', [0.529 0.808 0.922], ...
    'EdgeColor', 'none');

title('Count of U-boats by Type', 'FontSize', 20, 'FontWeight', 'bold', ...
      'Units', 'normalized', 'Position', [0.5 1.05 0]);
xlabel('Type', 'FontSize', 16);
ylabel('Number of U-boats', 'FontSize', 16, ...
       'Units', 'normalized', 'Position', [-0.05 0.5 0]);

maxCount = max(typeCountsFiltered.Count);
ylim([0, maxCount + ceil(maxCount * 0.1)]);
yticks(0:floor(maxCount/5):floor(maxCount));
set(gca, 'FontSize', 16, 'LineWidth', 1.5);
xtickangle(0);
grid on;

for i = 1:height(typeCountsFiltered)
    text(i, typeCountsFiltered.Count(i), num2str(typeCountsFiltered.Count(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
         'FontSize', 16, 'Color', 'k');
end

print(gcf, 'uboats_by_type.png', '-dpng', '-r300');
fprintf('Generated uboats_by_type.png\n');

if iscell(df.Warships_sunk_n_total_loss_No)
    df.Warships_sunk_n_total_loss_No = str2double(df.Warships_sunk_n_total_loss_No);
end
df.Warships_sunk_n_total_loss_No(isnan(df.Warships_sunk_n_total_loss_No)) = 0;

if iscell(df.Merchant_Ships_sunk_No)
    df.Merchant_Ships_sunk_No = str2double(df.Merchant_Ships_sunk_No);
end
df.Merchant_Ships_sunk_No(isnan(df.Merchant_Ships_sunk_No)) = 0;

groupedData = groupsummary(df, 'Type', 'sum', {'Warships_sunk_n_total_loss_No', 'Merchant_Ships_sunk_No'});
groupedData.GroupCount = [];
groupedData.Properties.VariableNames{'sum_Warships_sunk_n_total_loss_No'} = 'Warships_Sunk';
groupedData.Properties.VariableNames{'sum_Merchant_Ships_sunk_No'} = 'Merchant_Sunk';

sunk_threshold = 100;
groupedData.Total_Sunk = groupedData.Warships_Sunk + groupedData.Merchant_Sunk;
aboveThreshold = groupedData(groupedData.Total_Sunk >= sunk_threshold, :);
belowThreshold = groupedData(groupedData.Total_Sunk < sunk_threshold, :);

if ~isempty(belowThreshold)
    othersWarships = sum(belowThreshold.Warships_Sunk);
    othersMerchant = sum(belowThreshold.Merchant_Sunk);
    othersTotalSunk = othersWarships + othersMerchant;
    othersRow = table({'Others'}, othersWarships, othersMerchant, othersTotalSunk, ...
                      'VariableNames', {'Type', 'Warships_Sunk', 'Merchant_Sunk', 'Total_Sunk'});
    finalData = [aboveThreshold; othersRow];
else
    finalData = aboveThreshold;
end

finalData = sortrows(finalData, 'Total_Sunk', 'descend');

figure('Position', [100, 100, 1600, 900], 'Renderer', 'Painters');
hold on;

plot(1:height(finalData), finalData.Warships_Sunk, '-o', ...
     'Color', [0.2 0.4 0.6], ...
     'MarkerSize', 5, ...
     'MarkerFaceColor', [0.2 0.4 0.6], ...
     'LineWidth', 2, 'DisplayName', 'Warships Sunk');
plot(1:height(finalData), finalData.Merchant_Sunk, '-o', ...
     'Color', [1 0.5 0], ...
     'MarkerSize', 5, ...
     'MarkerFaceColor', [1 0.5 0], ...
     'LineWidth', 2, 'DisplayName', 'Merchant Ships Sunk');

title('Warships vs. Merchant Ships Sunk by Type', 'FontSize', 20, 'FontWeight', 'bold', ...
      'Units', 'normalized', 'Position', [0.5 1.05 0]);
xlabel('Submarine Type', 'FontSize', 16);
ylabel('Number of Ships Sunk', 'FontSize', 16, ...
       'Units', 'normalized', 'Position', [-0.05 0.5 0]);

set(gca, 'FontSize', 16, 'LineWidth', 1.5);
xticks(1:height(finalData));
xticklabels(finalData.Type);
xtickangle(0);
legend('FontSize', 16, 'Location', 'best');
grid on;

for i = 1:height(finalData)
    text(i, finalData.Warships_Sunk(i) + 20, num2str(finalData.Warships_Sunk(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 16);
    text(i, finalData.Merchant_Sunk(i) + 20, num2str(finalData.Merchant_Sunk(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 16);
end

xlim([0.5, height(finalData) + 0.5]);
hold off;

print(gcf, 'ships_sunk_by_type.png', '-dpng', '-r300');
fprintf('Generated ships_sunk_by_type.png\n');

[uniqueTypesRatio, ~, typeIdxRatio] = unique(df.Type);
typeCountsRatio = accumarray(typeIdxRatio, 1);
typeCountsRatioTable = table(uniqueTypesRatio, typeCountsRatio, 'VariableNames', {'Type', 'Count'});

totalSunkPerTypeTable = groupsummary(df, 'Type', 'sum', {'Warships_sunk_n_total_loss_No', 'Merchant_Ships_sunk_No'});
totalSunkPerTypeTable.GroupCount = [];
totalSunkPerTypeTable.TotalSunk = totalSunkPerTypeTable.sum_Warships_sunk_n_total_loss_No + totalSunkPerTypeTable.sum_Merchant_Ships_sunk_No;

mergedData = innerjoin(typeCountsRatioTable, totalSunkPerTypeTable, 'Keys', 'Type');
ratio = mergedData.TotalSunk ./ mergedData.Count;
ratioTable = table(mergedData.Type, ratio, 'VariableNames', {'Type', 'Ratio'});
ratioTable.Ratio(isnan(ratioTable.Ratio)) = 0;
ratioTable = sortrows(ratioTable, 'Ratio', 'descend');

ratio_threshold = 5;
ratioMain = ratioTable(ratioTable.Ratio >= ratio_threshold, :);
ratioOthers = ratioTable(ratioTable.Ratio < ratio_threshold, :);

ratioFiltered = ratioMain;
if height(ratioOthers) > 0
    othersRatioValue = sum(ratioOthers.Ratio) / height(ratioOthers);
    othersRow = table({'Others'}, othersRatioValue, 'VariableNames', {'Type', 'Ratio'});
    ratioFiltered = [ratioFiltered; othersRow];
end

ratioFiltered = sortrows(ratioFiltered, 'Ratio', 'descend');

figure('Position', [100, 100, 1600, 900], 'Renderer', 'Painters');

bar(categorical(ratioFiltered.Type, ratioFiltered.Type), ratioFiltered.Ratio, ...
    'FaceColor', [0.529 0.808 0.922], ...
    'EdgeColor', 'none');

title('Ratio of Total Ships Sunk / Count of U-boats per Type', 'FontSize', 20, 'FontWeight', 'bold', ...
      'Units', 'normalized', 'Position', [0.5 1.05 0]);
xlabel('Submarine Type', 'FontSize', 16);
ylabel('Ships Sunk per Sub', 'FontSize', 16, ...
       'Units', 'normalized', 'Position', [-0.05 0.5 0]);

maxRatio = max(ratioFiltered.Ratio);
ylim([0, maxRatio + ceil(maxRatio * 0.1)]);
yticks(0:floor(maxRatio/5):floor(maxRatio));
set(gca, 'FontSize', 16, 'LineWidth', 1.5);
xtickangle(0);
grid on;

for i = 1:height(ratioFiltered)
    text(i, ratioFiltered.Ratio(i), num2str(round(ratioFiltered.Ratio(i), 2)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
         'FontSize', 16, 'Color', 'k');
end

print(gcf, 'ratio_sunk_per_uboat.png', '-dpng', '-r300');
fprintf('Generated ratio_sunk_per_uboat.png\n');

fateColorMap = containers.Map();
fateColorMap('Sunk') = [0.121 0.466 0.705];
fateColorMap('Scuttled') = [1.0 0.498 0.055];
fateColorMap('Surrendered') = [0.172 0.627 0.172];
fateColorMap('Missing') = [0.839 0.153 0.157];
fateColorMap('Others') = [0.498 0.498 0.498];

fate_threshold = 20;

function plotFateDistribution(data, titleText, threshold, colorMap)
    [uniqueFates, ~, fateIdx] = unique(data.Fate_Event);
    fateCounts = accumarray(fateIdx, 1);
    fateCountsTable = table(uniqueFates, fateCounts, 'VariableNames', {'Fate', 'Count'});

    fateMain = fateCountsTable(fateCountsTable.Count >= threshold, :);
    othersCount = sum(fateCountsTable.Count(fateCountsTable.Count < threshold));
    fateFiltered = fateMain;
    if othersCount > 0
        othersRow = table({'Others'}, othersCount, 'VariableNames', {'Fate', 'Count'});
        fateFiltered = [fateFiltered; othersRow];
    end

    numFates = height(fateFiltered);
    colors = zeros(numFates, 3);
    labels = fateFiltered.Fate;
    for i = 1:numFates
        if isKey(colorMap, labels{i})
            colors(i, :) = colorMap(labels{i});
        else
            colors(i, :) = [0.78 0.78 0.78];
        end
    end

    figure('Position', [100, 100, 1600, 900], 'Renderer', 'Painters');
    h = pie(fateFiltered.Count, labels);
    colormap(colors);

    textObjs = findobj(h, 'Type', 'text');
    
    percentages = 100 * fateFiltered.Count / sum(fateFiltered.Count);

    for i = 1:numFates
        textObj = textObjs(i);
        
        original_pos = get(textObj, 'Position');
        angle = atan2(original_pos(2), original_pos(1));
        
        label_radius_multiplier = 1.3;
        new_label_x = label_radius_multiplier * cos(angle);
        new_label_y = label_radius_multiplier * sin(angle);
        
        set(textObj, 'String', labels{i}, ...
                     'Position', [new_label_x, new_label_y, 0], ...
                     'FontSize', 16, 'FontWeight', 'bold', ...
                     'Color', 'k', 'HorizontalAlignment', 'center', ...
                     'VerticalAlignment', 'middle');
    end

    for i = 1:numFates
        angle = sum(fateFiltered.Count(1:i-1)) / sum(fateFiltered.Count) * 2 * pi + ...
                (fateFiltered.Count(i) / sum(fateFiltered.Count) * 2 * pi) / 2;
        
        radius_for_percentage = 0.6;
        
        x = radius_for_percentage * cos(angle);
        y = radius_for_percentage * sin(angle);
        
        current_percentage = percentages(i);
        display_font_size = 14;
        if current_percentage < 3 && numFates > 5
            display_font_size = 10;
        end

        text(x, y, sprintf('%.1f%%', percentages(i)), ...
             'FontSize', display_font_size, 'FontWeight', 'bold', 'Color', 'k', ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end

    title(titleText, 'FontSize', 20, 'FontWeight', 'bold');
    pbaspect([1 1 1]);
end

dfWarships = df(df.Warships_sunk_n_total_loss_No > 0, :);
plotFateDistribution(dfWarships, 'Warships Fate Distribution', fate_threshold, fateColorMap);
print(gcf, 'warships_fate_distribution.png', '-dpng', '-r300');
fprintf('Generated warships_fate_distribution.png\n');

dfMerchants = df(df.Merchant_Ships_sunk_No > 0, :);
plotFateDistribution(dfMerchants, 'Merchant Ships Fate Distribution', fate_threshold, fateColorMap);
print(gcf, 'merchant_ships_fate_distribution.png', '-dpng', '-r300');
fprintf('Generated merchant_ships_fate_distribution.png\n');