function [lon,lat] = xyz2Longlat(xyz)
%XYZ2LONGLAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
a = 6378137.0;
b = 6356752.314245179;
e2 = 0.006694379990141381;
ep2 = 0.006739496742276499;
x=xyz(1);
y=xyz(2);
z=xyz(3);
s=sqrt(x^2+y^2);
theta = atan(z * a / (s * b));
lon = atan(y / x) * 57.29577951308232;
if lon < 0.0 && y >= 0.0
    lon = lon + 180.0;
elseif geoPos.lon > 0.0 && y < 0.0
    lon = lon - 180.0;
end
lat = ((atan((z + ep2 * b * sin(theta)^3) / (s - e2 * a * cos(theta)^3)) * 57.29577951308232));
end

