function [ff0,Zin,gamma_abs,SWR] = func_quarterwave(Z0, R_L)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% %Design parameters
%     Z0 = 50; % characteristic impedance to match to
%     R_L = 100; % quarter wave unmatched load, ohm

% Electrical Length as a function of freq ratio where f0 is the
% quarter wave frequency
    step = 0.01;
    ff0 = 0:step:4; % Quater wave freq ratio (f/f0)
    theta = (0.5*pi).*ff0; %Electrical length, rad

%For Quarter wave line load and impedance
    Z1 = sqrt(R_L*Z0); %Pozar, 2.63
    %Zin to the quarter wave line
    Zin = Z1.*((R_L + 1i.*Z1.* tan(theta)) ./ (Z1 + 1i.*R_L.* tan(theta)));
    
%Find gamma and SWR for the quarter wave line
    gamma_abs = abs((Zin - Z0)./(Zin + Z0));
    SWR = (1 + gamma_abs)./(1 - gamma_abs);
end

