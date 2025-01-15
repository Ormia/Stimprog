 
function varargout = ftc_module_v2(varargin)
% FTC_MODULE_V2 M-file for ftc_module_v2.fig
%      FTC_MODULE_V2, by itself, creates a new FTC_MODULE_V2 or raises the existing
%      singleton*.
%
%      H = FTC_MODULE_V2 returns the handle to a new FTC_MODULE_V2 or the handle to
%      the existing singleton*.
%
%      FTC_MODULE_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FTC_MODULE_V2.M with the given input arguments.
%
%      FTC_MODULE_V2('Property','Value',...) creates a new FTC_MODULE_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ftc_module_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ftc_module_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ftc_module_v2

% Last Modified by GUIDE v2.5 19-Jun-2018 11:10:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ftc_module_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @ftc_module_v2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ftc_module_v2 is made visible.
function ftc_module_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ftc_module_v2 (see VARARGIN)

global hfig_ftc_module
global hfig_stimprog
global hfig_ftc_modle
global srate

%Initiate TDT
CD='USB';


try
    PA5x1=actxcontrol('PA5.x',[5 5 26 26]);
    hfig_ftc_module.TDT.PA5x1 = PA5x1;

    %Connects to PA5 #1 via USB
    if invoke(PA5x1,'ConnectPA5',CD,1) % == -1
        e='PA5_1 connected'
        %update_TDTatten(1,hfig_ftc_module)
    else
        e='PA5_1 Unable to connect'
    end

    PA5x2=actxcontrol('PA5.x',[5 5 26 26]);
    hfig_ftc_module.TDT.PA5x2 = PA5x2;

    %Connects to PA5 #2 via USB
    if invoke(PA5x2,'ConnectPA5',CD,2) % == -1
        e='PA5_2 connected'

        %update_TDTatten(2,hfig_ftc_module)
    else
        e='PA5_2 Unable to connect'
    end
    
end

try
    release(hfig_stimprog.nidaq.s)
end
set(handles.figure1,'CloseRequestFcn',@my_closereq)

%Load Calibration
%current_directory = cd;
%dname_filt = uigetdir(cd, 'Locate Calibration Folder');

