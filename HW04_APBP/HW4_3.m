clearvars; clc; close all;

syms phi theta psi x y z a b c;

R1 = [cos(phi) -sin(phi) 0;
      sin(phi) cos(phi) 0;
      0 0 1];

R2 = [cos(theta) 0 sin(theta);
      0 1 0;
      -sin(theta) 0 cos(theta)];

R3 = [1 0 0;
      0 cos(psi) -sin(psi);
      0 sin(psi) cos(psi)];

R = R1 * R2 * R3;

d = [x; y; z];

H = vertcat(horzcat(R, d), [0 0 0 1]);
a = [a; b; c; 1];

b = H*a;
b = b(1:3);


J = jacobian(b, [x, y, z, phi, theta, psi]);

% J