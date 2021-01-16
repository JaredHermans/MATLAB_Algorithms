function [m0,x1,x2] = receive(bits,sr,tr_sig)
%Outputs demodulated binary signal m0. 
%   bits coresponds to the number of bits transmitted
%   sr is the ADC sample rate (same as DAC)
%   tr_sig is the output of the transmitter (modulated signal)

% Parameters
period=0:1/sr:1-1/sr;
tr_sig2=tr_sig;     % Copying modulated signal
f0=1;
f1=2;

local_osc1=sin(2*pi*f0*(period));     % Local oscillator 1
local_osc2=sin(2*pi*f1*(period));     % Local oscillator 2


x1=[];       % x(t)
x2=[];      % x1(t)
for i=1:bits    % Loop to multiply modulated signal with carrier sig
    if (i==1)
        d=tr_sig(1:sr);
        dd=tr_sig2(1:sr);
    else
        d=tr_sig((i-1)*sr+1:i*sr);
        dd=tr_sig2((i-1)*sr+1:i*sr);
    end
    x1=[x1 d.*local_osc1];
    x2=[x2 dd.*local_osc2];
end

m0=[];  % Demodulated binary signal m0(t)
for a=1:bits % Calculates energy of signal in each branch and compares
    if (a==1)
        Ex1(a)=sum(abs(x1(1:sr)).^2);
        Ex2(a)=sum(abs(x2(1:sr)).^2);
    else
        Ex1(a)=sum(abs(x1((a-1)*sr+1:a*sr)).^2);
        Ex2(a)=sum(abs(x2((a-1)*sr+1:a*sr)).^2);
    end
    % Comparing energy values:
    % Bit 0: Ex1=18.75,Ex1=12.5; Bit 1: Ex1=12.5,Ex2=18.75
    if(Ex1(a) > Ex2(a))
        m0=[m0 zeros(1,sr)]; % Branch 1 has higher energy
    else
        m0=[m0 ones(1,sr)]; % Branch 2 has higher energy
    end
end    
end