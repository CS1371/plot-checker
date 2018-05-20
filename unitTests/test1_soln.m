function test1_soln
rng(10);
x = randi(50, 1, 100);
y = sqrt(x) .* randi(10, 1, 100);
plot(x, y, 'm');
end