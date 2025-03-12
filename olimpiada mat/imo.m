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
figure(2);
bar(years, y, 1.4);
xlabel('Year');
ylabel('Number of Contestants');
title('Number of Male and Female Contestants through Years');
legend('Male', 'Female','Location' ,'Northwest');


y = df{:, 6} ./ df{:, 5};
figure(3);
bar(years, y);
xlabel('Year');
ylabel('Number of Contestants');
title('Percent of Female among participatns')


figure(4);
% Gold color: [1, 0.84, 0]
plot(years, df{:, 7} ./ df{:, 5}, '-o', 'Color', [1, 0.84, 0], 'LineWidth', 1.3, 'MarkerSize', 2);
hold on;
% Silver color: [0.75, 0.75, 0.75]
plot(years, df{:, 8} ./ df{:, 5}, '-o', 'Color', [0.75, 0.75, 0.75], 'LineWidth', 1.3, 'MarkerSize', 2);
% Bronze color: a custom choice ([0.8, 0.5, 0.2])
plot(years, df{:, 9} ./ df{:, 5}, '-o', 'Color', [0.8, 0.5, 0.2], 'LineWidth', 1.3, 'MarkerSize', 2);
xlabel('Year');
ylabel('Percent of Participants');
title('Number of Gold, Silver, Bronze Medals through Years');
legend('Gold', 'Silver', 'Bronze', 'Location', 'northeast');
xlim([min(years) max(years)]);
hold off;