% dname_filt = fullfile(stimprog_path, 'calibration_data\2018-06-18');
% %dname_filt = 'D:\Users\Norman Lee\Documents\MATLAB\stimprog v5.42 Hcin\calibration_data\2014-05-01';
% files_cal = dir(fullfile(dname_filt, '*.mat'));
% calibration_filt = load(strcat(dname_filt,'\', files_cal(1).name));
% hfig_ftc_module.ao0.cal_filt = calibration_filt.deg_0.filt_coefficients;
% %hfig_ftc_module.ao0.speaker_fix = calibration_filt.deg_0.speaker_response.dB_correction;
% hfig_ftc_module.ao0.speaker_fix = 1;
% calibration_filt = load(strcat(dname_filt,'\', files_cal(2).name));
% hfig_ftc_module.ao1.cal_filt = calibration_filt.deg_0.filt_coefficients;
% hfig_ftc_module.ao1.speaker_fix = 1;


% hfig_ftc_module.ao0.cal_filt = calibration_filt.deg_0.filt_coefficients;
% hfig_ftc_module.ao0.speaker_fix = calibration_filt.deg_0.speaker_response.dB_correction;
% calibration_filt = load(strcat(dname_filt,'/', files_cal(2).name));
% hfig_ftc_module.ao1.cal_filt = calibration_filt.deg_0.filt_coefficients;
% hfig_ftc_module.ao1.speaker_fix = calibration_filt.deg_0.speaker_response.dB_correction;

[FileName,PathName] = uigetfile('*.xlsx','Select the Excel Calibration File');
[num,txt,ch1] = xlsread(strcat(PathName,FileName), 'ch1');
[num,txt,ch2] = xlsread(strcat(PathName,FileName), 'ch2');

%S:\PROJ-Froglab\2013 Frog Experiments\Neurophys\stimprog v5.42 Hcin\calibration_FTC.xlsx
% [num,txt,ch1] = xlsread(strcat(fullfile(stimprog_path, 'calibration_FTC_new_V2.xlsx')), 'ch1');
% [num,txt,ch2] = xlsread(strcat(fullfile(stimprog_path, 'calibration_FTC_new_V2.xlsx')), 'ch2');


hfig_ftc_module.ch1.calibration = ch1;
hfig_ftc_module.ch2.calibration = ch2;

%Generate Tones
% freqs = [500, 630, 794, 1000, 1260, 1300, 1587, 2000, 2520, 2600, 3000,...
%     312155, 4000, 5040];

% cinerea freqs = [450, 560, 710, 900, 1120, 1400, 1800, 2240, 2700, 2800, 3550, 4500, 5600];
%freqs = [442, 625, 884, 992, 1250, 1575, 1984, 2500, 3150, 3536, 5000];

%for frequencies above freq, freq*2^(1/3), 1/3 octave steps
%octave_steps = 1/3;


% start_freq = 198;
% end_freq = 8000;
% freqs = 198;
% next_freq = start_freq*(2^(1/3));


start_freq = 1000;
end_freq = 50000;
freqs = 1000;
next_freq = start_freq*(2^(1/3));


while next_freq < end_freq
    freqs = [freqs, round(next_freq)];
    next_freq = next_freq*2^(1/3);
end

freqs = sort(freqs);

stimpars.pdur = 10;
stimpars.ipi = 50;
stimpars.ramp = 1;
stimpars.pnum = 1;
stimpars.revph = 1;
stimpars.noise = 0;
stimpars.chrpnum = 1;
stimpars.ici = 0;

hfig_ftc_module.ch1_stim_index = 1;
hfig_ftc_module.ch1_stim_index_max = 1;

srate = 100000;

for i = 1:length(freqs)
    stimpars.freq = freqs(i);
    fname{i} = strcat('f_', num2str(freqs(i)));
    signal = pulse_train(srate, stimpars);
    %signal = signal(8379:end); % to shorten signal
    stimuli.(fname{i}) = signal*1;

    % Increments index for listbox
    hfig_ftc_module.ch1_stim_index_max = hfig_ftc_module.ch1_stim_index_max + 1;
end

%silence
silence = zeros(length(stimuli.f_1000),1)';
 
stimuli.silence = silence;
hfig_ftc_module.ch1_stim_index = hfig_ftc_module.ch1_stim_index_max;
hfig_ftc_module.ch1_stim_index_max = hfig_ftc_module.ch1_stim_index_max + 1;
freqs = [freqs 0];

%fmsweep

% [sweep srate] = fmsweep_gen(200, 7500,0.5,0.5,1);  % start freq, stop freq, duration, period, rep 
% calibration = load(fullfile(stimprog_path, 'calibration_data\2018-07-13\ao0_calibration.mat'));
% sweep = filtfilt(calibration.left.filt_coefficients, 1, sweep);
% 
% sweep = (1/max(sweep))*sweep;
% sweep = sweep*5;
% stimuli.fmsweep = sweep;
% hfig_ftc_module.ch1_stim_index = hfig_ftc_module.ch1_stim_index_max;
% hfig_ftc_module.ch1_stim_index_max = hfig_ftc_module.ch1_stim_index_max + 1;
% freqs = [freqs 0];

stim_fieldnames = fieldnames(stimuli);
set(handles.listbox_ch1_stimuli,'String', stim_fieldnames)
set(handles.edit_ch1_intensity,'String', num2str('75'))

hfig_ftc_module.ch1.stimuli = stimuli;
hfig_ftc_module.ch1.stim_names = stim_fieldnames;
hfig_ftc_module.ch1.stim_freqs = freqs;
hfig_ftc_module.ch1.stim_time_short = 1/srate:1/srate:length(stimuli.(fname{i}))/srate;
hfig_ftc_module.ch1.stim_time = hfig_ftc_module.ch1.stim_time_short;

next_freq = [];
freqs = [];
fname = [];
stimuli = [];

% start_freq = 12;
% end_freq = 1000;
% freqs = 12;
% next_freq = start_freq*(2^(1/3));

start_freq = 1000;
end_freq = 100000;
freqs = 1000;
next_freq = start_freq*(2^(1/3));


while next_freq < end_freq
    freqs = [freqs, round(next_freq)];
    next_freq = next_freq*2^(1/3);
end

freqs = sort(freqs);

stimpars.pdur = 10;
stimpars.ipi = 50;
stimpars.ramp = 1;
stimpars.pnum = 1;
stimpars.revph = 1;
stimpars.noise = 0;
stimpars.chrpnum = 1;
stimpars.ici = 0;

hfig_ftc_module.ch2_stim_index = 1;
hfig_ftc_module.ch2_stim_index_max = 1;

srate = 100000;

for i = 1:length(freqs)
    stimpars.freq = freqs(i);
    fname{i} = strcat('f_', num2str(freqs(i)));
    signal = pulse_train(srate, stimpars);
    %signal = signal(8379:end); % to shorten signal
    stimuli.(fname{i}) = signal*1;

    % Increments index\ for listbox
    hfig_ftc_module.ch2_stim_index_max = hfig_ftc_module.ch2_stim_index_max + 1;
end

%silence
silence = zeros(length(stimuli.f_1000),1)';
 
stimuli.silence = silence;
hfig_ftc_module.ch2_stim_index = hfig_ftc_module.ch2_stim_index_max;
hfig_ftc_module.ch2_stim_index_max = hfig_ftc_module.ch2_stim_index_max + 1;
freqs = [freqs 0];

stim_fieldnames = fieldnames(stimuli);
set(handles.listbox_ch2_stimuli,'String', stim_fieldnames)
set(handles.edit_ch2_intensity,'String', num2str('75'))

hfig_ftc_module.ch2.stimuli = stimuli;
hfig_ftc_module.ch2.stim_names = stim_fieldnames;
hfig_ftc_module.ch2.stim_freqs = freqs;
hfig_ftc_module.ch2.stim_time_short = 1/srate:1/srate:length(stimuli.(fname{i}))/srate;
hfig_ftc_module.ch2.stim_time = hfig_ftc_module.ch2.stim_time_short;


hfig_ftc_module.spike_thresh = 1.5;
%hfig_ftc_module.spike_thresh = hfig_ballgui.spike_counting.thresh;
set(handles.edit_spike_thresh, 'String', num2str(hfig_ftc_module.spike_thresh))
hfig_ftc_module.spike_direction = 0;
%hfig_ftc_module.spike_direction = hfig_ballgui.spike_counting.direction;
hfig_ftc_module.interspike_distance = 2.5;
hfig_ftc_module.time_window = 0;
hfig_ftc_module.ftc_type =1; 
hfig_ftc_module.filter = 1;
hfig_ftc_module.iftc = 0;
hfig_ftc_module.iftc_v2 = 0;

hfig_ftc_module.unit_bf = 5000;

% setup nidaq---------------------------------------------
hfig_ftc_module.nidaq.srate = 100000;
hfig_ftc_module.nidaq.s = daq.createSession('ni');
hfig_ftc_module.nidaq.s.Rate = hfig_ftc_module.nidaq.srate;
addAnalogOutputChannel(hfig_ftc_module.nidaq.s,'Dev2',[0,1],'Voltage');

%data capture
active_chan_input = [0,1];
addAnalogInputChannel(hfig_ftc_module.nidaq.s, 'Dev2', active_chan_input, 'Voltage');

set(handles.uipanel_channels, 'SelectedObject', handles.radiobutton_ch1)
if hfig_ftc_module.spike_direction==1
    set(handles.uipanel_pos_neg_spikes, 'SelectedObject', handles.radiobutton_positive)
else
    set(handles.uipanel_pos_neg_spikes, 'SelectedObject', handles.radiobutton_negative)
end
set(handles.uipanel_time_window, 'SelectedObject', handles.radiobutton_during_stim)

uipanel_channels_SelectionChangeFcn(hObject, [], handles)
% uipanel_pos_neg_spikes_SelectionChangeFcn(hObject, [], handles)
% uipanel_time_window_SelectionChangeFcn(hObject, eventdata, handles)
% listbox_stimuli_Callback(hObject, [], handles)
%edit_thres_inten_Callback(hObject, eventdata, handles)


%Initiate NIDAQ data capture
%chan = str2double(inputdlg('Which Analog Output Channel would you like to calibrate?','Analog Output Channel'));


try
   release(hfig_cal.nidaq.s)
end

try
   release(hfig_stimprog.nidaq.s)
end


set(handles.figure1,'CloseRequestFcn',@my_closereq)

% Choose default command line output for ftc_module_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ftc_module_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ftc_module_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox_ch1_stimuli.
function listbox_ch1_stimuli_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ch1_stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ch1_stimuli contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ch1_stimuli

global hfig_ftc_module
global srate

hfig_ftc_module.ch1.selected_index = get(handles.listbox_ch1_stimuli, 'Value');

freq_val = char(hfig_ftc_module.ch1.stim_names(hfig_ftc_module.ch1.selected_index));
hfig_ftc_module.ch1.current_stimulus.signal = (hfig_ftc_module.ch1.stimuli.(freq_val))*2;

hfig_ftc_module.ch1.current_stimulus.intensity = ...
    str2num(get(handles.edit_ch1_intensity, 'String'));

hfig_ftc_module.ch1.current_stimulus.freq = freq_val;

stim_time = 1/srate:1/srate:length(hfig_ftc_module.ch1.current_stimulus.signal)/srate;

plot(handles.axes_ch1_stimulus, stim_time, ...
    hfig_ftc_module.ch1.current_stimulus.signal);

xlim(handles.axes_ch1_stimulus, [stim_time(1) stim_time(end)])

edit_ch1_intensity_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function listbox_ch1_stimuli_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ch1_stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_single_shot.
function dat = pushbutton_single_shot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_single_shot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module
global dat_out

cla(handles.axes_response_1)

if hfig_ftc_module.playback_chan == 0
    current_stim_ID.ch1 = hfig_ftc_module.ch1.stim_names(hfig_ftc_module.ch1.selected_index); 
    set(handles.listbox_ch2_stimuli, 'Value', 18); %15 to select for silence when we tested freq up to 11k
    listbox_ch2_stimuli_Callback(hObject, [], handles)
    playback(:,1) = hfig_ftc_module.ch1.current_stimulus.signal';
    
    silence = zeros(length(hfig_ftc_module.ch1.current_stimulus.signal),1);
    
    playback(:,2) = silence';
elseif hfig_ftc_module.playback_chan == 1
    current_stim_ID.ch2 = hfig_ftc_module.ch1.stim_names(hfig_ftc_module.ch1.selected_index); 
    set(handles.listbox_ch1_stimuli, 'Value', 18); %15 to select for silence when we tested freq up to 11k
    listbox_ch2_stimuli_Callback(hObject, [], handles)
    playback(:,1) = hfig_ftc_module.ch1.current_stimulus.signal';
    playback(:,2) = hfig_ftc_module.ch2.current_stimulus.signal';
elseif hfig_ftc_module.playback_chan == 2
    current_stim_ID.ch1 = hfig_ftc_module.ch1.stim_names(hfig_ftc_module.ch1.selected_index); 
    current_stim_ID.ch2 = hfig_ftc_module.ch2.stim_names(hfig_ftc_module.ch2.selected_index); 
    playback(:,1) = hfig_ftc_module.ch1.current_stimulus.signal';
    playback(:,2) = hfig_ftc_module.ch2.current_stimulus.signal';
end

    queueOutputData(hfig_ftc_module.nidaq.s, playback);
    output = startForeground(hfig_ftc_module.nidaq.s);

[row col] = size(output);

time_data = 1/hfig_ftc_module.nidaq.srate:1/hfig_ftc_module.nidaq.srate:row/hfig_ftc_module.nidaq.srate;

plot(handles.axes_response_1, time_data, output(:,1), 'b');
xlim(handles.axes_response_1, [0, time_data(end)])
y_axis_limit = str2num(get(handles.edit_plot_axis_limit, 'string'));
ylim(handles.axes_response_1, [-y_axis_limit, y_axis_limit])

plot(handles.axes_response_2, time_data, output(:,2), 'r');
xlim(handles.axes_response_2, [0, time_data(end)])
% y_axis_limit = str2num(get(handles.edit_plot_axis_limit, 'string'));
% ylim(handles.axes_response_2, [-y_axis_limit, y_axis_limit])

drawnow

dat.trace= output;
dat.time = time_data';
dat.ch1.stimsrate = hfig_ftc_module.nidaq.srate;
dat.ch1.freq = hfig_ftc_module.ch1.current_stimulus.freq;
dat.ch1.intensity = hfig_ftc_module.ch1.current_stimulus.intensity;
dat.ch2.stimsrate = hfig_ftc_module.nidaq.srate;
dat.ch2.freq = hfig_ftc_module.ch2.current_stimulus.freq;
dat.ch2.intensity = hfig_ftc_module.ch2.current_stimulus.intensity;

dat_out.raw = dat;

function edit_ch1_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module

current_stim_ID = hfig_ftc_module.ch1.stim_names(hfig_ftc_module.ch1.selected_index);
[row, col] = find(strcmp(hfig_ftc_module.ch1.calibration, char(current_stim_ID)));

hfig_ftc_module.ch1.current_stimulus.intensity = str2num(get(handles.edit_ch1_intensity, 'String'));

if hfig_ftc_module.playback_chan == 0
    %control sound intensity
    current_intensity = str2num(get(handles.edit_ch1_intensity, 'String'));
    ref_dB_spl = cell2mat(hfig_ftc_module.ch1.calibration(row,1));
    adjust = abs(current_intensity - ref_dB_spl);
    if current_intensity > ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) - adjust;
    elseif current_intensity <ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) + adjust;
    else
        atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3));
    end
    
    invoke(hfig_ftc_module.TDT.PA5x1, 'SetAtten', atten);
