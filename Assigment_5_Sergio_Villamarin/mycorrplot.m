function [correlations, stds] = mycorrplot(data, names, permutation, colorbreaks)

    arguments
        data;
        names;
        permutation;
        colorbreaks {mustBeInteger} = 10;
    end

    data = data(:,permutation);
    names = names(permutation);
    
    correlations = corrcoef(data, "Rows","pairwise");
    stds = std(data,"omitmissing");
    
    figure;
    tiledlayout("horizontal")
    nexttile([1 2]);
    heatmap(names, names, correlations, "Colormap", jet(colorbreaks))
    nexttile;
    y_loc = 1:20;
    y_loc = y_loc - 0.5;
    s = scatter(stds, flip(y_loc));
    s.MarkerFaceColor = "flat";
    hold on 
    plot(stds, flip(y_loc));
    set(gca, "YAxisLocation", "right")
    set(gca, "YTick", y_loc)
    set(gca, "YTickLabel",flip(names))
    hold off

end