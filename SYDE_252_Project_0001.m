clear;
InputSoundInfo = dir('Sounds/Input Sounds');

% Define the number of channels (N) and frequency range
N = 30;

%This can't change
lowFreq = 100;  % Hz
highFreq = 7999;  % Hz

logIntervals = 2.^(linspace(log2(lowFreq), log2(highFreq), N+1));
% logIntervals = linspace(lowFreq, highFreq, N+1);

centerFrequencies = zeros(length(N), 1);
for i = 1:N
    centerFrequencies(1, i) = sqrt(logIntervals(i) * logIntervals(i+1));
end

error_name = {length(InputSoundInfo)};
error_rmse = zeros(length(InputSoundInfo), 1);
error_psnr = zeros(length(InputSoundInfo), 1);
tic
for i = 4:length(InputSoundInfo)
    [audio_signal, sample_frequency] = processAudio("Sounds/Input Sounds/" + InputSoundInfo(i).name);

    envelopes = filter_bank(N, logIntervals, sample_frequency, audio_signal);
    cosineSignals = cell(1, N);

    for n = 1:N
        % Generate a cosine signal with the central frequency of the bandpass filter

        duration = length(audio_signal) / sample_frequency;
        time = linspace(0, duration, length(envelopes{n}));
        frequency = centerFrequencies(n);
        cosineSignals{n} = cos(2 * pi * frequency * time);
    end

    amplitudeModulatedSignals = cell(1, N);
    
    for n = 1:N
        amplitudeModulatedSignals{n} = cosineSignals{n}' .* envelopes{n};
    end

    outputSignal = zeros(length(amplitudeModulatedSignals{n}),1);

    for n = 1:N
        outputSignal = outputSignal + amplitudeModulatedSignals{n};
    end

    outputSignal = outputSignal / max(abs(outputSignal));
    
%     Plot the output signal
%     f3 = figure(3);
%     plot(time, outputSignal);
%     xlabel('Time');
%     ylabel('Amplitude');
%     title('Filtered Output Signal');
% 
%     saveas(f3, fullfile('Figures', [erase(InputSoundInfo(i).name, ".m4a") '_filtered_output_signal.png']));

    output_file = "Sounds/Output Sounds/" + erase(InputSoundInfo(i).name, ".wav") + "_filtered_output.wav";
    audiowrite(output_file, outputSignal, sample_frequency);

    error_name{i - 3} = erase(InputSoundInfo(i).name, ".wav");
    error_rmse(i - 3, 1) = calculateRMSE(audio_signal, outputSignal);
    error_psnr(i - 3, 1) = calculatePSNR(audio_signal, outputSignal);
end
time = toc;

error_name = error_name';
error_rmse = error_rmse(1:7, 1);
error_psnr = error_psnr(1:7, 1);

average_rmse = mean(error_rmse);
average_psnr = mean(error_psnr);

error = table(error_name, error_rmse, error_psnr)

function similarity = calculateRMSE(signal1, signal2)
    % Ensure both signals are column vectors
    signal1 = signal1(:);
    signal2 = signal2(:);

    % Check if the signals have the same length
    if length(signal1) ~= length(signal2)
        error('Input signals must have the same length.');
    end

    similarity = sqrt(mean((signal1 - signal2).^2));
end

function psnrValue = calculatePSNR(originalSignal, reconstructedSignal)
    % Ensure both signals are column vectors
    originalSignal = originalSignal(:);
    reconstructedSignal = reconstructedSignal(:);

    % Check if the signals have the same length
    if length(originalSignal) ~= length(reconstructedSignal)
        error('Both signals must have the same length.');
    end

    % Calculate the maximum possible signal power (assuming values in the range [0, 1])
    maxSignalPower = 1;

    % Calculate PSNR
    psnrValue = 10 * log10(maxSignalPower^2 / immse(originalSignal, reconstructedSignal));

end