elseif hfig_ftc_module.playback_chan ==2
    
    current_intensity = str2num(get(handles.edit_ch1_intensity, 'String'));
    ref_dB_spl = cell2mat(hfig_ftc_module.ch1.calibration(row,1));
    adjust = abs(current_intensity - ref_dB_spl);
    if current_intensity > ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) - adjust;
    elseif current_intensity <ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) + adjust;
    else
        atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3));
    end
    
    invoke(hfig_ftc_module.TDT.PA5x1, 'SetAtten', atten);
    
    current_intensity = str2num(get(handles.edit_ch2_intensity, 'String'));
    ref_dB_spl = cell2mat(hfig_ftc_module.ch2.calibration(row,1));
    adjust = abs(current_intensity - ref_dB_spl);
    if current_intensity > ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) - adjust;
    elseif current_intensity <ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) + adjust;
    elseif current_intensity == ref_dB_spl
        % get current atten and set to same atten
        current_atten = invoke(hfig_ftc_module.TDT.PA5x2, 'GetAtten');
        atten = current_atten;
    end
    
    invoke(hfig_ftc_module.TDT.PA5x2, 'SetAtten', atten);
    
end
        

% Hints: get(hObject,'String') returns contents of edit_ch1_intensity as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_intensity as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module
global dat_out

current_directory = cd;
data_directory = strcat(current_directory, char('\FTC data'));

if ~isdir(data_directory),
    mkdir(data_directory),
end

