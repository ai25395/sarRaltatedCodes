function  v = getNVector(v1,v2)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
v0 = [v1(2)*v2(3)-v1(3)*v2(2), v1(3)*v2(1)-v1(1)*v2(3),v1(1)*v2(2)-v1(2)*v2(1)];
r = norm(v1-v2);
v = v0/r;
end

