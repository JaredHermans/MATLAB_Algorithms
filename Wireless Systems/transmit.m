function [x,y] = transmit(bits,sr)
% Outputs sine wave of f0 and f1 coresponding to bit 0 and bit 1 and
% original binary signal
%   [x,y]=[output sine signal, input binary signal]
%   bits coresponds to the number of bits wanted to be transmitted
%   sr is the DAC sample rate

binary_sr=sr;               % Binary sample rate = DAC sample rate
sig_len=bits*sr;    % Signal length in samples

bin_data=round(rand(1,bits)); % Creating random binary signal

period=0:1/sr:1-(1/sr); % Period of one bit

% Create snusoidal carriers
carrier_freq_1=sin(2*2*pi*(period)); % 1st carrier freq
carrier_freq_2=sin(2*pi*(period));% 2nd carrier freq

sig_bin=[];     % Binary signal
sig_freq=[];    % Frequency modulated signal

for i=1:bits
    if (bin_data(i)==1)     % modulation for high bit 
        sig_bin=[sig_bin ones(1,binary_sr)];
        sig_freq=[sig_freq carrier_freq_1];
    else                    % modulation for low bit
        sig_bin=[sig_bin zeros(1,binary_sr)];
        sig_freq=[sig_freq carrier_freq_2];
    end
end
x=sig_freq;
y=sig_bin;
end

