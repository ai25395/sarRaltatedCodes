function Fd = getFd(satpos,satvel,dempos,lambda)
%GETFD 此处显示有关此函数的摘要
%   此处显示详细说明
range=norm(satpos-dempos);
Fd=2*satvel*(dempos-satpos)'/range/lambda;
end

