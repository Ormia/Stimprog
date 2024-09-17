
function varargout = StimProgV6(varargin)
% STIMPROGV6 MATLAB code for StimProgV6.fig
%      STIMPROGV6, by itself, creates a new STIMPROGV6 or raises the existing
%      singleton*.
%
%      H = STIMPROGV6 returns the handle to a new STIMPROGV6 or the handle to
%      the existing singleton*.
%
%      STIMPROGV6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIMPROGV6.M with the given input arguments.
%
%      STIMPROGV6('Property','Value',...) creates a new STIMPROGV6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StimProgV6_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StimProgV6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StimProgV6

% Last Modified by GUIDE v2.5 21-Jan-2018 20:52:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StimProgV6_OpeningFcn, ...
                   'gui_OutputFcn',  @StimProgV6_OutputFcn, ...
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




% --- Executes just before StimProgV6 is made visible.
function StimProgV6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StimProgV6 (see VARARGIN)

global hfig_stimprog

% Choose default command line output for StimProgV6
handles.output = hObject;

hfig_stimprog.handles = handles;

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

hfig_stimprog.default_values.ch1 = 70;
set(handles.edit_volume_ch1, 'String', num2str(hfig_stimprog.default_values.ch1));
hfig_stimprog.default_values.ch2 = 70;
set(handles.edit_volume_ch2, 'String', num2str(hfig_stimprog.default_values.ch2));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StimProgV6 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StimProgV6_OutputFcn(hObject, eventdata, handles) 
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

%configuration = load(strcat(stim_dir, char('Calibration_Tone'), '\stim_config_', char('Calibration_Tone'), '.mat'));
configuration = load(strcat(stim_dir, char(stim_folder), '\stim_config_', char(stim_folder), '.mat'));

hfig_stimprog.current_stim.configuration = configuration.configuration;

handles.uitable_config.Data = hfig_stimprog.current_stim.configuration;

files = dir(fullfile(strcat(stim_dir, char(stim_folder)), 'signal*.mat'));

