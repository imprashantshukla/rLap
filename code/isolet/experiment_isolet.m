function [et,eu]=experiment_isolet(method,gamma_A,gamma_I,nn);

% Isolet Experiment
% [et,eu]=experiment_isolet(method,gamma_A,gamma_I);
% et: error rates on test set
% eu: error rates on training set
% method: 'svm', 'rlsc', 'lapsvm',' laprlsc', 'tsvm' (you need to have
%                   saved model files for tsvm; check below)
%
% Author: Vikas Sindhwani (vikass@cs.uchicago.edu)
% June 2004

cd .\datasets
load isolet.mat
cd ..
sigma=1;

options=ml_options('Kernel','rbf', 'KernelParam', sigma, ...
    'NN',nn,'gamma_A',gamma_A,'gamma_I',gamma_I,'GraphWeights','heat','GraphWeightParam',1);

Xt=Xtp;
disp('Computing Kernels');
K=calckernel('rbf',sigma,X);
KT=calckernel('rbf',sigma,X,Xt);
disp('Done.');

if  strcmp(method, 'laprlsc')
    L=laplacian(X,'nn',options);
    %L=L*L';
    %L=L^5;
elseif strcmp(method,'r_laprlsc')
    B=rotationlap(X,options.NN);
end

for i=1:30
    
    y=labs(:,i);
    lab=find(y);
    unlab=find(y==0);
    Yu=Y(unlab);
    r=sum(Yt==-1)/length(Yt);
    
    
    switch method
        case 'rlsc'
            [alpha,b]=rlsc(K(lab,lab),y(lab),options.gamma_A);
            fu=K(unlab,lab)*alpha;
            ft=KT(:,lab)*alpha;
        case {'laprlsc'}
            [alpha,b]=laprlsc(K,y,L,options.gamma_A,options.gamma_I);
            fu=K(unlab,:)*alpha;
            ft=KT*alpha;
        case 'r_laprlsc'
            [alpha,b]=laprlsc(K,y,B,options.gamma_A,options.gamma_I);
            fu=K(unlab,:)*alpha;
            ft=KT*alpha;
    end
    
    bt=breakeven(ft,Yt,@pre_rec_equal);
    bu=breakeven(fu,Yu,@pre_rec_equal);
   
    et(i)=evaluate(sign(ft-bt),Yt);
    eu(i)=evaluate(sign(fu-bu),Yu);
    
    
    [i et(i) eu(i) ]
    
end
