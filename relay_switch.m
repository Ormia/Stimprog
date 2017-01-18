function varargout = relay_switch(varargin)
% RELAY_SWITCH M-file for relay_switch.fig
%      RELAY_SWITCH, by itself, creates a new RELAY_SWITCH or raises the existing
%      singleton*.
%
%      H = RELAY_SWITCH returns the handle to a new RELAY_SWITCH or the handle to
%      the existing singleton*.
%
%      RELAY_SWITCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RELAY_SWITCH.M with the given input arguments.
%
%      RELAY_SWITCH('Property','Value',...) creates a new RELAY_SWITCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before relay_switch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to relay_switch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help relay_switch

% Last Modified by GUIDE v2.5 20-Oct-2011 16:06:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @relay_switch_OpeningFcn, ...
                   'gui_OutputFcn',  @relay_switch_OutputFcn, ...
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


% --- Executes just before relay_switch is made visible.
function relay_switch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to relay_switch (see VARARGIN)

global hfig_ballgui

% Choose default command line output for relay_switch
handles.output = hObject;


CD = 'GB';

 PA5x3=actxcontrol('PA5.x',[5 5 26 26]);
 hfig_ballgui.TDT.PA5x3 = PA5x3;
 
 handles.pa5x3 = PA5x3;
 
 %Connects to PA5 #1 via GB
 if invoke(PA5x3,'ConnectPA5',CD,3) % == -1
      e='PA5 connected'
 else
      e= 'PA5 Unable to connect'
 end


 PA5x4=actxcontrol('PA5.x',[5 5 26 26]);
 hfig_ballgui.TDT.PA5x4 = PA5x4;

 handles.pa5x4 = PA5x4;
 
%Connects to PA5 #2 via GB
 if invoke(PA5x4,'ConnectPA5',CD,4) % == -1
     e='PA5 connected'
 else
     e='PA5 Unable to connect'
 end

% load rvds circuit

circ_name = 'pm2relay_switch.rcx';
invoke(hfig_ballgui.TDT.zBus,'zBusSync',3);

%Circuit_Path = circ_name;
hfig_ballgui.TDT.RP2=actxcontrol('RPco.x',[5 5 26 26]);
    

invoke(hfig_ballgui.TDT.RP2,'ConnectRP2',CD,1); %connects RP2 via GB or Xbus given the proper device number
invoke(hfig_ballgui.TDT.RP2,'LoadCOF',circ_name); % Loads circuit'
invoke(hfig_ballgui.TDT.RP2,'Run'); %Starts Circuit'
Status=double((invoke(hfig_ballgui.TDT.RP2,'GetStatus')));%converts value to bin'

    if bitget(Status,1)==0;%checks for errors in starting circuit'
        er='Error connecting to RP2_2 (output)'
    elseif bitget(Status,2)==0; %checks for connection'
        er='Error loading circuit'
    elseif bitget(Status,3)==0
        er='error running circuit'
    else  
        er='Output circuit loaded and running'
    end

circ_name2 = 'pm2relay_switch2.rcx';
invoke(hfig_ballgui.TDT.zBus,'zBusSync',3);

%Circuit_Path = circ_name;
hfig_ballgui.TDT.RP2_2=actxcontrol('RPco.x',[5 5 26 26]);    
 
invoke(hfig_ballgui.TDT.RP2_2,'ConnectRP2',CD,2); %connects RP2 via GB or Xbus given the proper device number
invoke(hfig_ballgui.TDT.RP2_2,'LoadCOF',circ_name2); % Loads circuit'
invoke(hfig_ballgui.TDT.RP2_2,'Run'); %Starts Circuit'
Status=double((invoke(hfig_ballgui.TDT.RP2_2,'GetStatus')));%converts value to bin'

    if bitget(Status,1)==0;%checks for errors in starting circuit'
        er='Error connecting to RP2_2 (output)'
    elseif bitget(Status,2)==0; %checks for connection'
        er='Error loading circuit'
    elseif bitget(Status,3)==0
        er='error running circuit'
    else  
        er='Output circuit loaded and running'
    end    



