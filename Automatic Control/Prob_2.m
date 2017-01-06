%% Olivier Shi Libin
%% 2 Asservissement d'un pendule invers¨¦
clear;
M = 8.085; % kg
m = 0.825; % kg
l = 0.098; % m
g = 9.8;   % kg.m/s^2

% On supprime x(t), et on peut obtenir
% M*g*theta - (M-m)*l*(theta)'' - u(t) = 0
% On suppose x = [theta(t);theta(t)']
% On peut ¨¦crire 4 matrices
A = [            0, 1;
     M*g/((M-m)*l), 0]
B = [0;1/((M-m)*l)]
C = [1,0]
D = 0

n_ctrl = rank(ctrb(A, B));
n_obsv = rank(obsv(A, C));
% On obtient n_ctrl = 2 et n_obsv = 2, donc ce syst¨¨me est commandable et observable.

% Concevoir une loi de commande permettant d'obtenir :
%  une erreur nulle en r¨¦gime permanent pour une consigne en ¨¦chelon,
%  un d¨¦passement maximal de 10%,
%  un temps de r¨¦ponse de 1 seconds.
% D'apr¨¨s le figure, on a
ksi = 0.6;
omega0 = 5.2;
% Donc on peut calculer les poles
p1 = -ksi*omega0 + omega0*sqrt(ksi^2 - 1);
p2 = -ksi*omega0 - omega0*sqrt(ksi^2 - 1);
P = [p1;p2]
% On peut calculer F et G
F = place(A, B, P)
G = 1./(C*inv(-A+B*F)*B)
% Observateur
L = place(A', C', [-500, -1000]);
L = L'