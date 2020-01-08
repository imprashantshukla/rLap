%% These gammaA and gammaI have been used for final results
 [et_hasy,eu_hasy] = experiment_hasy('laprlsc',0.005,0.05,6);
 [et_hasyp,eu_hasyp] = experiment_hasyp('laprlsc',0.005,0.05,6);
 [et_hasym,eu_hasym] = experiment_hasym('laprlsc',0.005,0.05,6);
 [et_hasyr,eu_hasyr] = experiment_hasy('r_laprlsc',0.005,0.05,6);

%% et rlsc
x = 1:length(et_hasy);
figure;
plot(x, et_hasy,'r--o' ,x,et_hasym,'g-+',x,et_hasyp,'k-.p',x, et_hasyr,'b- .');
title('HASY ET RLSC Set');
xlabel('36 Binary Classification');
ylabel('Root Mean Squared Error %');
legend('Lap','Lap2','pLap','rLap');
%% eu rlsc
x = 1:length(eu_hasym);
figure;
plot(x, eu_hasy,'r--o' ,x,eu_hasym,'g-+',x,eu_hasyp,'k-.p',x, eu_hasyr,'b- .');
title('HASY EU RLSC Set');
xlabel('36 Binary Classification');
ylabel('Root Mean Squared Error %');
legend('Lap','Lap2','pLap','rLap');


