i=0; 
nx = 21; 
thick = 0.05; 
tmax = 4000; 
for nt = 41:20:1001;
    i=i+1; 
    dt(i) = tmax/(nt-1);
    disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s']) 
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'forward', false); 
    uf(i) = u(end, 1); 
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'dufort-frankel', false); 
    ud(i) = u(end, 1);
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'backward', false); 
    ub(i) = u(end, 1);
    [~, ~, u] = shuttle(tmax, nt, thick, nx, 'crank-nick', false); 
    uc(i) = u(end, 1);
end
plot(dt, [uf; ud; ub; uc])
ylim([100 200])
xlim([4 100])
legend ('Forward', 'Dufort Frankel', 'Backward', 'Crank Nickelson')