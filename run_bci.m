%% set1 0.005,0.5
[et_bcil,eu_bcil] = experiment_bci('laprlsc',0.005,0.5);
[et_bcilp,eu_bcilp] = experiment_bcip('laprlsc',0.005,0.5); 
[et_bcilm,eu_bcilm] = experiment_bcim('laprlsc',0.005,0.5); 
[et_bcir,eu_bcir] = experiment_bci('r_laprlsc',0.005,0.5);
%% et rlsc
x = 1:length(et_bcil);
figure;
plot(x, et_bcil,'r--o' ,x,et_bcilm,'g-+',x,et_bcilp,'k-.p',x, et_bcir,'b- .');
title('BCI ET RLSC Set');
xlabel('10 Binary Classification');
ylabel('Root Mean Squared Error %');
legend('Lap','Lap2','pLap','rLap');
%% eu rlsc
x = 1:length(eu_bcilm);
figure;
plot(x, eu_bcil,'r--o' ,x,eu_bcilm,'g-+',x,eu_bcilp,'k-.p',x, eu_bcir,'b- .');
title('BCI EU RLSC Set');
xlabel('10 Binary Classification');
ylabel('Root Mean Squared Error %');
legend('Lap','Lap2','pLap','rLap');
