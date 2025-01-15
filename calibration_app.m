                                                                                                                                                                                                                                                                                 function varargout = calibration_app(varargin)
% CALIBRATION_APP MATLAB code for calibration_app.fig
%      CALIBRATION_APP, by itself, creates a new CALIBRATION_APP or raises the existing
%      singleton*.
%
%      H = CALIBRATION_APP returns the handle to a new CALIBRATION_APP or the handle to
%      the existing singleton*.
%
%      CALIBRATION_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATION_APP.M with the given input arguments.
%
%      CALIBRATION_APP('Property','Value',...) creates a new CALIBRATION_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calibration_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calibration_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calibration_app

% Last Modified by GUIDE v2.5 03-Jun-2022 10:34:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calibration_app_OpeningFcn, ...
                   'gui_OutputFcn',  @calibration_app_OutputFcn, ...
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


% --- Executes just before calibration_app is made visible.
function calibration_app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calibration_app (see VARARGIN)

global hfig_calibration_app

%Initiate TDT
CD='USB';

try
%     zBus = actxcontrol('ZBUS.x',[5 5 26 26]);
%     hfig_calibration_app.TDT.zBus = zBus;
%     
%     if invoke(zBus, 'ConnectZBUS','GB')
%         e='Zbus connected'
%     else
%         e='Unable to connect Zbus'
%     end

    PA5x1=actxcontrol('PA5.x',[5 5 26 26]);
    hfig_calibration_app.TDT.PA5x1 = PA5x1;

    %Connects to PA5 #1 via GB
    if invoke(PA5x1,'ConnectPA5',CD,1) % == -1
        e='PA5_1 connected'
        %update_TDTatten(1,hfig_calibration_app)
    else
        e='PA5_1 Unable to connect'
    end

    PA5x2=actxcontrol('PA5.x',[5 5 26 26]);
    hfig_calibration_app.TDT.PA5x2 = PA5x2;

    %Connects to PA5 #2 via GB
    if invoke(PA5x2,'ConnectPA5',CD,2) % == -1
        e='PA5_2 connected'

        %update_TDTatten(2,hfig_calibration_app)
    else
        e='PA5_2 Unable to connect'
    end
    
end


try
    release(hfig_stimprog.nidaq.s)
end


[FileName,PathName] = uigetfile('*.xlsx','Select the Excel Calibration File');
[num,txt,ch1] = xlsread(strcat(PathName,FileName), 'ch1');
[num,txt,ch2] = xlsread(strcat(PathName,FileName), 'ch2');

hfig_calibration_app.ch1.calibration = ch1;
hfig_calibration_app.ch2.calibration = ch2;

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

srate = 100000;
%srate = 44100;

start_freq = 1000;
end_freq = 65000;
freqs = 1000;
next_freq = start_freq*(2^(1/3));


while next_freq < end_freq
    freqs = [freqs, round(next_freq)];
    next_freq = next_freq*2^(1/3);
end

freqs = sort(freqs);

stimpars.pdur = 50;
stimpars.ipi = 25;
stimpars.ramp = 1;
stimpars.pnum = 1;
stimpars.revph = 1;
stimpars.noise = 0;
stimpars.chrpnum = 1;
stimpars.ici = 0;

hfig_calibration_app.ch1_stim_index = 1;
hfig_calibration_app.ch1_stim_index_max = 1;

for i = 1:length(freqs)
    stimpars.freq = freqs(i);
    fname{i} = strcat('f_', num2str(freqs(i)));
    signal = pulse_train(srate, stimpars);
    %signal = signal(8379:end); % to shorten signal
    stimuli.(fname{i}) = signal*1;

    % Increments index for listbox
    hfig_calibration_app.ch1_stim_index_max = hfig_calibration_app.ch1_stim_index_max + 1;
end

%silence
silence = zeros(length(stimuli.f_1000),1)';
 
stimuli.silence = silence;
hfig_calibration_app.ch1_stim_index = hfig_calibration_app.ch1_stim_index_max;
hfig_calibration_app.ch1_stim_index_max = hfig_calibration_app.ch1_stim_index_max + 1;
freqs = [freqs 0];

%fmsweep

