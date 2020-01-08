function [StoredIdx, KDistance] = MyKNN(Input,K,Input2)
[NumTstPtns,TstInputSize] = size(Input);
StoredIdx = zeros(NumTstPtns,K);
KDistance = zeros(NumTstPtns,K);
%     TstNormSq = sum(Input.^2,2)';
distances = pdist2(Input,Input);
for i=1: NumTstPtns
    %         InnerProduct = Input(i,:)*Input';
    %         DistanceSq = abs(TstNormSq-2*InnerProduct+TstNormSq(i));
    Distance = distances(i,:);
    if K>1
        [Sorted, KIndex] = sort(Distance, 'ascend');
        StoredIdx(i,:) = KIndex(1:K);
        KDistance(i,:) = Sorted(1:K);
    else
        KDistance(i) = min(Distance);
        Temp = find(Distance==KDistance(i));
        StoredIdx(i) = Temp(1);
    end
end

