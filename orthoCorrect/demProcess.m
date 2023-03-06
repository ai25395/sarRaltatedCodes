%读入多幅，并合成为一幅
dem1 = imread("N56E159.tif");
dem2 = imread("N56E160.tif");
dem3 = imread("N56E161.tif");
dem4 = imread("N57E159.tif");
dem5 = imread("N57E160.tif");
dem6 = imread("N57E161.tif");
dem = [dem4 dem5 dem6;
       dem1 dem2 dem3];
[nr1,nc1]=size(dem);

dlat = 2/nr1;
dlong = 3/nc1;

corners = [ 57.469943 159.701936;
            57.258512 161.299746;
            56.400279 159.242805;
            56.192606 160.794345];
xys=[(58-corners(:,1))'/dlat;(corners(:,2)-159)'/dlong];
xymm=round([max(xys(1,:)) min(xys(1,:)) max(xys(2,:)) min(xys(2,:))]);
llmm=[max(corners(:,2)) min(corners(:,2)) max(corners(:,1)) min(corners(:,1))];
dem=dem(xymm(2):xymm(1),xymm(4):xymm(3));
nr2=xymm(1)-xymm(2)+1;
nc2=xymm(3)-xymm(4)+1;
xys(1,:)=xys(1,:)-min(xys(1,:))+1;
xys(2,:)=xys(2,:)-min(xys(2,:))+1;
demll=zeros(nr2,nc2,2);
for m=1:nr2
    for n=1:nc2
        demll(m,n,:)=[llmm(2)+n*dlong llmm(3)-m*dlat];
    end
end
demxyz0=zeros(nr2,nc2,3);

vec31=xys(:,1)-xys(:,3);
vec24=xys(:,4)-xys(:,2);
vec12=xys(:,2)-xys(:,1);
vec43=xys(:,3)-xys(:,4);

for m=1:nr2
    for n=1:nc2
        vec0=double([m;n]);
        vec10=vec0-xys(:,1);
        vec20=vec0-xys(:,2);
        vec30=vec0-xys(:,3);
        vec40=vec0-xys(:,4);
        if (vec30(1)*vec31(2)-vec30(2)*vec31(1))*(vec20(1)*vec24(2)-vec20(2)*vec24(1))>0 && (vec10(1)*vec12(2)-vec10(2)*vec12(1))*(vec40(1)*vec43(2)-vec40(2)*vec43(1))>0
            demxyz0(m,n,:)=longLat2xyz([demll(m,n,1) demll(m,n,2) double(dem(m,n))]);
        end
    end
end
clear dem1 dem2 dem3 dem4 dem5 dem6 dem demll;

% angle1 = atan((corners(1,1)-corners(2,1))/(corners(2,2)-corners(1,2)));
% angle2 = atan((corners(3,1)-corners(4,1))/(corners(4,2)-corners(3,2)));
% angle = (angle1+angle2)/2;
% demr = imrotate(dem,angle*180/pi,'bilinear');
% demlong = imrotate(demll(:,:,1),angle*180/pi,'bilinear');
% demlat = imrotate(demll(:,:,2),angle*180/pi,'bilinear');
% [nr2,nc2]=size(demr);
% xys=[(58-corners(:,1))'/dlat;(corners(:,2)-159)'/dlong];
% trotate = [cos(angle) -sin(angle);sin(angle) cos(angle)];
% t1axis = [cos(-pi/2) -sin(-pi/2);sin(-pi/2) cos(-pi/2)];
% t2axis = [cos(pi/2) -sin(pi/2);sin(pi/2) cos(pi/2)];
% td1 = repmat([-nc1/2;nr1/2],1,4);
% td2 = repmat([nc2/2;-nr2/2],1,4);
% txys = t2axis * (trotate * (t1axis*xys+td1) + td2);
% txys
% %dem = dem(int16(txys(1,1)):int16(txys(1,3)),int16(txys(2,1)):int16(txys(2,2)));
% nc3 = int16(max([txys(2,2)-txys(2,1)  txys(2,4)-txys(2,3)]));
% nr3 = int16(max([txys(1,3)-txys(1,1)  txys(1,4)-txys(1,2)]));
% demxyz0 = zeros(nr3,nc3,3);
% for m=1:nr3
%     start = txys(2,1)+(txys(2,3)-txys(2,1))/double(nr3)*(m-1);
%     xx = int16(txys(1,1)+m-1);
%     for n=1:nc3  
%         yy = int16(start+n-1);
%         demxyz0(m,n,:)=longLat2xyz([demlong(xx,yy),demlat(xx,yy),double(demr(xx,yy))]);
%     end
% end






    