function varargout = signal_generator(varargin)
% SIGNAL_GENERATOR M-file for signal_generator.fig
%      SIGNAL_GENERATOR, by itself, creates a new SIGNAL_GENERATOR or raises the existing
%      singleton*.
%
%      H = SIGNAL_GENERATOR returns the handle to a new SIGNAL_GENERATOR or the handle to
%      the existing singleton*.
%
%      SIGNAL_GENERATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNAL_GENERATOR.M with the given input arguments.
%
%      SIGNAL_GENERATOR('Property','Value',...) creates a new SIGNAL_GENERATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before signal_generator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to signal_generator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help signal_generator

% Last Modified by GUIDE v2.5 05-Apr-2019 16:51:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @signal_generator_OpeningFcn, ...
                   'gui_OutputFcn',  @signal_generator_OutputFcn, ...
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


% --- Executes just before signal_generator is made visible.
function signal_generator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to signal_generator (see VARARGIN)

% Choose default command line output for signal_generator
handles.output = hObject;

global stim_param
global hfig_stimulator

hfig_signal_generator = handles;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes signal_generator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = signal_generator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_generate_signal.
function pushbutton_generate_signal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_generate_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
global stim_param;

    %Sampling rate
    srate = 44100;
    
    %Default number of chirps and interchirp intervals
    

    %Channel 1 signal properties
    handles.user.ch1.freq = str2num(get(handles.edit_ch1_frequency_input, 'String'));
    handles.user.ch1.pdur = str2num(get(handles.edit_ch1_pdur_input, 'String'));
    handles.user.ch1.ipi = str2num(get(handles.edit_ch1_ipi_input, 'String'));
    handles.user.ch1.pnum = str2num(get(handles.edit_ch1_pnum_input, 'String'));
    handles.user.ch1.ramp = str2num(get(handles.edit_ch1_ramp_input, 'String'));
    handles.user.ch1.chirpnum = str2num(get(handles.edit_ch1_chirpnum_input, 'String'));
    handles.user.ch1.ici = str2num(get(handles.edit_ch1_ici_input, 'String'));
    handles.user.ch1.delay = str2num(get(handles.edit_ch1_delay, 'String'));
    
    stim_param.ch1.freq = str2num(get(handles.edit_ch1_frequency_input, 'String'));
    stim_param.ch1.pdur = str2num(get(handles.edit_ch1_pdur_input, 'String'));
    stim_param.ch1.ipi = str2num(get(handles.edit_ch1_ipi_input, 'String'));
    stim_param.ch1.pnum = str2num(get(handles.edit_ch1_pnum_input, 'String'));
    stim_param.ch1.ramp = str2num(get(handles.edit_ch1_ramp_input, 'String'));
    stim_param.ch1.chirpnum = str2num(get(handles.edit_ch1_chirpnum_input, 'String'));
    stim_param.ch1.ici = str2num(get(handles.edit_ch1_ici_input, 'String'));
    stim_param.ch1.delay = str2num(get(handles.edit_ch1_delay, 'String'));

    
    %Channel 2 signal properties
    handles.user.ch2.freq = str2num(get(handles.edit_ch2_frequency_input, 'String'));
    handles.user.ch2.pdur = str2num(get(handles.edit_ch2_pdur_input, 'String'));
    handles.user.ch2.ipi = str2num(get(handles.edit_ch2_ipi_input, 'String'));
    handles.user.ch2.pnum = str2num(get(handles.edit_ch2_pnum_input, 'String'));
    handles.user.ch2.ramp = str2num(get(handles.edit_ch2_ramp_input, 'String'));
    handles.user.ch2.chirpnum = str2num(get(handles.edit_ch2_chirpnum_input, 'String'));
    handles.user.ch2.ici = str2num(get(handles.edit_ch2_ici_input, 'String'));
    handles.user.ch2.delay = str2num(get(handles.edit_ch2_delay, 'String'));
    
    stim_param.ch2.freq = str2num(get(handles.edit_ch2_frequency_input, 'String'));
    stim_param.ch2.pdur = str2num(get(handles.edit_ch2_pdur_input, 'String'));
    stim_param.ch2.ipi = str2num(get(handles.edit_ch2_ipi_input, 'String'));
    stim_param.ch2.pnum = str2num(get(handles.edit_ch2_pnum_input, 'String'));
    stim_param.ch2.ramp = str2num(get(handles.edit_ch2_ramp_input, 'String'));
    stim_param.ch2.chirpnum = str2num(get(handles.edit_ch2_chirpnum_input, 'String'));
    stim_param.ch2.ici = str2num(get(handles.edit_ch2_ici_input, 'String'));
    stim_param.ch2.delay = str2num(get(handles.edit_ch2_delay, 'String'));
    
    %Create Ch1 ramp
    Ch1_on = 0:round(handles.user.ch1.ramp * srate / 1000);
    Ch1_ramp_length = length(Ch1_on);
    Ch1_on = sin(Ch1_on/Ch1_ramp_length * pi/2).^2; %raised sin half-cycle, "ramp" ms rise-time
    
    Ch1_off = 0:round(handles.user.ch1.ramp * srate / 1000);
    Ch1_off = cos(Ch1_off/Ch1_ramp_length * pi/2).^2; %raised cos half-cycle, "ramp" ms fall-time
          
    %Create Ch2 ramp
    Ch2_on = 0:round(handles.user.ch2.ramp * srate / 1000);
    Ch2_ramp_length = length(Ch2_on);
    Ch2_on = sin(Ch2_on/Ch2_ramp_length * pi/2).^2; %raised sin half-cycle, "ramp" ms rise-time
    
    Ch2_off = 0:round(handles.user.ch2.ramp * srate / 1000);
    Ch2_off = cos(Ch2_off/Ch2_ramp_length * pi/2).^2; %raised cos half-cycle, "ramp" ms fall-time
    
    %Create tones
    
    Ch1_tone = 0:round(handles.user.ch1.pdur * srate / 1000);
    Ch1_tone = sin(Ch1_tone*2*pi* handles.user.ch1.freq/srate);
    
    Ch2_tone = 0:round(handles.user.ch2.pdur * srate / 1000);
    Ch2_tone = sin(Ch2_tone*2*pi*handles.user.ch2.freq/srate);
    
    %Apply ramps
    Ch1_tone(1:Ch1_ramp_length) = Ch1_tone(1:Ch1_ramp_length).* Ch1_on;
    Ch1_tone((length(Ch1_tone)-(Ch1_ramp_length-1)):end) = Ch1_tone((length(Ch1_tone)-(Ch1_ramp_length-1)):end).* Ch1_off;
           
    Ch2_tone(1:Ch2_ramp_length) = Ch2_tone(1:Ch2_ramp_length).* Ch2_on;
    Ch2_tone((length(Ch2_tone)-(Ch2_ramp_length-1)):end) = Ch2_tone((length(Ch2_tone)-(Ch2_ramp_length-1)):end).* Ch2_off;
      
    %Create chirps for Channel 1
    Ch1_silence_pts = round(handles.user.ch1.ipi * srate/1000);
    Ch1_silence = [zeros(1,Ch1_silence_pts)];
    %Ch1_pulse_int = [zeros(1,Ch1_silence_pts), Ch1_tone];
    Ch1_pulse_int = [Ch1_tone,zeros(1,Ch1_silence_pts)];
    
    Ch1_chirp = [];
    
    for i = 1:handles.user.ch1.pnum
        Ch1_chirp = [Ch1_chirp, Ch1_pulse_int];
    end  
    
    %Create chirps for Channel 2
    Ch2_silence_pts = round(handles.user.ch2.ipi * srate/1000);
    Ch2_silence = [zeros(1,Ch2_silence_pts)];
    %Ch2_pulse_int = [zeros(1,Ch2_silence_pts), Ch2_tone];
    Ch2_pulse_int = [Ch2_tone,zeros(1,Ch2_silence_pts)];
    
    Ch2_chirp = [];
    
    for j = 1:handles.user.ch2.pnum
        Ch2_chirp = [Ch2_chirp, Ch2_pulse_int];
    end
    
    %%%%%%%%%%%%%%%
    %checks for the longer interpulse interval
    
