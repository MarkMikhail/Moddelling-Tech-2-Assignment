function [x t u] = shuttle(tmax, nt, xmax, nx, method, pos, doplot)
% Function for modelling temperature in a space shuttle tile
% D N Johnston  11/2/16
%
% Input arguments:
% tmax   - maximum time
% nt     - number of timesteps
% xmax   - total thickness
% nx     - number of spatial steps
% method - solution method ('forward', 'backward' etc)
% doplot - true to plot graph; false to suppress graph.
%
% Return arguments:
% x      - distance vector
% t      - time vector
% u      - temperature matrix
%
% For example, to perform a  simulation with 501 time steps
%   [x, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', true);
%

% Set tile properties
thermcon = 0.142; % W/(m K)
density = 352; % 22 lb/ft^3
specheat = 1256; % 0.3 Btu/lb/F at 500F
alpha = thermcon /(density * specheat);


% Some crude data to get you started:
timedata = [0  60 250 500  1000 1250 1500 1750 2000 4000];
tempdata = [60 60 800 1500 1400 1000 830  0    60   60];

% Better to load surface temperature data from file.
% (you need to have modified and run plottemp.m to create the file first.)
% Uncomment the following line.
load([pos '.mat'])
%load('temp502.mat')

% Initialise everything.
dt = tmax / (nt-1);
t = (0:nt-1)*dt;
dx = xmax/(nx-1);
x = (0:nx-1)*dx;
u = zeros(nt, nx);

p = alpha * dt / dx^2;

% Vector of indices for internal points
ivec = 2:nx-1;

% set initial conditions to 60F throughout.
% Do this for first two timesteps.
u([1 2], :) = (60-32)*5/9;

% Main timestepping loop.
for n = 2:nt - 1
    
    % LHS boundary condition: inner surface (Neumann Boundary)
    L = (1 - 2*p)*u(n,1) + 2*p*u(n,2);
    
    % RHS boundary condition: outer surface
    R = surftemp(t(n+1), timedata, tempdata);
    
    % Select method.
    switch method
        case 'forward'
            % LHS Dirichlet boundary condition; need to change this.
            u(n+1, 1) = L;
            % Internal points
            u(n+1, ivec) = (1 - 2 * p) * u(n, ivec) + ...
                p * (u(n, ivec-1) + u(n, ivec+1));
            % RHS Dirichlet boundary condition
            u(n+1, nx) = R;
            
        case 'dufort-frankel'
            % LHS Dirichlet boundary condition; need to change this.
            u(n+1, 1) = L;
            % Internal points
            u(n+1, ivec) = ((1 - 2 * p) * u(n-1, ivec) + ...
                2*p * (u(n, ivec-1) + u(n, ivec+1)))/(1+2*p);
            % RHS Dirichlet boundary condition
            u(n+1, nx) = R;
            
        case 'backward'
            b(1)      = 1 + 2*p;
            c(1)      = -2*p;
            d(1)      = u(n,1);
            a(2:nx-1) = -p;
            b(2:nx-1) = 1 + 2*p;
            c(2:nx-1) = -p;
            d(2:nx-1) = u(n, 2:nx-1);
            a(nx)     = 0;
            b(nx)     = 1;
            d(nx)     = R;
    
            u(n+1,:) = tdm(a,b,c,d);
            
        case 'crank-nick'
            b(1)      = 1+p;
            c(1)      = -p;
            d(1)      = (1-p)*u(n,1) + p*u(n,2);
            a(2:nx-1) = -p/2;
            b(2:nx-1) = 1 + p;
            c(2:nx-1) = -p/2;
            d(2:nx-1) = (p/2)*u(n, 1:nx-2)  + ...
                (1-p)*u(n, 2:nx-1)          + ...
                (p/2)*u(n, 3:nx);
            a(nx)     = 0;
            b(nx)     = 1;
            d(nx)     = R;
    
            u(n+1,:) = tdm(a,b,c,d);

        otherwise
            error (['Undefined method: ' method])
            return
    end
end

if doplot
    % Surface plot - you need to add labels etc.
    figure (1)
    surf(x, t, u);
    xlabel('Thickness')
    ylabel('Time')
    zlabel('Temperature')
    shading interp
end
% End of shuttle function

% =========================================================================
function temp = surftemp(t, timedata, tempdata)
% Do linear interpolation
temp = interp1(timedata, tempdata, t, 'linear', 'extrap');

% Convert to degrees C
%temp = (tempf - 32) * 5 / 9;

% =========================================================================
% Tri-diagonal matrix solution 
function x = tdm(a,b,c,d)
n = length(d);

% Eliminate a terms
for i = 2:n
    factor = a(i) / b(i-1);
    b(i) = b(i) - factor * c(i-1);
    d(i) = d(i) - factor * d(i-1);
end

x(n) = d(n) / b(n);

% Loop backwards to find other x values by back-substitution
for i = n-1:-1:1
    x(i) = (d(i) - c(i) * x(i+1)) / b(i);
end
% =========================================================================

    