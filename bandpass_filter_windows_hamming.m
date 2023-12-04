function filtered_signal = bandpass_filter_windows_hamming(Fc1,Fc2, audioSignal)

Fs = 16000;
N = 600;        
flag = 'scale';
win = hamming(N+1);

b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

filtered_signal = filter(Hd, audioSignal);

end