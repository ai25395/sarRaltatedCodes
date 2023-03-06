function t = getZeroFdTime(satposs,satvels,dempos,dT,nr,lambda)
%GETZEROFDTIME 此处显示有关此函数的摘要
%   此处显示详细说明
low=1;
high=nr;
count = 0;
lowbound = getFd(satposs(low,:),satvels(low,:),dempos,lambda);
highbound = getFd(satposs(high,:),satvels(high,:),dempos,lambda);
if abs(lowbound)<3.0
    t=0;
elseif abs(highbound)<3.0
    t=dT*nr;
elseif lowbound*highbound>0
    t = -999.9;
else
    t = -999.9;
    mid = -999.9;
    while abs(highbound-lowbound)>1.0 && low < high && count<15
        mid = int16((low+high)/2);
        midfd = getFd(satposs(mid,:),satvels(mid,:),dempos,lambda);
        if midfd*lowbound>0
            low=mid;
            lowbound=midfd;
        elseif midfd*highbound>0
            high=mid;
            highbound=midfd;
        end
        count = count+1;
    end
    if count<30
        t = double(mid)*dT;
    else
        t = -999.9;
    end
end
end

