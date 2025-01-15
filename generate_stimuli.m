clear all
close all
clc

%% Stimulus Parameters

plotting = 1;
%stim_dir = '/Users/lee33/Library/CloudStorage/GoogleDrive-lee33@stolaf.edu/Shared drives/Lee Lab Neural Systems and Behavior/Projects/Ormia Song Recognition/v2023/';
stim_dir = fulldir(stimprog_path, 'Stimuli\');
%%
all_pdur = [2, 3, 5, 7, 10, 13, 15, 20, 25, 30, 35, 40, 45, 50];
all_pint = [2, 3, 5, 7, 10, 13, 15, 20, 25, 30, 35, 40, 45, 50];

pps50_ref_rms = 0.4674;

for x = 1:length(all_pdur)
%for x = 5
    
    for y = 1:length(all_pint)
    %for y = 5
      
        
        srate = 44100; % sampling rate
        freq = 4700; % Hertz
        pdur = all_pdur; % msec
        pint = all_pint; % msec
        %total_stim_dur = 2000/2; % What if we went shorter (e.g. 2 seconds)
        %total_stim_dur = 16000/2; % for calibration
        total_stim_dur = 500/2; % for experiments
        pnum = total_stim_dur/(pdur(x)+pint(y)); % number of sound pulses
        onramp = 1; % msec
        offramp = 1; % msec
        chirpnum = 0; % number of chirps
        chirp_int = 100; % msec
        duty_cycle = pdur(x)/(pdur(x)+pint(y));
        
        %Create Ch1 ramp
        on = 0:round(onramp * srate / 1000);
        on_ramp_length = length(on);
        on = sin(on/on_ramp_length * pi/2).^2; %raised sin half-cycle, "ramp" ms rise-time
        
        off = 0:round(offramp * srate / 1000);
        off_ramp_length = length(off);
        off = cos(off/off_ramp_length * pi/2).^2; %raised cos half-cycle, "ramp" ms fall-time
        
        %Create tones
        tone = 0:round(pdur(x) * srate / 1000);
        tone = sin(tone*2*pi* freq/srate);
        
        %Apply ramps
        tone(1:on_ramp_length) = tone(1:on_ramp_length).* on;
        tone((length(tone)-(off_ramp_length-1)):end) = tone((length(tone)-(off_ramp_length-1)):end).* off;
        
        %Create chirps
        silence_pts = round(pint(y) * srate/1000);
        silence = zeros(1,silence_pts);
        
        pulse_int = [tone,silence];
        
        chirp = [];
        
        for i = 1:pnum
            chirp = [chirp, pulse_int];
        end
        
        %Create songs
        chirp_int_pts = round(chirp_int * srate/1000);
        ch1_ici_silence = [zeros(1, chirp_int_pts)];
        
        Chirp_interchirp = [chirp, ch1_ici_silence];
        
        signal_out = [];
        
        if chirpnum ==0
            signal_out = chirp;
        else
            for k = 1:chirpnum
                signal_out = [signal_out Chirp_interchirp];
            end
        end
        
        % Digitally adjust amplitude of signal based on duty cycle. If duty
        % cycle is 0.5 (50%), then amplidude of signal is 1.0. If duty
        % cycle is 100%, amplitude is 0.5.
        
        % ref_signal_amp = 0.5;
        % signal_out = signal_out*ref_signal_amp; % to start signal at 0.5 volt.
        % scaling = duty_cycle/0.5; 
        % 10 ms pulse duration and 10 ms interpule interval is 50% duty cycle
        % Use a sound level meter to measure (SLM measurement values in LZeq) the output of a 0.6 v signal
        % to measure the output of this signal and adjust audio amplitude and/or 
        % programmable attenuator to result in 75 dB SPL. Then a 50% duty
        % cycle signal, at x volts, while have the correct 75 dB SPL. All
        % other signals will be equalized to this 75 dB SPL signal based on
        % scaling the digital file.
        
        % For example, a 0.5 v amplitude signal at 50% duty cycle will have
        % 75 dB SPL. A signal with a pulse duration of 2 ms and interpulse
        % interval of 50 ms will have a duty cycle of 3.84%
        % ((2/(2+50))*100). To make the 3.84% duty cycle match in acoustic
        % energy, this signal should be multiplied by 
        
        % signal_out = signal_out * 1/scaling;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% New approach to account for differeces in duty cycle across stimuli with
% different temporal patterns. This approach invovles equalizing rms values
% across different signals.

        current_signal_rms = rms(signal_out);
        ratio_fix = pps50_ref_rms/current_signal_rms;
        signal_out = signal_out * ratio_fix;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %Make left-right signals
        %left
        after_stim_silence= zeros(1, 200*srate/1000);
        
        %silence = zeros(1, total_stim_dur*srate/1000);
        
        left_signal_out = [signal_out after_stim_silence];
        right_signal_out = zeros(1, length(left_signal_out));
        
        %Plot stimuli
        time = 1/srate:1/srate:length(left_signal_out)/srate;
        if plotting==1
            figure(1)
            subplot(2,1,1)
            plot(time, left_signal_out)
            subplot(2,1,2)
            plot(time, right_signal_out)
        end
        
        % Write configuration
        folder_name = strcat('pd',num2str(pdur(x)),'_pint',num2str(pint(y)));
  
        configuration{1,1} = 'signal_1.wav';
        configuration{1,2} = folder_name;
        configuration{1,3} = 0;
        configuration{1,4} = 17.3;
        configuration{1,5} = 75;
        
        configuration{2,1} = 'signal_2.wav';
        configuration{2,2} = folder_name;
        configuration{2,3} = 1;
        configuration{2,4} = 15.3;
        configuration{2,5} = 75;
        
        % make directory
        new_dir1 = fullfile(stim_dir, folder_name);
        mkdir(new_dir1);

        % write wav files
        % audiowrite(strcat(new_dir1, '\','signal_1.wav'),left_signal_out,44100)
        % audiowrite(strcat(new_dir1, '\', 'signal_2.wav'),right_signal_out,44100)
        save(strcat(stim_dir, folder_name,'\', 'signal_1.mat'), 'left_signal_out');
        save(strcat(stim_dir, folder_name,'\', 'signal_2.mat'), 'right_signal_out');
        
        config_file_name = strcat('stim_config_', folder_name);
        % Mac
        %save(strcat(stim_dir, folder_name,'/', config_file_name, '.mat'), 'configuration');
        % PC
        save(strcat(stim_dir, folder_name,'\', config_file_name, '.mat'), 'configuration');
        
    end
end
%% Make Silence

srate = 44100;
silence = zeros(1, 450*srate/1000);

left_signal_out = silence;
right_signal_out = silence;

%Plot stimuli
time = 1/srate:1/srate:length(left_signal_out)/srate;
if plotting==1
    figure(1)
    subplot(2,1,1)
    plot(time, left_signal_out)
    subplot(2,1,2)
    plot(time, right_signal_out)
end

% Write configuration
folder_name = 'silence';

configuration{1,1} = 'signal_1.wav';
configuration{1,2} = folder_name;
configuration{1,3} = 0;
configuration{1,4} = 17.3;
configuration{1,5} = 75;

configuration{2,1} = 'signal_2.wav';
configuration{2,2} = folder_name;
configuration{2,3} = 1;
configuration{2,4} = 15.3;
configuration{2,5} = 75;

% make directory
new_dir1 = fullfile(stim_dir, folder_name);
mkdir(new_dir1);

% write wav files
% audiowrite(strcat(new_dir1, '\','signal_1.wav'),left_signal_out,44100)
% audiowrite(strcat(new_dir1, '\', 'signal_2.wav'),right_signal_out,44100)
save(strcat(stim_dir, folder_name,'\', 'signal_1.mat'), 'left_signal_out');
save(strcat(stim_dir, folder_name,'\', 'signal_2.mat'), 'right_signal_out');

config_file_name = strcat('stim_config_', folder_name);
% Mac
%save(strcat(stim_dir, folder_name,'/', config_file_name, '.mat'), 'configuration');
% PC
save(strcat(stim_dir, folder_name,'\', config_file_name, '.mat'), 'configuration');
        
