function xyz = longLat2xyz(lolah)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
lon = lolah(1) * 0.017453292519943295; 
lat = lolah(2) * 0.017453292519943295;
alt = lolah(3);
sinLat = sin(lat);
NNN = 6378137.0 / sqrt(1-0.006694379990141381*sinLat*sinLat);
NcosLat = (NNN+alt)*cos(lat);
xyz=zeros(1,3);
xyz(1)= NcosLat*cos(lon);
xyz(2)= NcosLat*sin(lon);
xyz(3)= (NNN+alt-0.006694379990141381 * NNN)*sinLat;
end

