% gammaA = 0.005; gammaI = 0.9; knn = 6; fname = 'ResultCvprVpw.mat';
% [etLapRLSCfpw, euLapRLSCfpw]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'heat', 10000);
% save(fname);
% [etLapRLSCfpwe, euLapRLSCfpwe]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'distance', 0);
% save(fname, 'etLapRLSCfpwe', 'euLapRLSCfpwe', '-append');
% [etLapRLSCfpwb, euLapRLSCfpwb]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'binary', 0);
% save(fname, 'etLapRLSCfpwb', 'euLapRLSCfpwb', '-append');
% [etLapRLSCvpw, euLapRLSCvpw]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'vpw', 0);
% save(fname, 'etLapRLSCvpw', 'euLapRLSCvpw', '-append');
% [etLapRLSCvpwc, euLapRLSCvpwc]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'vpwc', 0);
% save(fname, 'etLapRLSCvpwc', 'euLapRLSCvpwc', '-append');
% [etLapRLSCvpwce, euLapRLSCvpwce]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'vpwce', 0);
% save(fname, 'etLapRLSCvpwce', 'euLapRLSCvpwce', '-append');
% [etLapRLSCvpwcs, euLapRLSCvpwcs]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'vpwcs', 0);
% save(fname, 'etLapRLSCvpwcs', 'euLapRLSCvpwcs', '-append');
% [etLapRLSCvpwcm, euLapRLSCvpwcm]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'vpwcm', 0);
% save(fname, 'etLapRLSCvpwcm', 'euLapRLSCvpwcm', '-append');
% [etLapRLSCvpwdm, euLapRLSCvpwdm]=experiment_cvpr('laprlsc', gammaA, gammaI, knn, 'vpwdm', 0);
% save(fname, 'etLapRLSCvpwdm', 'euLapRLSCvpwdm', '-append');
% et = [mean(etLapRLSCfpw,2),mean(etLapRLSCfpwb,2),mean(etLapRLSCfpwe,2),mean(etLapRLSCvpw,2),mean(etLapRLSCvpwc,2),mean(etLapRLSCvpwce,2),mean(etLapRLSCvpwcs,2),mean(etLapRLSCvpwcm,2),mean(etLapRLSCvpwdm,2)];
% eu = [mean(euLapRLSCfpw,2),mean(euLapRLSCfpwb,2),mean(euLapRLSCfpwe,2),mean(euLapRLSCvpw,2),mean(euLapRLSCvpwc,2),mean(euLapRLSCvpwce,2),mean(euLapRLSCvpwcs,2),mean(euLapRLSCvpwcm,2),mean(euLapRLSCvpwdm,2)];
function [et,eu,alphas,bias,sup_vecs]=experiment_bcim(method, gamma_A, gamma_I)

cd .\datasets
load BciHaLT_A.mat;
Labels = Labels20;
cd ..

l=size(Labels,3)/2;
options=ml_options('Kernel', 'rbf', 'KernelParam', 6, ...
    'NN',12, 'gamma_A', gamma_A, 'gamma_I', gamma_I,...
    'GraphWeights','heat','GraphWeightParam',1);

p=0;
MAX = length(train);
etS = zeros(MAX,MAX);
euS = zeros(MAX,MAX);
for i=1:MAX
    for j=i+1:MAX
        x=[train{i};train{j}];
        xt=[test{i};test{j}];
        yunlab=[ones(size(train{i},1),1); -ones(size(train{j},1),1)];
        ytest=[ones(size(test{i},1),1); -ones(size(test{j},1),1)];
        p=p+1;
        disp('Computing Kernels');
        K=calckernel('rbf',6,x);
        KT=calckernel('rbf',6,x,xt);
        disp('Done.');
        if  strcmp(method, 'laprlsc') || strcmp(method,'lapsvm')
            L=laplacian(x,'nn',options);
            L=L*L';             
        elseif strcmp(method, 'laprlscr') || strcmp(method,'r_laprlsc')|| strcmp(method,'lapsvmr')
            B=rotationlap(x,options.NN);
        end
        
        
        for k=1:size(Labels,2)
            ypos=zeros(size(train{i},1),1);
            ypos(Labels(p,k,1:l))=1;
            yneg=zeros(size(train{j},1),1);
            yneg(Labels(p,k,l+1:2*l))=-1;
            y=[ypos;yneg];
            lab=find(y);
            unlab=find(y==0);
            yu=yunlab(unlab);
            
            switch method
                case 'rlsc'
                    [alpha,b]=rlsc(K(lab,lab),y(lab),options.gamma_A);
                    fu=K(unlab,lab)*alpha;
                    ft=KT(:,lab)*alpha;
                case 'laprlsc'
                    [alpha,b]=laprlsc(K,y,L,options.gamma_A,options.gamma_I);
                    fu=K(unlab,:)*alpha;
                    ft=KT*alpha;
                case {'r_laprlsc'}
                    [alpha,b]=laprlsc(K,y,B,options.gamma_A,options.gamma_I);
                    fu=K(unlab,:)*alpha;
                    ft=KT*alpha;
            end
            
            bt=breakeven(ft,ytest,@pre_rec_equal);
            bu=breakeven(fu,yu,@pre_rec_equal);
            
            et(p,k)=evaluate(sign(ft-bt),ytest);
            eu(p,k)=evaluate(sign(fu-bu),yu);
            
            indx = length(find(ytest==1));
            etS(i, j) = etS(i, j)+evaluate(sign(ft(1:indx)-bt),ytest(1:indx));
            etS(j, i) = etS(j, i)+evaluate(sign(ft(indx+1:end)-bt),ytest(indx+1:end));
            indx = length(find(yu==1));
            euS(i, j) = euS(i, j)+evaluate(sign(fu(1:indx)-bu),yu(1:indx));
            euS(j, i) = euS(j, i)+evaluate(sign(fu(indx+1:end)-bu),yu(indx+1:end));
            
            alphas{p,k}=alpha;
            bias(p,k)=b;
            
            [p k et(p,k) eu(p,k)]
            
        end
        etS(i, j) = etS(i, j)/k; etS(j, i) = etS(j, i)/k;
        euS(i, j) = euS(i, j)/k; euS(j, i) = euS(j, i)/k;
    end
end

et = mean(et,2);
eu = mean(eu,2);
etS = mean(etS,2);
euS = mean(euS,2);