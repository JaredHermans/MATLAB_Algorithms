clear; clc; close all;
% Test transmit and receive functions
sr=50;          % Sample rate of DAC
bits=10;        % Number of bits transmitted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transmitting signal:
[tr_sig,bin_sig]=transmit(bits,sr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting signals:
period=0:1/sr:1-1/sr;       % Period of one bit
sig_len=sr*bits;            % Length of signal 

figure(1),plot(1:sig_len,bin_sig),title('Binary Message Signal m(t)'),xlabel('Time')
ylabel('Amplitude'),datacursormode on
y=linspace(1,sig_len,length(tr_sig)); % y axis for modulated signal
figure(2),plot(y,tr_sig),title('Frequency Shift Keying \phi(t)'),xlabel('Time'),ylabel('Amplitude')
datacursormode on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adding noise:
t_snr=[50,10,8,6,4,3,1,0.05,0.005];       % Signal to noise ratio in dB
t1_snr=1; %%%%% ENTER INDEX TO SEE x1,x2 PLOTS FOR SPECIFIC SNR VALUE %%%%%
y1=[];
for a=1:length(t_snr)
    y1=[y1 awgn(tr_sig,t_snr(a))];   % Noisy signal
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting noisy signals:
h=figure('Position',[100 100 2048 1200]);
for i=1:length(t_snr)   
    if (i==1)
        subplot(length(t_snr),1,i),plot(y,tr_sig),hold on,plot(y,y1(1:sig_len))
    else
        subplot(length(t_snr),1,i),plot(y,tr_sig),hold on,plot(y,y1(sig_len*(i-1)+1:i*sig_len))
    end
    t=ylabel({'snr=';t_snr(i)});
    t.FontSize=12;
end
set(h,'WindowStyle','modal')
sgtitle('Adding White Gaussian Noise \phi(t)')
xlabel('Time')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiving signal:
for i1=1:length(t_snr)
    ind=sig_len*i1;
    [m0(ind-sig_len+1:ind),x1(ind-sig_len+1:ind),x2(ind-sig_len+1:ind)]...
        =receive(bits,sr,y1(ind-sig_len+1:ind));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ploting x(t) and demodulated signals
figure(4)
plot(y,x1((t1_snr*sig_len)-sig_len+1:t1_snr*sig_len))
title(['x_1(t) and x_2(t) for snr = ' num2str(t_snr(t1_snr))]),xlabel('Time')
ylabel('Amplitude'),hold on,plot(y,x2((t1_snr*sig_len)-sig_len+1:t1_snr*sig_len),'r')
legend('x_1(t)','x_2(t)')

figure(5),subplot(211),plot(1:sig_len,m0((t1_snr*sig_len)-sig_len+1:t1_snr*sig_len))
title(['m(t) vs. Demodulated Binary Signal m_0(t) for snr = ' num2str(t_snr(t1_snr))])
xlabel('Time'),ylabel('Amplitude'),legend('m_0(t)'),subplot(212),
plot(1:sig_len,bin_sig,'r'),legend('m(t)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating Bit error rate
bit_error1=[];
for index=1:length(t_snr)
    ind=sig_len*index;
    bit_error=biterr(bin_sig,m0(ind-sig_len+1:ind));
    bit_error1=[bit_error1 bit_error/sr];
end
ber=bit_error1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Bit error
figure(6)
X=categorical({'50','10','8','6','4','3','1','0.05','0.005'});
X=reordercats(X,{'50','10','8','6','4','3','1','0.05','0.005'});
Y=[ber(1) ber(2) ber(3) ber(4) ber(5) ber(6) ber(7) ber(8) ber(9)];
b=bar(X,Y);ylabel('Number of Bit Errors'),xlabel('SNR')
title('Bit Error')
xtips1=b(1).XEndPoints;
ytips1=b(1).YEndPoints;
labels1=string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center', ...
    'VerticalAlignment','bottom')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Bit error rate
ber=ber/bits;
figure(7)
X=categorical({'50','10','8','6','4','3','1','0.05','0.005'});
X=reordercats(X,{'50','10','8','6','4','3','1','0.05','0.005'});
Y=[ber(1) ber(2) ber(3) ber(4) ber(5) ber(6) ber(7) ber(8) ber(9)];
b=bar(X,Y);ylabel('Bit Error Rate'),xlabel('SNR')
title('Bit Error Rate')
xtips1=b(1).XEndPoints;
ytips1=b(1).YEndPoints;
labels1=string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center', ...
    'VerticalAlignment','bottom')