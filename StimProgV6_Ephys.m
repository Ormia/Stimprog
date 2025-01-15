function varargout = StimProgV6_Ephys(varargin)
% STIMPROGV6_EPHYS MATLAB code for StimProgV6_Ephys.fig
%      STIMPROGV6_EPHYS, by itself, creates a new STIMPROGV6_EPHYS or raises the existing
%      singleton*.
%
%      H = STIMPROGV6_EPHYS returns the handle to a new STIMPROGV6_EPHYS or the handle to
%      the existing singleton*.
%
%      STIMPROGV6_EPHYS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIMPROGV6_EPHYS.M with the given input arguments.
%
%      STIMPROGV6_EPHYS('Property','Value',...) creates a new STIMPROGV6_EPHYS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StimProgV6_Ephys_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StimProgV6_Ephys_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StimProgV6_Ephys

% Last Modified by GUIDE v2.5 09-Jul-2024 16:01:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StimProgV6_Ephys_OpeningFcn, ...
                   'gui_OutputFcn',  @StimProgV6_Ephys_OutputFcn, ...
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


% --- Executes just before StimProgV6_Ephys is made visible.
function StimProgV6_Ephys_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StimProgV6_Ephys (see VARARGIN)

global hfig_stimprog

% Choose default command line output for StimProgV6_Ephys
handles.output = hObject;

hfig_stimprog.handles = handles;

hfig_stimprog.working_dir = stimprog_path;

