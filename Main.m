%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           SISTEMA IDRAULICO 4.5                         %
%                               (liquidi)                                 % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% by Alberto Margari (2011)
% by Barbara Bertani (2015)
% by Fabio Bernardini (2016)
% by F. M. Marchese (2011-17)
%
% Tested with ver. MatLab Rl2013b
%


%%
function varargout = Main(varargin)
% Main M-file for Main.fig
%      Main, by itself, creates a1 new Main or raises the existing
%      singleton*.
%
%      H = Main returns the handle to a1 new Main or the handle to
%      the existing singleton*.
%
%      Main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Main.M with the given input arguments.
%
%      Main('Property','Value',...) creates a1 new Main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%   IMPORTANTE: necessita l'installazione del Image Processing Toolbox
%   per la funzione imshow()

%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 29-Nov-2016 14:51:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)
clc

global Sistemi;
Sistemi = 'Sistemi/*.m';

% Impostazioni di default
global def;
def =[
      1        % IngressoTipo
      1        % IngressoPar
      1        % Uscita
      0        % Phii_min   (4)
      5        % Phii, Phii_cur
      10       % Phii_max
      0        % A1_min
      2        % A1, A1_cur
      10       % A1_max
      0        % A2_min
      2        % A2, A2_cur
      10       % A2_max
      900      % rho_min  (13)
      1000     % rho, rho_cur
      1100     % rho_max
      0        % R1_min  
      500        % R1, R1_cur
      1000       % R1_max
      0        % R2_min  (19)
      500        % R2, R2_cur
      1000       % R2_max
      0        % h10_min (22)
      0        % h10, h10_cur
      10       % h10_max
      0        % h20_min  (25)
      0        % h20, h20_cur
      10       % h20_max
      ];
    
% Par degli slider
global Phiisld A1sld A2sld rhosld R1sld R2sld h10sld h20sld;

Phiisld.stmin = 0.1;
Phiisld.stmax = 1;
Phiisld.Llim = -Inf;
Phiisld.Hlim = +Inf;

A1sld.stmin = 0.1;
A1sld.stmax = 1;
A1sld.Llim = eps;
A1sld.Hlim = +Inf;

A2sld.stmin = 0.1;
A2sld.stmax = 1;
A2sld.Llim = eps;
A2sld.Hlim = +Inf;

rhosld.stmin = 10;
rhosld.stmax = 50;
rhosld.Llim = eps;
rhosld.Hlim = +Inf;

R1sld.stmin = 10;
R1sld.stmax = 100;
R1sld.Llim = eps;
R1sld.Hlim = +Inf;

R2sld.stmin = 10;
R2sld.stmax = 100;
R2sld.Llim = eps;
R2sld.Hlim = +Inf;

h10sld.stmin = 0.1;
h10sld.stmax = 1;
h10sld.Llim = eps;
h10sld.Hlim = +Inf;

h20sld.stmin = 0.1;
h20sld.stmax = 1;
h20sld.Llim = eps;
h20sld.Hlim = +Inf;

evalin('base', 'input_params = containers.Map();'); 

Load_Defaults(handles);


% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% Preparazione menu elenco dei modelli trovati nella directory corrente
model_list = {};
file_list = dir(Sistemi);
for i = 1:size(file_list, 1)
    model_list(i, 1) = cellstr(file_list(i).name(1:size(file_list(i).name, 2)-2));
end
model_list = vertcat([cellstr('Default')], model_list);
set(handles.ConfigLoadName, 'String', model_list);
set(handles.ConfigLoadName, 'Value',  1);
set(handles.ConfigDelete, 'Enable', 'off');


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% FIGURE
% --- Executes during object creation, after setting all properties.
function Schema_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Schema (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
im = imread('Schema.jpg');
image(im);
axis off;
axis equal;


%%
% --- Executes during object creation, after setting all properties.
function Modello_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Modello (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
im = imread('Modello.jpg');
image(im);
axis off;
axis equal;


%%RUN
% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)global Uscita;
clc

global Uscita;

% Chiudo il modello simulink senza salvare
bdclose(Uscita);

% Leggo la variabile di Uscita del sistema (y)
Uscita = 'SistemaIdraulico';

% Carico i valori dei parametri dal Workspace
ampiezza = evalin('base', 'input_params(''Ampiezza [m^3/s]'')');
if get(handles.IngressoTipo, 'Value') == 3
    frequenza = evalin('base', 'input_params(''Frequenza [Hz]'')');
else
    frequenza = evalin('base', 'input_params(''Frequenza [Hz]'')');
end
dutycycle = evalin('base', 'input_params(''Duty Cycle [%]'')');

% Controllo sui dati nulli
if frequenza == 0, frequenza = eps; end
if get(handles.IngressoTipo, 'Value') == 3, if frequenza == 1000, frequenza = 999.999; end, end
if dutycycle < 0.0001, dutycycle = 0.0001; end
if dutycycle == 100, dutycycle = 100-0.0001; end


% Leggo i dati inseriti dall'utente
Phii  = ampiezza(2);
A1   = get(handles.A1, 'Value');
A2   = get(handles.A2, 'Value');
rho = get(handles.rho, 'Value');
R1  = get(handles.R1, 'Value');
R2  = get(handles.R2, 'Value');
h10 = get(handles.h10, 'Value');
h20 = get(handles.h20, 'Value');
g = 9.8;


% Esporta tutte le variabili nel Workspace per permettere a1 Simulink
% di averne visibilità
vars = {'A1', A1; 'A2', A2; 'rho', rho; 'R1', R1; 'Phii', Phii; 'R2', R2; 'h10', h10; 'h20', h20};
for i = 1:size(vars, 1)
    name = vars(i, 1);
    value = vars(i, 2);
    assignin('base', name{1}, value{1}); 
end


% Calcolo costanti di tempo
F = [-rho*g/(R1*A1),  rho*g/(R1*A1);
      rho*g/(R1*A2), -rho*g*(1/R1+1/R2)/A2];
Tau = TimeConstantLTI(F);
% valore di default in caso di fallimento calcolo
if isnan(Tau), Tau = 0.1; end
Tau = min(1, Tau);  % sogliatura per evitare sim troppo lunghe


% Apre il sistema da simulare
open_system(Uscita);


% Impostazione del segnale in input al sistema
h = find_system(Uscita, 'Name', 'input');
if size(h) == [1, 1]
  system_blocks = find_system(Uscita);
  if numel(find(strcmp(system_blocks, [Uscita '/step1']))) > 0
    delete_line(Uscita, 'step1/1', 'input/1');
    delete_block([Uscita, '/step1']);
  end
  if numel(find(strcmp(system_blocks, [Uscita '/step2']))) > 0
    delete_line(Uscita, 'step2/1', 'input/2');
    delete_block([Uscita, '/step2']);  
  end
  if numel(find(strcmp(system_blocks, [Uscita '/input']))) > 0
    delete_line(Uscita, 'input/1', 'Gain/1');
    delete_block([Uscita, '/input']);
  end
end


% Legge qual'è il nuovo segnale in iNput da simulare
val = get(handles.IngressoTipo, 'Value');
switch val
  case 1  % step
      add_block('simulink/Sources/Step', [Uscita, '/input'], 'Time', num2str(0.5*Tau));
  case 2  % impulso
      add_block('simulink/Sources/Step', [Uscita, '/step1'], 'Time', num2str(0.5*Tau));
      add_block('simulink/Sources/Step', [Uscita, '/step2'], 'Time', num2str(0.5*Tau+min(0.25*Tau, 0.01)));
      add_block('simulink/Math Operations/Sum', [Uscita, '/input'], 'Inputs', '+-');
  case 3  % treno impulsi
      add_block('simulink/Sources/Pulse Generator', [Uscita, '/input'], 'Period', num2str(1/frequenza(2)), 'PulseWidth', num2str(frequenza(2)*0.1));
  case 4  % sinusoide
      add_block('simulink/Sources/Sine Wave', [Uscita, '/input'], 'Frequency', num2str(2*pi*frequenza(2)));
  case 5  % onda quadra
      add_block('simulink/Sources/Pulse Generator', [Uscita, '/input'], 'Period', num2str(1/frequenza(2)), 'PulseWidth', num2str(dutycycle(2)));
  case 6  % onda dente di sega
      add_block('simulink/Sources/Repeating Sequence', [Uscita, '/input'], 'rep_seq_t', ['[0 ' num2str(1/frequenza(2)) ']'], 'rep_seq_y', '[0 1]');
end;


% Modifica della durata della simulazione
switch val
  case {1, 2}
      set_param(Uscita, 'StopTime', num2str(5*Tau + 0.5*Tau));
  case {3, 4, 5, 6}
      set_param(Uscita, 'StopTime', num2str(6/frequenza(2)));
end


% Modifica dello sfondo e della posizione del blocco inserito
set_param([Uscita, '/input'], 'BackgroundColor', '[0, 206, 206]');
GainPos = get_param([Uscita, '/Gain'], 'Position');
avgGainh = (GainPos(2)+GainPos(4))/2;
if val ~= 2
  set_param([Uscita, '/input'], 'Position', ['[0,' num2str(avgGainh-15) ', 65,' num2str(avgGainh+15) ']']); % '[40, 90, 105, 120]');
