% Wil Selby
% Washington, DC
% May 30, 2015

% This function defines the quadrotor model. Parameters are saved in a .mat
% file to be loaded during the simulation initialization phase. Verify that
% the Quad.plot_arm, Quad.plot_arm_t, and Quad.plot_prop match related 
% values in  quad_variables.m. In this script, the variables are for 
% plotting purposes only and do not impact the dynamics.
function Quad = define_quad_model
global Quad

%% Define the Initial Coordinates of the Arms and Rotors

Quad.plot_arm = .3;     % Distance from the center of mass to the each motor (m)
Quad.plot_arm_t = .02;   %Thickness of the quadrotor's arms for drawing purposes (m)
Quad.plot_prop = .1;   %Radius of the propellor (m)

% Vertex Values for Y axis arm (m). Measurements from a 3DR kit
x1=-Quad.plot_arm;
x2=Quad.plot_arm;
y1=-Quad.plot_arm_t;
y2=Quad.plot_arm_t;
z1=-Quad.plot_arm_t;
z2=Quad.plot_arm_t;

[v1_x, v1_y] = rotate_transpose(x1,y1,pi/4);
[v2_x, v2_y] = rotate_transpose(x2,y1,pi/4);
[v3_x, v3_y] = rotate_transpose(x2,y2,pi/4);
[v4_x, v4_y] = rotate_transpose(x1,y2,pi/4);

% Vertex locations
vertex_matrix=[v1_x v1_y z1; 
   v2_x v2_y z1;
   v3_x v3_y z1;
   v4_x v4_y z1;
   v1_x v1_y z2;
   v2_x v2_y z2;
   v3_x v3_y z2;
   v4_x v4_y z2];

% Faces Matrix, entries refer to vertices in each face
face_matrix=[1 2 6 5;              
     2 3 7 6;
     3 4 8 7;
     4 1 5 8;
     1 2 3 4;
     5 6 7 8];

 
 X_arm=patch('faces',face_matrix,...
     'vertices',vertex_matrix,...
     'facecolor','b',...
     'edgecolor',[0 0 0],'facecolor','w','FaceAlpha',.3,'LineStyle','none');

% Vertex Values for X axis arm (m). Measurements from a 3DR kit
y1=-Quad.plot_arm;
y2=Quad.plot_arm;
x1=-Quad.plot_arm_t;
x2=Quad.plot_arm_t;
z1=-Quad.plot_arm_t;
z2=Quad.plot_arm_t;

[v1_x, v1_y] = rotate_transpose(x1,y1,pi/4);
[v2_x, v2_y] = rotate_transpose(x2,y1,pi/4);
[v3_x, v3_y] = rotate_transpose(x2,y2,pi/4);
[v4_x, v4_y] = rotate_transpose(x1,y2,pi/4);

vertex_matrix=[v1_x v1_y z1; 
   v2_x v2_y z1;
   v3_x v3_y z1;
   v4_x v4_y z1;
   v1_x v1_y z2;
   v2_x v2_y z2;
   v3_x v3_y z2;
   v4_x v4_y z2];

Y_arm=patch('faces',face_matrix,...
     'vertices',vertex_matrix,...
     'facecolor','b',...
     'edgecolor',[0 0 0],'facecolor','w','FaceAlpha',.3,'LineStyle','none');
 
 % Draw the Rotor area
 t=0:pi/10:2*pi;    %rotor circumfrence points
 X=Quad.plot_prop*cos(t);      
 Y=Quad.plot_prop*sin(t); 
 Z=zeros(size(t))+Quad.plot_arm_t;
 C=zeros(size(t));
 Quad.C = C;

 Motor1 = patch(X+Quad.plot_arm*sin(pi/4),Y+Quad.plot_arm*sin(pi/4),Z,C,'facealpha',.3,'facecolor','w','LineStyle','none'); %(Motor 1)
 Motor2 = patch(X+Quad.plot_arm*sin(pi/4),Y-Quad.plot_arm*sin(pi/4),Z,C,'facealpha',.3,'facecolor','w','LineStyle','none'); %(Motor 2)
 Motor3 = patch(X-Quad.plot_arm*sin(pi/4),Y-Quad.plot_arm*sin(pi/4),Z,C,'facealpha',.3,'facecolor','w','LineStyle','none'); %(Motor 3)
 Motor4 = patch(X-Quad.plot_arm*sin(pi/4),Y+Quad.plot_arm*sin(pi/4),Z,C,'facealpha',.3,'facecolor','w','LineStyle','none'); %(Motor 4)
 
 %Coordinates of each face in each axis (4 coordinates x 6 faces)
 Quad.X_armX = get(X_arm,'xdata');
 Quad.X_armY = get(X_arm,'ydata');
 Quad.X_armZ = get(X_arm,'zdata');
 
 Quad.Y_armX = get(Y_arm,'xdata');
 Quad.Y_armY = get(Y_arm,'ydata');
 Quad.Y_armZ = get(Y_arm,'zdata');
  
 %Coordinates of each rotor in each axis (21 coordinates x 1 face)
 Quad.Motor1X = get(Motor1,'xdata');
 Quad.Motor1Y = get(Motor1,'ydata');
 Quad.Motor1Z = get(Motor1,'zdata');

 Quad.Motor2X = get(Motor2,'xdata');
 Quad.Motor2Y = get(Motor2,'ydata');
 Quad.Motor2Z = get(Motor2,'zdata');
 
 Quad.Motor3X = get(Motor3,'xdata');
 Quad.Motor3Y = get(Motor3,'ydata');
 Quad.Motor3Z = get(Motor3,'zdata');
 
 Quad.Motor4X = get(Motor4,'xdata');
 Quad.Motor4Y = get(Motor4,'ydata');
 Quad.Motor4Z = get(Motor4,'zdata'); 
 
end

 % Rotation Matrix
function [x_r,y_r] = rotate_transpose(x, y, theta_rotation)
    rotation_matrix = [cos(theta_rotation) -sin(theta_rotation) ; sin(theta_rotation) cos(theta_rotation)];
    rotated = rotation_matrix * [x ; y];
    transposed = transpose(rotated);
    x_r = transposed(1);
    y_r = transposed(2);
end