data_dir = datestr(now,29);
persistent xnum;
xnum = 1;
xnums = strcat('exp',num2str(xnum),'.mat');
data_file = strcat(data_dir,'\',xnums);
dummy = [];
if ~isdir(data_dir),
    mkdir(data_dir);
%     xnums = 'exp1.mat';
    data_file = strcat(data_dir,'\',xnums);
    save(data_file,'dummy');
else
    while exist(strcat(data_dir,'\',xnums)) == 2,
        xnum = xnum + 1;
        xnums = strcat('exp',num2str(xnum),'.mat');
        data_file = strcat(data_dir,'\',xnums);
    end
end
% set(handles.savefile_edit,'String',data_dir);
    save(data_file,'dummy');
set(handles.edit_save_file,'String',data_file);

% Set up TDT attenuators
Dnum=1;
CD='USB';
 
try    
    PA5x1=actxcontrol('PA5.x',[5 5 26 26]);
    hfig_stimprog.TDT.PA5x1 = PA5x1;
    
    handles.pa5x1 = PA5x1;
    
    
    %Connects to PA5 #1 via GB
    if invoke(PA5x1,'ConnectPA5',CD,1) % == -1
        e='PA5_1 connected'
        
        %update_TDTatten(1,hfig_ballgui)
    else
        e= 'PA5_1 Unable to connect'
    end
    
    
    
    PA5x2=actxcontrol('PA5.x',[5 5 26 26]);
    hfig_stimprog.TDT.PA5x2 = PA5x2;
    
    handles.pa5x2 = PA5x2;
    
    %Connects to PA5 #2 via GB
    if invoke(PA5x2,'ConnectPA5',CD,2) % == -1
        e='PA5_2 connected'
        
        %update_TDTatten(2,hfig_ballgui)
    else
        e='PA5_2 Unable to connect'
    end
    
    invoke(hfig_stimprog.TDT.PA5x1, 'SetAtten', 20);
    set(handles.edit_TDT_Ch1_Atten, 'String', num2str(20))
    invoke(hfig_stimprog.TDT.PA5x2, 'SetAtten', 20);
    set(handles.edit_TDT_Ch2_Atten, 'String', num2str(20))
end

hfig_stimprog.default_values.ch1 = 75;
set(handles.edit_volume_ch1, 'String', num2str(hfig_stimprog.default_values.ch1));
hfig_stimprog.default_values.ch2 = 84;
set(handles.edit_volume_ch2, 'String', num2str(hfig_stimprog.default_values.ch2));

% Set Timer

hfig_stimprog.handles.timerobj = timer('ExecutionMode', 'fixedRate', 'Period', 0.2,...
    'TimerFcn', {@continuous_stim_Callback, hObject});
    

% load stimulus filters

%calibration_directory = fullfile(stimprog_path, 'calibration\calibration_data\2018-04-30\');
%hfig_stimprog.calibration.ch1 = load(strcat(calibration_directory,'ao0_calibration.mat'));
%hfig_stimprog.calibration.ch2 = load(strcat(calibration_directory,'ao1_calibration.mat'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StimProgV6_Ephys wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StimProgV6_Ephys_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox_stim_config.
function listbox_stim_config_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_stim_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_stim_config contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_stim_config

global hfig_stimprog

stim_selected = handles.listbox_stim_config.Value;
stim_folder = hfig_stimprog.current_stim.stim_wav_dir_folder_names(stim_selected);
stim_dir = hfig_stimprog.current_stim.stim_wav_dir;

[num,text,raw_left]=xlsread(strcat(hfig_stimprog.working_dir, '\SongRecogCalibration.xlsx'),'Left');
[num,text,raw_right]=xlsread(strcat(hfig_stimprog.working_dir, '\SongRecogCalibration.xlsx'),'Right');

ind_left = find(strcmp(raw_left, stim_folder));
left_atten_value = cell2mat(raw_left(ind_left,2));
ind_right = find(strcmp(raw_right, stim_folder));
right_atten_value = cell2mat(raw_right(ind_right,2));

configuration = load(strcat(stim_dir, char(stim_folder), '\stim_config_', char(stim_folder), '.mat'));
configuration.configuration{1,4}= left_atten_value;
configuration.configuration{2,4}= right_atten_value;

hfig_stimprog.current_stim.configuration = configuration.configuration;

handles.uitable_config.Data = hfig_stimprog.current_stim.configuration;

%files = dir(fullfile(strcat(stim_dir, char(stim_folder)), '*.wav'));
files = dir(fullfile(strcat(stim_dir, char(stim_folder)), '*.mat'));

% for i = 1:length(files)
%     %hfig_stimprog.current_stim.signal{i} = audioread(strcat(stim_dir, char(stim_folder), '\', files(i).name));
% end

left = load(strcat(stim_dir, char(stim_folder), '\', 'signal_1.mat'));
right = load(strcat(stim_dir, char(stim_folder), '\', 'signal_2.mat'));


hfig_stimprog.current_stim.signal{1} = left.left_signal_out;
hfig_stimprog.current_stim.signal{2} = right.right_signal_out;

set_atten(hObject, eventdata,handles);

%Plot Stimuli
linkaxes([handles.axes_stimulus_ch1, handles.axes_stimulus_ch2])

srate = 44100;
time = 1/srate:1/srate:length(hfig_stimprog.current_stim.signal{1})/srate;


plot(handles.axes_stimulus_ch1, time, hfig_stimprog.current_stim.signal{1}, 'b');
plot(handles.axes_stimulus_ch2, time, hfig_stimprog.current_stim.signal{2}, 'r');


% --- Executes during object creation, after setting all properties.
function listbox_stim_config_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_stim_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_single_shot.
function pushbutton_single_shot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_single_shot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_stimprog
global sweep_buffer
global dat_save

handles = guidata(hObject);

dat = stimulate(hObject, eventdata,handles);

[row col] =  size(hfig_stimprog.current_stim.configuration);

for i = 1:row
    temp_field_name = strcat('ch', num2str(i), '_params');
    last_trace.(char(temp_field_name)).configuration = hfig_stimprog.current_stim.configuration(i,:);
    temp_TDT_atten = strcat('PA5x', num2str(i));
    PA5 = hfig_stimprog.TDT.(temp_TDT_atten);
    last_trace.(char(temp_field_name)).current_TDT_Atten = invoke(PA5, 'GetAtten');
end

last_trace.data.ch1_trace = dat.ch1.trace; % Channel 1 is neural data
last_trace.data.ch2_trace = dat.ch2.trace; % Channel 2 is stimulus
last_trace.data.srate = hfig_stimprog.nidaq.srate;
time_vector = 1/hfig_stimprog.nidaq.srate:1/ hfig_stimprog.nidaq.srate:length(last_trace.data.ch1_trace)/hfig_stimprog.nidaq.srate;
last_trace.data.time = time_vector';
last_trace.data.info = {'ch1 data = neural', 'ch2 data = stimulus capture'};

set(handles.pushbutton_save_last_trace,'Enable','on');
set(handles.pushbutton_save_last_trace,'UserData',last_trace)
set(handles.pushbutton_save_last_trace,'String','Save last trace');

if isempty(sweep_buffer)
    sweep_buffer = 1;
else
    sweep_buffer = sweep_buffer+1;
end

last_saved_trace_name = get(handles.edit_trace_name, 'String');

if isempty(last_saved_trace_name)
    trace_name = strcat('trace_', num2str(sweep_buffer));
else
    ind = strfind(last_saved_trace_name, '_');
    ind = cell2mat(ind);
    last_saved_trace_name = char(last_saved_trace_name);
    num_traces_saved = str2num(last_saved_trace_name(ind+1:length(last_saved_trace_name)));
    trace_name = strcat('trace_', num2str(num_traces_saved+sweep_buffer)); 
end

dat_save.(trace_name) = last_trace;
set(handles.text_traces_buffer, 'String', num2str(sweep_buffer))
guidata(hObject, handles);


function  dat = stimulate(hObject,eventdata,handles)

% e.g. temp = stimulate(hfig_stimprog.handles)

global hfig_stimprog

handles = guidata(hObject);

hfig_stimprog.current_stim.stim_config_selected = get(handles.listbox_stim_config, 'Value');

% set signals
[row col] = size(hfig_stimprog.current_stim.configuration);

signal_lengths = [];

for i = 1:row
    temp_name = strcat('sig_', num2str(i));
    signal.(temp_name) = hfig_stimprog.current_stim.signal{i};
    signal_lengths = [signal_lengths length(hfig_stimprog.current_stim.signal{i})];
end

max_length = max(signal_lengths);
sig_fieldnames = fieldnames(signal);
output_data = zeros(max_length,length(sig_fieldnames));

for i = 1:length(sig_fieldnames)
    if length(signal.(char(sig_fieldnames(i))))< max_length
        diff_length = max_length - length(signal.(char(sig_fieldnames(i))));
        silence = zeros(1, diff_length);
        new_sig = [signal.(char(sig_fieldnames(i))); silence'];
        signal.(char(sig_fieldnames(i))) = new_sig;
    end
    output_data(:,i) = signal.(char(sig_fieldnames(i)));    
end
        

% Intitialize National Instruments

set_nidaq(hObject, eventdata,handles);
queueOutputData(hfig_stimprog.nidaq.s, output_data);
acquiredData = startForeground(hfig_stimprog.nidaq.s);



srate = 44100;
time = 1/srate:1/srate:length(acquiredData(:,1))/srate;

%Plot Stimuli
linkaxes([handles.axes_ch1_input, handles.axes_ch2_input])

plot(handles.axes_ch1_input, time, acquiredData(:,1), 'b');
plot(handles.axes_ch2_input, time, acquiredData(:,2), 'r');




dat.ch1.trace = acquiredData(:,1);
dat.ch2.trace = acquiredData(:,2);

function set_atten(hObject,eventdata,handles)

global hfig_stimprog

handles = guidata(hObject);

%Set Default TDT Atten Values
current_spl = str2num(get(handles.edit_volume_ch1,'string'));
diff_intensity = current_spl -...
    cell2mat(hfig_stimprog.current_stim.configuration(1,5));
atten_val = cell2mat(hfig_stimprog.current_stim.configuration(1,4));
atten_val = atten_val - diff_intensity;
SetAtten(hfig_stimprog.TDT.PA5x1,atten_val)
set(handles.edit_TDT_Ch1_Atten, 'String', num2str(atten_val))

current_spl = str2num(get(handles.edit_volume_ch2,'string'));
diff_intensity = current_spl -...
    cell2mat(hfig_stimprog.current_stim.configuration(2,5));
atten_val = cell2mat(hfig_stimprog.current_stim.configuration(2,4));
atten_val = atten_val - diff_intensity;
SetAtten(hfig_stimprog.TDT.PA5x2,atten_val)
set(handles.edit_TDT_Ch2_Atten, 'String', num2str(atten_val))



function set_nidaq(hObject, eventdata,handles)

global hfig_stimprog

if isfield(hfig_stimprog, 'nidaq')
    delete(hfig_stimprog.nidaq.s)
end

hfig_stimprog.nidaq.srate = 44100;
hfig_stimprog.nidaq.s = daq.createSession('ni');
hfig_stimprog.nidaq.s.Rate = hfig_stimprog.nidaq.srate;

% Determine active channels
active_chan = cell2mat(hfig_stimprog.current_stim.configuration(:,3));

addAnalogOutputChannel(hfig_stimprog.nidaq.s, 'Dev2', active_chan, 'Voltage');
addAnalogInputChannel(hfig_stimprog.nidaq.s, 'Dev2', active_chan, 'Voltage');

%addTriggerConnection(hfig_stimprog.nidaq.s,'External','Dev1/PFI0','StartTrigger');
% hfig_stimprog.nidaq.s.Connections(1).TriggerCondition = 'RisingEdge';
% hfig_stimprog.nidaq.s.TriggersPerRun = 1;


% --- Executes on button press in togglebutton_cont.
function togglebutton_cont_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_cont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_stimprog

handles = guidata(hObject);

toggle_state = get(hfig_stimprog.handles.togglebutton_cont, 'value');

if toggle_state == 1
    start(hfig_stimprog.handles.timerobj);
else
    stop(hfig_stimprog.handles.timerobj);
    %delete(hfig_stimprog.handles.timerobj);
    %clear hfig_stimprog.handles.timerobj
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton_avg.
function pushbutton_avg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_stimprog
global sweep_buffer
global dat_save

handles = guidata(hObject);
num_reps = 20;

all_traces.ch1 = [];
all_traces.ch2 = [];

for j = 1:num_reps
    
    dat = stimulate(hObject, eventdata,handles);
    
    all_traces.ch1(:,j) = dat.ch1.trace;
    all_traces.ch2(:,j) = dat.ch2.trace;
    
    set(handles.pushbutton_avg,'string', num2str(j))
    
end

[row col] =  size(hfig_stimprog.current_stim.configuration);

for i = 1:row
    temp_field_name = strcat('ch', num2str(i), '_params');
    last_trace.(char(temp_field_name)).configuration = hfig_stimprog.current_stim.configuration(i,:);
    temp_TDT_atten = strcat('PA5x', num2str(i));
    PA5 = hfig_stimprog.TDT.(temp_TDT_atten);
    last_trace.(char(temp_field_name)).current_TDT_Atten = invoke(PA5, 'GetAtten');
end

last_trace.data.ch1_trace = all_traces.ch1;
last_trace.data.ch2_trace = all_traces.ch2;

set(handles.pushbutton_save,'Enable','on');
set(handles.pushbutton_save,'UserData',last_trace)
set(handles.pushbutton_save,'String','Save last');

if isempty(sweep_buffer)
    sweep_buffer = 1;
else
    sweep_buffer = sweep_buffer+1;
end

last_saved_trace_name = get(handles.edit_trace_name, 'String');

if isempty(last_saved_trace_name)
    trace_name = strcat('trace_', num2str(sweep_buffer));
else
    ind = strfind(last_saved_trace_name, '_');
    ind = cell2mat(ind);
    last_saved_trace_name = char(last_saved_trace_name);
    num_traces_saved = str2num(last_saved_trace_name(ind+1:length(last_saved_trace_name)));
    trace_name = strcat('trace_', num2str(num_traces_saved+sweep_buffer)); 
end


dat_save.(trace_name) = last_trace;
set(handles.text_traces_buffer, 'String', num2str(sweep_buffer))
set(handles.pushbutton_avg, 'string', 'Average')
guidata(hObject, handles);




% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_loadConfig_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_stimprog

stim_wav_dir = strcat(hfig_stimprog.working_dir, '\Stimuli\');
stim_wav_dir_folders = dir(stim_wav_dir);
stim_wav_dir_folders = stim_wav_dir_folders(3:end);
stim_folder_names = {stim_wav_dir_folders.name};

hfig_stimprog.current_stim.stim_wav_dir_folder_names = stim_folder_names;
hfig_stimprog.current_stim.stim_wav_dir = stim_wav_dir;

set(handles.listbox_stim_config, 'String', stim_folder_names);




% --- Executes when selected cell(s) is changed in uitable_config.
function uitable_config_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_config (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

global hfig_stimprog

function edit_save_dir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_save_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_save_dir as text
%        str2double(get(hObject,'String')) returns contents of edit_save_dir as a double


% --- Executes during object creation, after setting all properties.
function edit_save_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_save_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_increase_volume_ch1.
function pushbutton_increase_volume_ch1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_increase_volume_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

current_spl = str2num(get(handles.edit_volume_ch1,'string'));
new_spl = current_spl+1;
set(handles.edit_volume_ch1,'string', num2str(new_spl))
set_atten(hObject,eventdata,handles)


% --- Executes on button press in pushbutton_decrease_volume_ch1.
function pushbutton_decrease_volume_ch1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_decrease_volume_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

current_spl = str2num(get(handles.edit_volume_ch1,'string'));
new_spl = current_spl-1;
set(handles.edit_volume_ch1,'string', num2str(new_spl))
set_atten(hObject,eventdata,handles)


function edit_volume_ch1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_volume_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_volume_ch1 as text
%        str2double(get(hObject,'String')) returns contents of edit_volume_ch1 as a double

set_atten(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function edit_volume_ch1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_volume_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_increase_volume_ch2.
function pushbutton_increase_volume_ch2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_increase_volume_ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

current_spl = str2num(get(handles.edit_volume_ch2,'string'));
new_spl = current_spl+1;
set(handles.edit_volume_ch2,'string', num2str(new_spl))
set_atten(hObject,eventdata,handles)


% --- Executes on button press in pushbutton_decrease_volume_ch2.
function pushbutton_decrease_volume_ch2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_decrease_volume_ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

current_spl = str2num(get(handles.edit_volume_ch2,'string'));
new_spl = current_spl-1;
set(handles.edit_volume_ch2,'string', num2str(new_spl))
set_atten(hObject,eventdata,handles)


function edit_volume_ch2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_volume_ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_volume_ch2 as text
%        str2double(get(hObject,'String')) returns contents of edit_volume_ch2 as a double

set_atten(hObject,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function edit_volume_ch2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_volume_ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ch1.
function popupmenu_ch1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ch1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ch1


% --- Executes during object creation, after setting all properties.
function popupmenu_ch1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ch2.
function popupmenu_ch2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ch2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ch2


% --- Executes during object creation, after setting all properties.
function popupmenu_ch2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_stimuli_Callback(hObject, eventdata, handles)
% hObject    handle to menu_stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_save_file_Callback(hObject, eventdata, handles)
% hObject    handle to edit_save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_save_file as text
%        str2double(get(hObject,'String')) returns contents of edit_save_file as a double


% --- Executes during object creation, after setting all properties.
function edit_save_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_trace_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trace_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trace_name as text
%        str2double(get(hObject,'String')) returns contents of edit_trace_name as a double


% --- Executes during object creation, after setting all properties.
function edit_trace_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trace_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton_save_last_trace.
function pushbutton_save_last_trace_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_last_trace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global hfig_stimprog
global dat_save
global sweep_buffer

handles = guidata(hObject);

% find last trace
trace_names = fieldnames(dat_save);
last_trace_name = trace_names(end);

temp_dat_save.(char(trace_names(end))) = dat_save.(char(trace_names(end)));
temp_dat_save.(char(trace_names(end))).data.experimenter_name = hfig_stimprog.expt_metadata.experimenter_name;
temp_dat_save.(char(trace_names(end))).data.flypop = hfig_stimprog.expt_metadata.flypop;
temp_dat_save.(char(trace_names(end))).data.flyID = hfig_stimprog.expt_metadata.flyID;
temp_dat_save.(char(trace_names(end))).data.rec_loc = hfig_stimprog.expt_metadata.rec_loc;


if isempty(dat_save)
   %do nothing.
else
    fullname = get(handles.edit_save_file,'String');
    
    if exist(fullname, 'file')
        save(fullname, '-struct', 'temp_dat_save', '-append');
        last_trace_saved = trace_names(end);
        dat_save = [];
        sweep_buffer = 0;
        set(handles.edit_trace_name, 'String', last_trace_saved)
        set(handles.text_traces_buffer, 'String', num2str(sweep_buffer))
    end
     
end
    



function edit_TDT_Ch1_Atten_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TDT_Ch1_Atten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TDT_Ch1_Atten as text
%        str2double(get(hObject,'String')) returns contents of edit_TDT_Ch1_Atten as a double


% --- Executes during object creation, after setting all properties.
function edit_TDT_Ch1_Atten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TDT_Ch1_Atten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_TDT_Ch2_Atten_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TDT_Ch2_Atten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TDT_Ch2_Atten as text
%        str2double(get(hObject,'String')) returns contents of edit_TDT_Ch2_Atten as a double


% --- Executes during object creation, after setting all properties.
function edit_TDT_Ch2_Atten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TDT_Ch2_Atten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

eventdata

if strcmp(eventdata.Key, 's')==1
    pushbutton_single_shot_Callback(hObject, eventdata, handles)
end


function continuous_stim_Callback(timer_object, eventdata, hObject)

handles = guidata(hObject);
pushbutton_single_shot_Callback(hObject, [], handles);


% --- Executes on button press in pushbutton_TempPatternRec.
function pushbutton_TempPatternRec_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TempPatternRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_stimprog
global dat_save
global sweep_buffer

tic
reps = 5;
all_stimuli = get(handles.listbox_stim_config, 'String');

[num,text,playlist]=xlsread(strcat(hfig_stimprog.working_dir, '\SongRecogPlaylist.xlsx'),'Playlist');

playlist = playlist(2:end);

hfig_stimprog.playlist = playlist;

playlist_shuffled = playlist(randperm(length(playlist)));

for i = 1:length(playlist)
    
    exact_match_mask = strcmp(all_stimuli, playlist_shuffled{i});
    exact_match_locations = find(exact_match_mask);
   
    set(handles.listbox_stim_config, 'Value', exact_match_locations)
    listbox_stim_config_Callback(hObject, eventdata, handles)
    
    for j=1:reps
        pushbutton_single_shot_Callback(hObject, eventdata, handles)
        pushbutton_save_last_trace_Callback(hObject,eventdata,handles)
        
        if get(handles.pushbutton_abort, 'UserData') ==1
            %set(handles.pushbutton_abort, 'UserData',0)
            break
        end
    end
    
    if get(handles.pushbutton_abort, 'UserData') ==1
        set(handles.pushbutton_abort, 'UserData',0)
        break
    end
    
end
toc



% --- Executes on button press in pushbutton_abort.
function pushbutton_abort_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_abort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ftc_module

set(handles.pushbutton_abort, 'UserData', 1);



function edit_experimenter_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_experimenter_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_experimenter_name as text
%        str2double(get(hObject,'String')) returns contents of edit_experimenter_name as a double

global hfig_stimprog

hfig_stimprog.expt_metadata.experimenter_name = get(handles.edit_experimenter_name, 'String');

% --- Executes during object creation, after setting all properties.
function edit_experimenter_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_experimenter_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_flypop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_flypop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_flypop as text
%        str2double(get(hObject,'String')) returns contents of edit_flypop as a double

global hfig_stimprog

hfig_stimprog.expt_metadata.flypop = get(handles.edit_flypop, 'String');


% --- Executes during object creation, after setting all properties.
function edit_flypop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_flypop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_flyID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_flyID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_flyID as text
%        str2double(get(hObject,'String')) returns contents of edit_flyID as a double


global hfig_stimprog

hfig_stimprog.expt_metadata.flyID = get(handles.edit_flyID, 'String');


% --- Executes during object creation, after setting all properties.
function edit_flyID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_flyID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rec_loc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rec_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rec_loc as text
%        str2double(get(hObject,'String')) returns contents of edit_rec_loc as a double


global hfig_stimprog

hfig_stimprog.expt_metadata.rec_loc = get(handles.edit_rec_loc, 'String');

test =1;


% --- Executes during object creation, after setting all properties.
function edit_rec_loc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rec_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