else
  set_param([Uscita, '/step1'], 'BackgroundColor', '[0, 206, 206]');
  set_param([Uscita, '/step2'], 'BackgroundColor', '[0, 206, 206]');
  set_param([Uscita, '/step1'], 'Position', ['[0,' num2str(avgGainh-30-15) ', 65 ,' num2str(avgGainh-30+15) ']']);    % '[20, 45, 85, 75]');
  set_param([Uscita, '/step2'], 'Position', ['[0,' num2str(avgGainh+30-15) ', 65 ,' num2str(avgGainh+30+15)  ']']);  % '[20, 135, 85, 165]');
  set_param([Uscita, '/input'], 'Position', ['[75,' num2str(avgGainh-10) ', 95,' num2str(avgGainh+10) ']']); % '[95, 95, 115, 115]');
  add_line(Uscita, 'step1/1', 'input/1' , 'autorouting', 'on');
  add_line(Uscita, 'step2/1', 'input/2' , 'autorouting', 'on');
end

% Nuovo collegamento con il blocco successivo (Gain)
add_line(Uscita, 'input/1', 'Gain/1' , 'autorouting', 'on');

% Salva il sistema
save_system(Uscita);

% Avvia la simulazione
sim(Uscita);

ViewerAutoscale();


%% USCITA
% --- Executes on selection change in Uscita.
function Uscita_Callback(hObject, eventdata, handles)
% hObject    handle to Uscita (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Uscita contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Uscita


% --- Executes during object creation, after setting all properties.
function Uscita_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Uscita (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%SLIDER A1
% --- Executes on slider movement.
function A1_Callback(hObject, eventdata, handles)
% hObject    handle to A1 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Slider_sld_Callback(handles, handles.A1, handles.A1_cur);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function A1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a1 light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%
function A1_min_Callback(hObject, eventdata, handles)
% hObject    handle to A1_min (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1sld;
Slider_min_Callback(handles, handles.A1, handles.A1_min, handles.A1_cur, handles.A1_max, A1sld.stmin, A1sld.stmax, A1sld.Llim, A1sld.Hlim);
% Hints: get(hObject,'String') returns contents of A1_min as text
%        str2double(get(hObject,'String')) returns contents of A1_min as a1 double


% --- Executes during object creation, after setting all properties.
function A1_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1_min (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function A1_cur_Callback(hObject, eventdata, handles)
% hObject    handle to A1_cur (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1sld;
Slider_cur_Callback(handles, handles.A1, handles.A1_min, handles.A1_cur, handles.A1_max, A1sld.stmin, A1sld.stmax, A1sld.Llim, A1sld.Hlim);

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');
% Hints: get(hObject,'String') returns contents of A1_cur as text
%        str2double(get(hObject,'String')) returns contents of A1_cur as a1 double


% --- Executes during object creation, after setting all properties.
function A1_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1_cur (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function A1_max_Callback(hObject, eventdata, handles)
% hObject    handle to A1_max (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A1sld;
Slider_max_Callback(handles, handles.A1, handles.A1_min, handles.A1_cur, handles.A1_max, A1sld.stmin, A1sld.stmax, A1sld.Llim, A1sld.Hlim);
% Hints: get(hObject,'String') returns contents of A1_max as text
%        str2double(get(hObject,'String')) returns contents of A1_max as a1 double


% --- Executes during object creation, after setting all properties.
function A1_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1_max (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%SLIDER A2
% --- Executes on slider movement.
function A2_Callback(hObject, eventdata, handles)
% hObject    handle to A2 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Slider_sld_Callback(handles, handles.A2, handles.A2_cur);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function A2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a1 light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%
function A2_min_Callback(hObject, eventdata, handles)
% hObject    handle to A2_min (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A2sld;
Slider_min_Callback(handles, handles.A2, handles.A2_min, handles.A2_cur, handles.A2_max, A2sld.stmin, A2sld.stmax, A2sld.Llim, A2sld.Hlim);
% Hints: get(hObject,'String') returns contents of A2_min as text
%        str2double(get(hObject,'String')) returns contents of A2_min as a1 double


% --- Executes during object creation, after setting all properties.
function A2_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2_min (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function A2_cur_Callback(hObject, eventdata, handles)
% hObject    handle to A2_cur (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A2sld;
Slider_cur_Callback(handles, handles.A2, handles.A2_min, handles.A2_cur, handles.A2_max, A2sld.stmin, A2sld.stmax, A2sld.Llim, A2sld.Hlim);

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');
% Hints: get(hObject,'String') returns contents of A2_cur as text
%        str2double(get(hObject,'String')) returns contents of A2_cur as a1 double


% --- Executes during object creation, after setting all properties.
function A2_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2_cur (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function A2_max_Callback(hObject, eventdata, handles)
% hObject    handle to A2_max (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A2sld;
Slider_max_Callback(handles, handles.A2, handles.A2_min, handles.A2_cur, handles.A2_max, A2sld.stmin, A2sld.stmax, A2sld.Llim, A2sld.Hlim);
% Hints: get(hObject,'String') returns contents of A2_max as text
%        str2double(get(hObject,'String')) returns contents of A2_max as a1 double


% --- Executes during object creation, after setting all properties.
function A2_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2_max (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% SLIDER rho
% --- Executes on slider movement.
function rho_Callback(hObject, eventdata, handles)
% hObject    handle to rho (see GCBO)
Slider_sld_Callback(handles, handles.rho, handles.rho_cur);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function rho_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%
function rho_min_Callback(hObject, eventdata, handles)
% hObject    handle to rho_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rhosld;
Slider_min_Callback(handles, handles.rho, handles.rho_min, handles.rho_cur, handles.rho_max, rhosld.stmin, rhosld.stmax, rhosld.Llim, rhosld.Hlim);

% Hints: get(hObject,'String') returns contents of .rhomin as text
%        str2double(get(hObject,'String')) returns contents of .rhomin as a double


% --- Executes during object creation, after setting all properties.
function rho_min_CreateFcn(hObject, eventdata, ~)
% hObject    handle to rho_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function rho_cur_Callback(hObject, eventdata, handles)
% hObject    handle to rho_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rhosld;
Slider_cur_Callback(handles, handles.rho, handles.rho_min, handles.rho_cur, handles.rho_max, rhosld.stmin, rhosld.stmax, rhosld.Llim, rhosld.Hlim);

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');
% Hints: get(hObject,'String') returns contents of rho_cur as text
%        str2double(get(hObject,'String')) returns contents of rho_cur as a double


% --- Executes during object creation, after setting all properties.
function rho_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rho_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function rho_max_Callback(hObject, eventdata, handles)
% hObject    handle to rho_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rhosld;
Slider_max_Callback(handles, handles.rho, handles.rho_min, handles.rho_cur, handles.rho_max, rhosld.stmin, rhosld.stmax, rhosld.Llim, rhosld.Hlim);
% Hints: get(hObject,'String') returns contents of .rhomax as text
%        str2double(get(hObject,'String')) returns contents of .rhomax as a double


% --- Executes during object creation, after setting all properties.
function rho_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rho_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%SLIDER R1
%%
% --- Executes on slider movement.
function R1_Callback(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
Slider_sld_Callback(handles, handles.R1, handles.R1_cur);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function R1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%
function R1_min_Callback(hObject, eventdata, handles)
% hObject    handle to R1_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global R1sld;
Slider_min_Callback(handles, handles.R1, handles.R1_min, handles.R1_cur, handles.R1_max, R1sld.stmin, R1sld.stmax, R1sld.Llim, R1sld.Hlim);

% Hints: get(hObject,'String') returns contents of R1_min as text
%        str2double(get(hObject,'String')) returns contents of R1_min as a double


% --- Executes during object creation, after setting all properties.
function R1_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function R1_cur_Callback(hObject, eventdata, handles)
% hObject    handle to R1_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global R1sld;
Slider_cur_Callback(handles, handles.R1, handles.R1_min, handles.R1_cur, handles.R1_max, R1sld.stmin, R1sld.stmax, R1sld.Llim, R1sld.Hlim);

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');
% Hints: get(hObject,'String') returns contents of R1_cur as text
%        str2double(get(hObject,'String')) returns contents of R1_cur as a double


% --- Executes during object creation, after setting all properties.
function R1_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function R1_max_Callback(hObject, eventdata, handles)
% hObject    handle to R1_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global R1sld;
Slider_max_Callback(handles, handles.R1, handles.R1_min, handles.R1_cur, handles.R1_max, R1sld.stmin, R1sld.stmax, R1sld.Llim, R1sld.Hlim);
% Hints: get(hObject,'String') returns contents of R1_max as text
%        str2double(get(hObject,'String')) returns contents of R1_max as a double


% --- Executes during object creation, after setting all properties.
function R1_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%SLIDER R2
%%
% --- Executes on slider movement.
function R2_Callback(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
Slider_sld_Callback(handles, handles.R2, handles.R2_cur);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function R2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%
function R2_min_Callback(hObject, eventdata, handles)
% hObject    handle to R2_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global R2sld;
Slider_min_Callback(handles, handles.R2, handles.R2_min, handles.R2_cur, handles.R2_max, R2sld.stmin, R2sld.stmax, R2sld.Llim, R2sld.Hlim);

% Hints: get(hObject,'String') returns contents of R2_min as text
%        str2double(get(hObject,'String')) returns contents of R2_min as a double


% --- Executes during object creation, after setting all properties.
function R2_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function R2_cur_Callback(hObject, eventdata, handles)
% hObject    handle to R2_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global R2sld;
Slider_cur_Callback(handles, handles.R2, handles.R2_min, handles.R2_cur, handles.R2_max, R2sld.stmin, R2sld.stmax, R2sld.Llim, R2sld.Hlim);

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');
% Hints: get(hObject,'String') returns contents of R2_cur as text
%        str2double(get(hObject,'String')) returns contents of R2_cur as a double


% --- Executes during object creation, after setting all properties.
function R2_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function R2_max_Callback(hObject, eventdata, handles)
% hObject    handle to R2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global R2sld;
Slider_max_Callback(handles, handles.R2, handles.R2_min, handles.R2_cur, handles.R2_max, R2sld.stmin, R2sld.stmax, R2sld.Llim, R2sld.Hlim);
% Hints: get(hObject,'String') returns contents of R2_max as text
%        str2double(get(hObject,'String')) returns contents of R2_max as a double


% --- Executes during object creation, after setting all properties.
function R2_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%SLIDER h10
%%
% --- Executes on slider movement.
function h10_Callback(hObject, eventdata, handles)
% hObject    handle to h10 (see GCBO)
Slider_sld_Callback(handles, handles.h10, handles.h10_cur);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function h10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%
function h10_min_Callback(hObject, eventdata, handles)
% hObject    handle to h10_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h10sld;
Slider_min_Callback(handles, handles.h10, handles.h10_min, handles.h10_cur, handles.h10_max, h10sld.stmin, h10sld.stmax, h10sld.Llim, h10sld.Hlim);

% Hints: get(hObject,'String') returns contents of h10_min as text
%        str2double(get(hObject,'String')) returns contents of h10_min as a double


% --- Executes during object creation, after setting all properties.
function h10_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h10_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function h10_cur_Callback(hObject, eventdata, handles)
% hObject    handle to h10_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h10sld;
Slider_cur_Callback(handles, handles.h10, handles.h10_min, handles.h10_cur, handles.h10_max, h10sld.stmin, h10sld.stmax, h10sld.Llim, h10sld.Hlim);

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');
% Hints: get(hObject,'String') returns contents of h10_cur as text
%        str2double(get(hObject,'String')) returns contents of h10_cur as a double


% --- Executes during object creation, after setting all properties.
function h10_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h10_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function h10_max_Callback(hObject, eventdata, handles)
% hObject    handle to h10_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h10sld;
Slider_max_Callback(handles, handles.h10, handles.h10_min, handles.h10_cur, handles.h10_max, h10sld.stmin, h10sld.stmax, h10sld.Llim, h10sld.Hlim);
% Hints: get(hObject,'String') returns contents of h10_max as text
%        str2double(get(hObject,'String')) returns contents of h10_max as a double


% --- Executes during object creation, after setting all properties.
function h10_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h10_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%SLIDER h20
%%
% --- Executes on slider movement.
function h20_Callback(hObject, eventdata, handles)
% hObject    handle to h20 (see GCBO)
Slider_sld_Callback(handles, handles.h20, handles.h20_cur);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function h20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%
function h20_min_Callback(hObject, eventdata, handles)
% hObject    handle to h20_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h20sld;
Slider_min_Callback(handles, handles.h20, handles.h20_min, handles.h20_cur, handles.h20_max, h20sld.stmin, h20sld.stmax, h20sld.Llim, h20sld.Hlim);

% Hints: get(hObject,'String') returns contents of h20_min as text
%        str2double(get(hObject,'String')) returns contents of h20_min as a double


% --- Executes during object creation, after setting all properties.
function h20_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h20_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function h20_cur_Callback(hObject, eventdata, handles)
% hObject    handle to h20_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h20sld;
Slider_cur_Callback(handles, handles.h20, handles.h20_min, handles.h20_cur, handles.h20_max, h20sld.stmin, h20sld.stmax, h20sld.Llim, h20sld.Hlim);

% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');
% Hints: get(hObject,'String') returns contents of h20_cur as text
%        str2double(get(hObject,'String')) returns contents of h20_cur as a double


% --- Executes during object creation, after setting all properties.
function h20_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h20_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function h20_max_Callback(hObject, eventdata, handles)
% hObject    handle to h20_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h20sld;
Slider_max_Callback(handles, handles.h20, handles.h20_min, handles.h20_cur, handles.h20_max, h20sld.stmin, h20sld.stmax, h20sld.Llim, h20sld.Hlim);
% Hints: get(hObject,'String') returns contents of h20_max as text
%        str2double(get(hObject,'String')) returns contents of h20_max as a double


% --- Executes during object creation, after setting all properties.
function h20_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h20_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%% INGRESSI
% --- Executes on selection change in IngressoTipo.
function IngressoTipo_Callback(hObject, eventdata, handles)
% hObject    handle to IngressoTipo (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns IngressoTipo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from IngressoTipo

% Segnala la modifica
global modified;
modified = true;
list = get(handles.ConfigLoadName, 'String');
index = get(handles.ConfigLoadName, 'Value');
name = [list{index}, '_'];
set(handles.ConfigSaveName, 'String', name);


id_ingresso = get(hObject, 'Value');

new_String = cell(1);
new_String{1} = 'Ampiezza [m^3/s]';


switch id_ingresso
  case {1, 2}
    set(handles.IngressoPar, 'Value', 1);
    set(handles.IngressoPar, 'Enable', 'off');
  case 3
    new_String{2} = 'Frequenza [Hz]'; 
    if get(handles.IngressoPar, 'Value') > 2
            set(handles.IngressoPar, 'Value', 2);
        end
        set(handles.IngressoPar, 'Enable', 'on');
  case 5
    new_String{2} = 'Frequenza [Hz]'; 
    new_String{3} = 'Duty Cycle [%]';  
    if get(handles.IngressoPar, 'Value') > 3
            set(handles.IngressoPar, 'Value', 3);
        end
        set(handles.IngressoPar, 'Enable', 'on');
    
  case {4, 6}
    new_String{2} = 'Frequenza [Hz]'; 
    if get(handles.IngressoPar, 'Value') > 2
            set(handles.IngressoPar, 'Value', 2);
        end
    set(handles.IngressoPar, 'Enable', 'on');
end

set(handles.IngressoPar, 'String', new_String);
set(handles.IngressoTipo, 'Value', id_ingresso);
set(handles.IngressoPar, 'Value', 1);

parametri = get(handles.IngressoPar, 'String');
param_name = parametri{get(handles.IngressoPar, 'Value')};
values = evalin('base', ['input_params(''' param_name ''')']);

set(handles.Phii_min, 'Value',  values(1));
set(handles.Phii_min, 'String', num2str(values(1), '%.1f'));
set(handles.Phii_cur, 'Value',  values(2));
set(handles.Phii_cur, 'String', num2str(values(2), '%.1f'));
set(handles.Phii_max, 'Value',  values(3));
set(handles.Phii_max, 'String', num2str(values(3), '%.1f'));
set(handles.Phii, 'Min',   values(1));
set(handles.Phii, 'Value', values(2));
set(handles.Phii, 'Max',   values(3));


% --- Executes during object creation, after setting all properties.
function IngressoTipo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IngressoTipo (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in IngressoPar.
function IngressoPar_Callback(hObject, eventdata, handles)
% hObject    handle to IngressoPar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Segnala la modifica
global modified;
modified = true;
list = get(handles.ConfigLoadName, 'String');
index = get(handles.ConfigLoadName, 'Value');
name = [list{index}, '_'];
set(handles.ConfigSaveName, 'String', name);


parametri = get(handles.IngressoPar, 'String');
param_name = parametri{get(handles.IngressoPar, 'Value')};
values = evalin('base', ['input_params(''' param_name ''')']);

set(handles.Phii_min, 'Value',  values(1));
set(handles.Phii_min, 'String', num2str(values(1), '%.1f'));
set(handles.Phii_cur, 'Value',  values(2));
set(handles.Phii_cur, 'String', num2str(values(2), '%.1f'));
set(handles.Phii_max, 'Value',  values(3));
set(handles.Phii_max, 'String', num2str(values(3), '%.1f'));
set(handles.Phii, 'Min',   values(1));
set(handles.Phii, 'Max',   values(3));
set(handles.Phii, 'Value', values(2));



% --- Executes during object creation, after setting all properties.
function IngressoPar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IngressoPar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
% --- Executes on slider movement.
function Phii_Callback(hObject, eventdata, handles)
% hObject    handle to Phii (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Slider_sld_Callback(handles, handles.Phii, handles.Phii_cur);

val = get(handles.Phii, 'Value');
parametri = get(handles.IngressoPar, 'String');
param_name = parametri{get(handles.IngressoPar, 'Value')};
values = evalin('base', ['input_params(''' param_name ''')']);
values(2) = val;
evalin('base', ['input_params(''' param_name ''') = ' mat2str(values) ';']);

% Past instruction:
% evalin('base', ['input_param(' num2str(get(handles.IngressoPar, 'Value')) ') = ' num2str(get(hObject, 'Value')) ';']);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Phii_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phii (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a1 light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%
function Phii_max_Callback(hObject, eventdata, handles)
% hObject    handle to Phii_max (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Phiisld;
Slider_max_Callback(handles, handles.Phii, handles.Phii_min, handles.Phii_cur, handles.Phii_max, Phiisld.stmin, Phiisld.stmax, Phiisld.Llim, Phiisld.Hlim);

parametri = get(handles.IngressoPar, 'String');
param_name = parametri{get(handles.IngressoPar, 'Value')};
values = [get(handles.Phii, 'Min') get(handles.Phii, 'Value'), get(handles.Phii, 'Max')];
evalin('base', ['input_params(''' param_name ''') = ' mat2str(values) ';']);

% Hints: get(hObject,'String') returns contents of Phii_max as text
%        str2double(get(hObject,'String')) returns contents of Phii_max as a1 double


% --- Executes during object creation, after setting all properties.
function Phii_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phii_max (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Phii_min_Callback(hObject, eventdata, handles)
% hObject    handle to Phii_min (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Phiisld;
Slider_min_Callback(handles, handles.Phii, handles.Phii_min, handles.Phii_cur, handles.Phii_max, Phiisld.stmin, Phiisld.stmax, Phiisld.Llim, Phiisld.Hlim);

parametri = get(handles.IngressoPar, 'String');
param_name = parametri{get(handles.IngressoPar, 'Value')};
values = [get(handles.Phii, 'Min') get(handles.Phii, 'Value'), get(handles.Phii, 'Max')];
evalin('base', ['input_params(''' param_name ''') = ' mat2str(values) ';']);
% Hints: get(hObject,'String') returns contents of Phii_min as text
%        str2double(get(hObject,'String')) returns contents of Phii_min as a1 double


% --- Executes during object creation, after setting all properties.
function Phii_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phii_min (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function Phii_cur_Callback(hObject, eventdata, handles)
% hObject    handle to Phii_cur (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Phiisld;
Slider_cur_Callback(handles, handles.Phii, handles.Phii_min, handles.Phii_cur, handles.Phii_max, Phiisld.stmin, Phiisld.stmax, Phiisld.Llim, Phiisld.Hlim);


parametri = get(handles.IngressoPar, 'String');
param_name = parametri{get(handles.IngressoPar, 'Value')}; 
values = [get(handles.Phii, 'Min') get(handles.Phii, 'Value'), get(handles.Phii, 'Max')];
evalin('base', ['input_params(''' param_name ''') = ' mat2str(values) ';']);
% Hints: get(hObject,'String') returns contents of Phii_cur as text
%        str2double(get(hObject,'String')) returns contents of Phii_cur as a1 double


% --- Executes during object creation, after setting all properties.
function Phii_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phii_cur (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% VALORI DI DEFAULT
% 
function Load_Defaults(handles)

global def;
global Phiisld A1sld A2sld rhosld R1sld R2sld h10sld h20sld;


% ingressi
IngressoParstr = cell(1);
IngressoParstr{1} = 'Ampiezza [m^3/s]';
IngressoParval = get(handles.IngressoPar, 'Value');
set(handles.IngressoPar, 'Enable', 'on');

switch def(1)
  case {1, 2}
    set(handles.IngressoPar, 'Value', 1);
    set(handles.IngressoPar, 'Enable', 'off');
  case 3
    IngressoParstr{2} = 'Frequenza [Hz]';
    set(handles.IngressoPar, 'Value', 2);
  case 5
    IngressoParstr{2} = 'Frequenza [Hz]'; 
    IngressoParstr{3} = 'Duty Cycle [%]'; 
    set(handles.IngressoPar, 'Value', 3);
  case {4, 6}
    IngressoParstr{2} = 'Frequenza [Hz]'; 
    set(handles.IngressoPar, 'Value', 2);
end

set(handles.IngressoPar, 'String', IngressoParstr);
set(handles.IngressoTipo, 'Value', def(1));
set(handles.IngressoPar, 'Value', def(2));

% Uscita
set(handles.Uscita, 'Value', def(3)); 


% slider Phii
set(handles.Phii_min, 'Value', def(4));
set(handles.Phii_min, 'String', num2str(def(4),  '%.1f')); 
set(handles.Phii_cur, 'Value', def(5));
set(handles.Phii_cur, 'String', num2str(def(5), '%.2f')); 
set(handles.Phii_max, 'Value', def(6));
set(handles.Phii_max, 'String', num2str(def(6), '%.1f'));

set(handles.Phii, 'Min',   def(4)); 
set(handles.Phii, 'Value', def(5));
set(handles.Phii, 'Max',   def(6)); 
majorstep = Phiisld.stmax / (def(6)-def(4));
minorstep = Phiisld.stmin / (def(6)-def(4));
set(handles.Phii, 'SliderStep', [minorstep majorstep]);

vect = mat2str([get(handles.Phii, 'Min') get(handles.Phii, 'Value') get(handles.Phii, 'Max')]);
evalin('base', ['input_params(''Ampiezza [m^3/s]'') = ' vect ';']);
evalin('base', 'input_params(''Frequenza [Hz]'') = [0 100 10000];'); % Frequenza dei segnali periodici tranne il treno di impulsi
evalin('base', 'input_params(''Frequenza [Hz]'') = [0 100 500];');   % Frequenza del treno di impulsi
evalin('base', 'input_params(''Duty Cycle [%]'') = [0 50 100];');


% slider A1
set(handles.A1_min, 'Value', def(7));
set(handles.A1_min, 'String', num2str(def(7),  '%.1f')); 
set(handles.A1_cur, 'Value', def(8));
set(handles.A1_cur, 'String', num2str(def(8), '%.2f')); 
set(handles.A1_max, 'Value', def(9));
set(handles.A1_max, 'String', num2str(def(9), '%.1f'));

set(handles.A1, 'Min',   def(7)); 
set(handles.A1, 'Value', def(8));
set(handles.A1, 'Max',   def(9)); 
majorstep = A1sld.stmax / (def(9)-def(7));
minorstep = A1sld.stmin / (def(9)-def(7));
set(handles.A1, 'SliderStep', [minorstep majorstep]);

% slider A2
set(handles.A2_min, 'Value', def(10));
set(handles.A2_min, 'String', num2str(def(10),  '%.1f')); 
set(handles.A2_cur, 'Value', def(11));
set(handles.A2_cur, 'String', num2str(def(11), '%.2f')); 
set(handles.A2_max, 'Value', def(12));
set(handles.A2_max, 'String', num2str(def(12), '%.1f'));

set(handles.A2, 'Min',   def(10)); 
set(handles.A2, 'Value', def(11));
set(handles.A2, 'Max',   def(12)); 
majorstep = A2sld.stmax / (def(12)-def(10));
minorstep = A2sld.stmin / (def(12)-def(10));
set(handles.A2, 'SliderStep', [minorstep majorstep]);

% slider rho
set(handles.rho_min, 'Value', def(13));
set(handles.rho_min, 'String', num2str(def(13), '%.1f'));
set(handles.rho_cur, 'Value', def(14));
set(handles.rho_cur, 'String', num2str(def(14), '%.2f'));
set(handles.rho_max, 'Value', def(15));
set(handles.rho_max, 'String', num2str(def(15), '%.1f'));

set(handles.rho, 'Min',   def(13)); 
set(handles.rho, 'Value', def(14));
set(handles.rho, 'Max',   def(15)); 
majorstep = rhosld.stmax / (def(15)-def(13));
minorstep = rhosld.stmin / (def(15)-def(13));
set(handles.rho, 'SliderStep', [minorstep majorstep]);


% slider R1
set(handles.R1_min, 'Value', def(16));
set(handles.R1_min, 'String', num2str(def(16), '%.1f'));
set(handles.R1_cur, 'Value', def(17));
set(handles.R1_cur, 'String', num2str(def(17), '%.2f'));
set(handles.R1_max, 'Value', def(18));
set(handles.R1_max, 'String', num2str(def(18), '%.1f'));

set(handles.R1, 'Min',   def(16)); 
set(handles.R1, 'Value', def(17));
set(handles.R1, 'Max',   def(18)); 
majorstep = R1sld.stmax / (def(18)-def(16));
minorstep = R1sld.stmin / (def(18)-def(16));
set(handles.R1, 'SliderStep', [minorstep majorstep]);

% slider R2
set(handles.R2_min, 'Value', def(19));
set(handles.R2_min, 'String', num2str(def(19), '%.1f'));
set(handles.R2_cur, 'Value', def(20));
set(handles.R2_cur, 'String', num2str(def(20), '%.2f'));
set(handles.R2_max, 'Value', def(21));
set(handles.R2_max, 'String', num2str(def(21), '%.1f'));

set(handles.R2, 'Min',   def(19)); 
set(handles.R2, 'Value', def(20));
set(handles.R2, 'Max',   def(21)); 
majorstep = R2sld.stmax / (def(21)-def(19));
minorstep = R2sld.stmin / (def(21)-def(19));
set(handles.R2, 'SliderStep', [minorstep majorstep]);

% slider h10
set(handles.h10_min, 'Value', def(22));
set(handles.h10_min, 'String', num2str(def(22), '%.1f'));
set(handles.h10_cur, 'Value', def(23));
set(handles.h10_cur, 'String', num2str(def(23), '%.2f'));
set(handles.h10_max, 'Value', def(24));
set(handles.h10_max, 'String', num2str(def(24), '%.1f'));

set(handles.h10, 'Min',   def(22)); 
set(handles.h10, 'Value', def(23));
set(handles.h10, 'Max',   def(24)); 
majorstep = h10sld.stmax / (def(24)-def(22));
minorstep = h10sld.stmin / (def(24)-def(22));
set(handles.h10, 'SliderStep', [minorstep majorstep]);


% slider h20
set(handles.h20_min, 'Value', def(25));
set(handles.h20_min, 'String', num2str(def(25), '%.1f'));
set(handles.h20_cur, 'Value', def(26));
set(handles.h20_cur, 'String', num2str(def(26), '%.2f'));
set(handles.h20_max, 'Value', def(27));
set(handles.h20_max, 'String', num2str(def(27), '%.1f'));

set(handles.h20, 'Min',   def(25)); 
set(handles.h20, 'Value', def(26));
set(handles.h20, 'Max',   def(27)); 
majorstep = h20sld.stmax / (def(27)-def(25));
minorstep = h20sld.stmin / (def(27)-def(25));
set(handles.h20, 'SliderStep', [minorstep majorstep]);

set(handles.ConfigSaveName, 'String', 'nomefile');



%%
% --- Executes when user attempts to close Dialog.
function Dialog_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Dialog (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc

% Chiusura dello schema simulink senza salvare
bdclose('all');

% Hint: ConfigDelete(hObject) closes the figure
delete(hObject);

% Pulizia workspace
evalin('base', 'clear');



function Punto_eq_Callback(hObject, eventdata, handles)
% hObject    handle to Punto_eq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc

ampiezza = evalin('base', 'input_params(''Ampiezza [m^3/s]'')');

set(handles.IngressoTipo,'Value',1);
set(handles.IngressoPar, 'Value', 1);
set(handles.IngressoPar, 'Enable', 'off');

set(handles.Phii_min, 'Value',  ampiezza(1));
set(handles.Phii_min, 'String', num2str(ampiezza(1), '%.1f'));
set(handles.Phii_cur, 'Value',  ampiezza(2));
set(handles.Phii_cur, 'String', num2str(ampiezza(2), '%.2f'));
set(handles.Phii_max, 'Value',  ampiezza(3));
set(handles.Phii_max, 'String', num2str(ampiezza(3), '%.1f'));
set(handles.Phii, 'Min',   ampiezza(1));
set(handles.Phii, 'Value', ampiezza(2));
set(handles.Phii, 'Max',   ampiezza(3));

% Leggo i dati inseriti dall'utente
Phii = get(handles.Phii, 'Value');
A1 = get(handles.A1, 'Value');
A2 = get(handles.A2, 'Value');
rho = get(handles.rho, 'Value');
R1 = get(handles.R1, 'Value');
R2 = get(handles.R2, 'Value');
g = 9.81;
u = Phii;

% Controllo sui dati nulli
if R1 == 0, R1 = eps; end
if R2 == 0, R2 = eps; end
if A1 == 0, A1 = eps; end
if A2 == 0, A2 = eps; end


% Scrittura dell'equazione dinamica
% Risoluzione dell'equazione 0 = F*x + G*u nell'incognita x (u noto)
% Preparazione matrici 
F = [-rho*g/(R1*A1),  rho*g/(R1*A1);
      rho*g/(R1*A2), -rho*g*(1/R1+1/R2)/A2];     
G = [1/A1; 0];

[x, stb] = PuntoEquilibrioLTI2(F, G, u);
if isnan(stb)
  set(handles.Punto_Eq_txt, 'String', ...
    {'Non esiste uno stato di equilibrio con l''ingresso: ';...
    ['Phii = ', num2str(u(1), '%.2f'), ' m^3/s']});
  return
end


% Preparazione testo da visualizzare
str = sprintf('In presenza dell''ingresso: Phii = %.1f m^3/s', u(1));
str1 = sprintf('\nlo stato:');
str21 = sprintf('\n  h1 = %.1f m', x(1));
str22 = sprintf('\n  h2 = %.1f m', x(2));

% Stabilita'
switch stb
  case -1.2
    str3 = sprintf('\n e'' asintoticamente stabile (osc.)');
  case -1.1
    str3 = sprintf('\n e'' asintoticamente stabile');
  case  0.1
    str3 = sprintf('\n e'' semplicemente stabile');
  case  0.2
    str3 = sprintf('\n e'' semplicemente stabile (osc.)');
  case +1.1
    str3 = sprintf('\n e'' debolmente instabile');
  case +1.2
    str3 = sprintf('\n e'' debolmente instabile (osc.)');
  case +2.1
    str3 = sprintf('\n e'' fortemente instabile');
  case +2.2
    str3 = sprintf('\n e'' fortemente instabile (osc.)');
  otherwise
    str1 = sprintf('\nper lo stato:');
    str3 = sprintf('\n la stabilità NON e'' determinabile');
end

endstr = '.';
str = strcat(str, str1, str21, str22, str3, endstr);
set(handles.punto_eq_txt, 'String', str);



%% GESTIONE CONFIGURAZIONI
% --- Executes on button press in ConfigLoad.
function ConfigLoad_Callback(hObject, eventdata, handles)
% hObject    handle to ConfigLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Recupera il nome della config
val = get(handles.ConfigLoadName, 'Value');
string_list = get(handles.ConfigLoadName, 'String');
name = string_list{val};

% Controllo se la configurazione corrente sia stata modificata
global modified;
if modified == true
  choice = questdlg('Do you want to save this configuration?', 'Config Saving', 'Yes', 'No', 'No');
  switch choice
    case 'Yes'
      % Save della configurazione corrente
      ConfigSave_Callback(hObject, [], handles);
    case 'No'
      % no action
  end
end
modified = false;
fclose('all');

% Ricerca nella lista della posizione della config
% che l'utente voleva caricare prima del salvataggio
string_list = get(handles.ConfigLoadName, 'String');
for i = 1 : size(string_list, 1)
  if strcmp(string_list{i}, name) == 1
    val = i;
    % Selezione nel menu della configurazione da caricare
    set(handles.ConfigLoadName, 'Value', i);
    break;
  end
end

% Se tale configurazione e' 'Default', si chiama la funzione config_load_Defaults
if val == 1
  Load_Defaults(handles);
  return;
end


if exist('Sistemi', 'dir') == 0
  mkdir('Sistemi');
  return;
end
cd('Sistemi');

set(handles.ConfigSaveName, 'String', name);

% Lettura dei dati e creazione delle variabili
text = fileread([name, '.m']);
eval(text);

fclose('all');

cd('..');

% Aggiornamento degli slider
global Phiisld A1sld A2sld rhosld R1sld R2sld h10sld h20sld;
set(handles.A1_min, 'Value',  A1_min);
set(handles.A1_min, 'String', num2str(A1_min, '%.1f'));
set(handles.A1_cur, 'Value',  A1_cur);
set(handles.A1_cur, 'String', num2str(A1_cur, '%.2f'));
set(handles.A1_max, 'Value',  A1_max);
set(handles.A1_max, 'String', num2str(A1_max, '%.1f'));

set(handles.A1, 'Min',   A1_min);
set(handles.A1, 'Value', A1_cur);
set(handles.A1, 'Max',   A1_max);
majorstep = A1sld.stmax / (A1_max-A1_min);
minorstep = A1sld.stmin / (A1_max-A1_min);
set(handles.A1, 'SliderStep', [minorstep majorstep]);

set(handles.A2_min, 'Value',  A2_min);
set(handles.A2_min, 'String', num2str(A2_min, '%.1f'));
set(handles.A2_cur, 'Value',  A2_cur);
set(handles.A2_cur, 'String', num2str(A2_cur, '%.2f'));
set(handles.A2_max, 'Value',  A2_max);
set(handles.A2_max, 'String', num2str(A2_max, '%.1f'));

set(handles.A2, 'Min',   A2_min);
set(handles.A2, 'Value', A2_cur);
set(handles.A2, 'Max',   A2_max);
majorstep = A2sld.stmax / (A2_max-A2_min);
minorstep = A2sld.stmin / (A2_max-A2_min);
set(handles.A2, 'SliderStep', [minorstep majorstep]);

set(handles.rho_min, 'Value',  rho_min);
set(handles.rho_min, 'String', num2str(rho_min, '%.1f'));
set(handles.rho_cur, 'Value',  rho_cur);
set(handles.rho_cur, 'String', num2str(rho_cur, '%.2f'));
set(handles.rho_max, 'Value',  rho_max);
set(handles.rho_max, 'String', num2str(rho_max, '%.1f'));

set(handles.rho, 'Min',   rho_min);
set(handles.rho, 'Value', rho_cur);
set(handles.rho, 'Max',   rho_max);
majorstep = rhosld.stmax / (rho_max-rho_min);
minorstep = rhosld.stmin / (rho_max-rho_min);
set(handles.rho, 'SliderStep', [minorstep majorstep]);

set(handles.R1_min, 'Value',  R1_min);
set(handles.R1_min, 'String', num2str(R1_min, '%.1f'));
set(handles.R1_cur, 'Value',  R1_cur);
set(handles.R1_cur, 'String', num2str(R1_cur, '%.2f'));
set(handles.R1_max, 'Value',  R1_max);
set(handles.R1_max, 'String', num2str(R1_max, '%.1f'));

set(handles.R1, 'Min',   R1_min);
set(handles.R1, 'Value', R1_cur);
set(handles.R1, 'Max',   R1_max);
majorstep = R1sld.stmax / (R1_max-R1_min);
minorstep = R1sld.stmin / (R1_max-R1_min);
set(handles.R1, 'SliderStep', [minorstep majorstep]);

set(handles.R2_min, 'Value',  R2_min);
set(handles.R2_min, 'String', num2str(R2_min, '%.1f'));
set(handles.R2_cur, 'Value',  R2_cur);
set(handles.R2_cur, 'String', num2str(R2_cur, '%.2f'));
set(handles.R2_max, 'Value',  R2_max);
set(handles.R2_max, 'String', num2str(R2_max, '%.1f'));

set(handles.R2, 'Min',   R2_min);
set(handles.R2, 'Value', R2_cur);
set(handles.R2, 'Max',   R2_max);
majorstep = R2sld.stmax / (R2_max-R2_min);
minorstep = R2sld.stmin / (R2_max-R2_min);
set(handles.R2, 'SliderStep', [minorstep majorstep]);

set(handles.h10_min, 'Value',  h10_min);
set(handles.h10_min, 'String', num2str(h10_min, '%.1f'));
set(handles.h10_cur, 'Value',  h10_cur);
set(handles.h10_cur, 'String', num2str(h10_cur, '%.2f'));
set(handles.h10_max, 'Value',  h10_max);
set(handles.h10_max, 'String', num2str(h10_max, '%.1f'));

set(handles.h10, 'Min',   h10_min);
set(handles.h10, 'Value', h10_cur);
set(handles.h10, 'Max',   h10_max);
majorstep = h10sld.stmax / (h10_max-h10_min);
minorstep = h10sld.stmin / (h10_max-h10_min);
set(handles.h10, 'SliderStep', [minorstep majorstep]);


set(handles.h20_min, 'Value',  h20_min);
set(handles.h20_min, 'String', num2str(h20_min, '%.1f'));
set(handles.h20_cur, 'Value',  h20_cur);
set(handles.h20_cur, 'String', num2str(h20_cur, '%.2f'));
set(handles.h20_max, 'Value',  h20_max);
set(handles.h20_max, 'String', num2str(h20_max, '%.1f'));

set(handles.h20, 'Min',   h20_min);
set(handles.h20, 'Value', h20_cur);
set(handles.h20, 'Max',   h20_max);
majorstep = h20sld.stmax / (h20_max-h20_min);
minorstep = h20sld.stmin / (h20_max-h20_min);
set(handles.h20, 'SliderStep', [minorstep majorstep]);


% ingressi
IngressoParstr = cell(1);
IngressoParstr{1} = 'Ampiezza [m^3/s]';
set(handles.IngressoPar, 'Enable', 'on');
switch IngressoTipo
  case {1, 2}
      set(handles.IngressoPar, 'Enable', 'off');
  case 3
      IngressoParstr{2} = 'Frequenza [Hz]';
  case 5
      IngressoParstr{2} = 'Frequenza [Hz]';
      IngressoParstr{3} = 'Duty Cycle [%]';
  case {4, 6}
      IngressoParstr{2} = 'Frequenza [Hz]';
end

set(handles.IngressoPar,  'String', IngressoParstr);
set(handles.IngressoTipo, 'Value',  IngressoTipo);
set(handles.IngressoPar,  'Value',  IngressoPar);

set(handles.Phii_min, 'Value',  Phii_min);
set(handles.Phii_min, 'String', num2str(Phii_min, '%.1f'));
set(handles.Phii_cur, 'Value',  Phii_cur);
set(handles.Phii_cur, 'String', num2str(Phii_cur, '%.2f'));
set(handles.Phii_max, 'Value',  Phii_max);
set(handles.Phii_max, 'String', num2str(Phii_max, '%.1f'));

set(handles.Phii, 'Min',   Phii_min);
set(handles.Phii, 'Value', Phii_cur);
set(handles.Phii, 'Max',   Phii_max);
majorstep = Rsld.stmax / (Phii_max-Phii_min);
minorstep = Rsld.stmin / (Phii_max-Phii_min);
set(handles.Phii, 'SliderStep', [minorstep majorstep]);

set(handles.Uscita, 'Value', Uscita);


% --- Executes on button press in ConfigSave.
function ConfigSave_Callback(hObject, eventdata, handles)
% --- Executes on button press in Save.
% hObject    handle to ConfigSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global modified;

name = get(handles.ConfigSaveName, 'String');

% Gestione nomefile vuoto
if isempty(name)
  errordlg('Empty file name!');
  return;
end

if exist('Sistemi', 'dir') == 0
  mkdir('Sistemi');
end
cd('Sistemi'); 

% Controllo se il nome della configurazione da salvare sia gia' presente
namem = [name, '.m'];
if exist(namem, 'file') == 2
  choice = questdlg('Overwrite file?', 'File Overwrite', 'Yes', 'No', 'No');
  switch choice
    case 'Yes'
      delete(namem);
    case 'No'
      cd('..');
      return
  end
end

modified = false;


% Salvataggio di tutti i parametri
% pannello serbatoio A1
A1_min = get(handles.A1_min, 'Value');
A1_cur = get(handles.A1_cur, 'Value');
A1_max = get(handles.A1_max, 'Value');

% pannello serbatoio A2
A2_min = get(handles.A2_min, 'Value');
A2_cur = get(handles.A2_cur, 'Value');
A2_max = get(handles.A2_max, 'Value');


% pannello densità del liquido, rho
rho_min = get(handles.rho_min, 'Value');
rho_cur = get(handles.rho_cur, 'Value');
rho_max = get(handles.rho_max, 'Value');

% pannello Valvola R1
R1_min = get(handles.R1_min, 'Value');
R1_cur = get(handles.R1_cur, 'Value');
R1_max = get(handles.R1_max, 'Value');

% pannello Valvola R2
R2_min = get(handles.R2_min, 'Value');
R2_cur = get(handles.R2_cur, 'Value');
R2_max = get(handles.R2_max, 'Value');

% pannello ingressi
IngressoTipo = get(handles.IngressoTipo, 'Value');
IngressoPar = get(handles.IngressoPar, 'Value');

Phii_min = get(handles.Phii_min, 'Value');
Phii_cur = get(handles.Phii_cur, 'Value');
Phii_max = get(handles.Phii_max, 'Value');

% pannello stato iniziale
h10_min = get(handles.h10_min, 'Value');
h10_cur = get(handles.h10_cur, 'Value');
h10_max = get(handles.h10_max, 'Value');

h20_min = get(handles.h20_min, 'Value');
h20_cur = get(handles.h20_cur, 'Value');
h20_max = get(handles.h20_max, 'Value');

Uscita = get(handles.Uscita, 'Value');

% Salvataggio parametri su file
fid = fopen(namem, 'w');
fprintf(fid, 'IngressoTipo = %f;\n', IngressoTipo);
fprintf(fid, 'IngressoPar = %f;\n', IngressoPar);
fprintf(fid, 'Uscita = %f;\n', Uscita);

fprintf(fid, 'Phii_min = %f;\n', Phii_min);
fprintf(fid, 'Phii_cur = %f;\n', Phii_cur);
fprintf(fid, 'Phii_max = %f;\n', Phii_max);

fprintf(fid, 'A1_min = %f;\n', A1_min);
fprintf(fid, 'A1_cur = %f;\n', A1_cur);
fprintf(fid, 'A1_max = %f;\n', A1_max);

fprintf(fid, 'A2_min = %f;\n', A2_min);
fprintf(fid, 'A2_cur = %f;\n', A2_cur);
fprintf(fid, 'A2_max = %f;\n', A2_max);

fprintf(fid, 'rho_min = %f;\n', rho_min);
fprintf(fid, 'rho_cur = %f;\n', rho_cur);
fprintf(fid, 'rho_max = %f;\n', rho_max);

fprintf(fid, 'R1_min = %f;\n', R1_min);
fprintf(fid, 'R1_cur = %f;\n', R1_cur);
fprintf(fid, 'R1_max = %f;\n', R1_max);

fprintf(fid, 'R2_min = %f;\n', R2_min);
fprintf(fid, 'R2_cur = %f;\n', R2_cur);
fprintf(fid, 'R2_max = %f;\n', R2_max);

fprintf(fid, 'h10_min = %f;\n', h10_min);
fprintf(fid, 'h10_cur = %f;\n', h10_cur);
fprintf(fid, 'h10_max = %f;\n', h10_max);

fprintf(fid, 'h20_min = %f;\n', h20_min);
fprintf(fid, 'h20_cur = %f;\n', h20_cur);
fprintf(fid, 'h20_max = %f;\n', h20_max);

fclose(fid);
fclose('all');
clearvars fid;
cd('..');

% Aggiornamento del menu della lista dei modelli
% Aggiunge tutti i nomi dei modelli trovati nella directory corrente in
% una struttura temporanea (rimuovendone l'estensione .m)
global Sistemi;

model_list = {};
file_list = dir(Sistemi);
for i = 1 : size(file_list, 1)
  model_list(i, 1) = cellstr(file_list(i).name(1:size(file_list(i).name, 2)-2));
end
model_list = vertcat([cellstr('Default')], model_list);
set(handles.ConfigLoadName, 'String', model_list);

% Attiva la voce di menu della config attuale
for i = 1 : size(model_list, 1)
  if strcmp(model_list(i, 1), name) == 1
    set(handles.ConfigLoadName, 'Value', i);
    break;
  end
end

set(handles.ConfigDelete, 'Enable', 'on');

% hObject    handle to ConfigSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in ConfigLoadName.
function ConfigLoadName_Callback(hObject, eventdata, handles)
% hObject    handle to ConfigLoadName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ConfigLoadName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ConfigLoadName
if get(handles.ConfigLoadName, 'Value') == 1
    set(handles.ConfigDelete, 'Enable', 'off');
else
    set(handles.ConfigDelete, 'Enable', 'on');
end


% --- Executes during object creation, after setting all properties.
function ConfigLoadName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConfigLoadName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ConfigSaveName_Callback(hObject, ~, handles)
% hObject    handle to ConfigSaveName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ConfigSaveName as text
%        str2double(get(hObject,'String')) returns contents of ConfigSaveName as a double


% --- Executes during object creation, after setting all properties.
function ConfigSaveName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConfigSaveName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ConfigDelete.
function ConfigDelete_Callback(hObject, eventdata, handles)

val = get(handles.ConfigLoadName, 'Value');
string_list = get(handles.ConfigLoadName, 'String');
name = strcat(string_list{val}, '.m');
choice = questdlg(['Delete', ' ', name, '?'], 'Config Deletion', 'Yes', 'No', 'No');
switch choice
  case 'Yes'
    if exist('Sistemi', 'dir') == 0, return; end
    cd('Sistemi');
    delete(name);

    % Aggiunge tutti i nomi delle config trovati nella directory corrente 
    % in una struttura temporanea (rimuovendone l'estensione .m)
    file_list = dir('*.m');
    model_list = {};
    for i = 1 : size(file_list, 1)
        model_list(i, 1) = cellstr(file_list(i).name(1:size(file_list(i).name, 2)-2));
    end
    model_list = vertcat([cellstr('Default')], model_list);

    % Aggiornamento della lista dei nomi delle config nel menu 
    set(handles.ConfigLoadName, 'String', model_list);
    set(handles.ConfigLoadName, 'Value', 1);   
    cd('..');
    set(handles.ConfigDelete, 'Enable', 'off');
    Load_Defaults(handles);
  case 'No'
    % no action
end