% [sweep -] = fmsweep_gen(200, 7500,0.5,0.5,1);  % start freq, stop freq, duration, period, rep 
% calibration = load(fullfile(stimprog_path, 'calibration_data\2018-07-13\ao0_calibration.mat'));
% sweep = filtfilt(calibration.left.filt_coefficients, 1, sweep);
% 
% sweep = (1/max(sweep))*sweep;
% sweep = sweep*5;
% stimuli.fmsweep = sweep;
% hfig_calibration_app.ch1_stim_index = hfig_calibration_app.ch1_stim_index_max;
% hfig_calibration_app.ch1_stim_index_max = hfig_calibration_app.ch1_stim_index_max + 1;
% freqs = [freqs 0];

set(handles.edit_mic_sen, 'String', num2str(0.783));

stim_fieldnames = fieldnames(stimuli);
set(handles.listbox_stimulus_list,'String', stim_fieldnames)
set(handles.edit_ch1_intensity,'String', num2str('75'))

hfig_calibration_app.ch1.stimuli = stimuli;
hfig_calibration_app.ch1.stim_names = stim_fieldnames;
hfig_calibration_app.ch1.stim_freqs = freqs;
hfig_calibration_app.ch1.stim_time_short = 1/srate:1/srate:length(stimuli.(fname{i}))/srate;
hfig_calibration_app.ch1.stim_time = hfig_calibration_app.ch1.stim_time_short;
hfig_calibration_app.cal_type = 'tones';

% setup nidaq---------------------------------------------
hfig_calibration_app.nidaq.srate = srate;
hfig_calibration_app.nidaq.s = daq.createSession('ni');
hfig_calibration_app.nidaq.s.Rate = hfig_calibration_app.nidaq.srate;
addAnalogOutputChannel(hfig_calibration_app.nidaq.s,'Dev2',[0],'Voltage');

%data capture
active_chan_input = [1];
ch = addAnalogInputChannel(hfig_calibration_app.nidaq.s, 'Dev2', active_chan_input, 'Voltage');
%ch.Range = [-5,5];

%Initiate NIDAQ data capture
%chan = str2double(inputdlg('Which Analog Output Channel would you like to calibrate?','Analog Output Channel'));


try
   release(hfig_cal.nidaq.s)
end

try
   release(hfig_stimprog.nidaq.s)
end


set(handles.figure1,'CloseRequestFcn',@my_closereq)

% Choose default command line output for calibration_app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calibration_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calibration_app_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_stimuluate.
function pushbutton_stimuluate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stimuluate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_calibration_app
global dat_out

cla(handles.axes_recording)
srate = hfig_calibration_app.nidaq.srate;

if strcmp(hfig_calibration_app.cal_type, 'tones') ==1
    current_stim_ID.ch1 = hfig_calibration_app.ch1.stim_names(hfig_calibration_app.ch1.selected_index);
    playback(:,1) = hfig_calibration_app.ch1.current_stimulus.signal';
elseif strcmp(hfig_calibration_app.cal_type == 'noise') ==1

end

queueOutputData(hfig_calibration_app.nidaq.s, playback);
output = startForeground(hfig_calibration_app.nidaq.s);

[row col] = size(output);

time_data = 1/hfig_calibration_app.nidaq.srate:1/hfig_calibration_app.nidaq.srate:row/hfig_calibration_app.nidaq.srate;

output = output(:,1)*1000; % multiply by 1000 to covert to mV
output = highpass(output,300,srate);

plot(handles.axes_recording, time_data, output(:,1), 'b');
hold on
xlim(handles.axes_recording, [0, time_data(end)])
%ylim(handles.axes_recording, [-250, 250])

%Measure RMS of recording
srate = hfig_calibration_app.nidaq.srate;
start = srate*0.0275;
stop = srate*(0.0275+0.05);
xline(handles.axes_recording,start/srate);
xline(handles.axes_recording,stop/srate);
hold off

output = output(:,1)/100; % to remove 100x amplification.

% RMS calculation depending on if the signal is call/tone or noise.

if strcmp(hfig_calibration_app.cal_type, 'tones') ==1
    %rms_recording = ((max(output)-min(output))/2)*0.707;
    rms_recording = rms(output(start:stop));
    set(handles.text_rms, 'String', num2str(rms_recording))
elseif strcmp(hfig_calibration_app.cal_type == 'noise') ==1
    
end


mic_sen = str2num(get(handles.edit_mic_sen, 'String'));
dB_difference = 20*log10(rms_recording/mic_sen);

dB_SPL = 94+(dB_difference);

set(handles.text_dBSPL, 'String', num2str(dB_SPL));

