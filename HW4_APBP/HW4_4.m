clearvars; clc;

syms d theta_1 theta_2;

A1 = [1, 0, 0, 0;
      0, 1, 0, 0;
      0, 0, 1, d;
      0, 0, 0, 1];
 
R_z_2 = [cos(theta_1), -sin(theta_1), 0, 0;
          sin(theta_1), cos(theta_1), 0, 0;
                0, 0, 1, 0;
                0, 0, 0, 1];
T_a_2 = [1, 0, 0, 3;
    0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1];
A2 = R_z_2 * T_a_2;

R_z_3 = [cos(theta_2), -sin(theta_2), 0, 0;
          sin(theta_2), cos(theta_2), 0, 0;
                0, 0, 1, 0;
                0, 0, 0, 1];
T_a_3 = [1, 0, 0, 1;
    0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1];
A3 = R_z_3 * T_a_3;

T1 = A1*[0; 0; 0; 1];
T2 = A1*A2*[0; 0; 0; 1];
T3 = A1*A2*A3*[0; 0; 0; 1];

T1 = T1(1:3);
T2 = T2(1:3);
T3 = T3(1:3);

J1 = jacobian(T1, [d, theta_1, theta_2])
J2 = jacobian(T2, [d, theta_1, theta_2])
J3 = jacobian(T3, [d, theta_1, theta_2])

syms x y z;

v = [x; y; z];

J1*v
J2*v
J3*v