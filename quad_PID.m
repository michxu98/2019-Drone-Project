% Wil Selby
% Washington, DC
% May 30, 2015

% This function implements a Proportional Integral Derivative Controller
% (PID) for the quadrotor. A high level controller outputs desired roll and
% pitch angles based on errors between the Global and desired X and Y
% positions. A lower level controller takes those inputs and controls the
% error between the deisred and actual Euler angles. After the control
% inputs are calculated, the desired motor speeds are calculated. See
% www.wilselby.com for derivations of these equations.

function quad_PID

global Quad

%% High Level Translational Controller

% TODO - Rotation function from GF to BF 

% X Position PD controller (simple yaw rotation matrix assuming other angles
%near 0)
Quad.X_des = Quad.X_des_GF*cos(Quad.psi) + Quad.Y_des_GF*sin(Quad.psi); %Convert Deisred position from GF to BF)

Quad.X_BF = Quad.X*cos(Quad.psi) + Quad.Y*sin(Quad.psi); %Convert position from GF to BF)
Quad.X_BF_dot = Quad.X_dot*cos(Quad.psi) + Quad.Y_dot*sin(Quad.psi); %Convert velocity from GF to BF)

cp = Quad.X_KP*(Quad.X_des - Quad.X_BF);    %Proportional term
cd = Quad.X_KD*Quad.X_BF_dot;                     %Derivative term

Quad.theta_des =   cp + cd;

if(abs(Quad.theta_des) > Quad.theta_max)
    Quad.theta_des = sign(Quad.theta_des)*Quad.theta_max;
end

% Y Position PD controller (simple yaw rotation matrix assuming other angles
%near 0)
Quad.Y_des = Quad.Y_des_GF*cos(Quad.psi) - Quad.X_des_GF*sin(Quad.psi); %Convert Deisred position from GF to BF)

Quad.Y_BF = Quad.Y*cos(Quad.psi) - Quad.X*sin(Quad.psi); %Convert position from GF to BF)
Quad.Y_BF_dot = Quad.Y_dot*cos(Quad.psi) - Quad.X_dot*sin(Quad.psi); %Convert velocity from GF to BF)

cp =  Quad.Y_KP*(Quad.Y_des - Quad.Y_BF);    %Proportional term
cd = Quad.Y_KD*Quad.Y_BF_dot;                      %Derivative term

Quad.phi_des = cp + cd; 

if(abs(Quad.phi_des) > Quad.phi_max)
    Quad.phi_des = sign(Quad.phi_des)*Quad.phi_max;
end

% Z Position PD Controller/Altitude Controller

cp = Quad.Z_KP*(Quad.Z_des_GF-Quad.Z);         %Proportional term
cd = Quad.Z_KD*Quad.Z_dot;                  %Derivative term%Quad.U1 = (cp + cd + Quad.m*Quad.g)/(cos(Quad.theta)*cos(Quad.phi));
Quad.U1 =  (cp + cd + Quad.m * Quad.g)/(cos(Quad.theta)*cos(Quad.phi));
Quad.U1_plot(Quad.counter) = Quad.U1; %(TODO record after motor limits applied?)

%% Low Level Attitude Controller

% TODO - use p,q,r instead of dot
% Roll PD Controller
cp = Quad.phi_KP*(Quad.phi_des - Quad.phi);
cd = Quad.phi_KD*Quad.p;
Quad.U2 = cp + cd;
% Quad.U2 = 0;

% Pitch PD Controller
cp = Quad.theta_KP*(Quad.theta_des - Quad.theta);
cd = Quad.theta_KD*Quad.q;
Quad.U3 = cp + cd;
% Quad.U3 = 0;
a =1 
% Roll PD Controller
cp = Quad.psi_KP*(Quad.psi_des - Quad.psi);
cd = Quad.psi_KD*Quad.r;
Quad.U4 = cp + cd;
% Quad.U4 = 0;

end
















