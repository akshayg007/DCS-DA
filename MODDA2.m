%PULSE CODE MODULATION
clc
clear all
syms x
% SAMPLING
% n=input('Enter the number of samples per cycle : ');
n=20;
[signal_1,Fs] = audioread('guitar sound.m4a')  %reading audio signal
info = audioinfo('guitar sound.m4a')    %information about the audio
x = 0:seconds(1/Fs):seconds(info.Duration);
x = x(1:end);
figure(1);
hold on;
plot(x,signal_1);   % plotting sine signal
title('SINE SIGNAL');
xlabel('TIME');
ylabel('AMPLITUDE');
hold off;       % hold on and hold off for plotting in different windows
figure(2);
hold on;
stem(signal_1);     % plot of sampled signal
title('SAMPLED SIGNAL');
xlabel('TIME');
ylabel('AMPLITUDE');
hold off;
% QUANTIZATION
% n1=input('Enter the number of bits per sample : ');
n1=3;
L=2^n1;
xmax=2;
xmin=-2;
del=(xmax-xmin)/L;
partition=xmin:del:xmax;            % definition of decision lines
codebook=xmin-(del/2):del:xmax+(del/2);    % definition of representation levels
[index,quants]=quantiz(signal_1,partition,codebook);    
% gives rounded off values of the samples
hold on;
stem(quants);
title('QUANTIZED SIGNAL');
xlabel('TIME');
ylabel('AMPLITUDE');
hold off;
% NORMALIZATION
l1=length(index);                 % to convert 1 to n as 0 to n-1 indices
for i=1:l1
    if (index(i)~=0)
        index(i)=index(i)-1;
    end
end
l2=length(quants);
for i=1:l2          %  to convert the end representation levels within the range.
    if(quants(i)==xmin-(del/2))
        quants(i)=xmin+(del/2);
    end
    if(quants(i)==xmax+(del/2))
        quants(i)=xmax-(del/2);
    end
end
%  ENCODING
code=de2bi(index,'left-msb')    % DECIMAL TO BINANRY CONV OF INDICIES
k=1;
for i=1:l1                     % to convert column vector to row vector
    for j=1:n1
        coded(k)=code(i,j);
        j=j+1;
        k=k+1;
    end
    i=i+1;
end
figure(4);
hold on;
stairs(coded);
axis([0 200 -2 2])
%plot of digital signal
title('DIGITAL SIGNAL');
xlabel('TIME');
ylabel('AMPLITUDE');
hold off;
%  DEMODULATION
code1=reshape(coded,n1,(length(coded)/n1));
index1=bi2de(code1,'left-msb');
resignal=del*index+xmin+(del/2);
figure(5);
hold on;
plot(resignal);
title('DEMODULATAED SIGNAL');
xlabel('TIME');
ylabel('AMPLITUDE');
hold off;
