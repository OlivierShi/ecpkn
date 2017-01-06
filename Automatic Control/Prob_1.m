%% Olivier Shi Libin
%% 1 Asservissement de position d'un missile guid¨¦

A = [   0,    1,  0, 0, 0;
     -0.1, -0.5,  0, 0, 0;
      0.5,    0,  0, 0, 0;
        0,    0, 10, 0, 0;
      0.5,    1,  0, 0, 0]
B = [0;1;0;0;0]
C = [0,0,0,1,0]
D = 0

%% Q1
n = rank(ctrb(A, B))
% On peut obtenir n = 4 < 5, donc ce syst¨¨me n'est pas commandable.
sys = ss(A,B,C,D)

%% Q2
Fonc_tf = tf(sys)
% Donc c'est un syst¨¨me instable.
% C'est ¨¤ dire la fonction de transfert du syst¨¨me initial est
[NUM,DON] = ss2tf(A,B,C,D)

%% Q3
nouv_sys = ss(Fonc_tf)
A2 = nouv_sys.a
B2 = nouv_sys.b
C2 = nouv_sys.c
D2 = nouv_sys.d

%% Q4
% commadabilit¨¦
n_ctrl = rank(ctrb(A2,B2));
% observabilit¨¦
n_obsv = rank(obsv(A2,C2));
% On a n_ctrl = 4 et n_obsv = 4. Donc c'est commandable et observable.

%% Q5
% Concevoir une loi de commande permettant d'obtenir :
%  une erreur nulle en r¨¦gime permanent pour une consigne en ¨¦chelon,
%  un d¨¦passement maximal de 10%,
%  un temps de r¨¦ponse de 10 seconds.
% D'apr¨¨s le figure, on a
ksi = 0.6;
omega0 = 0.52;
% Donc on peut calculer les poles
p1 = -ksi*omega0 + omega0*sqrt(ksi^2 - 1);
p2 = -ksi*omega0 - omega0*sqrt(ksi^2 - 1);
% On suppose
p3 = -100*ksi*omega0;
p4 = -200*ksi*omega0;
% Alors,
P = [p1;p2;p3;p4];
% On peut calculer F et G
F = place(A2, B2, P)
G = 1./(C2*inv(-A2+B2*F)*B2)
% Observateur
L = place(A2', C2', [-500, -1000, -1500, -2000]);
L = L'