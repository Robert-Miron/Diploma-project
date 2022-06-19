clear;
clc;
close all;
r=6371000;%radius of the Earth in meters
eye_elev=958-534;

%For better visualizaton of the algorithm I used simplified coordinates,
%that are easier to display. However, the algorithm works with the actual
%coordinates and cand be tested by un-commenting the following lines:
%Definition of the runway and the point of view
% pov=[45.693567 25.513848 eye_elev];
% pov=[rho*sind(90-pov_sph(1))*cosd(pov_sph(2)) rho*sind(90-pov_sph(1))*sind(pov_sph(2)) rho*cosd(90-pov_sph(1))];
% coords_sph=[
%         45.6961304903615,25.512585809795,0;
%         45.69589421802449,25.5130535549274,0;
%         45.7163406468641,25.5344942154015,0;
%         45.716682, 25.533974,0;];
% %Conversion of the coordinates from spherical to cartesian
% coords=zeros(size(coords_sph,1),3);
% for i=1:size(coords_sph,1)
%     rho=r+coords_sph(i,3);
%     coords(i,1)=rho*sind(90-coords_sph(i,1))*cosd(coords_sph(i,2));
%     coords(i,2)=rho*sind(90-coords_sph(i,1))*sind(coords_sph(i,2));
%     coords(i,3)=rho*cosd(90-coords_sph(i,1));
% end

pov=[15 1 11];%coordinates of the p.o.v.
coords=[1 3 0;%coordinates of the runway's corners
    1 2 0;
    21 2 0;
    21 3 0];
thr=zeros(2,3);%coordinates of the threshold
thr(1,:)=(coords(1,:)+coords(2,:))./2;
thr(2,:)=(coords(3,:)+coords(4,:))./2;
centre=(thr(1,:)+thr(2,:))./2; %coordinates of the center of the runway
%Definition of the line from P.o.v. to the cetre of the runway
t=0:0.1:1;
a_vector = [centre(1)-pov(1) centre(2)-pov(2) centre(3)-pov(3)]; %governing vector for the optical axis
a=zeros(size(t,2),3);
a(:,1)=pov(1)+a_vector(1).*t;
a(:,2)=pov(2)+a_vector(2).*t;
a(:,3)=pov(3)+a_vector(3).*t;
%Definition of the lines from P.o.v. to each corner of the runway
d=zeros(size(t,2),3,size(coords,1));
for i=1:(size(coords,1))
    d(:,1,i)=pov(1)+(coords(i,1)-pov(1)).*t;
    d(:,2,i)=pov(2)+(coords(i,2)-pov(2)).*t;
    d(:,3,i)=pov(3)+(coords(i,3)-pov(3)).*t;
end

%Plotting the runway, p.o.v. and the lines connecting the corners
figure;
axis([0 25 0 4 0 15]);
hold on;
x0_vector = [1,0,0];
y0_vector = [0,1,0];
z0_vector = [0,0,1];
x0=[linspace(0,25,50) zeros(1, 50) zeros(1, 50)];
y0=[zeros(1, 50) linspace(0,25,50) zeros(1, 50)];
z0=[zeros(1, 50) zeros(1, 50) linspace(0,25,50)];
plot3(x0,y0,z0,'k-.');

plot3([coords(1,1),coords(2,1)],[coords(1,2),coords(2,2)],[coords(1,3),coords(2,3)],'k',...
    [coords(2,1),coords(3,1)],[coords(2,2),coords(3,2)],[coords(2,3),coords(3,3)],'k',...
    [coords(3,1),coords(4,1)],[coords(3,2),coords(4,2)],[coords(3,3),coords(4,3)],'k',...
    [coords(4,1),coords(1,1)],[coords(4,2),coords(1,2)],[coords(4,3),coords(1,3)],'k');

plot3(pov(1),pov(2),pov(3),'r*');

for i=1:size(d,3)
    plot3(d(:,1,i),d(:,2,i),d(:,3,i));
end
plot3(a(:,1),a(:,2),a(:,3));

P=centre-pov; %Normal vector to the projection plane
o=(pov+centre)./2; %Origin point of the projection plane
plot3(o(1),o(2),o(3),'m*')
to=[]; %t that satisfies both the equations of the lines and the one of the projection plane
for i=1:4
    to=[to; -(P(1)*(coords(i,1)-o(1))+P(2)*(coords(i,2)-o(2))+P(3)*(coords(i,3)-o(3)))/(P(1)*(coords(i,1)-pov(1))+P(2)*(coords(i,2)-pov(2))+P(3)*(coords(i,3)-pov(3)))];
