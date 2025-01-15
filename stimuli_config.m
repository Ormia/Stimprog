function varargout = stimuli_config(varargin)
% STIMULI_CONFIG MATLAB code for stimuli_config.fig
%      STIMULI_CONFIG, by itself, creates a new STIMULI_CONFIG or raises the existing
%      singleton*.
%
%      H = STIMULI_CONFIG returns the handle to a new STIMULI_CONFIG or the handle to
%      the existing singleton*.
%
%      STIMULI_CONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIMULI_CONFIG.M with the given input arguments.
%
%      STIMULI_CONFIG('Property','Value',...) creates a new STIMULI_CONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stimuli_config_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stimuli_config_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stimuli_config

% Last Modified by GUIDE v2.5 25-Dec-2017 11:14:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stimuli_config_OpeningFcn, ...
                   'gui_OutputFcn',  @stimuli_config_OutputFcn, ...
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


% --- Executes just before stimuli_config is made visible.
function stimuli_config_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stimuli_config (see VARARGIN)

global hfig_stim_config

% Choose default command line output for stimuli_config
handles.output = hObject;

hfig_stim_config.stim_wav_dir = fullfile(stimprog_path, 'stimuli wav\');
stim_names = [];

for i = 3:length(dir(hfig_stim_config.stim_wav_dir))
    temp_stim = dir(hfig_stim_config.stim_wav_dir); 
    stim_names{i-2} = temp_stim(i).name; 
end

set(handles.listbox_stim_name, 'string', stim_names)


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stimuli_config wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stimuli_config_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_save_stim_config.
function pushbutton_save_stim_config_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_stim_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_stim_config

prompt = {'Enter attenuation for ch1:','Enter attenuation for ch1:'};
title = 'PA5 Attenuator Settings';
dims = [1 35];
definput = {'10','10'};
answer = inputdlg(prompt,title,dims,definput);
answer = str2num(char(answer));
ref_vals = [75;75];


%config_filename = inputdlg('Enter File Name','Stimulus Configuration Filename');

str = get(handles.listbox_stim_name, 'String' )
counts = numel(str);

for i = 1:counts
    set(handles.listbox_stim_name, 'value', i)
    listbox_stim_name_Callback(hObject, eventdata, handles)
    configuration = handles.uitable_stim_config.Data;
    configuration(:,4) = num2cell(answer);
    configuration(:,5) = num2cell(ref_vals);
    config_filename = strcat('stim_config_', cellstr(str(i)));
    file_loc = strcat(hfig_stim_config.selected_stim_dir, '\', config_filename, '.mat'); 
    save(char(file_loc), 'configuration')
end
closereq

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


closereq


% --- Executes when entered data in editable cell(s) in uitable_stim_config.
function uitable_stim_config_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_stim_config (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global hfig_stim_config


if eventdata.Indices(2) == 4 % changes to attenuation value
    % look up signal name
    ao_channel = handles.uitable_stim_config.Data(eventdata.Indices(1),3);
    
    [row col] = size(handles.uitable_stim_config.Data)
    
    for i = 1:row
        if cell2mat(handles.uitable_stim_config.Data(i,3)) == cell2mat(ao_channel)
            handles.uitable_stim_config.Data(i,4) = num2cell(eventdata.NewData);
        end
    end
end


% --- Executes on selection change in listbox_stim_name.
function listbox_stim_name_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_stim_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_stim_name contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_stim_name

global hfig_stim_config

selected_val = handles.listbox_stim_name.Value;
selected_stim = handles.listbox_stim_name.String(selected_val);

selected_stim_dir = strcat(hfig_stim_config.stim_wav_dir, selected_stim);
hfig_stim_config.selected_stim_dir = selected_stim_dir;

stim_config_file = dir(fullfile(char(selected_stim_dir),'*.mat'));
wav_files = dir(fullfile(char(selected_stim_dir),'*.wav'));

temp = load(strcat(char(selected_stim_dir),'\', stim_config_file.name));

%check for new files not in configuration
[row col] = size(temp.configuration);
num_wav_files = length(wav_files);

stim_config_filenames = temp.configuration(:,1);
%stim_config_filenames = selected_stim;

wav_filenames = {wav_files.name};

if row>num_wav_files % more files in configuration than wav files in folder
    % Look for additional file in configuration
    additional_entry = setdiff(stim_config_filenames, wav_filenames);
    [row col] = find(strcmp(temp.configuration,additional_entry));
    % remove 'row' entry
    temp.configuration(row,:)=[];
    
elseif row<num_wav_files % more files in wav folder than configuration
    % Look for additional file in wav folder
    missing = setdiff(wav_filenames, stim_config_filenames);
    %insert missing file
    temp.configuration = [temp.configuration; missing, 'default', num2cell(0), num2cell(0), num2cell(0)];
end
    
temp.configuration(1,1) = cellstr(wav_files(1).name);
temp.configuration(2,1) = cellstr(wav_files(2).name);
temp.configuration(1,2) = selected_stim;
temp.configuration(2,2) = selected_stim;

handles.uitable_stim_config.Data = temp.configuration;


% --- Executes during object creation, after setting all properties.
function listbox_stim_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_stim_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
