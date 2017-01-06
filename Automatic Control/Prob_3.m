%% Olivier Shi Libin
%% 3 Asservissement de vitesse d'un v¨¦hicule hybride
clear;
% On peut obtenir la fonction transfert
%                     110.772
% H(p) = ---------------------------------
%        7.226 p^2 + 144.65787 p + 74.7574

NUM = [0,0,110.772];
DEN = [7.226,144.65787,74.7574];
% On peut obtenir 4 matrices
[A,B,C,D] = tf2ss(NUM,DEN)

n_ctrl = rank(ctrb(A, B))
n_obsv = rank(obsv(A, C))
% On obtient n_ctrl = 2 et n_obsv = 2, donc ce syst¨¨me est commandable et observable.

% Concevoir une loi de commande permettant d'obtenir :
%  une erreur nulle en r¨¦gime permanent pour une consigne en ¨¦chelon,
%  un d¨¦passement maximal de 4.32%,
%  un temps de r¨¦ponse de 4.4 seconds.
% D'apr¨¨s le figure, on a
ksi = 0.7;
omega0 = 2.8/4.4;
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