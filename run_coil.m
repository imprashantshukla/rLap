
 [etS,euS,et_coil,eu_coil] = experiment_coil('laprlsc',0.005,0.5);
 [etSp,euSp,et_coilp,eu_coilp] = experiment_coilp('laprlsc',0.005,0.5);
 [etSm,euSm,et_coilm,eu_coilm] = experiment_coilm('laprlsc',0.005,0.5);
 [etSr,euSr,et_coilr,eu_coilr] = experiment_coil('r_laprlsc',0.0005,0.05);

%% et rlsc
x = 1:length(et_coil);
figure;
plot(x, et_coil,'r--o' ,x,et_coilm,'g-+',x,et_coilp,'k-.p',x, et_coilr,'b- .');
title('coil ET RLSC Set');
xlabel('10 Binary Classification');
ylabel('Root Mean Squared Error %');
legend('Lap','Lap2','pLap','rLap');
%% eu rlsc
x = 1:length(eu_coilm);
figure;
plot(x, eu_coil,'r--o' ,x,eu_coilm,'g-+',x,eu_coilp,'k-.p',x, eu_coilr,'b- .');
title('coil EU RLSC Set');
xlabel('10 Binary Classification');
ylabel('Root Mean Squared Error %');
legend('Lap','Lap2','pLap','rLap');







