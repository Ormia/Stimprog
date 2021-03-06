function varargout = treadmillsetup(varargin)
% TREADMILLSETUP M-file for treadmillsetup.fig
%      TREADMILLSETUP, by itself, creates a new TREADMILLSETUP or raises the existing
%      singleton*.
%
%      H = TREADMILLSETUP returns the handle to a new TREADMILLSETUP or the handle to
%      the existing singleton*.
%
%      TREADMILLSETUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREADMILLSETUP.M with the given input arguments.
%
%      TREADMILLSETUP('Property','Value',...) creates a new TREADMILLSETUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before treadmillsetup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to treadmillsetup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help treadmillsetup

% Last Modified by GUIDE v2.5 20-May-2011 10:56:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @treadmillsetup_OpeningFcn, ...
                   'gui_OutputFcn',  @treadmillsetup_OutputFcn, ...
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


% --- Executes just before treadmillsetup is made visible.
function treadmillsetup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to treadmillsetup (see VARARGIN)

global hfig_treadmill_setup
global hfig_ballgui

% Choose default command line output for treadmillsetup
handles.output = hObject;

if hfig_treadmill_setup.status == 1; %treadmill on
    set(handles.text_duration, 'visible', 'on');
    set(handles.edit_duration, 'visible', 'on');
    status = 2; %treadmill on
    
    try
        set(handles.edit_duration, 'String', num2str(hfig_treadmill_setup.capture_dur))
    catch
        set(handles.edit_duration, 'String', num2str(1))
    end
    
else
    set(handles.text_duration, 'visible', 'off');
    set(handles.edit_duration, 'visible', 'off');
    status = 1; %treadmill off
end

    radiobuttons = get(handles.uipanel_treadmill, 'children');
    set(handles.uipanel_treadmill, 'SelectedObject', radiobuttons(status));
    
% Update handles structure
guidata(hObject, handles);
uiwait(handles.treadmill_options);


% UIWAIT makes treadmillsetup wait for user response (see UIRESUME)
% uiwait(handles.treadmill_options);


% --- Outputs from this function are returned to the command line.
function varargout = treadmillsetup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.treadmill_options);


% --- Executes on button press in pushbutton_done.
function pushbutton_done_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_treadmill_setup
global hfig_ballgui


if hfig_treadmill_setup.status == 1;
    duration = hfig_treadmill_setup.capture_dur;

    %-------------------------------------------------------------
    % create serial interface with treadmill

    hfig_treadmill_setup.npts = (2160 * duration * 4) + 4;
 
    s = serial('COM4');
    s.BaudRate = 115200;
    s.timeout=1.5;
    s.terminator='';
    s.BytesAvailableFcnMode='byte';
    s.BytesAvailablefcncount= hfig_treadmill_setup.npts;
    s.InputBufferSize= hfig_treadmill_setup.npts;

    hfig_treadmill_setup.serial_interface = s;
    
     try
         fopen(hfig_treadmill_setup.serial_interface);
         fwrite(hfig_treadmill_setup.serial_interface,255)
     catch exception
         if strcmp(exception.identifier, 'MATLAB:serial:fopen:opfailed')
             ind = findstr('COM', exception.message);
             find_COM = exception.message(ind(2):ind(2)+3);
             hfig_treadmill_setup.COM = find_COM;
             
             s = serial(find_COM);
             s.BaudRate = 115200;
             s.timeout=1.5;
             s.terminator='';
             s.BytesAvailableFcnMode='byte';
             s.BytesAvailablefcncount= hfig_treadmill_setup.npts;
             s.InputBufferSize= hfig_treadmill_setup.npts;
             
             hfig_treadmill_setup.serial_interface = s;
             fopen(hfig_treadmill_setup.serial_interface);
         end
     end
     
     fwrite(hfig_treadmill_setup.serial_interface,254)
     fclose(hfig_treadmill_setup.serial_interface);

    %-------------------------------------------------------------
else
    %do nothing
end


if hfig_treadmill_setup.status == 1;
    set(hfig_ballgui.handles.ch1datacq, 'visible', 'off');
    set(hfig_ballgui.handles.ch2datacq, 'visible', 'off');
    set(hfig_ballgui.handles.ballplot, 'visible', 'on');
else
    set(hfig_ballgui.handles.ch1datacq, 'visible', 'on');
    set(hfig_ballgui.handles.ch2datacq, 'visible', 'on');
    set(hfig_ballgui.handles.ballplot, 'visible', 'off');
end



guidata(hObject, handles);
uiresume(handles.treadmill_options);


function edit_duration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_duration as text
%        str2double(get(hObject,'String')) returns contents of edit_duration as a double

global hfig_treadmill_setup

hfig_treadmill_setup.capture_dur = str2num(get(handles.edit_duration, 'String'));


% --- Executes during object creation, after setting all properties.
function edit_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel_treadmill.
function uipanel_treadmill_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_treadmill 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global hfig_treadmill_setup

status = get(handles.uipanel_treadmill, 'SelectedObject');

switch get(status, 'Tag') 
    
    case 'radiobutton_on'
        hfig_treadmill_setup.status = 1; % treadmill on
        set(handles.edit_duration, 'visible', 'on')
        set(handles.text_duration, 'visible', 'on')
        
        try
            set(handles.edit_duration, 'String', num2str(hfig_treadmill_setup.capture_dur))
        catch
            set(handles.edit_duration, 'String', num2str(1))
        end
        
    case 'radiobutton_off'
        hfig_treadmill_setup.status = 0; % treadmill on
        set(handles.edit_duration, 'visible', 'off')
        set(handles.text_duration, 'visible', 'off')
end


% --- Executes when user attempts to close treadmill_options.
function treadmill_options_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to treadmill_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hfig_ballgui


% if hfig_treadmill_setup.status == 1;
%     set(hfig_ballgui.handles.ch1datacq, 'visible', 'off');
%     set(hfig_ballgui.ch2datacq, 'visible', 'off');
%     set(hfig_ballgui.ballplot, 'visible', 'on');
% else
%     set(hfig_ballgui.ch1datacq, 'visible', 'on');
%     set(hfig_ballgui.ch2datacq, 'visible', 'on');
%     set(hfig_ballgui.ballplot, 'visible', 'off');
% end


% Hint: delete(hObject) closes the figure
uiresume(handles.treadmill_options);
delete(hObject);
