run('demProcess.m')
run('localIncidence.m')
run('crossreg.m')
%下面是用得到的GCPs进行校正的步骤，最终校正结果有点问题，需要修改
tcSar=zeros(nr2,nc2);
degree=2;
xparam=polyfit(slaveGCPsFinal(1,1:countGCPFinal),masterGCPsFinal(1,1:countGCPFinal),degree);
yparam=polyfit(slaveGCPsFinal(2,1:countGCPFinal),masterGCPsFinal(2,1:countGCPFinal),degree);
countOutBound=0;
%xmax xmaxy xmin xminy ymaxx ymax yminx ymin
xymm=[0 0 1e8 0 0 0 0 1e8];
for m=2:nr-1
    for n=2:nc-1
        if demxyz(m,n,1)==0 && demxyz(m,n,2)==0 && demxyz(m,n,3)==0
            continue;
        end
        xy1=reshape(simsarAziRanIndex(m,n,:),[1,2]);
%         for dg=1:degree+1
%             x2 = x2+xy1(1)^(dg-1)*xparam(4-dg);
%             y2 = y2+xy1(2)^(dg-1)*yparam(4-dg);
%         end
        x2=xy1(1)*xy1(1)*xparam(1)+xy1(1)*xparam(2)+xparam(3);
        y2=xy1(2)*xy1(2)*yparam(1)+xy1(2)*yparam(2)+yparam(3);
        if x2<1 || x2>sarNr || y2<1 || y2>sarNc
            countOutBound=countOutBound+1;
            continue;
        end
%         if mod(n,100)==0 && mod(m,100)==0
%             scatter(x2,y2);xlim([-500 6000]);ylim([0 5000]);hold on;
%         end
        x20=floor(x2);
        y20=floor(y2);
        x21=x20+1;
        y21=y20+1;
        ex=x2-x20;
        ey=y2-y20;
%         int16(ex*1000)+1
%         int16(ey*1000)+1
%         x20
%         y20
%         if x2>4800 && x2<4900 && y2>16 && y2<42
%             [x20 y20]
%             [ss1,ss2]=xyz2Longlat(reshape(demxyz(m,n,:),[1,3]))
%         end
%xmax xmaxy xmin xminy ymaxx ymax yminx ymin
%         if m==3001 && n==3001
%             x2 
%             y2
%         end
%         if xymm(1)<x2
%             xymm(1)=x2;
%             xymm(2)=y2;
%         end
%         if xymm(3)>x2
%             xymm(3)=x2;
%             xymm(4)=y2;
%         end
%         if xymm(6)<y2
%             xymm(6)=y2;
%             xymm(5)=x2;
%         end
%         if xymm(8)>y2
%             xymm(8)=y2;
%             xymm(7)=x2;
%         end
%         rcs00=ratioTable(int16(ex*1000)+1,int16(ey*1000)+1,1)*srcsar(x20,y20);
%         rcs01=ratioTable(int16(ex*1000)+1,int16(ey*1000)+1,2)*srcsar(x20,y21);
%         rcs10=ratioTable(int16(ex*1000)+1,int16(ey*1000)+1,3)*srcsar(x21,y20);
%         rcs11=ratioTable(int16(ex*1000)+1,int16(ey*1000)+1,4)*srcsar(x21,y21);
%         tcSar(m,n)=rcs00+rcs01+rcs10+rcs11;
%         tcSar(m,n)=max([srcsar(x21,y20) srcsar(x20,y21) srcsar(x20,y20) srcsar(x21,y21)]);
        upm=ceil(m/ratio1);
        downm=floor(m/ratio1);
        leftn=floor(n/ratio1);
        rightn=ceil(n/ratio1);
        tcSar(upm,leftn)=0.5*srcsar(round(x2),round(y2))+tcSar(upm,leftn);
        tcSar(upm,rightn)=0.5*srcsar(round(x2),round(y2))+tcSar(upm,rightn);
        tcSar(downm,leftn)=0.5*srcsar(round(x2),round(y2))+tcSar(downm,leftn);
        tcSar(downm,rightn)=0.5*srcsar(round(x2),round(y2))+tcSar(downm,rightn);
    end
end

    
    