set(handles.pm2relay_A, 'SelectedObject', handles.radiobutton_mute_A)
set(handles.pm2relay_B, 'SelectedObject', handles.radiobutton_mute_B)

invoke(hfig_ballgui.TDT.PA5x2, 'SetAtten', 120);
invoke(hfig_ballgui.TDT.PA5x3, 'SetAtten', 120);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes relay_switch wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = relay_switch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes when selected object is changed in pm2relay_A.
function pm2relay_A_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pm2relay_A 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global hfig_ballgui

ch_select = get(handles.pm2relay_A, 'SelectedObject');

switch get(ch_select, 'Tag') 
    case 'radiobutton_ch1'
        hfig_ballgui.TDT.pm2relay_chan = 0; % ch1 stimulus put through pm2relay index 0
        %do something
        invoke(hfig_ballgui.TDT.RP2, 'SetTagVal', 'ch_num', 0);
        invoke(hfig_ballgui.TDT.RP2, 'SetTagVal', 'ch_num', 0);
        invoke(hfig_ballgui.TDT.RP2, 'SetTagVal', 'ch_num', 0);
        hfig_ballgui.TDT.zBus.zBusTrigA(0,0,5)
        
        invoke(hfig_ballgui.TDT.PA5x2, 'SetAtten', 3.8);
        
    case 'radiobutton_ch2'
        hfig_ballgui.TDT.pm2relay_chan = 1; % ch1 stimulus put through pm2relay index 1
        invoke(hfig_ballgui.TDT.RP2, 'SetTagVal', 'ch_num', 1);
        invoke(hfig_ballgui.TDT.RP2, 'SetTagVal', 'ch_num', 1);
        invoke(hfig_ballgui.TDT.RP2, 'SetTagVal', 'ch_num', 1);
        hfig_ballgui.TDT.zBus.zBusTrigA(0,0,5)
        
        invoke(hfig_ballgui.TDT.PA5x2, 'SetAtten', 4.5);
        %do something
    case 'radiobutton_mute_A'
        invoke(hfig_ballgui.TDT.PA5x2, 'SetAtten', 120);
end


% --- Executes when selected object is changed in pm2relay_B.
function pm2relay_B_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pm2relay_B 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global hfig_ballgui

ch_select = get(handles.pm2relay_B, 'SelectedObject');

switch get(ch_select, 'Tag') 
    case 'radiobutton_ch3'
        hfig_ballgui.TDT.pm2relay_chan = 0; % ch1 stimulus put through pm2relay index 0
        %do something
        invoke(hfig_ballgui.TDT.RP2_2, 'SetTagVal', 'ch_num', 1);
        invoke(hfig_ballgui.TDT.RP2_2, 'SetTagVal', 'ch_num', 1);
        invoke(hfig_ballgui.TDT.RP2_2, 'SetTagVal', 'ch_num', 1);
        hfig_ballgui.TDT.zBus.zBusTrigA(0,0,5)
        
        invoke(hfig_ballgui.TDT.PA5x3, 'SetAtten', 3.9);
    case 'radiobutton_ch4'
        hfig_ballgui.TDT.pm2relay_chan = 1; % ch1 stimulus put through pm2relay index 1
        invoke(hfig_ballgui.TDT.RP2_2, 'SetTagVal', 'ch_num', 2);
        invoke(hfig_ballgui.TDT.RP2_2, 'SetTagVal', 'ch_num', 2);
        invoke(hfig_ballgui.TDT.RP2_2, 'SetTagVal', 'ch_num', 2);
        hfig_ballgui.TDT.zBus.zBusTrigA(0,0,5)
        
        invoke(hfig_ballgui.TDT.PA5x3, 'SetAtten', 4.4);
        %do something
    case 'radiobutton_mute_B'
        invoke(hfig_ballgui.TDT.PA5x3, 'SetAtten', 120);
end
            