srate = hfig_calibration_app.nidaq.srate;
nfft = 5000;
overlap = 50;
f_freq = 0:50:50000;

[pxx freq] = pwelch((output(:,1)), nfft, overlap, f_freq, srate);
pxx = 20*log10(abs(pxx));
plot(handles.axes_spec, freq, pxx)

% y_axis_limit = str2num(get(handles.edit_plot_axis_limit, 'string'));
% ylim(handles.axes_response_2, [-y_axis_limit, y_axis_limit])

drawnow

dat.trace= output;
dat.time = time_data';
dat.ch1.stimsrate = hfig_calibration_app.nidaq.srate;
dat.ch1.freq = hfig_calibration_app.ch1.current_stimulus.freq;
dat.ch1.intensity = hfig_calibration_app.ch1.current_stimulus.intensity;


dat_out.raw = dat;

% --- Executes on selection change in listbox_stimulus_list.
function listbox_stimulus_list_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_stimulus_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_stimulus_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_stimulus_list


global hfig_calibration_app

srate = hfig_calibration_app.nidaq.srate;

hfig_calibration_app.ch1.selected_index = get(handles.listbox_stimulus_list, 'Value');

freq_val = char(hfig_calibration_app.ch1.stim_names(hfig_calibration_app.ch1.selected_index));
hfig_calibration_app.ch1.current_stimulus.signal = (hfig_calibration_app.ch1.stimuli.(freq_val))*2;

hfig_calibration_app.ch1.current_stimulus.intensity = ...
    str2num(get(handles.edit_ch1_intensity, 'String'));

hfig_calibration_app.ch1.current_stimulus.freq = freq_val;

stim_time = 1/srate:1/srate:length(hfig_calibration_app.ch1.current_stimulus.signal)/srate;

plot(handles.axes_stimulus, stim_time, ...
    hfig_calibration_app.ch1.current_stimulus.signal);

xlim(handles.axes_stimulus, [stim_time(1) stim_time(end)])

edit_ch1_intensity_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox_stimulus_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_stimulus_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_loadPA5.
function pushbutton_loadPA5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadPA5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_calibration_app

[FileName,PathName] = uigetfile('*.xlsx','Select the Excel Calibration File');

[num,txt,ch1] = xlsread(strcat(PathName,FileName), 'ch1');
[num,txt,ch2] = xlsread(strcat(PathName,FileName), 'ch2');
hfig_calibration_app.ch1.calibration = ch1;
hfig_calibration_app.ch2.calibration = ch2;


function edit_ch1_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_intensity as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_intensity as a double


global hfig_calibration_app

current_stim_ID = hfig_calibration_app.ch1.stim_names(hfig_calibration_app.ch1.selected_index);
[row, col] = find(strcmp(hfig_calibration_app.ch1.calibration, char(current_stim_ID)));

hfig_calibration_app.ch1.current_stimulus.intensity = str2num(get(handles.edit_ch1_intensity, 'String'));


%control sound intensity
current_intensity = str2num(get(handles.edit_ch1_intensity, 'String'));
ref_dB_spl = cell2mat(hfig_calibration_app.ch1.calibration(row,1));
adjust = abs(current_intensity - ref_dB_spl);
if current_intensity > ref_dB_spl
    atten = cell2mat(hfig_calibration_app.ch1.calibration(row,3)) - adjust;
elseif current_intensity <ref_dB_spl
    atten = cell2mat(hfig_calibration_app.ch1.calibration(row,3)) + adjust;
else
    atten = cell2mat(hfig_calibration_app.ch1.calibration(row,3));
end

invoke(hfig_calibration_app.TDT.PA5x1, 'SetAtten', atten);


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


function my_closereq(src,callbackdata,handles)

global hfig_calibration_app

try
    release(hfig_calibration_app.nidaq.s)
end

delete(gcf)



function edit_mic_sen_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mic_sen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mic_sen as text
%        str2double(get(hObject,'String')) returns contents of edit_mic_sen as a double


% --- Executes during object creation, after setting all properties.
function edit_mic_sen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mic_sen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup_calibration_type.
function uibuttongroup_calibration_type_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_calibration_type 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_calibration_app

calibration_type = get(handles.uibuttongroup_calibration_type, 'SelectedObject');

switch get(calibration_type, 'Tag') 
    case 'radiobutton_callstone'
        hfig_calibration_app.cal_type = 'tones';
    case 'radiobutton_noise'
        hfig_calibration_app.cal_type = 'noise';
end
