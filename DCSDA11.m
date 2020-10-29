clc
clear all
close all
%%Reading the audio input signal.
[y,Fs] = audioread('guitar sound.m4a')  %reading audio signal
info = audioinfo('guitar sound.m4a')    %information about the audio
t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end);
figure()
subplot(3,1,1)
plot(t,y)                                %plotting the signal
xlabel('time')
ylabel('amplitude')
title('audio signal')
%%Quantization of the audio signal
n=12
y_max=max(y)                             %calculating the maximum value
y_min=min(y)                             %calculating the minimum value
yquan=y/y_max(1)
d=(y_max-y_min)/n                        %step size
d=d(1)
q=d.*[0:n-1]
q=q-((n-1)/2)*d
subplot(3,1,2)
stem(q)
xlabel('time')
ylabel('Amplitude')
title('Quantisation Levels')
%quantized waveform
for i=1:n
    yquan(find((q(i)-d/2<=yquan)&(yquan<=q(i)+d/2)))=q(i).*ones(1,length(find((q(i)-d/2<=yquan)&(yquan<=q(i)+d/2))))
    bquan(find(yquan==q(i)))=(i-1).*ones(1,length(find(yquan==q(i))))
end
 
%%Plotting the Quantized Output
subplot(3,1,3)
plot(t,yquan)
xlabel('time')
ylabel('amplitude')
title('quantised waveform')
sound(yquan,Fs)
 
figure()
zoom=100000:100000+length(t)/120
subplot(2,1,1)
plot(t(zoom),y(zoom),'g')%%the quantized signal zoomed in
title('Original Audio')
xlabel('Time')
ylabel('Amplitude')
subplot(2,1,2)
plot(t(zoom),yquan(zoom),'b')
title('Quantized')
xlabel('Time')
ylabel('Amplitude')
