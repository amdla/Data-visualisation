% Set global defaults for figures and axes
set(0, 'DefaultAxesFontSize', 16, ...
       'DefaultAxesXColor', 'w', ...            % White X axis
       'DefaultAxesYColor', 'w', ...            % White Y axis
       'DefaultAxesZColor', 'w', ...            % White Z axis (if needed)
       'DefaultAxesGridColor', 'w', ...         % White grid lines
       'DefaultAxesMinorGridColor', 'w')    % White minor grid lines

set(0, 'DefaultAxesColor', [0.1 0.1 0.1]);  % Dark axes background
% Figure background color


column_names = ["age", "workclass", "final_weight", "education", "education_num", ...
                "marital_status", "occupation", "relationship", "race", ...
                "sex", "capital_gain", "capital_loss", "hours_per_week", ...
                "native_country", "income"];



df = readtable('adult.csv', 'ReadVariableNames', false); % No headers
df.Properties.VariableNames = column_names;











