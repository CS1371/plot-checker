function multipleSubplots_soln

subplot(2, 2, 1);
plot(1:120, 1:120, 'k--');
subplot(2, 2, 2);
plot(2:2:100, 2:2:100, 'b*');
subplot(2, 2, 3);
plot(100:-5:5, 100:-5:5, 'k');
subplot(2, 2, 4);
plot(1:100, 100:-1:1, 'r');
end