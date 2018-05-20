function test1
rng(10);
x = randi(50, 1, 100) + .03;
y = sqrt(x) .* randi(10, 1, 100);
plot(x, y, 'b');
end