%     adjust = abs(handles.user.ch1.ipi - handles.user.ch2.ipi);
%     adjust_silence = [];
%     
%      if handles.user.ch1.ipi > handles.user.ch2.ipi
%          Ch1_chirp = Ch1_chirp(round(adjust*srate/1000):length(Ch1_chirp));
%      elseif handles.user.ch2.ipi> handles.user.ch1.ipi
%          Ch2_chirp = Ch2_chirp(round(adjust*srate/1000):length(Ch2_chirp));
%      end
%      
%      adjust_silence = abs(length(Ch1_chirp) - length(Ch2_chirp));
%      
%      if length(Ch1_chirp) > length(Ch2_chirp)
%          Ch2_chirp = [Ch2_chirp zeros(1,adjust_silence)];
%      elseif length(Ch2_chirp) >length(Ch1_chirp)
%          Ch1_chirp = [Ch1_chirp zeros(1,adjust_silence)];
%      end
     
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Create songs
    
    ch1_ici = handles.user.ch1.ici;
    ch1_ici_pts = round(ch1_ici * srate/1000);
    ch1_ici_silence = [zeros(1, ch1_ici_pts)];
    
    ch2_ici = handles.user.ch2.ici;
    ch2_ici_pts = round(ch2_ici * srate/1000);
    ch2_ici_silence = [zeros(1, ch2_ici_pts)];
    
    
    ch1_signal = [];
    ch2_signal = [];
    adjust_ici = [];
    adjust_ici_silence = [];
    
    Ch1_Chirp_interchirp = [Ch1_chirp, ch1_ici_silence];
    Ch2_Chirp_interchirp = [Ch2_chirp, ch2_ici_silence];

    ch1_delay_silence_pts = round(handles.user.ch1.delay * srate/1000);
    ch2_delay_silence_pts = round(handles.user.ch2.delay * srate/1000);
    
    ch1_delay_silence = [zeros(1, ch1_delay_silence_pts)];
    ch2_delay_silence = [zeros(1, ch2_delay_silence_pts)];
    
    Ch1_Chirp_interchirp = [ch1_delay_silence, Ch1_Chirp_interchirp];
    Ch2_Chirp_interchirp = [ch2_delay_silence, Ch2_Chirp_interchirp];

