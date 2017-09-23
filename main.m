clear all
close all
file = fopen('data.txt');
data = textscan(file,'%f %f');
fclose(file);
t = data{1,1};
f = data{1,2};
[m,n] = size(f);
figure1 = figure;
plot(t,f,'LineWidth',0.1);
grid on;
grid minor;
title('Given Accelaration Data');
xlabel('time(s)');
ylabel('accelaration (m/s/s)');
name1 = strcat(date,'_give_earthquake_data');
saveas(figure1,name1,'pdf');
%Material data for problem 1
material = [0,0.5;0,1;0,2;0.02,0.5;0.02,1;0.02,2;0.05,0.5;0.05,1;0.05,2];
% End of material data input

% 60 second conversion , this is an adjustment - should be corrected later
timeStep = t(2,1)-t(1,1);
q = 60/timeStep+1;
t = 0:timeStep:60;
t = t';
f = [f;zeros(q-m,1)];
[m,n] = size(f);
% End

% Initial Conditions
x0 = 0;
v0 = 0;
response = zeros(q,27);
for i=1:9
    response(:,3*i-2:3*i) = newmarks(1,-9.81*f,t,material(i,1),(2*pi()/material(i,2)),x0,v0);
    response(:,3*i) = response(q,3*i)+9.81*f;
    figure2 = figure;
    subplot(3,1,1)
    titleDisp = strcat('Relative displacement SDF of damping = ',num2str(material(i,1)),' Natural Period = ',num2str(material(i,2)),'s'); 
    titleVel = strcat('Relative velocity SDF of damping = ',num2str(material(i,1)),' Natural Period = ',num2str(material(i,2)),'s');
    titleAcc = strcat('Absolute accelaration of damping = ',num2str(material(i,1)),' Natural Period = ',num2str(material(i,2)),'s');
    plot(t,response(:,3*(i-1)+1),'LineWidth',0.1);
    
    temp1 = abs(response(:,3*(i-1)+1));
    [l,z] = max(temp1);
    qq = response(z,3*(i-1)+1);
    xx = (z-1)*timeStep;
    strmax = num2str(qq);
    text(xx,qq,strmax,'BackgroundColor',[.7 .9 .7],'HorizontalAlignment','left','VerticalAlignment','top');
    
    grid on;
    grid minor;
    title(titleDisp);
    xlabel('time(s)');
    ylabel('displacement(m)');
    subplot(3,1,2);
    plot(t,response(:,3*(i-1)+2),'LineWidth',0.1);
        
    temp1 = abs(response(:,3*(i-1)+2));
    [l,z] = max(temp1);
    qq = response(z,3*(i-1)+2);
    xx = (z-1)*timeStep;
    strmax = num2str(qq);
    text(xx,qq,strmax,'BackgroundColor',[.7 .9 .7],'HorizontalAlignment','left','VerticalAlignment','top');
    
    grid on;
    grid minor;
    title(titleVel);
    xlabel('time(s)');
    ylabel('velocity(m/s)');
    subplot(3,1,3);
    plot(t,response(:,3*i),'LineWidth',0.1);
        
    temp1 = abs(response(:,3*i));
    [l,z] = max(temp1);
    qq = response(z,3*i);
    xx = (z-1)*timeStep;
    strmax = num2str(qq);
    text(xx,qq,strmax,'BackgroundColor',[.7 .9 .7],'HorizontalAlignment','left','VerticalAlignment','top');
    
    grid on;
    grid minor;
    title(titleAcc);
    xlabel('time(s)');
    ylabel('accelaration(m/s/s)');
    name2 = strcat(date,'-','Response_of_SDF_Problem_1_',num2str(i));
    saveas(figure2,name2,'pdf');
end

%damping = input('Enter the value of damping in percentage =');
%damping = damping*0.01;
damping = 0.05;
response2 = zeros(m,3);
number = (5/0.001)+1;
spectrum = zeros(number,5);
for j = 1:number
    time = (j-1)*0.001;
    response2 = newmarks(1,-9.81*f,t,damping,(2*pi()/time),x0,v0);
    response2(:,3) = response2(:,3)+9.81*f;
    response2 = abs(response2);
    spectrum(j,1) = max(response2(:,1));
    spectrum(j,2) = max(response2(:,2));
    spectrum(j,3) = max(response2(:,3));
    spectrum(j,4) = spectrum(j,1)*(2*pi()/time);
    spectrum(j,5) = spectrum(j,1)*(2*pi()/(time+0.000001))*(2*pi()/(time+0.0000001));
end
tt = 0:0.001:5;
figure3 = figure;
plot(tt,spectrum(:,1));
grid on;
grid minor;
xlabel('time(s)');
ylabel('Spectral Displacement(SD)');
title('Spectral Displacement');
name3 = strcat(date,'Spectral_Displacement');
saveas(figure3,name3,'pdf');

figure4 = figure;
plot(tt,spectrum(:,2));
grid on;
grid minor;
xlabel('time(s)');
ylabel('Spectral Velociy(SV)');
title('Spectral Velocity');
name4 = strcat(date,'Spectral_Velocity(SV)');
saveas(figure4,name4,'pdf');

figure5 = figure;
plot(tt,spectrum(:,3));
grid on;
grid minor;
xlabel('time(s)');
ylabel('Spectral Accelaration(SA)');
title('Spectral Accelaration');
name5 = strcat(date,'Spectral_Accelaration(SA)');
saveas(figure5,name5,'pdf');

figure6 = figure;
plot(tt,spectrum(:,4));
grid on;
grid minor;
xlabel('time(s)');
ylabel('Pseudo Spectral Velocity(PSV)');
title('Pseudo Spectral Velocity');
name6 = strcat(date,'Pseudo_Spectral_Velocity(PSV)');
saveas(figure6,name6,'pdf');

figure7 = figure;
plot(tt,spectrum(:,5));
grid on;
grid minor;
xlabel('time(s)');
ylabel('Pseudo Spectral Accelaration(SA)');
title('Pseudo Spectral Accelaration');
name7 = strcat(date,'Pseudo_Spectral_Accelaration(PSA)');
saveas(figure7,name7,'pdf');

name6 = strcat(date,'_Final_Result.txt');
FinalResult = [tt',spectrum];
dlmwrite(name6,FinalResult);
closseeee = input('Press enter or any key followe by enter to close and clear all the data','s');
display('All you''r datas will be saved as pdf file in your root folder with file name starts with date');
close all;
clear all;