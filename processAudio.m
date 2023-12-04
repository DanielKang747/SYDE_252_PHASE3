function [audio_signal, sample_frequency] = processAudio(file_path)
    [audio_data, sampling_rate] = audioread(file_path);

    [~,name,~] = fileparts(file_path);

    desired_sampling_rate = 16000;

    if sampling_rate < desired_sampling_rate
        disp(name + "has a sampling rate smaller than 16kHz.");
        return; 
    end

    file_name = "";
    for i = 1:length(name)
        file_name = file_name.append(name(1,i));
    end

    if size(audio_data, 2) == 2
        audio_data = sum(audio_data, 2);
    end
    
%     sound(audio_data, sampling_rate);

    sample_number = (0:length(audio_data) - 1);

    f1 = figure('visible','off');
    plot(sample_number, audio_data);
    xlabel('Sample Number');
    ylabel('Amplitude');
    title(file_name + ' Based on Sample Number', 'Interpreter', 'none');

    if sampling_rate >= desired_sampling_rate
        audio_data = resample(audio_data, desired_sampling_rate, sampling_rate);
        sampling_rate = desired_sampling_rate;
    end
    
    saveas(f1, 'Figures/' + file_name + '_waveform.png');
%     saveas(f2, 'Figures/' + file_name + '_cosine.png');

    audio_signal = audio_data;
    sample_frequency = desired_sampling_rate;

end