%     if length(Ch1_Chirp_interchirp) > length(Ch2_Chirp_interchirp)
%         adjust_ici = length(Ch1_Chirp_interchirp) - length(Ch2_Chirp_interchirp);
%         adjust_ici_silence = zeros(1,adjust_ici);
%         Ch2_Chirp_interchirp =  [Ch2_Chirp_interchirp adjust_ici_silence];
%     elseif length(Ch2_Chirp_interchirp) > length(Ch1_Chirp_interchirp)
%         adjust_ici = length(Ch2_Chirp_interchirp) - length(Ch1_Chirp_interchirp);
%         adjust_ici_silence = zeros(1,adjust_ici);
%         Ch1_Chirp_interchirp =  [Ch1_Chirp_interchirp adjust_ici_silence];
%     end
        

    stim_param.ch1.ici = handles.user.ch1.ici;
    stim_param.ch1.chirpnum = handles.user.ch1.chirpnum;
    
    stim_param.ch2.ici = handles.user.ch2.ici;
    stim_param.ch2.chirpnum = handles.user.ch2.chirpnum;

    
    
    for k = 1:handles.user.ch1.chirpnum
        ch1_signal = [ch1_signal Ch1_Chirp_interchirp];
    end
    
    if isempty(handles.user.ch1.ici)
        ch1_signal = [Ch1_chirp];
    else
        %ch1_signal = [ch1_signal(length(ch1_lead_silence):end), ch1_lead_silence];
    end
    
    
    for l = 1:handles.user.ch2.chirpnum
        ch2_signal = [ch2_signal Ch2_Chirp_interchirp];
    end
    
    if isempty(handles.user.ch2.ici)
        ch2_signal = [Ch2_chirp];
    else
        %ch2_signal = [ch2_signal(length(ch2_lead_silence):end), ch2_lead_silence];
    end


     %Adjusts Ch1 and Ch2 signals so that they are the same length
     add_silence = [];
     
     if length(ch1_signal) > length(ch2_signal)
         add_silence = [zeros(1, (length(ch1_signal)-length(ch2_signal)))];
         ch2_signal = [ch2_signal, add_silence];
     elseif length(ch1_signal) < length(ch2_signal)
         add_silence = [zeros(1, (length(ch2_signal)-length(ch1_signal)))];
         ch1_signal = [ch1_signal, add_silence];
     end 
        
    silence =  zeros(length(ch1_signal),1)';
    ch1_signal = [silence ch1_signal silence];
    ch2_signal = [ch2_signal silence silence];
  
    [Ch1_time] = 0:(1000*length(ch1_signal)/44100)/length(ch1_signal):(1000*length(ch1_signal)/44100);
    [Ch1_time] = Ch1_time(1:length(ch1_signal));
    
    [Ch2_time] = 0:(1000*length(ch2_signal)/44100)/length(ch2_signal):(1000*length(ch2_signal)/44100);
    [Ch2_time] = Ch2_time(1:length(ch2_signal));
    
    
    % reduce stimulus intensity
    
    %ch1_signal = ch1_signal*0.5;
    %ch2_signal = ch2_signal*0.5;
    
    %Plot stimuli
       
    set(handles.figure1, 'CurrentAxes', handles.ch1_axes);
    plot(Ch1_time, ch1_signal);
    set(handles.figure1, 'CurrentAxes', handles.ch2_axes);
    plot(Ch2_time, ch2_signal, 'r');
   
    stim_param.ch1.signal = ch1_signal;
    stim_param.ch2.signal = ch2_signal;
    stim_param.ch1.time = Ch1_time;
    stim_param.ch2.time = Ch2_time;
    
    %write wav files
    if  ~isempty(get(handles.edit_ch1_filename, 'String'))
       
        ch1_save_filename = get(handles.edit_ch1_filename,'string');
        ch1_save_filename = strcat('Ch1_', ch1_save_filename,'.wav');
        
    else
        ch1_save_filename = 'test_ch1.wav';
    end
        
    if ~isempty(get(handles.edit_ch2_filename, 'String'))
        
        ch2_save_filename = get(handles.edit_ch2_filename,'string');
        ch2_save_filename = strcat('Ch2_', ch2_save_filename,'.wav');
    else
        ch2_save_filename = 'test_ch2.wav';
    end
    
   
    audiowrite(char(ch1_save_filename),ch1_signal,44100)
    audiowrite(char(ch2_save_filename),ch2_signal,44100)
   
   
