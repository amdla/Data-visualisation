df = readtable('Ranking of countries by Year.csv');


% Assign columns to variables
years            = df{:,1};
countries        = df{:,3};
allContestants   = df{:,4};
maleContestants  = df{:,5};
femaleContestants= df{:,6};
goldCount        = df{:,7};
silverCount      = df{:,8};
bronzeCount      = df{:,9};
hmCount          = df{:,10};
goldCutoff       = df{:,12};
silverCutoff     = df{:,13};
bronzeCutoff     = df{:,14};



% FIGURE (1): BAR CHART OF TOTAL CONTESTANTS
figure(1);
bar(years, allContestants);
xlabel('Year');
ylabel('Number of Contestants');
title('(1) Number of Contestants Through the Years');



% FIGURE (2): LINE CHART COMPARING MALE vs. FEMALE
figure(2);
plot(years, maleContestants,  '-','LineWidth',2, 'DisplayName','Male');
hold on;
plot(years, femaleContestants,'-','LineWidth',2, 'DisplayName','Female');
hold off;
xlabel('Year');
ylabel('Number of Contestants');
title('(2) Male vs. Female Contestants');
legend('Location','northwest');
xlim([min(years), max(years)]);
grid on; % Adds grid lines
grid minor; % Adds finer background lines



% FIGURE (3): FEMALE-TO-MALE RATIO
figure(3);
ratioFM = femaleContestants ./ maleContestants;
bar(years, ratioFM);
xlabel('Year');
ylabel('Ratio (F / M)');
title('(3) Female-to-Male Ratio Among Participants');



% FIGURE (4): % OF TOTAL PARTICIPANTS EARNING GOLD, SILVER, BRONZE
figure(4);
goldFrac   = (goldCount   ./ allContestants)*100;
silverFrac = (silverCount ./ allContestants)*100;
bronzeFrac = (bronzeCount ./ allContestants)*100;
totalMedalFrac = goldFrac + silverFrac + bronzeFrac;

subplot(2,1,1);
plot(years, goldFrac,   '-','LineWidth',2, 'Color', [1 0.84 0], 'DisplayName','Gold');
hold on;
plot(years, silverFrac, '-','LineWidth',2, 'Color', [0.75 0.75 0.75], 'DisplayName','Silver'); 
plot(years, bronzeFrac, '-','LineWidth',2, 'Color', [0.8 0.5 0.2], 'DisplayName','Bronze')
hold off;
xlabel('Year');
ylabel('Percent of All Participants');
title('(4a) Percentage of Participants Earning Gold / Silver / Bronze');
legend('Location','best');
xlim([min(years), max(years)]);
ylim([0, max([goldFrac; silverFrac; bronzeFrac])*1.1]);
grid on;
grid minor;

% FIGURE (4b): TOTAL MEDALS EARNED (GOLD + SILVER + BRONZE)
subplot(2,1,2);
plot(years, totalMedalFrac, '-k','LineWidth',2,'DisplayName','Total Medals');
xlabel('Year');
ylabel('Percent of All Participants');
title('(4b) Percentage of Participants Earning Any Medal');
legend('Location','best');
xlim([min(years), max(years)]);
ylim([0, max(totalMedalFrac)*1.1]);
grid on;
grid minor;



% FIGURE (5): 4 SUBPLOTS REPRESENTING GOLD, SILVER, BRONZE, HM
figure(5);
% Determine a common max Y among all four medal types
commonMax = max([ max(goldCount), max(silverCount), ...
                  max(bronzeCount), max(hmCount) ]);

subplot(2,2,1);
bar(years, goldCount);
xlabel('Year'); ylabel('Gold');
title('Gold Medals');
ylim([0, commonMax]);

subplot(2,2,2);
bar(years, silverCount);
xlabel('Year'); ylabel('Silver');
title('Silver Medals');
ylim([0, commonMax]);

subplot(2,2,3);
bar(years, bronzeCount);
xlabel('Year'); ylabel('Bronze');
title('Bronze Medals');
ylim([0, commonMax]);

subplot(2,2,4);
bar(years, hmCount);
xlabel('Year'); ylabel('Honorable Mentions');
title('Honorable Mentions');
ylim([0, commonMax]);

sgtitle('(5) Medals and Honorable Mentions');



% FIGURE (6): MEDAL CUTOFF SCORES (IN PERCENTAGE)
figure(6);
goldCutoffPct   = (goldCutoff   ./ df{:,11}) * 100;
silverCutoffPct = (silverCutoff ./ df{:,11}) * 100;
bronzeCutoffPct = (bronzeCutoff ./ df{:,11}) * 100;

plot(years, goldCutoffPct,   '-','LineWidth',2, 'Color', [1 0.84 0], 'DisplayName','Gold Cutoff');   % Yellow
hold on;
plot(years, silverCutoffPct, '-','LineWidth',2, 'Color', [0.75 0.75 0.75], 'DisplayName','Silver Cutoff'); % Silver/Grey
plot(years, bronzeCutoffPct, '-','LineWidth',2, 'Color', [0.8 0.5 0.2], 'DisplayName','Bronze Cutoff'); % Bronze
hold off;
xlabel('Year');
ylabel('Cutoff (%)');
title('(6) Medal Cutoff Scores (Percentage)');
legend('Location','best');
xlim([1959, max(years)]); 
ylim([0, 100]); 
grid on;
grid minor;
