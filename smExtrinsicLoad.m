function [] = smExtrinsicLoad()
%Translation vector cam1: 
Tc_ext1 = [ 1154.033851 	 -1119.785546 	 9308.577514 ];
%Rotation matrix cam1:
Rc_ext1 = [ 0.070448 	 0.991565 	 -0.108793
                               0.613862 	 -0.129061 	 -0.778792
                               -0.786264 	 -0.011919 	 -0.617776 ];
%Translation vector cam2: 
Tc_ext2 = [ 1456.793863 	 -1194.131518 	 12381.184673 ];
%Rotation matrix cam2:    
Rc_ext2 = [ 0.274936 	 -0.961462 	 0.001289
                               -0.475228 	 -0.137059 	 -0.869122
                               0.835805 	 0.238340 	 -0.494596 ];
RY = [cos(pi/2) 0 -sin(pi/2);0 1 0;sin(pi/2) 0 cos(pi/2)];
RX1 = [1 0 0;0 cos(-pi/2) sin(-pi/2);0 -sin(-pi/2) cos(-pi/2)];
Rc_ext2 = Rc_ext2*RY;
Rc_ext2 = Rc_ext2*RX1;
%matriz de valores extrinsicos, matriz de proyeccion A
A = [Rc_ext1 Tc_ext1'];    
%centro optico de camara1
C1 = null(A);
%pseudo inversa de A
Aplus = A'*inv(A*A');
%matriz proyeccion B
B = [Rc_ext2 Tc_ext2'];
%pseudo inversa de B
Bplus = B'*inv(B*B');
% usamos el toolbox para calcular la matriz fundamental
Fc = Bmv_fundamental(A,B, 'tensor');
end