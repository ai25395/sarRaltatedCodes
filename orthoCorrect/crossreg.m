srcsar = imread('srcsar.tif');
lenx = 400;
leny = 400;
dx = 30;
dy = 30;
xblockN=floor((sarNr-dx)/lenx);
yblockN=floor((sarNc-dy)/leny);
xstart=int16(mod(sarNr,lenx)/2+dx/2);
ystart=int16(mod(sarNc,leny)/2+dy/2);
masterGCPs=zeros(2,xblockN*yblockN);
slaveGCPs=zeros(2,xblockN*yblockN);
masterGCPsFinal=zeros(2,xblockN*yblockN);
slaveGCPsFinal=zeros(2,xblockN*yblockN);
demGCPsFinal=zeros(2,xblockN*yblockN);
vars=zeros(1,xblockN*yblockN);
values=zeros(dx,dy,3);
starta = -int16(dx/2);
overa = -starta-1;
startb = -int16(dy/2);
overb = -startb-1;
countGCP=0;
corrMin=0.6;
for m=1:xblockN
    m
    for n=1:yblockN
        ss1 = simsar(xstart+(m-1)*lenx:xstart+m*lenx-1,ystart+(n-1)*leny:ystart+n*leny-1);
        [x0,y0]=find(ss1==max(max(ss1)));
        x1 = int16(x0+(m-1)*lenx+xstart+dx/2);
        y1 = int16(y0+(n-1)*leny+ystart+dy/2);
        maxv=0;
        maxc=0;
        maxa=-1;
        maxb=-1;
        existFlag=1;
        for a=starta:overa
            for b=startb:overb
                ss2 = double(srcsar(xstart+(m-1)*lenx+a:xstart+m*lenx-1+a,ystart+(n-1)*leny+b:ystart+n*leny-1+b));
                v = sum(sum(ss1.*ss2));
                if v>maxv 
                    maxv=v;
                    maxa=a;
                    maxb=b;
                elseif v==maxv
                    existFlag=0;
                    maxv=-999.9;
                    break;
                end
            end
        end
        x2=int16(x0-maxa+(m-1)*lenx+xstart+dx/2);
        y2=int16(y0-maxb+(n-1)*leny+ystart+dy/2);
        ss2 = double(srcsar(xstart+(m-1)*lenx+maxa:xstart+m*lenx-1+maxa,ystart+(n-1)*leny+maxb:ystart+n*leny-1+maxb));
        maxc = corr2(ss1,ss2);
        if existFlag && maxc>corrMin
            countGCP=countGCP+1;
            masterGCPs(:,countGCP)=[x2;y2];
            slaveGCPs(:,countGCP)=[x1,y1];
            vars(1,countGCP)=sum(sum(cov(ss1)));
        end
    end
end
meanVar = mean(vars);
countGCPFinal=0;
for m=1:countGCP
    if vars(m)>meanVar
        countGCPFinal=countGCPFinal+1;
        masterGCPsFinal(:,countGCPFinal)=masterGCPs(:,m);
        slaveGCPsFinal(:,countGCPFinal)=slaveGCPs(:,m);
%         demGCPsFinal(:,countGCPFinal)=xyz2Longlat(reshape(demxyz(),[1,3]))
    end
end

figure(1);imshow(simsar);hold on;scatter(slaveGCPsFinal(1,1:94),slaveGCPsFinal(2,1:94),'r');hold off;
figure(2);imshow(srcsar);hold on;scatter(masterGCPsFinal(1,1:94),masterGCPsFinal(2,1:94),'r');hold off;