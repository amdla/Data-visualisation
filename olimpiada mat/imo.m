df = readtable('Ranking of countries by Year.csv');

years = df{:, 1};
contestants = df{:, 4};
figure(1);
bar(years, contestants);
xlabel('Year');
ylabel('Number of Contestants');
title('Number of Contestants through Years');

% wersja z nachodzącymi na siebie
% -------------------------------
% figure(2);
% bar(years, df{:, 5}, 'FaceColor', 'b');
% hold on;
% bar(years, df{:, 6}, 'FaceColor', 'r');

y = [df{:, 5}, df{:, 6}];
bar(years, y, 1.4);
xlabel('Year');
ylabel('Number of Contestants');
title('Number of Male and Female Contestants through Years');
legend('Male', 'Female','Location' ,'Northwest');


y = df{:, 6} ./ df{:, 5};
y
figure(3);
bar(years, y);
xlabel('Year');
ylabel('Number of Contestants');
title('Percent of Female among participatns')


figure(4);
plot(years, df{:, 7} ./ df{:, 5});
hold on;
plot(years, df{:, 8} ./ df{:, 5});
hold on
plot(years, df{:, 9} ./ df{:, 5});
xlabel('Year');
ylabel('Percent of Participants');
title('Number of Gold, Silver, Bronze Medals');
legend('Silver', 'Gold', 'Bronze', 'Location', 'northeast');
xlim(min(years), max(years)); % Set x-axis limits to the range of years
