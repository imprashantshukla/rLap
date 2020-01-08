[et_isolet,eu_isolet] = experiment_isolet('laprlsc',0.005,0.5,10);
[et_isoletp,eu_isoletp] = experiment_isoletp('laprlsc',0.005,0.5,10); 
[et_isoletm,eu_isoletm] = experiment_isoletm('laprlsc',0.005,0.5,10); 
%[et_isoletr,eu_isoletr] = experiment_isolet('r_laprlsc',0.005,0.5,10);
[etr_isolet,eur_isolet] = experiment_isolet('r_laprlsc',0.05,0.05,10);
%% et rlsc
x = 1:length(et_isolet);
figure;
plot(x, et_isolet,'r--o' ,x,et_isoletm,'g-+',x,et_isoletp,'k-.p',x, etr_isolet,'b- .');
title('ISOLET ET RLSC Set');
xlabel('10 Binary Classification');
ylabel('Root Mean Squared Error %');
legend('Lap','Lap2','pLap','rLap');
%% eu rlsc
x = 1:length(eu_isolet);
figure;
plot(x, eu_isolet,'r--o' ,x,eu_isoletm,'g-+',x,eu_isoletp,'k-.p',x, eur_isolet,'b- .');
title('ISOLET EU RLSC Set');
xlabel('10 Binary Classification');
ylabel('Root Mean Squared Error %');
legend('Lap','Lap2','pLap','rLap');
