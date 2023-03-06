function RCS = getRCS(satpos,pos,pos1,pos2,pos3,pos4)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
n1 = getNVector(pos-pos1,pos-pos2);
n2 = getNVector(pos-pos2,pos-pos3);
n3 = getNVector(pos-pos3,pos-pos4);
n4 = getNVector(pos-pos4,pos-pos1);
ts = pos-satpos;
n = (n1+n2+n3+n4)/4;
cosAngle = abs(ts*n'/(norm(ts)*norm(n)));
sinAngle = sqrt(1-cosAngle^2);
% RCS=(sqrt(1-cosAngle * cosAngle) + 0.1 * cosAngle)^3;
RCS= 0.0118*cosAngle/(sinAngle+0.111*cosAngle)^3;
end