for i = 1:length(files)
    %hfig_stimprog.current_stim.signal{i} = audioread(strcat(stim_dir, char(stim_folder), '\', files(i).name));
    imported_signal = load(strcat(stim_dir, char(stim_folder), '\', files(i).name));
    
    if isfield(imported_signal, 'adjusted_signal')
        temp = load(strcat(stim_dir, char(stim_folder), '\', files(i).name));
        hfig_stimprog.current_stim.signal{i} = temp.adjusted_signal;
    elseif isfield(imported_signal, 'silence_signal')
        temp = load(strcat(stim_dir, char(stim_folder), '\', files(i).name));
        hfig_stimprog.current_stim.signal{i} = temp.silence_signal;
    end
    
end

set_atten(hObject, eventdata,handles);
set(handles.edit_volume_ch1, 'string', num2str(hfig_stimprog.current_stim.configuration{1,4}))
set(handles.edit_volume_ch2, 'string', num2str(hfig_stimprog.current_stim.configuration{2,4}))


srate = 90000;
time = 1/srate:1/srate:length(hfig_stimprog.current_stim.signal{1})/srate;

%Plot Stimuli
linkaxes([handles.axes_stimulus_ch1, handles.axes_stimulus_ch2])

plot(handles.axes_stimulus_ch1, time, hfig_stimprog.current_stim.signal{1}, 'b');
plot(handles.axes_stimulus_ch2, time, hfig_stimprog.current_stim.signal{2}, 'r');
%ylim([-1,1])

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
    last_trace.(char(temp_field_name)).atten_left = str2num(get(hfig_stimprog.handles.edit_TDT_Ch1_Atten,'string'));
    last_trace.(char(temp_field_name)).atten_right = str2num(get(hfig_stimprog.handles.edit_TDT_Ch2_Atten,'string'));
    last_trace.(char(temp_field_name)).spl_left = str2num(get(hfig_stimprog.handles.edit_volume_ch1,'string'));
    last_trace.(char(temp_field_name)).spl_right = str2num(get(hfig_stimprog.handles.edit_volume_ch2,'string'));
end

last_trace.data.x = dat.trace.x;
last_trace.data.y = dat.trace.y;
last_trace.data.x_raw = dat.trace.x_raw;
last_trace.data.y_raw = dat.trace.y_raw;

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
 
% Initialize flyball System

if strcmp(hfig_stimprog.pop, 'FL')==1
    npts = 2160*28; %2 seconds of treadmill data capture
elseif strcmp(hfig_stimprog.pop, 'HI')==1
    npts = 2160*28; %7 seconds of treadmill data capture
elseif strcmp(hfig_stimprog.pop, 'HI_Natural')==1
    npts = 2160*28; %7 seconds of treadmill data capture
end
    
flyball = serial('COM1');
flyball.BaudRate = 115200;
flyball.timeout=1.5;
flyball.terminator='';
flyball.BytesAvailableFcnMode='byte';
flyball.BytesAvailablefcncount=npts;
flyball.InputBufferSize=npts;


queueOutputData(hfig_stimprog.nidaq.s, output_data);
startBackground(hfig_stimprog.nidaq.s);

% Run flyball System
fopen(flyball);
fwrite(flyball,255)

ba = 0;
while ba < npts
    ba = flyball.BytesAvailable;
end

try
    poop = fread(flyball,flyball.BytesAvailable);
        if poop(1)==0 && poop(2)==0,
            poop=poop(3:end);
        end      
        
    x=5*(poop(find(poop==1)+1)-128);%/255;
    y=5*(poop(find(poop==0)+1)-128);%/255;
    
    fix = length(x)-length(y);

    x = x(1:end-fix);
end

fwrite(flyball,254)
fclose(flyball)

cx = cumsum(x);
cy = cumsum(y);
cx = -cx;

axes(hfig_stimprog.handles.axes_response)
plot(cx./880,cy./880,'.');
maxdat=max(abs([cx./880; cy./880]));
if ~maxdat, maxdat = 1;, end

set(gca,'xlim',[-maxdat maxdat],'ylim',[-maxdat maxdat])%,'visible','off')
drawnow

ylabel('Y Direction (cm)');
xlabel('X Direction (cm)');

% prepare data for saving

dat.trace.x = cx;
dat.trace.y = cy;
dat.trace.x_raw = x;
dat.trace.y_raw = y;

x_diff = diff(dat.trace.x);
y_diff = diff(dat.trace.y);
a_squared = x_diff.^2;
b_squared = y_diff.^2;

total_distance = sum(sqrt(a_squared + b_squared)) / 880;
set(handles.text_total_dist_walked, 'String', strcat('Total Distance Walked (cm):', num2str(total_distance)))



function set_atten(hObject,eventdata,handles)

global hfig_stimprog

handles = guidata(hObject);

%Set Default TDT Atten Values
current_spl = str2num(get(handles.edit_volume_ch1,'string'));
diff_intensity = current_spl -...
    cell2mat(hfig_stimprog.current_stim.configuration(1,5));
atten_val = cell2mat(hfig_stimprog.current_stim.configuration(1,4));
atten_val = atten_val - diff_intensity;

atten_val = 0;
%SetAtten(hfig_stimprog.TDT.PA5x1,atten_val)
set(handles.edit_TDT_Ch1_Atten, 'String', num2str(atten_val))

current_spl = str2num(get(handles.edit_volume_ch2,'string'));
diff_intensity = current_spl -...
    cell2mat(hfig_stimprog.current_stim.configuration(2,5));
atten_val = cell2mat(hfig_stimprog.current_stim.configuration(2,4));
atten_val = atten_val - diff_intensity;

atten_val = 0;
%SetAtten(hfig_stimprog.TDT.PA5x2,atten_val)
set(handles.edit_TDT_Ch2_Atten, 'String', num2str(atten_val))



function set_nidaq(hObject, eventdata,handles)

global hfig_stimprog

if isfield(hfig_stimprog, 'nidaq')
    delete(hfig_stimprog.nidaq.s)
end

hfig_stimprog.nidaq.srate = 90000



















;
hfig_stimprog.nidaq.s = daq.createSession('ni');
hfig_stimprog.nidaq.s.Rate = hfig_stimprog.nidaq.srate;

% Determine active channels
active_chan = cell2mat(hfig_stimprog.current_stim.configuration(:,3));

addAnalogOutputChannel(hfig_stimprog.nidaq.s, 'Dev1', active_chan, 'Voltage');
addTriggerConnection(hfig_stimprog.nidaq.s,'External','Dev1/PFI0','StartTrigger');
hfig_stimprog.nidaq.s.Connections(1).TriggerCondition = 'RisingEdge';
hfig_stimprog.nidaq.s.TriggersPerRun = 1;



% --- Executes on button press in pushbutton_cont.
function pushbutton_cont_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_avg.
function pushbutton_avg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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

list = {'FL','HI', 'HI_Natural'};
[indx,tf] = listdlg('ListString',list,'SelectionMode','single');

if indx ==1
    stim_wav_dir = 'C:\Users\Lee Lab\Documents\MATLAB\StimProgV6\stimuli wav_94ksrate\';
    %stim_wav_dir = 'C:\Users\Lee Lab\Documents\MATLAB\StimProgV6\stimuli wav\';
    hfig_stimprog.pop = "FL";
elseif indx ==2
    stim_wav_dir = 'C:\Users\Lee Lab\Documents\MATLAB\StimProgV6\HI stimuli wav\';
    hfig_stimprog.pop = "HI";
else
    stim_wav_dir = 'C:\Users\Lee Lab\Documents\MATLAB\StimProgV6\HI Natural stimuli wav\';
    hfig_stimprog.pop = "HI_Natural";
end


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


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_stimprog
global dat_save
global sweep_buffer

tic

handles = guidata(hObject);

if isempty(dat_save)
   %do nothing.
else
    fullname = get(handles.edit_save_file,'String');
    
    dat_save_fields = fieldnames(dat_save);
    temp_dat_save = dat_save;
    
    if exist(fullname, 'file')
        save(fullname, '-struct', 'temp_dat_save', '-append');
        last_trace_saved = dat_save_fields(end);
        dat_save = [];
        sweep_buffer = 0;
        set(handles.edit_trace_name, 'String', last_trace_saved)
        set(handles.text_traces_buffer, 'String', num2str(sweep_buffer))
    end
     
end
    
toc

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
function menu_calibration_Callback(hObject, eventdata, handles)
% hObject    handle to menu_calibration (see GCBO)
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


% --- Executes on button press in pushbutton_open_save_buffer.
function pushbutton_open_save_buffer_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open_save_buffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_save_last_trace.
function pushbutton_save_last_trace_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_last_trace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global hfig_stimprog
global dat_save
global sweep_buffer

tic

handles = guidata(hObject);

% find last trace
trace_names = fieldnames(dat_save);
last_trace_name = trace_names(end);

temp_dat_save.(char(trace_names(end))) = dat_save.(char(trace_names(end)));

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
    
toc



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
