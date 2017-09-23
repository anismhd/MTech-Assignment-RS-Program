function response_x_v_a = newmarks(n,f,x,damping,natural,x0,v0)
% n - Type of accelaration interpolating, '0' for linear accelaration, '1'
% average accelaration
% f - forcing value
% x - fime series
% response_x_v_a = first column represent relative displacement,2
% velocity,3 accelaration
[m,p] = size(x);
if p~=1
    exit;
end
response_x_v_a = zeros(m,3);
response_x_v_a(1,1) = x0;
response_x_v_a(1,2) = v0;
response_x_v_a(1,3) = -f(1,1)-natural^2*x0-2*damping*natural*v0;
switch n
    case 0
        gamma = 0.5;
        beta = 1/6;
    case 1
        gamma = 0.5;
        beta = 0.25;
    otherwise
        display('This program can''t handle this problem');
end
for i=1:m-1
    deltaT = x(i+1,1)-x(i,1);
    k = (natural*natural)+(gamma*2*damping*natural/(beta*deltaT))+(1/(beta*deltaT^2));
    a = (1/(beta*deltaT))+(gamma*2*damping*natural/beta);
    b = (0.5/beta)+(deltaT*2*damping*natural)*((0.5*gamma/beta)-1);
    deltaF = f(i+1,1)-f(i,1)+a*response_x_v_a(i,2)+b*response_x_v_a(i,3);
    deltaX = deltaF/k;
    deltaV = (gamma*deltaX/(beta*deltaT))-(gamma*response_x_v_a(i,2)/beta)+(deltaT*response_x_v_a(i,3))*(1-(0.5*gamma/beta));
    deltaA = (deltaX/(beta*deltaT^2))-(response_x_v_a(i,2)/(beta*deltaT))-(0.5*response_x_v_a(i,3)/beta);
    response_x_v_a(i+1,1) = response_x_v_a(i,1)+deltaX;
    response_x_v_a(i+1,2) = response_x_v_a(i,2)+deltaV;
    response_x_v_a(i+1,3) = response_x_v_a(i,3)+deltaA;
end
end