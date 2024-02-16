% the detrended data corresponds to the residuals
det_stage = reg_sta.Residuals.Raw;
det_discharge = reg_dis.Residuals.Raw;
% plot detrended pairs
scatter(det_stage,det_discharge,"red")
xlabel("stage residuals")
ylabel("river discharge residuals")
% find the correlation with CI bounds and corr coeff
[R,P,RL,RU] = corrcoef(det_stage,det_discharge,"Rows","complete");
disp("correlation: "+string(R(2)))
disp("CI bounds [" + string(RL(2)) + " , " + string(RU(2)) + "]")
disp("p-value: " + string(P(2)))