function edit_ch2_pdur_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_pdur_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_pdur_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_pdur_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_pdur_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_pdur_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_ipi_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_ipi_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_ipi_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_ipi_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_ipi_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_ipi_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_pnum_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_pnum_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_pnum_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_pnum_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_pnum_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_pnum_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_ramp_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_ramp_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_ramp_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_ramp_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_ramp_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_ramp_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_onset_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_onset_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_onset_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_onset_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_onset_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_onset_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_frequency_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_frequency_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_frequency_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_frequency_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_frequency_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_frequency_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_pnum_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_pnum_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_pnum_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_pnum_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_pnum_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_pnum_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_ramp_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_ramp_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_ramp_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_ramp_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_ramp_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_ramp_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_pdur_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_pdur_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_pdur_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_pdur_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_pdur_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_pdur_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_ipi_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_ipi_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_ipi_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_ipi_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_ipi_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_ipi_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_onset_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_onset_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_onset_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_onset_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_onset_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_onset_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_frequency_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_frequency_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_frequency_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_frequency_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_frequency_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_frequency_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_ici_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_ici_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_ici_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_ici_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_ici_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_ici_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_chirpnum_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_chirpnum_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_chirpnum_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_chirpnum_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_chirpnum_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_chirpnum_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_chirpnum_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_chirpnum_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_chirpnum_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_chirpnum_input as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_chirpnum_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_chirpnum_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_ici_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_ici_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_ici_input as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_ici_input as a double


    

% --- Executes during object creation, after setting all properties.
function edit_ch1_ici_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_ici_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_open_Callback(hObject, eventdata, handles)
% hObject    handle to menu_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open uigetfile dialog GUI
[filename, pathname] = uigetfile({'*.mat'}, 'Open Stimulus settings *.mat');

load(filename)

set(handles.figure1, 'CurrentAxes', handles.ch1_axes)
plot(stim_param.ch1.time, stim_param.ch1.signal);
set(handles.figure1, 'CurrentAxes', handles.ch2_axes)
plot(stim_param.ch2.time, stim_param.ch2.signal, 'r');

set(handles.edit_ch1_frequency_input, 'String', stim_param.ch1.freq);
set(handles.edit_ch1_pdur_input, 'String', stim_param.ch1.pdur);
set(handles.edit_ch1_ipi_input, 'String', stim_param.ch1.ipi);
set(handles.edit_ch1_pnum_input, 'String', stim_param.ch1.pnum);
set(handles.edit_ch1_ramp_input, 'String', stim_param.ch1.ramp);
set(handles.edit_ch1_chirpnum_input, 'String', stim_param.ch1.chirpnum);
set(handles.edit_ch1_ici_input, 'String', stim_param.ch1.ici);

set(handles.edit_ch2_frequency_input, 'String', stim_param.ch2.freq);
set(handles.edit_ch2_ipi_input, 'String', stim_param.ch2.ipi);
set(handles.edit_ch2_pnum_input, 'String', stim_param.ch2.pnum);
set(handles.edit_ch2_ramp_input, 'String', stim_param.ch2.ramp);
set(handles.edit_ch2_chirpnum_input, 'String', stim_param.ch2.chirpnum);
set(handles.edit_ch2_ici_input, 'String', stim_param.ch2.ici);
set(handles.edit_ch2_pdur_input, 'String', stim_param.ch2.pdur);


% read stimulus parameters


% --------------------------------------------------------------------
function menu_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global stim_param;

% Open uiputfile dialog GUI
filename = uiputfile({'*.mat'}, 'Save stimulus settings *.mat');

save(filename, 'stim_param');


% --------------------------------------------------------------------
function menu_quit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

quit;



function edit_ch1_delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_delay as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_delay as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_delay as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_delay as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_save_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_save_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_save_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_save_filename as a double


% --- Executes during object creation, after setting all properties.
function edit_save_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_save_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch1_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch1_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch1_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_ch1_filename as a double


% --- Executes during object creation, after setting all properties.
function edit_ch1_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch1_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ch2_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ch2_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ch2_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_ch2_filename as a double


% --- Executes during object creation, after setting all properties.
function edit_ch2_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ch2_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