end

x=[];
y=[];
z=[];
for i=1:4
    x=[x;coords(i,1)+(coords(i,1)-pov(1))*to(i)];
    y=[y;coords(i,2)+(coords(i,2)-pov(2))*to(i)];
    z=[z;coords(i,3)+(coords(i,3)-pov(3))*to(i)];
    plot3(x(i),y(i),z(i),'k*');
end
coords_p = [x y z]; %coordinates of the projected points wrt to the center of the Earth

p1 = [(x(1)+x(2))/2 (y(1)+y(2))/2 (z(1)+z(2))/2]; %middle point between projected point 1 and 2
plot3(p1(1),p1(2), p1(3), 'k*');
x1_vector = [p1(1) - o(1) p1(2) - o(2) p1(3) - o(3)]; %governing vector of the x' axis
x1 = []; %the x axis of the projected plane
x1(:,1) = o(1)+x1_vector(1).*t;
x1(:,2) = o(2)+x1_vector(2).*t;
x1(:,3) = o(3)+x1_vector(3).*t;
plot3(x1(:,1), x1(:,2), x1(:,3), 'm-.');

y1_vector = cross(a_vector,x1_vector); %governing vector of the y' axis
y1(:,1) = o(1)+y1_vector(1).*t;
y1(:,2) = o(2)+y1_vector(2).*t;
y1(:,3) = o(3)+y1_vector(3).*t;
plot3(y1(:,1), y1(:,2), y1(:,3), 'm-.');

%calculations for theta angle
cos_theta = abs(x0_vector(1)*x1_vector(1)+x0_vector(2)*x1_vector(2)+x0_vector(3)*x1_vector(3))/(sqrt(x0_vector(1)*x0_vector(1)+x0_vector(2)*x0_vector(2)+x0_vector(3)*x0_vector(3))*sqrt(x1_vector(1)*x1_vector(1)+x1_vector(2)*x1_vector(2)+x1_vector(3)*x1_vector(3)));
sin_theta = sqrt(1-cos_theta*cos_theta);
theta = asind(sin_theta);

%calculations for phi angle
cos_phi = abs(y0_vector(1)*y1_vector(1)+y0_vector(2)*y1_vector(2)+y0_vector(3)*y1_vector(3))/(sqrt(y0_vector(1)*y0_vector(1)+y0_vector(2)*y0_vector(2)+y0_vector(3)*y0_vector(3))*sqrt(y1_vector(1)*y1_vector(1)+y1_vector(2)*y1_vector(2)+y1_vector(3)*y1_vector(3)));
sin_phi = sqrt(1-cos_phi*cos_phi);
phi = asind(sin_phi);

%calculations for psi angle
cos_psi = abs(z0_vector(1)*a_vector(1)+z0_vector(2)*a_vector(2)+z0_vector(3)*a_vector(3))/(sqrt(z0_vector(1)*z0_vector(1)+z0_vector(2)*z0_vector(2)+z0_vector(3)*z0_vector(3))*sqrt(a_vector(1)*a_vector(1)+a_vector(2)*a_vector(2)+a_vector(3)*a_vector(3)));
sin_psi = sqrt(1-cos_psi*cos_psi);
psi = asind(sin_psi);

%calculating the rotation matrix
R_s_g = [cos_theta*cos_psi cos_theta*sin_psi -sin_theta;
         cos_psi*sin_theta*sin_phi-sin_psi*cos_phi sin_psi*sin_theta*sin_phi+cos_psi*cos_phi cos_theta*sin_phi;
         cos_psi*sin_theta*cos_phi+sin_psi*sin_phi sin_psi*sin_theta*cos_phi-cos_psi*sin_phi cos_theta*cos_phi];
R_s_g = R_s_g';

new_coords=[]; %the coordinates of the points in the projection plane wrt to the origin
for i=1:4
    v = o-coords_p(i,:);
    dist_y = cross(v,x1_vector);
    dist_x = cross(v,y1_vector);
    new_coords = [new_coords; norm(dist_x)/norm(y1_vector) norm(dist_y)/norm(x1_vector) z(i)];
end
legend('Earth system of coordinates','Runway contour','Runway contour','Runway contour','Runway contour','Point of observation','Line 1', 'Line 2', 'Line 3', 'Line 4', 'Optic axis','Projection plane origin point', 'Point of intersection 1','Point of intersection 2','Point of intersection 3','Point of intersection 4','Middle point between projected point 1 and 2','The x axis of the projected plane','The y axis of the projected plane');

