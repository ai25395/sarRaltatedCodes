%各种参数
T = 18.345114;
descending = 1;
left = 1;
sarNr = 6163;
sarNc = 4903;
ratio1 = 2.0;
demxyz=imresize(demxyz0,ratio1);
[nr,nc,~]=size(demxyz);
simsarAziRanIndexInteger = zeros(nr,nc,2);
simsarAziRanIndex = zeros(nr,nc,2);
dT = T/sarNr/ratio1;
c=3e8;
rangeSpacing = 7.90489006;
firstSlantRange = 828106.663686057;
lambda = c/5299.999744e6;
%轨道建模
satellitePos=[-3816835.72 1009920.08 5960169.72;
              -3840701.0  1027120.9  5941911.69;
              -3864467.36 1044314.26 5923517.41;
              -3888134.27 1061499.72 5904987.3;
              -3911701.19 1078676.82 5886321.78];
satelliteVel=[-5214.36775 3751.27246 -3966.13541;
              -5192.85711 3749.69825 -3995.89666;
              -5171.23214 3748.02489 -4025.55482;
              -5149.4906  3746.25169 -4055.11952;
              -5127.63245 3744.3785  -4084.59308];
t=[0 4.586278 9.172757 13.758835 18.345114];
posxParam=polyfit(t,satellitePos(:,1)',2);
posyParam=polyfit(t,satellitePos(:,2)',2);
poszParam=polyfit(t,satellitePos(:,3)',2);
velxParam=polyfit(t,satelliteVel(:,1)',2);
velyParam=polyfit(t,satelliteVel(:,2)',2);
velzParam=polyfit(t,satelliteVel(:,3)',2);
parampos=[posxParam;posyParam;poszParam]';
paramvel=[velxParam;velyParam;velzParam]';
poss=zeros(nr,3);
vels=zeros(nr,3);
for m=1:floor(sarNr*ratio1*1.01)
    tt = (m-1)*dT;
    poss(m,:)=[tt*tt tt 1]*parampos;
    vels(m,:)=[tt*tt tt 1]*paramvel;
end
% 计算示例t=7.712753295898438
% ts=[7.712753295898438*7.712753295898438 7.712753295898438 1];
% posvel=ts*params;
% pos=posvel(1,1:3);
% vel=posvel(1,4:6);

simsar0 = zeros(sarNr,sarNc);
% simxyz=zeros(sarNr,sarNc,4*1000);
ratioTable = zeros(1001,1001,4);
for m=1:1001
    for n=1:1001
        ratioTable(m,n,1)=(1-0.001*m)*(1-0.001*n);
        ratioTable(m,n,2)=(1-0.001*m)*0.001*n;
        ratioTable(m,n,1)=0.001*m*(1-0.001*n);
        ratioTable(m,n,1)=0.000001*m*n;
    end
end
%循环计算本地入射角，并转换为灰度
outboundNum = 0;
zeroFdtMax=0;
% parfor m=2:nr-1
for m=2:nr-1
    m
    %zeroFdt = getZeroFdTime(poss,vels,reshape(demxyz(m,3,:),[1,3]),dT,nr,lambda);
    for n=2:nc-1
        if demxyz(m,n,1)==0 && demxyz(m,n,2)==0 && demxyz(m,n,3)==0
            continue;
        end
        zeroFdt = getZeroFdTime(poss,vels,reshape(demxyz(m,n,:),[1,3]),dT,sarNr*ratio1,lambda);
        if zeroFdt <-900
            outboundNum = outboundNum +1;
            continue
        end
        tmp = reshape(demxyz(m,n,:),[1,3]);
        range=norm(tmp-poss(m,:));
        zeroFdtc=zeroFdt+2*range/c;
        rangetc=norm(tmp-poss(int16(zeroFdtc/dT),:));
        indexAzimuth = zeroFdtc/dT/ratio1;
        indexRange = (rangetc-firstSlantRange)/rangeSpacing;
        if indexRange<1 || indexRange>sarNc
            outboundNum = outboundNum +1;
            continue
        end
        if indexAzimuth<1 || indexAzimuth>sarNr
            outboundNum = outboundNum +1;
            continue
        end
        
        RCS = getRCS(poss(m,:),tmp,reshape(demxyz(m-1,n,:),[1,3]),reshape(demxyz(m,n-1,:),[1,3]),reshape(demxyz(m+1,n,:),[1,3]),reshape(demxyz(m,n+1,:),[1,3]));
        a0 = floor(indexAzimuth);
        a1 = a0+1;
        r0 = floor(indexRange);
        r1 = r0+1;
        ea = indexAzimuth - double(a0);
        er = indexRange - double(r0);
        simsar0(a0,r0)=ratioTable(int16(ea*1000)+1,int16(er*1000)+1,1)*RCS+simsar0(a0,r0);
        simsar0(a0,r1)=ratioTable(int16(ea*1000)+1,int16(er*1000)+1,2)*RCS+simsar0(a0,r1);
        simsar0(a1,r0)=ratioTable(int16(ea*1000)+1,int16(er*1000)+1,3)*RCS+simsar0(a1,r0);
        simsar0(a1,r1)=ratioTable(int16(ea*1000)+1,int16(er*1000)+1,4)*RCS+simsar0(a1,r1);
        simsarAziRanIndexInteger(m,n,:)=[int16(indexAzimuth);int16(indexRange)];
        simsarAziRanIndex(m,n,:)=[indexAzimuth;indexRange];
        %saveRCS(RCS,indexAzimuth,indexRange);
        %simsar0(indexAzimuth,indexRange) = RCS + simsar0(indexAzimuth,indexRange);
    end
end
aveFilter =  fspecial('average',5);
simsar = imfilter(simsar0,aveFilter);