data_dir = datestr(now,29);
data_file = strcat(data_directory,'\', data_dir);

if ~isdir(strcat(data_directory,'\', data_dir)),
    mkdir(strcat(data_directory,'\', data_dir));
    
    data_file = strcat(data_directory,'\',data_dir,'\');
end

prompt = {'Enter Subject ID', 'Enter Unit Name'};
dlg_title = 'Save Information';
num_lines = 1;
animal_ID = get(handles.edit_animal_ID, 'String');
unit_ID = get(handles.edit_unit_ID, 'String');

def = {animal_ID, unit_ID};
answer = inputdlg(prompt, dlg_title, num_lines, def);

savefile = strcat(data_file,'\',answer{1}, '_', answer{2});
save(savefile, 'dat_out')

%dat_out = [];

% --- Executes on button press in pushbutton_abort.
function pushbutton_abort_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_abort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module

set(handles.pushbutton_abort, 'UserData', 1);

% --- Executes on button press in togglebutton_continuous.
function togglebutton_continuous_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_continuous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_continuous

global hfig_ftc_module
global srate

srate = 100000;
toggle_state = get(hObject, 'value');

if toggle_state ==1
    duration = length(hfig_ftc_module.ch2.current_stimulus.signal)/srate;
    hfig_ftc_module.timerobj = ...
        timer('TimerFcn', {@pushbutton_single_shot_Callback, handles}, ...
        'ExecutionMode', 'fixedRate', 'Period', duration + 0.5);
    start(hfig_ftc_module.timerobj)
else
    stop(hfig_ftc_module.timerobj)
    delete(hfig_ftc_module.timerobj)
    clear hfig_ftc_module.timerobj
end

guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel_channels.
function uipanel_channels_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_channels 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module
global srate

srate = 100000;

ch_select = get(handles.uipanel_channels, 'SelectedObject');

switch get(ch_select, 'Tag') 
    case 'radiobutton_ch1'
        hfig_ftc_module.playback_chan = 0; % sound
        set(handles.listbox_ch2_stimuli, 'Value', hfig_ftc_module.ch2_stim_index_max-1);
        listbox_ch2_stimuli_Callback(hObject, [], handles)
        invoke(hfig_ftc_module.TDT.PA5x2, 'SetAtten', 120);
    case 'radiobutton_ch2'
        hfig_ftc_module.playback_chan = 1; % vibration
        set(handles.listbox_ch1_stimuli, 'Value', hfig_ftc_module.ch1_stim_index_max-1);
        listbox_ch1_stimuli_Callback(hObject, [], handles)             
        invoke(hfig_ftc_module.TDT.PA5x1, 'SetAtten', 120);
    case 'radiobutton_both'
        hfig_ftc_module.playback_chan = 2;
        listbox_ch1_stimuli_Callback(hObject, [], handles)
        
end

% --- Executes on button press in pushbutton_load_cal.
function pushbutton_load_cal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_cal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module

[FileName,PathName] = uigetfile('*.xlsx','Select the Excel Calibration File');

[num,txt,ch1] = xlsread(strcat(PathName,FileName), 'ch1');
[num,txt,ch2] = xlsread(strcat(PathName,FileName), 'ch2');

hfig_ftc_module.ch1.calibration = ch1;
hfig_ftc_module.ch2.calibration = ch2;


% --- Executes when selected object is changed in uipanel_pos_neg_spikes.
function uipanel_pos_neg_spikes_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_pos_neg_spikes 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module

spike_direction = get(handles.uipanel_pos_neg_spikes, 'SelectedObject');

switch get(spike_direction, 'Tag') 
    case 'radiobutton_positive'
        hfig_ftc_module.spike_direction = 1; % spikes deflect in positive direciton
        %do something
    case 'radiobutton_negative'
        hfig_ftc_module.spike_direction = 0; % spikes deflect in negative direction
        %do something
end



function edit_spike_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_spike_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_spike_thresh as text
%        str2double(get(hObject,'String')) returns contents of edit_spike_thresh as a double

global hfig_ftc_module

hfig_ftc_module.spike_thresh = str2num(get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function edit_spike_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_spike_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_interspike_dist_Callback(hObject, eventdata, handles)
% hObject    handle to edit_interspike_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_interspike_dist as text
%        str2double(get(hObject,'String')) returns contents of edit_interspike_dist as a double

global hfig_ftc_module

hfig_ftc_module.interspike_distance = str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_interspike_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_interspike_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel_time_window.
function uipanel_time_window_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_time_window 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module

time_window = get(handles.uipanel_time_window, 'SelectedObject');

switch get(time_window, 'Tag') 
    case 'radiobutton_during_stim'
        hfig_ftc_module.time_window = 0; % only during stimulus
        %do something
    case 'radiobutton_during_and_post_stim'
        hfig_ftc_module.time_window = 1; % during and post stimulus
        %do something
end


function edit_bf_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bf as text
%        str2double(get(hObject,'String')) returns contents of edit_bf as a double

global hfig_ftc_module

hfig_ftc_module.unit_bf = str2num(get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function edit_bf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_thres_inten_Callback(hObject, eventdata, handles)
% hObject    handle to edit_thres_inten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_thres_inten as text
%        str2double(get(hObject,'String')) returns contents of edit_thres_inten as a double

global hfig_ftc_module

hfig_ftc_module.unit_bf_thresh = str2num(get(handles.edit_thres_inten, 'String'));
%fname = 'f_5000';
fname = strcat('f_', num2str(hfig_ftc_module.unit_bf));
current_stim_ID = fname;
[row, col] = find(strcmp(hfig_ftc_module.ch1.calibration, char(current_stim_ID)));
% 
% row = 12;
% 
% if hfig_ftc_module.playback_chan == 0
%     %control sound intensity
%     current_intensity = str2num(get(handles.edit_thres_inten, 'String'));
%     ref_dB_spl = cell2mat(hfig_ftc_module.ch1.calibration(row,1));
%     adjust = abs(current_intensity - ref_dB_spl);
%     if current_intensity > ref_dB_spl
%         atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) - adjust-10;
%     elseif current_intensity <ref_dB_spl
%         atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) + adjust-6-10;
%         % +3dB atten to account for splitting ao3 output between PA5x3 and PA5x4
%     else
%         atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) - 6-10;
%     end
%     
%     invoke(hfig_ftc_module.TDT.PA5x3, 'SetAtten', atten);
%     
% else
%     current_intensity = str2num(get(handles.edit_thres_inten, 'String'));
%     ref_dB_spl = cell2mat(hfig_ftc_module.ch2.calibration(row,1));
%     adjust = abs(current_intensity - ref_dB_spl);
%     if current_intensity > ref_dB_spl
%         atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) - adjust-10;
%     elseif current_intensity <ref_dB_spl
%         atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) + adjust-6-10;
%     else
%         atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) - 6-10;
%     end
%         
%     invoke(hfig_ftc_module.TDT.PA5x4, 'SetAtten', atten);
% 
% end


% --- Executes during object creation, after setting all properties.
function edit_thres_inten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_thres_inten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_eFreq_Resp_Map.
function pushbutton_eFreq_Resp_Map_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_eFreq_Resp_Map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module
global hfig_ballgui
global dat_out
global dat
global hfig_ftc_module_plot
global playback_sequence
global srate

start = 0.01*srate;
stop =  fix((0.01+0.1)*srate);

dat_out = [];
dat = [];
% initialize variables
warning off

hfig_ftc_module.fhandles_single_shot = @pushbutton_single_shot_Callback;
repetitions =1;
flag = [];
playback_sequence = [];

% ftc_module_plot
% cla(hfig_ftc_module_plot.handles.axes_ftc_plot)

%Determine matrix of frequency/stimulus intensity combinations

if hfig_ftc_module.playback_chan ==0
    
    intensity_values = 20:2.5:90;
    intensity_values = intensity_values';
    freq_values = hfig_ftc_module.ch1.stim_freqs;
    freq_values = freq_values';
    
    % Select correct speaker-specific stimuli
   
    freq_names = fieldnames(hfig_ftc_module.ch1.stimuli);
       
    tic
    
    % Make random sequence for two-tone stimuli
    % two_tone_stimuli = [900 2700 3600];
    % playback_sequence_two_tone = combvec(intensity_values', two_tone_stimuli);
    % playback_sequence_two_tone = playback_sequence_two_tone';
    
    rand_sequence = randperm(length(playback_sequence));
    playback_sequence = playback_sequence(rand_sequence,:);
    
    % remove 900 and 2700 from previous playback list.
    % new_freq_values = freq_values(or(freq_values~=900, freq_values~=2700));
    % new_freq_values = new_freq_values(new_freq_values~=-1);
    
    %playback_sequence = combvec(intensity_values', freq_values');
    playback_sequence = allcomb(intensity_values', freq_values');
    playback_sequence = playback_sequence;
    
    rand_sequence = randperm(length(playback_sequence));
    playback_sequence = playback_sequence(rand_sequence,:);
    
    all_playback_sequence  = [playback_sequence];
    playback_sequence_num = 1:length(all_playback_sequence);
    playback_sequence_num = playback_sequence_num';
    set(handles.listbox_ch1_index, 'String', playback_sequence_num)
    stim_names = num2str(all_playback_sequence(:,2));
    
    [row col] = size(stim_names);
    
    set(handles.listbox_ch1_frequency, 'String', num2str(stim_names))
    set(handles.listbox_ch1_intensity, 'String', num2str(all_playback_sequence(:,1)))
    
    for i = 1:length(all_playback_sequence)
        
        set(handles.listbox_ch1_index, 'value', i)
        set(handles.listbox_ch1_frequency, 'value',i)
        set(handles.listbox_ch1_intensity, 'value',i)
        
        %intensity_name = strcat('dB_', num2str(playback_sequence(i,1)));
        intensity_name = strcat('intensity_', num2str(all_playback_sequence(i,1)));
        %set(handles.edit_ch1_intensity, 'string', num2str(playback_sequence(i,1)));
        set(handles.edit_ch1_intensity, 'string', num2str(all_playback_sequence(i,1)));
        edit_ch1_intensity_Callback(hObject, eventdata, handles)
        
        ind = find(freq_values==all_playback_sequence(i,2));
        
        set(handles.listbox_ch1_stimuli, 'Value', ind);
        listbox_ch1_stimuli_Callback(hObject, [], handles)
        
        temp_resp = [];
        
        ax = [handles.axes_ch1_stimulus handles.axes_response_1];
        linkaxes(ax, 'x');
        
        
        for k = 1:repetitions
            %pause(0.2)
            
            if strfind(intensity_name, '.')~=0
                intensity_name = strrep(intensity_name,'.','_')
            end
            
            dat.(char(freq_names(ind))).(intensity_name){k} = ...
                hfig_ftc_module.fhandles_single_shot(hObject, eventdata, handles);
            
            axes(handles.axes_response_1)
            hold on
            
            % Measure evoked spike rate
            if hfig_ftc_module.spike_direction == 0
                if hfig_ftc_module.time_window == 0
                    [pks_evoked, locs_evoked] = findpeaks(-(dat.(char(freq_names(ind))).(intensity_name){k}.trace(start:stop)), 'minpeakheight', abs(hfig_ftc_module.spike_thresh));
                else
                    [pks_evoked, locs_evoked] = findpeaks(-(dat.(char(freq_names(ind))).(intensity_name){k}.trace(start:end)), 'minpeakheight', abs(hfig_ftc_module.spike_thresh));
                end
                
                evoked_spikes = length(pks_evoked);
                locs_evoked = locs_evoked+start;
                plot(handles.axes_response_1, dat.(char(freq_names(ind))).(intensity_name){k}.time(locs_evoked), -pks_evoked, 'ob');
                xlim([0 dat.(char(freq_names(ind))).(intensity_name){k}.time(end)])
                hold off
                
            else
                if hfig_ftc_module.time_window == 0
                    [pks_evoked, locs_evoked] = findpeaks((dat.(char(freq_names(ind))).(intensity_name){k}.trace(start:stop)), 'minpeakheight', hfig_ftc_module.spike_thresh);
                else
                    [pks_evoked, locs_evoked] = findpeaks((dat.(char(freq_names(ind))).(intensity_name){k}.trace(start:end)), 'minpeakheight', hfig_ftc_module.spike_thresh);
                end
                
                evoked_spikes = length(pks_evoked);
                locs_evoked = locs_evoked+start;
                plot(handles.axes_response_1, dat.(char(freq_names(ind))).(intensity_name){k}.time(locs_evoked), pks_evoked, 'ob');
                xlim([0 dat.(char(freq_names(ind))).(intensity_name){k}.time(end)])
                hold off
                
            end
            
            %temp_resp = [temp_resp evoked_spikes];
            
            pause(0.0001)
            if get(handles.pushbutton_abort, 'UserData') ==1
                set(handles.pushbutton_abort, 'UserData',0)
                flag =1;
                break
            end
            
        end
        
        %dat.(char(freq_names(ind))).(intensity_name){k+1} = mean(temp_resp);
        
        if flag==1
            break
        end
        
        
        
        if flag==1
            break
        end
        
    end
    
    toc
    
    freq_names = flipud(freq_names);
    dat = orderfields(dat, freq_names);
    
    %reorder intensities
    for i = 1:length(freq_names)
        dat.(char(freq_names(i))) = orderfields(dat.(char(freq_names(i))));
    end
    
    dat_out.raw = dat;
    dat_out.playback_sequence = playback_sequence;
    
    % Call frequency response plot function here.
    start = 0.02*srate;
    stop =  fix((0.02+0.05+0.05)*srate);
    %freq_response_map(dat_out.raw,hfig_ballgui.spike_counting.thresh, hfig_ballgui.spike_counting.direction, start, stop)
elseif hfig_ftc_module.playback_chan == 1
    intensity_values = 20:2.5:90;
    %intensity_values = [0.125 0.25 0.5 1.0 2 2.5 3.75 5 7.5 10];
    intensity_values = intensity_values';
    freq_values = hfig_ftc_module.ch2.stim_freqs;
    freq_values = freq_values';
    
    % Select correct speaker-specific stimuli
   
    freq_names = fieldnames(hfig_ftc_module.ch2.stimuli);
       
    tic
    
    % Make random sequence for two-tone stimuli
    % two_tone_stimuli = [900 2700 3600];
    % playback_sequence_two_tone = combvec(intensity_values', two_tone_stimuli);
    % playback_sequence_two_tone = playback_sequence_two_tone';
    
    rand_sequence = randperm(length(playback_sequence));
    playback_sequence = playback_sequence(rand_sequence,:);
    
    % remove 900 and 2700 from previous playback list.
    % new_freq_values = freq_values(or(freq_values~=900, freq_values~=2700));
    % new_freq_values = new_freq_values(new_freq_values~=-1);
    
    playback_sequence = combvec(intensity_values', freq_values');
    playback_sequence = playback_sequence';
    
    rand_sequence = randperm(length(playback_sequence));
    playback_sequence = playback_sequence(rand_sequence,:);
    
    all_playback_sequence  = [playback_sequence];
    playback_sequence_num = 1:length(all_playback_sequence);
    playback_sequence_num = playback_sequence_num';
    set(handles.listbox_ch2_index, 'String', playback_sequence_num)
    stim_names = num2str(all_playback_sequence(:,2));
    
    [row col] = size(stim_names);
    
    set(handles.listbox_ch2_frequency, 'String', num2str(stim_names))
    set(handles.listbox_ch2_intensity, 'String', num2str(all_playback_sequence(:,1)))
    
    for i = 1:length(all_playback_sequence)

        set(handles.listbox_ch2_index, 'value', i)
        set(handles.listbox_ch2_frequency, 'value',i)
        set(handles.listbox_ch2_intensity, 'value',i)
        
        %intensity_name = strcat('dB_', num2str(playback_sequence(i,1)));
        intensity_name = strcat('dB_', num2str(all_playback_sequence(i,1)));
        intensity_name = matlab.lang.makeValidName(intensity_name);
        %set(handles.edit_ch1_intensity, 'string', num2str(playback_sequence(i,1)));
        set(handles.edit_ch2_intensity, 'string', num2str(all_playback_sequence(i,1)));
        edit_ch2_intensity_Callback(hObject, eventdata, handles)
        
        ind = find(freq_values==all_playback_sequence(i,2));
        
        set(handles.listbox_ch2_stimuli, 'Value', ind);
        listbox_ch2_stimuli_Callback(hObject, [], handles)
        
        temp_resp = [];
        
        ax = [handles.axes_ch2_stimulus handles.axes_response_1];
        linkaxes(ax, 'x');
        
        
        for k = 1:repetitions
            %pause(0.2)
            
            dat.(char(freq_names(ind))).(intensity_name){k} = ...
                hfig_ftc_module.fhandles_single_shot(hObject, eventdata, handles);
            
            axes(handles.axes_response_1)
            hold on
            
            % Measure evoked spike rate
            if hfig_ftc_module.spike_direction == 0
                if hfig_ftc_module.time_window == 0
                    [pks_evoked, locs_evoked] = findpeaks(-(dat.(char(freq_names(ind))).(intensity_name){k}.trace(start:stop)), 'minpeakheight', abs(hfig_ftc_module.spike_thresh));
                else
                    [pks_evoked, locs_evoked] = findpeaks(-(dat.(char(freq_names(ind))).(intensity_name){k}.trace(start:end)), 'minpeakheight', abs(hfig_ftc_module.spike_thresh));
                end
                
                evoked_spikes = length(pks_evoked);
                locs_evoked = locs_evoked+start;
                plot(handles.axes_response_1, dat.(char(freq_names(ind))).(intensity_name){k}.time(locs_evoked), -pks_evoked, 'ob');
                xlim([0 dat.(char(freq_names(ind))).(intensity_name){k}.time(end)])
                hold off
                
            else
                if hfig_ftc_module.time_window == 0
                    [pks_evoked, locs_evoked] = findpeaks((dat.(char(freq_names(ind))).(intensity_name){k}.trace(start:stop)), 'minpeakheight', hfig_ftc_module.spike_thresh);
                else
                    [pks_evoked, locs_evoked] = findpeaks((dat.(char(freq_names(ind))).(intensity_name){k}.trace(start:end)), 'minpeakheight', hfig_ftc_module.spike_thresh);
                end
                
                evoked_spikes = length(pks_evoked);
                locs_evoked = locs_evoked+start;
                plot(handles.axes_response_1, dat.(char(freq_names(ind))).(intensity_name){k}.time(locs_evoked), pks_evoked, 'ob');
                xlim([0 dat.(char(freq_names(ind))).(intensity_name){k}.time(end)])
                hold off
                
            end
            
            %temp_resp = [temp_resp evoked_spikes];
            
            pause(0.0001)
            if get(handles.pushbutton_abort, 'UserData') ==1
                set(handles.pushbutton_abort, 'UserData',0)
                flag =1;
                break
            end
            
        end
        
        %dat.(char(freq_names(ind))).(intensity_name){k+1} = mean(temp_resp);
        
        if flag==1
            break
        end
        
        
        
        if flag==1
            break
        end
        
    end
    
    toc
    
    freq_names = flipud(freq_names);
    dat = orderfields(dat, freq_names);
    
    %reorder intensities
    for i = 1:length(freq_names)
        dat.(char(freq_names(i))) = orderfields(dat.(char(freq_names(i))));
    end
    
    dat_out.raw = dat;
    dat_out.playback_sequence = playback_sequence;
    
    % Call frequency response plot function here.
    start = 0.02*srate;
    stop =  fix((0.02+0.05+0.05)*srate);
    %freq_response_map(dat_out.raw,hfig_ballgui.spike_counting.thresh, hfig_ballgui.spike_counting.direction, start, stop)
end


function output = freq_response_map(data,thresh, direction, start, stop)

global srate

% thresh = 1.25;
% direction = 1; % 1 = positive, 0 = negative;
% 
% start = 0.02*44100;
% stop =  fix((0.02+0.05+0.05)*44100);

% read in raw data

% all_data = load('D:\Users\Norman Lee\Documents\MATLAB\Hcin_NSF_Nphys_AIM2_Exp3\FTC data\2015-06-10\Hcin013_test_unit1.mat');
% data = all_data.dat_out.raw;

frequencies = fieldnames(data);

max_val = [];
min_val = [];

for i = 1:length(frequencies)

    intensities = fieldnames(data.(char(frequencies(i))));
    
    for j = 1:length(intensities)
        
        % count spikes for stimulus presentation
        
        spikes = [];
        
        [row col] = size(data.(char(frequencies(i))).(char(intensities(j))));
        
        for k = 1:col
            
            time = data.(char(frequencies(i))).(char(intensities(j))){k}.time;
            dat = data.(char(frequencies(i))).(char(intensities(j))){k}.trace;
            
            max_val = [max_val max(dat)];
            min_val = [min_val min(dat)];
            
            figure(20)
            plot(gca,time,dat)
                     
            hold on
            
            line([time(start) time(start)], [-2 2], 'Color', 'r', 'LineStyle', '--')
            line([time(fix((0.02+0.05)*srate)) time(fix((0.02+0.05)*srate))], [-2 2], 'Color', 'r', 'LineStyle', '--')
            
            %Count Spikes
            
            if direction==1
                [pks loc] = findpeaks(dat(start:stop), 'minpeakheight', thresh);
                %[pks loc] = findpeaks(dat(start:end), 'minpeakheight', thresh);
                loc = loc+start;
                               
                if isempty(pks)
                    spikes = [spikes 0];
                else
                    spikes = [spikes length(pks)];
                end
                
                plot(time(loc), pks, 'or')
                
                hold off
                
            else
                [pks loc] = findpeaks(-dat(start:stop), 'minpeakheight', thresh);
                %[pks loc] = findpeaks(-dat(start:end), 'minpeakheight', thresh);
                loc = loc+start;
                
                if isempty(pks)
                    spikes = [spikes 0];
                else
                    spikes = [spikes length(pks)];
                end
                
                plot(time(loc), -pks, 'or')
                
                hold off
                
            end
            
            hold on
            
            %pause
            drawnow
            hold off
            
            locs.(char(frequencies(i))).(char(intensities(j))){k} = loc;
            
        end
        
        spike_counts.(char(frequencies(i))).(char(intensities(j))) =...
            spikes;
        
    end

    max_val = [];
    min_val = [];
end

labels.x = [];
labels.y = [];

for i = 2:length(frequencies)
    
    for j = 1:length(intensities)
        
        mean_spikes.(char(frequencies(i))).(char(intensities(j))) =...
            mean(spike_counts.(char(frequencies(i))).(char(intensities(j))));
        
        mean_spikes_all(i-1,j) = mean_spikes.(char(frequencies(i))).(char(intensities(j)));
        
        labels.x{j} = intensities(j);
        
    end
    
    labels.y{i-1}= frequencies(i);
    
end

% create labels
x_labels = [];
y_labels = [];

for i = 1:10
    x_labels = [x_labels labels.x{i}];
end

for i = 1:14
    y_labels = [y_labels labels.y{i}];
end 
    
labels.x = x_labels;
labels.y = y_labels;

output.x = 20:5:90;
output.y = [544, 647, 769, 915, 1088, 1294, 1538, 1830, 2176, 2588, 3077, 3660, 4352, 5000];

output.raw_data.time = time;
output.raw_data.values = data;
output.locs.time = time;
output.locs.values = locs;
output.labels = labels;
output.spike_counts = spike_counts;
output.mean_spike_counts_all = mean_spikes_all;

x = linspace(20, 90, 100);
y = linspace(544, 5000, 100);
[Xq Yq] = meshgrid(x,y);

figure(100)

Vq = interp2(output.x,output.y,output.mean_spike_counts_all,Xq,Yq);
output.surf_plot.mean_spikes.Xq = Xq;
output.surf_plot.mean_spikes.Yq = Yq;
output.surf_plot.mean_spikes.Vq = Vq;

surf(Xq, Yq, Vq, 'EdgeColor', 'none');
view([90 270])

set(gca,'YScale','log');
set(gca,'ytick',[500 800 1000 1500 2000 2500 3500 5000],'yticklabel',[500 800 1000 1500 2000 2500 3500 5000])
set(gca, 'ylim', [500 5000])


% --- Executes on button press in pushbutton_eFTC_v2.
function pushbutton_eFTC_v2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_eFTC_v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_eFTC_v2

global hfig_ftc_module
global dat_out
global hfig_ftc_module_plot
global playback_sequence
global srate

warning off
srate = 100000

cla(handles.axes_response_1)
%start = 0.02*srate;
start = 0.01*srate; %signal starts at 10 ms.
stop =  fix((0.01+0.1)*srate);

ipi = 50;

hfig_ftc_module.fhandles_single_shot = @pushbutton_single_shot_Callback;
tuning_curve_dat = [];
tuning_curve_dat.values = [];
trace_num = 0;
tuning_curve.threshold = [];
playback_sequence = [];

tic

if hfig_ftc_module.playback_chan ==0
    freq_names = fieldnames(hfig_ftc_module.filtered_stimuli.left);
else
    freq_names = fieldnames(hfig_ftc_module.filtered_stimuli.right);
end

freq_values = hfig_ftc_module.stim_freqs;
%remove unwanted stimuli.
freq_values = freq_values(freq_values~=900);
freq_values = freq_values(freq_values~=2700);
freq_values = freq_values(freq_values~=0);
% freq_values = freq_values(freq_values~=-1);


%rand_sequence = randperm(length(freq_values));
rand_sequence = randperm(length(freq_values));

playback_sequence = freq_values(rand_sequence);

ind = find(strcmp(freq_names,'f_900')==1);
freq_names(ind) = [];
ind = find(strcmp(freq_names,'f_2700')==1);
freq_names(ind) = [];
% ind = find(strcmp(freq_names,'silence')==1);
% freq_names(ind) = []; 
% ind = find(strcmp(freq_names,'both')==1);
% freq_names(ind) = [];



playback_sequence_text = freq_names(rand_sequence);
set(handles.listbox_ch1_frequency, 'String', playback_sequence_text)
index_text = 1:length(playback_sequence);
index_text = num2str(index_text');
set(handles.listbox_ch1_index, 'String', index_text)

dat = [];

for i =1:length(playback_sequence)
    threshold = [];

    %Adaptive Tracking procedure

    dB_step_size = 10;
    previous_response = [];
    reversal = 0;
    spl_vals = [];
    response = [];

    set(handles.edit_ch1_intensity, 'string', num2str(50))
    edit_intensity_Callback(hObject, eventdata, handles)
    
    search_freq = strcat('f_', num2str(playback_sequence(i)));
    freq_list = get(handles.listbox_ch1_stimuli, 'string');
    ix = strfind(freq_list, char(search_freq));
    ind = cellfun('isempty', ix);
    ind = find(ind==0);
    %ind = find(freq_values==playback_sequence(i));
    set(handles.listbox_ch1_stimuli, 'Value', ind);
    listbox_stimuli_Callback(hObject, [], handles)
    set(handles.listbox_ch1_index, 'Value', i)
    set(handles.listbox_ch1_frequency, 'Value', i)
    set(handles.listbox_ch1_intensity, 'string', num2str(55))
   
    pause(0.0001)
    if get(handles.pushbutton_abort, 'UserData') ==1
        set(handles.pushbutton_abort, 'UserData',0)
        break
    end
    
    count = 0;
    

    while isempty(threshold)==1

        pause(0.0001)
        if get(handles.pushbutton_abort, 'UserData') ==1
            set(handles.pushbutton_abort, 'UserData',0)
            break
        end

        pause(0.0001)
        intensity_value  = get(handles.edit_ch1_intensity, 'string');        
        remainder = mod(intensity_value,2);
        
        if str2num(intensity_value(end-1:end))==0.5
            intensity_name = strcat('dB_', intensity_value(1:end-2), '_5');
        else
            intensity_name = strcat('dB_', intensity_value);
        end
        
        if ~isempty(dat)
            if isfield(dat, playback_sequence_text(i))
                if isfield(dat.(char(playback_sequence_text(i))), (intensity_name))
                    count = count+1;
                    intensity_name = strcat('dB_', intensity_value, '_', num2str(count));
                end                
            end
        end
        
        for k = 1:4

            dat.(char(playback_sequence_text(i))).(intensity_name){k} = hfig_ftc_module.fhandles_single_shot(hObject, eventdata, handles);
            trace_num = trace_num+1;
            
            axes(handles.axes_response_1)
            hold on
            
            pause(0.001)

            % Measure evoked spike rate
            if hfig_ftc_module.spike_direction == 0
                if hfig_ftc_module.time_window == 0
                    [pks_evoked, locs_evoked] = findpeaks(-(dat.(char(playback_sequence_text(i))).(intensity_name){k}.trace(start:stop)), 'minpeakheight', abs(hfig_ftc_module.spike_thresh));
                else
                    [pks_evoked, locs_evoked] = findpeaks(-(dat.(char(playback_sequence_text(i))).(intensity_name){k}.trace(start:end)), 'minpeakheight', abs(hfig_ftc_module.spike_thresh));
                end

                evoked_spikes = length(pks_evoked);
                all_reps_evoked_spikes{k} = evoked_spikes; 
                locs_evoked = locs_evoked+start;
                plot(handles.axes_response_1, dat.(char(playback_sequence_text(i))).(intensity_name){k}.time(locs_evoked), -pks_evoked, 'ob');
                xlim(handles.axes_response_1, [0 dat.(char(playback_sequence_text(i))).(intensity_name){k}.time(end)])
                y_axis_limit = str2num(get(handles.edit_plot_axis_limit, 'string'));
                ylim(handles.axes_response_1, [-y_axis_limit, y_axis_limit])
                drawnow                
                hold off
                
                dat.(char(playback_sequence_text(i))).(intensity_name){k}.evoked_spikes = evoked_spikes;
                dat.(char(playback_sequence_text(i))).(intensity_name){k}.locs = locs_evoked;

            else
                if hfig_ftc_module.time_window == 0
                    [pks_evoked, locs_evoked] = findpeaks((dat.(char(playback_sequence_text(i))).(intensity_name){k}.trace(start:stop)), 'minpeakheight', hfig_ftc_module.spike_thresh);
                else
                    [pks_evoked, locs_evoked] = findpeaks((dat.(char(playback_sequence_text(i))).(intensity_name){k}.trace(start:end)), 'minpeakheight', hfig_ftc_module.spike_thresh);
                end

                evoked_spikes = length(pks_evoked);
                all_reps_evoked_spikes{k} = evoked_spikes;
                locs_evoked = locs_evoked+start;
                plot(handles.axes_response_1, dat.(char(playback_sequence_text(i))).(intensity_name){k}.time(locs_evoked), pks_evoked, 'ob');
                xlim(handles.axes_response_1, [0 dat.(char(playback_sequence_text(i))).(intensity_name){k}.time(end)])
                y_axis_limit = str2num(get(handles.edit_plot_axis_limit, 'string'));
                ylim(handles.axes_response_1, [-y_axis_limit, y_axis_limit])
                drawnow
                drawnow
                hold off
                
                dat.(char(playback_sequence_text(i))).(intensity_name){k}.evoked_spikes = evoked_spikes;
                dat.(char(playback_sequence_text(i))).(intensity_name){k}.locs = locs_evoked;

            end
        
        end
        
        idx = find(cell2mat(all_reps_evoked_spikes) ==0);
        
        if length(idx)>1
            %no response - increase sound intensity
            current_response = 'N';
            
        else % yes response - decrease sound intensity
            current_response = 'Y';
        end
                   
        %check for reversal
        
        if reversal ==2 % time to exit loop
            response = [response current_response];
            SPL = hfig_ftc_module.current_stimulus.intensity;
            spl_vals = [spl_vals SPL];
            
            ind_Y = find(response=='Y', 1, 'last');
            ind_N = find(response=='N', 1, 'last');
            
            UB = spl_vals(ind_Y);
            LB = spl_vals(ind_N);
            threshold = 10*log10((10^(UB/10)+10^(LB/10))/2);
        end

        if isempty(previous_response)==1
            previous_response = current_response;
            response = [response current_response];
            
            SPL = hfig_ftc_module.current_stimulus.intensity;
            spl_vals = [spl_vals SPL];

            if strcmp(current_response, 'Y') ==1
                SPL = SPL-dB_step_size;
                set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                edit_intensity_Callback(hObject, eventdata, handles)
            else
                SPL = SPL+dB_step_size;
                if SPL >95
                    threshold = 95;
                else
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                end
            end

        elseif strcmp(previous_response, current_response) ~=1 % Reversal Occured
            
            previous_response = current_response;
            
            % reduce step size. if down then test up by 1/2 step size. if
            % up then test down by 1/2 step size.            

            reversal = reversal +1;
            response = [response current_response];
            
            SPL = hfig_ftc_module.current_stimulus.intensity;
            spl_vals = [spl_vals, SPL];

            if reversal == 1
                
                dB_step_size = 5;
                
                if strcmp(current_response, 'Y') ==1
                    SPL = SPL-dB_step_size;
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                else
                    SPL = SPL+dB_step_size;
                    if SPL >95
                        threshold = 95;
                    else
                        set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                        edit_intensity_Callback(hObject, eventdata, handles)
                    end
                end
            else
                if reversal == 2
                    dB_step_size = 2.5;                                                            
                elseif reversal ==3;
                    dB_step_size = 1;
                end
                  

                if strcmp(current_response, 'Y') ==1
                    SPL = SPL-dB_step_size;
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                else
                    SPL = SPL+dB_step_size;
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                end
            end

        else % no reversal - continue incrementing or decrementing
            previous_response = current_response;
            response = [response current_response];
            SPL =  hfig_ftc_module.current_stimulus.intensity;
            spl_vals = [spl_vals, SPL];

            if strcmp(current_response, 'Y') ==1
                SPL = SPL-dB_step_size;
                set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                edit_intensity_Callback(hObject, eventdata, handles)
            else
                SPL = SPL+dB_step_size;
                if SPL >95
                    threshold = 95
                else
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                end
            end

        end
    end
    
    dat.(char(playback_sequence_text(i))).response = response(1:end-1);

    %tuning_curve.data.(char(freq_names(ind))) = dat.(char(freq_names(ind)));
    tuning_curve.threshold = [tuning_curve.threshold; hfig_ftc_module.stim_freqs(ind) threshold];
        
    axes(hfig_ftc_module_plot.handles.axes_ftc_plot)
    hold on
    plot(hfig_ftc_module_plot.handles.axes_ftc_plot,hfig_ftc_module.stim_freqs(ind), threshold, '.', 'MarkerSize', 15)
    hold off
end
toc

dat_out.raw = dat;
dat_out.tuning_curve = tuning_curve;
dat_out.playback_sequence = playback_sequence;



% --- Executes on selection change in listbox_ch1_index.
function listbox_ch1_index_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ch1_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ch1_index contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ch1_index


% --- Executes during object creation, after setting all properties.
function listbox_ch1_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ch1_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_ch1_frequency.
function listbox_ch1_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ch1_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ch1_frequency contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ch1_frequency


% --- Executes during object creation, after setting all properties.
function listbox_ch1_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ch1_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_ch1_intensity.
function listbox_ch1_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ch1_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ch1_intensity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ch1_intensity


% --- Executes during object creation, after setting all properties.
function listbox_ch1_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ch1_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_single_FTv2.
function pushbutton_single_FTv2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_single_FTv2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module
global dat_out
global hfig_ftc_module_plot
global playback_sequence

warning off
srate = 100000

start = 0.01*srate;
stop =  fix((0.01+0.1)*srate);

ipi = 50;

hfig_ftc_module.fhandles_single_shot = @pushbutton_single_shot_Callback;
tuning_curve_dat = [];
tuning_curve_dat.values = [];
trace_num = 0;
tuning_curve.threshold = [];

ftc_module_plot

tic

if hfig_ftc_module.playback_chan ==0
    freq_names = fieldnames(hfig_ftc_module.filtered_stimuli.left);
else
    freq_names = fieldnames(hfig_ftc_module.filtered_stimuli.right);
end

freq_values = hfig_ftc_module.stim_freqs;

playback_ind = get(handles.listbox_ch1_index, 'value');
playback_sequence_text = get(handles.listbox_ch1_frequency, 'string');

dat = [];
for i = playback_ind
    
    threshold = [];

    %Adaptive Tracking procedure

    dB_step_size = 10;
    previous_response = [];
    reversal = 0;
    spl_vals = [];
    response = [];

    set(handles.edit_ch1_intensity, 'string', num2str(55))
    edit_intensity_Callback(hObject, eventdata, handles)
    
    ind = find(freq_values==playback_sequence(i));
    set(handles.listbox_ch1_stimuli, 'Value', ind);
    listbox_stimuli_Callback(hObject, [], handles)
    set(handles.listbox_ch1_index, 'Value', i)
    set(handles.listbox_ch1_frequency, 'Value', i)
    set(handles.listbox_ch1_intensity, 'string', num2str(50))
   
    pause(0.0001)
    if get(handles.pushbutton_abort, 'UserData') ==1
        set(handles.pushbutton_abort, 'UserData',0)
        break
    end
    
    count = 0;
    

    while isempty(threshold)==1

        pause(0.0001)
        if get(handles.pushbutton_abort, 'UserData') ==1
            set(handles.pushbutton_abort, 'UserData',0)
            break
        end

        %pause(1)
        intensity_value  = get(handles.edit_ch1_intensity, 'string');
        remainder = mod(intensity_value,2);
        
        if str2num(intensity_value(end-1:end))==0.5
            intensity_name = strcat('dB_', intensity_value(1:end-2), '_5');
        else
            intensity_name = strcat('dB_', intensity_value);
        end
        
        if ~isempty(dat)
            if isfield(dat, (char(playback_sequence_text(i))))
                if isfield(dat.(char(playback_sequence_text(i))), (intensity_name))
                    count = count+1;
                    intensity_name = strcat('dB_', intensity_value, '_', num2str(count));
                end                
            end                  
        end
        
        for k = 1:4

            dat.(char(playback_sequence_text(i))).(intensity_name){k} = hfig_ftc_module.fhandles_single_shot(hObject, eventdata, handles);
            trace_num = trace_num+1;
            
            axes(handles.axes_response_1)
            hold on
            
            pause(0.001)

            % Measure evoked spike rate
            if hfig_ftc_module.spike_direction == 0
                if hfig_ftc_module.time_window == 0
                    [pks_evoked, locs_evoked] = findpeaks(-(dat.(char(playback_sequence_text(i))).(intensity_name){k}.trace(start:stop)), 'minpeakheight', abs(hfig_ftc_module.spike_thresh));
                else
                    [pks_evoked, locs_evoked] = findpeaks(-(dat.(char(playback_sequence_text(i))).(intensity_name){k}.trace(start:end)), 'minpeakheight', abs(hfig_ftc_module.spike_thresh));
                end

                evoked_spikes = length(pks_evoked);
                all_reps_evoked_spikes{k} = evoked_spikes; 
                locs_evoked = locs_evoked+start;
                plot(handles.axes_response_1, dat.(char(playback_sequence_text(i))).(intensity_name){k}.time(locs_evoked), -pks_evoked, 'ob');
                xlim(handles.axes_response_1, [0 dat.(char(playback_sequence_text(i))).(intensity_name){k}.time(end)])
                y_axis_limit = str2num(get(handles.edit_plot_axis_limit, 'string'));
                ylim(handles.axes_response_1, [-y_axis_limit, y_axis_limit])
                drawnow
                hold off

                
                dat.(char(playback_sequence_text(i))).(intensity_name){k}.evoked_spikes = evoked_spikes;
                dat.(char(playback_sequence_text(i))).(intensity_name){k}.locs = locs_evoked;

            else
                if hfig_ftc_module.time_window == 0
                    [pks_evoked, locs_evoked] = findpeaks((dat.(char(playback_sequence_text(i))).(intensity_name){k}.trace(start:stop)), 'minpeakheight', hfig_ftc_module.spike_thresh);
                else
                    [pks_evoked, locs_evoked] = findpeaks((dat.(char(playback_sequence_text(i))).(intensity_name){k}.trace(start:end)), 'minpeakheight', hfig_ftc_module.spike_thresh);
                end

                evoked_spikes = length(pks_evoked);
                all_reps_evoked_spikes{k} = evoked_spikes;
                locs_evoked = locs_evoked+start;
                plot(handles.axes_response_1, dat.(char(playback_sequence_text(i))).(intensity_name){k}.time(locs_evoked), pks_evoked, 'ob');
                xlim(handles.axes_response_1, [0 dat.(char(playback_sequence_text(i))).(intensity_name){k}.time(end)])
                y_axis_limit = str2num(get(handles.edit_plot_axis_limit, 'string'));
                ylim(handles.axes_response_1, [-y_axis_limit, y_axis_limit])
                drawnow
                hold off
                
                dat.(char(playback_sequence_text(i))).(intensity_name){k}.evoked_spikes = evoked_spikes;
                dat.(char(playback_sequence_text(i))).(intensity_name){k}.locs = locs_evoked;

            end
        
        end
        
        idx = find(cell2mat(all_reps_evoked_spikes) ==0);
        
        if length(idx)>1
            %no response - increase sound intensity
            current_response = 'N';
            
        else % yes response - decrease sound intensity
            current_response = 'Y';
        end
                   
        %check for reversal
        
        if reversal ==2 % time to exit loop
            response = [response current_response];
            SPL = hfig_ftc_module.current_stimulus.intensity;
            spl_vals = [spl_vals SPL];
            
            ind_Y = find(response=='Y', 1, 'last');
            ind_N = find(response=='N', 1, 'last');
            
            UB = spl_vals(ind_Y);
            LB = spl_vals(ind_N);
            threshold = 10*log10((10^(UB/10)+10^(LB/10))/2);
        end

        if isempty(previous_response)==1
            previous_response = current_response;
            response = [response current_response];
            
            SPL = hfig_ftc_module.current_stimulus.intensity;
            spl_vals = [spl_vals SPL];

            if strcmp(current_response, 'Y') ==1
                SPL = SPL-dB_step_size;
                set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                edit_intensity_Callback(hObject, eventdata, handles)
            else
                SPL = SPL+dB_step_size;
                if SPL >95
                    threshold = 95;
                else
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                end
            end

        elseif strcmp(previous_response, current_response) ~=1 % Reversal Occured
            
            previous_response = current_response;
            
            % reduce step size. if down then test up by 1/2 step size. if
            % up then test down by 1/2 step size.            

            reversal = reversal +1;
            response = [response current_response];
            
            SPL = hfig_ftc_module.current_stimulus.intensity;
            spl_vals = [spl_vals, SPL];

            if reversal == 1
                
                dB_step_size = 5;
                
                if strcmp(current_response, 'Y') ==1
                    SPL = SPL-dB_step_size;
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                else
                    SPL = SPL+dB_step_size;
                    if SPL >95
                        threshold = 95;
                    else
                        set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                        edit_intensity_Callback(hObject, eventdata, handles)
                    end
                end
            else
                if reversal == 2
                    dB_step_size = 2.5;                                                            
                elseif reversal ==3;
                    dB_step_size = 1;
                end
                  

                if strcmp(current_response, 'Y') ==1
                    SPL = SPL-dB_step_size;
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                else
                    SPL = SPL+dB_step_size;
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                end
            end

        else % no reversal - continue incrementing or decrementing
            previous_response = current_response;
            response = [response current_response];
            SPL =  hfig_ftc_module.current_stimulus.intensity;
            spl_vals = [spl_vals, SPL];

            if strcmp(current_response, 'Y') ==1
                SPL = SPL-dB_step_size;
                set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                edit_intensity_Callback(hObject, eventdata, handles)
            else
                SPL = SPL+dB_step_size;
                if SPL >95
                    threshold = 95
                else
                    set(handles.edit_ch1_intensity, 'string', num2str(SPL))
                    edit_intensity_Callback(hObject, eventdata, handles)
                end
            end

        end
    end
    
    dat.(char(playback_sequence_text(i))).response = response(1:end-1);
    
    axes(hfig_ftc_module_plot.handles.axes_ftc_plot)
    hold on
    plot(hfig_ftc_module_plot.handles.axes_ftc_plot,hfig_ftc_module.stim_freqs(ind), threshold, '-ok')
    hold off
   
end
toc

dat_out.redos.raw.(char(playback_sequence_text(i))) = dat.(char(playback_sequence_text(i)));
dat_out.redos.tuning_curve.threshold(1,1) = freq_values(ind);
dat_out.redos.tuning_curve.threshold(1,2) = threshold;


function edit_plot_axis_limit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plot_axis_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plot_axis_limit as text
%        str2double(get(hObject,'String')) returns contents of edit_plot_axis_limit as a double


% --- Executes during object creation, after setting all properties.
function edit_plot_axis_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plot_axis_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_animal_ID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_animal_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_animal_ID as text
%        str2double(get(hObject,'String')) returns contents of edit_animal_ID as a double


% --- Executes during object creation, after setting all properties.
function edit_animal_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_animal_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_unit_ID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_unit_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_unit_ID as text
%        str2double(get(hObject,'String')) returns contents of edit_unit_ID as a double


% --- Executes during object creation, after setting all properties.
function edit_unit_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_unit_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_clear_data.
function pushbutton_clear_data_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton_clear.

global dat_out
global dat

dat_out = [];
dat = [];

function my_closereq(src,callbackdata,handles)

global hfig_cal

try
    release(hfig_ftc_module.nidaq.s)
end

delete(gcf)


% --- Executes on selection change in listbox_ch2_stimuli.
function listbox_ch2_stimuli_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ch2_stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ch2_stimuli contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ch2_stimuli

global hfig_ftc_module
global srate

hfig_ftc_module.ch2.selected_index = get(handles.listbox_ch2_stimuli, 'Value');

freq_val = char(hfig_ftc_module.ch2.stim_names(hfig_ftc_module.ch2.selected_index));
hfig_ftc_module.ch2.current_stimulus.signal = (hfig_ftc_module.ch2.stimuli.(freq_val));

hfig_ftc_module.ch2.current_stimulus.intensity = ...
    str2num(get(handles.edit_ch2_intensity, 'String'));

hfig_ftc_module.ch2.current_stimulus.freq = freq_val;

stim_time = 1/srate:1/srate:length(hfig_ftc_module.ch2.current_stimulus.signal)/srate;

plot(handles.axes_ch2_stimulus, stim_time, ...
    hfig_ftc_module.ch2.current_stimulus.signal, 'r');

xlim(handles.axes_ch2_stimulus, [stim_time(1) stim_time(end)])

edit_ch2_intensity_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox_ch2_stimuli_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ch2_stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_ch2_index.
function listbox_ch2_index_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ch2_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ch2_index contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ch2_index


% --- Executes during object creation, after setting all properties.
function listbox_ch2_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ch2_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_ch2_frequency.
function listbox_ch2_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ch2_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ch2_frequency contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ch2_frequency


% --- Executes during object creation, after setting all properties.
function listbox_ch2_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ch2_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_ch2_intensity.
function listbox_ch2_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ch2_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ch2_intensity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ch2_intensity


% --- Executes during object creation, after setting all properties.
function listbox_ch2_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ch2_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_ch2_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_intensity as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_intensity as a double

global hfig_ftc_module

current_stim_ID = hfig_ftc_module.ch2.stim_names(hfig_ftc_module.ch2.selected_index);
[row, col] = find(strcmp(hfig_ftc_module.ch2.calibration, char(current_stim_ID)));

hfig_ftc_module.ch2.current_stimulus.intensity = str2num(get(handles.edit_ch2_intensity, 'String'));

if hfig_ftc_module.playback_chan == 1
    %control sound intensity
    current_intensity = str2num(get(handles.edit_ch2_intensity, 'String'));
    ref_vel = cell2mat(hfig_ftc_module.ch2.calibration(row,1));
    
    atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3))+(20*log10(ref_vel/current_intensity));
    
%     adjust = abs(current_intensity - ref_dB_spl);
%     if current_intensity > ref_dB_spl
%         atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) - adjust;
%     elseif current_intensity <ref_dB_spl
%         atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) + adjust;
%     else
%         atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3));
%     end
    
    invoke(hfig_ftc_module.TDT.PA5x2, 'SetAtten', atten);
