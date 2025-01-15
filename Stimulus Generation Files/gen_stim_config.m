% Read in *.wav files.

wav_files = dir('*.wav');

ch1_signal_name = wav_files(1).name;
ch2_signal_name = wav_files(1).name;

ch1_stim_ID = ch1_signal_name(1:end-4);
ch2_stim_ID = ch2_signal_name(1:end-4);

configuration{1,1} = ch1_signal_name;
configuration{1,2} = ch1_stim_ID;
configuration{1,3} = 0; % NI Channel
configuration{1,4} = 0; % TDT attenuation  value;
configuration{1,5} = 75; % Reference sound intensity

configuration{2,1} = ch2_signal_name;
configuration{2,2} = ch2_stim_ID;
configuration{2,3} = 1; % NI Channel
configuration{2,4} = 0; % TDT attenuation  value;
configuration{2,5} = 75; % Reference sound intensity

current_dir = dir;
current_folder_name_idx = strfind(current_dir(1).folder, '\');
temp_name = current_dir(1).folder(current_folder_name_idx(end)+1:end);

save_filename = strcat('stim_config_',temp_name, '.mat');
save(save_filename, 'configuration')