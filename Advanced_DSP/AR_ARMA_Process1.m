clear; clc; close all;
rng(1)                          % Random Number Generator Seed
L=1000;                         % Number of random signal realizations to average
N=1024;                         % Sample length for each realization for FFT
sigma = 2;                      % Sqrt of variance of each realization of noise process
f=(0:N-1)/N;                    % Normalized frequency

Cxx=(sigma^2)*diag(ones(N,1));   
R=chol(Cxx);                    
w=randn(L,N)*R;                 % White noise LxN Matrix

W=1/sqrt(N)*fft(w,[],2);        % Scale by sqrt(N)
Sww=mean(W.*conj(W));           % mean power from FFT (PSD estimate over L realizations)
Sww=fftshift(Sww);

A=[1 -1.6408 2.2044 -1.4808 0.8145];    % Denominator Filter Coefficients
B=[1 1.5857 0.9604];                    % Numerator Filter Coefficients
H=freqz(B,A,N)';                        % Frequency response H(z) for ARMA Model

Syy=Sww.*(H.*conj(H));         % ARMA PSD Realization

figure(8),plot(f,Syy),hold on,plot(f,Sww),title('PSD Estimate')
xlabel('Normalized Frequency x\pi rad/sample')
figure(9),plot(f,10*log10(Syy)),hold on,plot(f,10*log10(Sww)),title('PSD Estimate dB')
xlabel('Normalized Frequency x\pi rad/sample'),ylabel('dB/Hz')

y=filter(B,A,w,[],2);           % signal y[n] LXN matrix, L realizations

Y=1/sqrt(N)*fft(y,2*N,2);       % Periodogram over L realizations
Syy=mean(Y.*conj(Y));
Syy=Syy(1:end/2);               
figure(8),plot(f,Syy),figure(9),plot(f,10*log10(Syy))

%y=mean(y);                      % y[n] mean from L realizations 1xN vector
y=y(1,:);

%%%%%%%%%% Estimate PSD with ARMA least-squares Model %%%%%%%%%%
[ARMA_coeffa,ARMA_coeffb,sig2]=lsarma(y,4,4,8);         % Calculating filter coefficients
ARMA_ls1=freqz(ARMA_coeffb,ARMA_coeffa,N);   % Frequency response of H(w)
ARMA_ls=sig2*(ARMA_ls1.*conj(ARMA_ls1));      % Frequency response of |H(w)|^2*noise
figure(8),plot(f,ARMA_ls,'LineWidth',0.8),figure(9),plot(f,10*log10(ARMA_ls),'LineWidth',0.8)

%%%%%%%%%% Estimate PSD with AR Yule-Walker Model %%%%%%%%%
[AR_coeff,sig1]=yulewalker(y,16);            % Calculating filter coefficients
AR_PSD=freqz(1,AR_coeff,N);         % Frequency response of 1/A(w)
AR_PSD=sig1*(AR_PSD.*conj(AR_PSD));     % Frequency response of |1/A(w)|^2*noise
figure(8),plot(f,AR_PSD),figure(9),plot(f,10*log10(AR_PSD))

%%%%%%%%%% Estimate PSD with AR least-squares Model %%%%%%%%%%
[AR_coef,sig1]=lsar(y,4);
AR_PSD1=freqz(1,AR_coef,N);
AR_PSD_ls=sig1*(AR_PSD1.*conj(AR_PSD1));
figure(8),plot(f,AR_PSD_ls),figure(9),plot(f,10*log10(AR_PSD_ls))

%%%%%%%%%% Estimate PSD with AR Yule-Walker MATLAB Model %%%%%%%%% -- Same as other AR models
%[AR_coef2,var]=aryule(y,4);
%AR_PSD2=freqz(1,AR_coef2,N);
%AR_PSD2=AR_PSD2.*conj(AR_PSD2);
%figure(8),plot(f,AR_PSD2),figure(9),plot(f,10*log10(AR_PSD2))

%%%%%%%%%% Estimate PSD with ARMA Yule-Walker Model %%%%%%%%%%  -- NOT WORKING
%[ARMA_coeffa,gamma]=mywarma(y,8,8,16);               % Calculating filter coefficients
%ARMA_PSD=freqz(gamma,ARMA_coeffa,N);            % Frequency response of H(w)
%ARMA_PSD=ARMA_PSD.*conj(ARMA_PSD);             % Frequency response of |H(w)|^2*noise
%figure(8),plot(f,ARMA_PSD),figure(9),plot(f,10*log10(ARMA_PSD))

figure(8),legend('\sigma^2H(z)','Noise','Periodogram','ARMA(4,4) L-S Method', ...
    'AR(4) Y-W Method','AR(4) L-S Method'),grid on
figure(9),legend('\sigma^2H(z)','Noise','Periodogram','ARMA(4,4) L-S Method', ...
    'AR(4) Y-W Method','AR(4) L-S Method'),grid on
