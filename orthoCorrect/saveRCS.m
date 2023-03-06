function a = saveRCS(RCS,azimuthIndex,rangeIndex)
%SAVERCS 此处显示有关此函数的摘要
%   此处显示详细说明
a0 = int16(azimuthIndex);
a1 = a0+1;
r0 = int16(rangeIndex);
r1 = r0+1;
ea = azimuthIndex - double(a0);
er = rangeIndex - double(r0);
simsar0(a0,r0)=ratioTable(int16(ea*1000),int16(er*1000),1)*RCS+simsar0(a0,r0);
simsar0(a0,r1)=ratioTable(int16(ea*1000),int16(er*1000),2)*RCS+simsar0(a0,r1);
simsar0(a1,r0)=ratioTable(int16(ea*1000),int16(er*1000),3)*RCS+simsar0(a1,r0);
simsar0(a1,r1)=ratioTable(int16(ea*1000),int16(er*1000),4)*RCS+simsar0(a1,r1);
    
end

