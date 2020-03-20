


clear
clc

winstyle = 'docked'; % window styles to have to set 
%winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle) % creates the window style for the plots
set(0,'defaultaxesfontsize',18)% chooses font size 
set(0,'defaultaxesfontname','Times New Roman') % chooses font
%set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
% setting all of the global variables between all code 
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1; 

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);     % finding the characteristic impedance of the material (Vacuum) 


tSim = 200e-15 % simulation length
f = 230e12; % frequency of propagation 
lambda = c_c/f; % wavelength of beam

xMax{1} = 20e-6; % x length for simulation window in metres
nx{1} = 200; % sets the number of cells in x direction 
ny{1} = 0.75*nx{1}; % sets number of cells in the y direction 


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0; % creates a matrix grid specified by nx and ny which all has a value of mu0

epi{1} = ones(nx{1},ny{1})*c_eps_0; % creates epsilon value of all space with vacuum value 
er = 11.3;
epi{1}(125:150,55:95)= c_eps_0*er; % chnages a small section of the simulation space to have different epsilon value 

% More Inclusions!!!
%epi{1}(125:150,5:45)= c_eps_0*er;
%epi{1}(125:150,105:145)= c_eps_0*er;

%epi{1}(100:125,55:95)= c_eps_0*er;
%epi{1}(170:195,55:95)= c_eps_0*er;

sigma{1} = zeros(nx{1},ny{1}); 
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/(1*nx{1});  % sets the size of each square 
dt = 0.25*dx/c_c; % creates time steps for the simulaiton to iterate over
nSteps = round(tSim/dt*2); % getting a whole number to move through the simulation 
yMax = ny{1}*dx; % sets the yMax
nsteps_lamda = lambda/dx 

movie = 1; % sets whether its played as a movie or not 
Plot.off = 0; % sets if it gets plotted or not 
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100; 
Plot.MaxEz = 1.1; % sets maximum height of Ez
Plot.MaxH = Plot.MaxEz/c_eta_0; % sets maximum height of H
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax]; % chooses the 


bc{1}.NumS = 2;
bc{1}.s(1).xpos = nx{1}/(8) + 1;
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC;

bc{1}.s(2).xpos = nx{1}/(2) + 1;
bc{1}.s(2).type = 'ss';
bc{1}.s(2).fct = @PlaneWaveBC;

% mag = -1/c_eta_0;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
st = -0.05;%15e-15;
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};

Plot.y0 = round(y0/dx);

bc{1}.xm.type = 'a'; % sets the lower x boundary condition
bc{1}.xp.type = 'a'; % sets the upper x boundary condition
bc{1}.ym.type = 'a'; % sets the lower y boundary condition
bc{1}.yp.type = 'a'; % sets the upper y boundary condition

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






