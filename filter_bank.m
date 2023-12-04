function envelopes = filter_bank(N, logIntervals, sample_frequency, audio_signal)

    filteredSignals = cell(1, N);

    for j = 1:N
        filteredSignals{j} = bandpass_filter_windows_hamming(logIntervals(1,j), logIntervals(1,j+1), audio_signal);
    end

    rectifiedSignals = cell(1, N);
    
    for l = 1:N
        rectifiedSignals{l} = abs(filteredSignals{l});
    end
   
    % Design a lowpass filter
    lpfCutoff = 400;  % Cutoff frequency for the lowpass filter
    lpfOrder = 26;    % Order of the lowpass filter
    lpf = fir1(lpfOrder, lpfCutoff / (sample_frequency/2), 'low', hamming(26+1), 'scale');
    Hd_low_pass_filter = dfilt.dffir(lpf);

    % Apply the lowpass filter to rectified signals
    envelopes = cell(1, N);
    
    for m = 1:N
        envelopes{m} = filter(Hd_low_pass_filter, rectifiedSignals{m});
    end

    hpfCutoff = 6100;  % Cutoff frequency for the high pass filter
    hpfOrder = 26;    % Order of the high pass filter
    hpf = fir1(hpfOrder, hpfCutoff / (sample_frequency/2), 'high', hamming(26+1), 'scale');
    Hd_high_pass_filter = dfilt.dffir(hpf);

    for m = 1:N
        envelopes{m} = filter(Hd_high_pass_filter, envelopes{m});
    end
end