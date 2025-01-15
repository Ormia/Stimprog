clear all
clc
close all

srate = 44100;

%MAC
%files_dir = fullfile('/Volumes/GoogleDrive/Shared drives/Lee Lab Neural Systems and Behavior/CURI/2021/Projects/Ormia Neural Excitatory Response Maps/HI FTC Data/HI_Fly19');

%PC but using Googledrive as a drive on the comptuer watch out for the letter of the drive
%files_dir = fullfile('C:\Shared drives\Lee Lab Neural Systems and Behavior\CURI\2021\Projects\Ormia Neural Excitatory Response Maps\HI FTC Data\2021-07-07\HI_Fly20');

%PC lab ephys rig computer:
files_dir = fullfile(stimprog_path, 'FTC data\2021-07-09\HI_Fly23');

files = dir(fullfile(files_dir, '*.mat'));

for i = 1:length(files)

    files(i).name
    
    temp_dat = load(strcat(files_dir,'/', files(i).name));
    
    stimuli_names = fieldnames(temp_dat.dat_out.raw);
    stimuli_names = flip(stimuli_names);
    
    for j = 1:length(stimuli_names)
        
        intensity_names = fieldnames(temp_dat.dat_out.raw.(char(stimuli_names(j))));
        
        for k = 1:length(intensity_names)
            
            trace_dat = temp_dat.dat_out.raw.(char(stimuli_names(j))).(char(intensity_names(k))){1}.trace(:,1);
            time = 1/srate:1/srate:length(trace_dat)/srate;
            
            all_reps.(char(stimuli_names(j))).(char(intensity_names(k)))(:,i)= trace_dat;
            
            %figure(j)
            %subplot(3,10,k)
            %plot(time, trace_dat)
            %ylim([-0.5,0.5])
            %xlim([0,0.11])
     
            start_window = srate*0.05;
            end_window = srate*0.1;
            
            rms_val(k,j,i) = rms(trace_dat(start_window:end_window));
            
            drawnow

            
        end
        
    end
    
end
%%

for i = 1:length(stimuli_names)
    
    figure('Name', char(stimuli_names(i)) ,'NumberTitle','off')
    
    for j = 1:length(intensity_names)
        avg_trace = mean(all_reps.(char(stimuli_names(i))).(char(intensity_names(j))),2);
        
        all_freqs.(char(stimuli_names(i)))(:,j) = avg_trace;

        subplot(3,10,j)
        plot(time, avg_trace)
        xlim([0,0.11])
        ylim([-0.2,0.2])
        
        inten_val = 20:2.5:90;
        title_name = num2str(inten_val(j));
        title(title_name)
        
    end
        
end


%% Plotting Response Maps

figure()

[Xq, Yq] = meshgrid(500:0.5:16000, 20:0.5:90);
intensities = 20:2.5:90;
frequencies = [500, 630, 794, 1000, 1260, 1587, 2000, 2520, 3175, 4000, 5040, 6350, 8000, 10079, 12699, 16000];
interp_dat = interp2(frequencies, intensities, mean(rms_val(:,2:end,:),3), Xq, Yq);

surf(Xq, Yq, interp_dat , 'EdgeColor', 'none');

colorbar
colormap(jet(256));
%caxis([0.04,0.06])
view([0,90])

%ylim([0.2 7.5])

set(gca, 'xtick', [500, 630, 794, 1000, 1260, 1587, 2000, 2520, 3175, 4000, 5040, 6350, 8000, 10079, 12699, 16000],...
    'xticklabel',[500, 630, 794, 1000, 1260, 1587, 2000, 2520, 3175, 4000, 5040, 6350, 8000, 10079, 12699, 16000])
%display_title = strcat(char(animals(i)));
%title(display_title, 'interpreter', 'none');
set(gca, 'layer', 'top')
set(gca,'FontSize', 8)
%set(gca, 'XScale', 'log')
grid on
axis square


%%

