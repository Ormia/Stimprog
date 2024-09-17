% combination

close all

tic
% Initialize LC variables.

srate = 44100;
freq = [1000,...
    1250,...
    1600,...
    2000,...
    2500,...
    3150,...
    4000,...
    5000,...
    6300,...
    8000,...
    10000,...
    12500,...
    16000];

intensities = 10:2.5:90;
ref_dB = 80;

HI_Song_dir = 'C:\Users\Lee Lab\Documents\MATLAB\StimProgV6\TO_NaturalSongs_dontdelete\';

%% For calibration - SPL levels at each frequency (when signals are -1 to 1)

calibration_table_left = readtable('C:\Users\Lee Lab\Documents\MATLAB\StimProgV6\HI_Natural_calibration.xlsx', 'Sheet', 'LeftSpk');
calibration_table_right = readtable('C:\Users\Lee Lab\Documents\MATLAB\StimProgV6\HI_Natural_calibration.xlsx', 'Sheet', 'RightSpk');

%%

%import signal name
stimuli_filenames = dir(HI_Song_dir);
stimuli_filenames = stimuli_filenames(3:end);

for i=1:length(stimuli_filenames)
    
    % Import SynSing Signals
    
    import_sig_name = stimuli_filenames(i).name;
    import_sig = audioread(strcat(HI_Song_dir, import_sig_name));
    if strcmp(stimuli_filenames(i).name, 'White Noise Control.wav') ==1
        import_sig = normalize(import_sig, 'range', [-0.20 0.20]);
    else
        import_sig = normalize(import_sig, 'range', [-1 1]);
    end
    % then have it repeat for the next frequency, a loop
    
    original_signal = import_sig; 
    
    stim_dir = fullfile('C:\Users\Lee Lab\Documents\MATLAB\StimProgV6\HI Natural stimuli wav');
    
    % Produce signals at different intensities
    
    for j = 1:length(intensities)
        
        % To make files for signals on left or right.
        for k = 1:2
            
            if k == 1 % left
                
                %idx = find(calibration_table_left.Freq == freq(i));
                idx = strcmp(calibration_table_left.FileName,stimuli_filenames(i).name);
                idx = find(idx==1);
                linear_adjustment = calibration_table_left.LinearAdjustment(idx);
                final_signal = original_signal*linear_adjustment ;
                adjusted_signal = db2mag(intensities(j)-ref_dB)*final_signal;
                silence_signal = zeros(1, length(adjusted_signal));
                
                if mod(intensities(j),5)~= 0
                    signal_name = strcat('L_',char(stimuli_filenames(i).name(1:end-4)),'_dB', num2str(floor(intensities(j))),'_5');
                    new_dir = fullfile(stim_dir, signal_name);
                    mkdir(new_dir)
                    
                    filename1 = strcat(new_dir, '\', 'signal_1.mat');
                    filename2 = strcat(new_dir, '\', 'signal_2.mat');
                else
                    signal_name = strcat('L_',char(stimuli_filenames(i).name(1:end-4)),'_dB',num2str(intensities(j)));
                    new_dir = fullfile(stim_dir, signal_name);
                    mkdir(new_dir)
                    
                    filename1 = strcat(new_dir, '\', 'signal_1.mat');
                    filename2 = strcat(new_dir, '\', 'signal_2.mat');
                end
                
                save(char(filename1),'adjusted_signal')
                save(char(filename2),'silence_signal')
                
                %audiowrite(filename1,adjusted_signal,srate)
                %audiowrite(filename2,silence_signal,srate)
                
                
                configuration{1,1} = 'signal_1.mat';
                configuration{1,2} = signal_name;
                configuration{1,3} = 0;
                configuration{1,4} = intensities(j);
                configuration{1,5} = 90;
                
                configuration{2,1} = 'signal_2.mat';
                configuration{2,2} = signal_name;
                configuration{2,3} = 1;
                configuration{2,4} = 0;
                configuration{2,5} = 90;
                
                filename = strcat(new_dir, '\', 'stim_config_',signal_name,'.mat');
                save(filename, 'configuration')
                
            elseif k == 2 % Right
                
                idx = strcmp(calibration_table_right.FileName,stimuli_filenames(i).name);
                idx = find(idx==1);
                linear_adjustment = calibration_table_right.LinearAdjustment(idx);
                final_signal = original_signal*linear_adjustment;
                
                adjusted_signal = db2mag(intensities(j)-ref_dB)*final_signal;
                silence_signal = zeros(1, length(adjusted_signal));
                
                if mod(intensities(j),5)~= 0
                    signal_name = strcat('R_',char(stimuli_filenames(i).name(1:end-4)),'_dB', num2str(floor(intensities(j))),'_5');
                    new_dir = fullfile(stim_dir, signal_name);
                    mkdir(new_dir)
                    
                    filename1 = strcat(new_dir, '\', 'signal_1.mat');
                    filename2 = strcat(new_dir, '\', 'signal_2.mat');
                else
                    signal_name = strcat('R_',char(stimuli_filenames(i).name(1:end-4)),'_dB',num2str(intensities(j)));
                    new_dir = fullfile(stim_dir, signal_name);
                    mkdir(new_dir)
                    
                    filename1 = strcat(new_dir, '\', 'signal_1.mat');
                    filename2 = strcat(new_dir, '\', 'signal_2.mat');
                end
                
                save(char(filename1),'silence_signal')
                save(char(filename2),'adjusted_signal')
                
                %audiowrite(filename1,silence_signal,srate)
                %audiowrite(filename2,adjusted_signal,srate)
                
                
                configuration{1,1} = 'signal_1.mat';
                configuration{1,2} = signal_name;
                configuration{1,3} = 0;
                configuration{1,4} = 0;
                configuration{1,5} = 90;
                
                configuration{2,1} = 'signal_2.mat';
                configuration{2,2} = signal_name;
                configuration{2,3} = 1;
                configuration{2,4} = intensities(j);
                configuration{2,5} = 90;
                
                filename = strcat(new_dir, '\', 'stim_config_',signal_name,'.mat');
                save(filename, 'configuration')
            end
        end
        
    end
    
    % time=1/srate:1/srate:length(combination)/srate
    % plot(time, combination)
    
    combination = [];
    lc_signal=[];
    sc_signal=[];
    sc_full_signal=[];
        
end
    
    toc
    