elseif hfig_ftc_module.playback_chan ==2
    
    current_intensity = str2num(get(handles.edit_ch2_intensity, 'String'));
    ref_dB_spl = cell2mat(hfig_ftc_module.ch2.calibration(row,1));
    adjust = abs(current_intensity - ref_dB_spl);
    if current_intensity > ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) - adjust;
    elseif current_intensity <ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3)) + adjust;
    else
        atten = cell2mat(hfig_ftc_module.ch2.calibration(row,3));
    end
    
    invoke(hfig_ftc_module.TDT.PA5x2, 'SetAtten', atten);
    
    current_intensity = str2num(get(handles.edit_ch1_intensity, 'String'));
    ref_dB_spl = cell2mat(hfig_ftc_module.ch1.calibration(row,1));
    adjust = abs(current_intensity - ref_dB_spl);
    if current_intensity > ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) - adjust;
    elseif current_intensity <ref_dB_spl
        atten = cell2mat(hfig_ftc_module.ch1.calibration(row,3)) + adjust;
    elseif current_intensity == ref_dB_spl
        % get current atten and set to same atten
        current_atten = invoke(hfig_ftc_module.TDT.PA5x1, 'GetAtten');
        atten = current_atten;
    end
    
    invoke(hfig_ftc_module.TDT.PA5x1, 'SetAtten', atten);
end

% --- Executes during object creation, after setting all properties.
function edit_ch2_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
