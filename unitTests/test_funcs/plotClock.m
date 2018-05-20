function plotClock(time)
[hours,rest] = strtok(time,':');
hours = str2num(hours);
minutes = str2num(rest(2:end));
radius = 1;
circleth = linspace(0,360);
figure
hold on
plot(radius.*cosd(circleth + 90),radius.*sind(circleth+90),'b-');
xtick = [0,0];
ytick = [0.8.*radius,radius];
beforerotate = [xtick;ytick];
plot(xtick,ytick,'k-');
th = 30;
for i = 1:12
    tickth = i * th;
    rotmat = [cosd(tickth),sind(tickth);-sind(tickth),cosd(tickth)];
    rotated = rotmat * beforerotate;
    plot(rotated(1,:),rotated(2,:),'k-')
end
hourtickx = [0 0];
hourticky = [0 0.5*radius];
hourtick = [hourtickx;hourticky];
hourrotmat = [cosd(30 * hours),sind(30 * hours);-sind(30 * hours),cosd(30 * hours)];
hourrotate = hourrotmat * hourtick;
plot(hourrotate(1,:),hourrotate(2,:),'b-');
mintickx = [0 0];
minticky = [0 0.7*radius];
mintick = [mintickx;minticky];
minrotmat = [cosd(6 * minutes),sind(6 * minutes);-sind(6 * minutes),cosd(6 * minutes)];
minrotate = minrotmat * mintick;
plot(minrotate(1,:),minrotate(2,:),'r-');
plot(0, 0, 'ko');
title('Text');
axis equal
end