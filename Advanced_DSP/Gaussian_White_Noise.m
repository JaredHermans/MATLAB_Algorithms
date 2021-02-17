clear; clc; close all;
rng default;
L=1000;                         % Number of random signal realizations to average
N=1024;                         % Sample length for each realization
sigma = 2;                      % Sqrt of variance of each realization of noise process
mu=0;                           % Mean of each realization of noise process

MU=mu*ones(1,N);                % Vector of mean for all realizations
Cxx=(sigma^2)*diag(ones(N,1));  % Covariance Matrix
R=chol(Cxx);                    % Cholesky function
z=repmat(MU,L,1)+randn(L,N)*R;  % Random Process LxN Matrix

% By default, FFT is done across each column
% Find the FFT across each row
Z=1/sqrt(N)*fft(z,[],2);        % Scale by sqrt(N)
P_i=angle(mean(Z));             % Save imaginary 
Z1=Z.*conj(Z);
Pzavg1=mean(Z1);                % mean power from FFT
Pzavg=fftshift(Pzavg1);         % Periodogram estimate over L realizations

f=(-N/2:N/2-1)/N;               % Normalized frequency
figure(1),plot(f,10*log10(Pzavg),'r'),title(['PSD estimate of white noise \sigma^2 = ',num2str(sigma^2)])
axis([-0.5 0.5 -1 10]),xlabel('Normalized Frequency f'),ylabel('dB/Hz')

[rw,k]=xcorr(z(1,:),'biased');  % ACS of first realization of white noise
figure(2),plot(k,rw),title('ACS of white noise')

z_n2=mean(z);                   % Averaged 
rw3=xcorr(z_n2,'biased');

figure(3),plot(k,rw3),title('ACS of Averaged white noise over L realizations')

figure(4),plot(z(1,:)),hold on,plot(z_n2),axis([0 N -10 10]),title('White Noise')
legend('White noise for 1 realization','Averaged white noise over L realizations')

% Go back from PSD to time domain
Z2=Z1./conj(Z);
z_n=sqrt(N)*ifft(Z2,N,2);
z_n=mean(z_n);
%figure(),plot(z_n2,'k'),hold on,plot(z_n+0.3),title('Vs'),legend('Mean','PSD')

w=sigma*randn(1,N);
n=200;                                  % Number of Histogram bins
[ff,x]=hist(w,n);
g=(1/(sqrt(2*pi)*sigma))*exp(-((x-mu).^2)/(2*sigma^2));% Theoretical PDF of Gaussian Random Variable
figure(5),bar(x,ff/trapz(x,ff)),hold on,plot(x,g,'LineWidth',3),legend('Generated','Theoretical')
title('Probability Density Function of White Gaussian Noise')
