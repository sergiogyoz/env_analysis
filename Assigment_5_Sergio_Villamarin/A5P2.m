%% prep
A5P1;

% aditional sorting based on the std values
stds = std(Mcldt,"omitmissing");
[~, std_order] = sort(stds, "ascend");

%% plotting in default order
id_order = 1:20;
mycorrplot(Mcldt, N, id_order);

%% plotting in decending order latitude
mycorrplot(Mcldt, N, descend);

%% plotting in std ascending order
mycorrplot(Mcldt, N, std_order);

%% select the last 5 of the std order and make an index
mystations = 16:20;
my_data = Mcldt(:, std_order);
my_data = my_data(:, mystations);
names = N(std_order);
names = names(mystations);
% my index STDI
STDI = mean(my_data, 2,"omitmissing");

% plotting
figure;
for station = mystations
    color = [1 1 1] * (station-10)/15;
    plot(t, Mcldt(:,station), LineWidth=0.3, Color=[0.5,0.7,0.9])
    hold on
end
plot(t, STDI, LineWidth=1, Color=[1 1 1])
hold off



