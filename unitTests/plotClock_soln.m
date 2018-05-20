function plotClock_soln(time)
[hour, min] = strtok(time, ':');
hour = str2double(hour);
min = str2double(min(2:end));
th = linspace(0, 360);
xcirc = sind(th);
ycirc = cosd(th);
figure
plot(xcirc, ycirc, 'k');
axis equal
axis off
hold on
plot(0, 0, 'ko');
hr_deg = 360 / 12;
min_deg = 360 / 60;
tick = [0, 0; 1, .8];
for i = 1:12
    plot(tick(1, :), tick(2, :), 'k');
    tick = rot(tick, hr_deg);
end
hr_hand = rot([0, 0; 0, .5], hr_deg * hour);
min_hand = rot([0, 0; 0, .7], min_deg * min);
plot(min_hand(1, :), min_hand(2, :), 'r');
plot(hr_hand(1, :), hr_hand(2, :), 'b');
end

function pts = rot(pts, th)
rot_mat = [cosd(th), sind(th); ...
           -sind(th),  cosd(th)];
pts = rot_mat * pts;
end