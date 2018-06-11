%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           SISTEMA IDRAULICO 4.1                         %
%                               (liquidi)                                 % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% by Alberto Margari (2011)
% by Barbara Bertani (2015)
% by Fabio Bernardini (2016)
% by F. M. Marchese (2011-16)
%
% Tested with ver. MatLab Rl2013b
%


%%
function varargout = Main_export(varargin)
% Main_export M-file for Main_export.fig
%      Main_export, by itself, creates a1 new Main_export or raises the existing
%      singleton*.
%
%      H = Main_export returns the handle to a1 new Main_export or the handle to
%      the existing singleton*.
%
%      Main_export('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Main_export.M with the given input arguments.
%
%      Main_export('Property','Value',...) creates a1 new Main_export or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%   IMPORTANTE: necessita l'installazione del Image Processing Toolbox
%   per la funzione imshow()

%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main_export

% Last Modified by GUIDE v2.5 01-Dec-2016 16:32:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_export_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_export_OutputFcn, ...
                   'gui_LayoutFcn',  @Main_export_LayoutFcn, ...
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


% --- Executes just before Main_export is made visible.
function Main_export_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main_export (see VARARGIN)
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


% Choose default command line output for Main_export
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
function varargout = Main_export_OutputFcn(hObject, eventdata, handles) 
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
% Hint: place code in OpeningFcn to populate Schema


%%
% --- Executes during object creation, after setting all properties.
function Modello_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Modello (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
im = imread('Modello.jpg');
image(im);
axis off;
% Hint: place code in OpeningFcn to populate Modello



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

% Verifica e pulisce il segnale in input al sistema
h = find_system(Uscita,'Name','input');
if ( size(h)==[1, 1])
    delete_line(Uscita, 'input/1', 'Gain/1');
    system_blocks = find_system(Uscita);
    if numel(find(strcmp(system_blocks, [Uscita '/step1']))) > 0
        delete_line(Uscita, 'step1/1', 'input/1');
        delete_line(Uscita, 'step2/1', 'input/2');
    end
    delete_block([Uscita,'/input']);
    if numel(find(strcmp(system_blocks, [Uscita '/step1']))) > 0
        delete_block([Uscita,'/step1']);
        delete_block([Uscita,'/step2']);
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


% Modifico lo sfondo e la posizione del blocco inserito
set_param([Uscita,'/input'], 'BackgroundColor','[0,206,206]');
if val~=2
    set_param([Uscita,'/input'], 'Position', '[40,90,105,120]');
else
    set_param([Uscita,'/step1'], 'BackgroundColor','[0,206,206]');
    set_param([Uscita,'/step2'], 'BackgroundColor','[0,206,206]');
    set_param([Uscita,'/step1'], 'Position', '[20,45,85,75]');
    set_param([Uscita,'/step2'], 'Position', '[20,135,85,165]');
    set_param([Uscita,'/input'], 'Position', '[95,95,115,115]');
    add_line(Uscita, 'step1/1', 'input/1' , 'autorouting', 'on');
    add_line(Uscita, 'step2/1', 'input/2' , 'autorouting', 'on');
end

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









% --- Executes on slider movement.
function R2_Callback(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function R2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function R2_min_Callback(hObject, eventdata, handles)
% hObject    handle to R2_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function R2_cur_Callback(hObject, eventdata, handles)
% hObject    handle to R2_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function R2_max_Callback(hObject, eventdata, handles)
% hObject    handle to R2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function R1_min_Callback(hObject, eventdata, handles)
% hObject    handle to R1_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function R1_cur_Callback(hObject, eventdata, handles)
% hObject    handle to R1_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function R1_max_Callback(hObject, eventdata, handles)
% hObject    handle to R1_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Creates and returns a handle to the GUI figure. 
function h1 = Main_export_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'axes', 5, ...
    'uipanel', 20, ...
    'slider', 10, ...
    'edit', 29, ...
    'popupmenu', 6, ...
    'pushbutton', 8, ...
    'text', 3), ...
    'override', 1, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', 'D:\Marchese\Documents\Didattica\DISCO\Robotica\Materiale\MatLab\Esempi\Esempi FM 2016.Mag\14 - Sistema Idraulico.4.1\Main_export.m', ...
    'lastFilename', 'D:\Marchese\Documents\Didattica\DISCO\Robotica\Materiale\MatLab\Esempi\Esempi FM 2016.Mag\14 - Sistema Idraulico.4.1\Main.fig');
appdata.lastValidTag = 'Dialog';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'Dialog');

h1 = figure(...
'Units','characters',...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'CloseRequestFcn',@(hObject,eventdata)Main_export('Dialog_CloseRequestFcn',hObject,eventdata,guidata(hObject)),...
'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
'Colormap',[1 1 1;0 0 0;0.529411764705882 0.529411764705882 0.529411764705882;0.427450980392157 0.435294117647059 0.0196078431372549;0.325490196078431 0.325490196078431 0.325490196078431;0.341176470588235 0.752941176470588 1;0.419607843137255 0 0.192156862745098;0.988235294117647 0.415686274509804 0.0313725490196078;1 1 0.329411764705882;0.423529411764706 0.188235294117647 0.0117647058823529;0.745098039215686 0.266666666666667 1;0 0 0;0 0 0;0 0 0;0 0 0;0 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','SISTEMA IDRAULICO (liquidi)',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',get(0,'defaultfigurePaperSize'),...
'PaperType',get(0,'defaultfigurePaperType'),...
'Position',[103.571428571429 25.95 138.428571428571 35.65],...
'Resize','off',...
'HandleVisibility','callback',...
'UserData',[],...
'Tag','Dialog',...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel5';

h2 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderWidth',2,...
'FontWeight','bold',...
'Title','Variabili di Ingresso',...
'Clipping','on',...
'Position',[103.428571428571 23.05 33.4285714285714 9.2],...
'Tag','uipanel5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel6';

h3 = uipanel(...
'Parent',h2,...
'Units','characters',...
'Title','Portata ingresso Phii [m^3/s]',...
'Clipping','on',...
'Position',[0.714285714285714 0.3 31.2857142857143 7.7],...
'Tag','uipanel6',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Phii_min';

h4 = uicontrol(...
'Parent',h3,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('Phii_min_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[1.42857142857143 0.5 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('Phii_min_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Phii_min');

appdata = [];
appdata.lastValidTag = 'Phii_cur';

h5 = uicontrol(...
'Parent',h3,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('Phii_cur_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[10.8571428571429 0.5 9 1],...
'String','1.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('Phii_cur_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Phii_cur');

appdata = [];
appdata.lastValidTag = 'Phii_max';

h6 = uicontrol(...
'Parent',h3,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('Phii_max_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[20.4285714285714 0.5 9 1],...
'String','10.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('Phii_max_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Phii_max');

appdata = [];
appdata.lastValidTag = 'IngressoTipo';

h7 = uicontrol(...
'Parent',h3,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('IngressoTipo_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[1.42857142857143 5 28 1.3],...
'String',{  'Step'; 'Impulso'; 'Treno di impulsi'; 'Sinusoide'; 'Onda quadra'; 'Onda a dente di sega' },...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('IngressoTipo_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','IngressoTipo');

appdata = [];
appdata.lastValidTag = 'Phii';

h8 = uicontrol(...
'Parent',h3,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Main_export('Phii_Callback',hObject,eventdata,guidata(hObject)),...
'Max',10,...
'Position',[1.42857142857143 1.9 28 1],...
'String',{  'Slider' },...
'Style','slider',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('Phii_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Phii');

appdata = [];
appdata.lastValidTag = 'IngressoPar';

h9 = uicontrol(...
'Parent',h3,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('IngressoPar_Callback',hObject,eventdata,guidata(hObject)),...
'Enable','off',...
'Position',[1.42857142857143 3.3 28 1.3],...
'String','Ampiezza [m^3/s]',...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('IngressoPar_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','IngressoPar');

appdata = [];
appdata.lastValidTag = 'uipanel8';

h10 = uipanel(...
'Parent',h1,...
'Units','characters',...
'FontWeight','bold',...
'Title','Modello Matematico',...
'Clipping','on',...
'Position',[1 0.200000000000001 49.8571428571429 7.7],...
'Tag','uipanel8',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Modello';

h11 = axes(...
'Parent',h10,...
'Units','characters',...
'Position',[1.42857142857143 0.496153846153845 46.7142857142857 5.9],...
'Box','on',...
'CameraPosition',[120 41.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'FontSize',8,...
'Layer','top',...
'LooseInset',[3.92976009894699 0.672137418703745 2.87174776461511 0.458275512752554],...
'XColor',get(0,'defaultaxesXColor'),...
'XLim',[0.5 239.5],...
'XLimMode','manual',...
'YColor',get(0,'defaultaxesYColor'),...
'YDir','reverse',...
'YLim',[0.5 82.5],...
'YLimMode','manual',...
'ZColor',get(0,'defaultaxesZColor'),...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('Modello_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Modello',...
'Visible','off');

h12 = get(h11,'xlabel');

set(h12,...
'Parent',h11,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[119.269113149847 100.220338983051 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','cap',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h13 = get(h11,'ylabel');

set(h13,...
'Parent',h11,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-18.868501529052 42.542372881356 1.00005459937205],...
'Rotation',90,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h14 = get(h11,'zlabel');

set(h14,...
'Parent',h11,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','right',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-13.7522935779817 -400.813559322034 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','middle',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

appdata = [];
appdata.lastValidTag = 'uipanel7';

h15 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderWidth',2,...
'FontWeight','bold',...
'Title','Variabili di Uscita',...
'Clipping','on',...
'Position',[63.4285714285714 2.5 39.4285714285714 3],...
'Tag','uipanel7',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Uscita';

h16 = uicontrol(...
'Parent',h15,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('Uscita_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Enable','off',...
'Position',[2.28571428571429 0.45 34.7142857142857 1.3],...
'String','Portata di uscita',...
'Style','popupmenu',...
'Value',1,...
'Clipping','off',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('Uscita_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'UserData',[],...
'Tag','Uscita');

appdata = [];
appdata.lastValidTag = 'Run';

h17 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 0 0],...
'Callback',@(hObject,eventdata)Main_export('Run_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'FontWeight','bold',...
'ForegroundColor',[1 1 1],...
'Position',[71.4285714285714 0.4 23.5714285714286 1.7],...
'String','Run',...
'Tag','Run',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel16';

h18 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderWidth',2,...
'FontWeight','bold',...
'Title','Configurazione',...
'Clipping','on',...
'Position',[63.4 32.2269230769231 73 3.38461538461539],...
'Tag','uipanel16',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'ConfigLoad';

h19 = uicontrol(...
'Parent',h18,...
'Units','characters',...
'Callback',@(hObject,eventdata)Main_export('ConfigLoad_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'Position',[23.5714285714286 0.55 8.57142857142857 1.3],...
'String','Load',...
'Tag','ConfigLoad',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'ConfigSave';

h20 = uicontrol(...
'Parent',h18,...
'Units','characters',...
'Callback',@(hObject,eventdata)Main_export('ConfigSave_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10,...
'Position',[62.4285714285714 0.55 9 1.3],...
'String','Save',...
'Tag','ConfigSave',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'ConfigLoadName';

h21 = uicontrol(...
'Parent',h18,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('ConfigLoadName_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[1.14285714285714 0.55 21 1.3],...
'String','Default',...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('ConfigLoadName_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','ConfigLoadName');

appdata = [];
appdata.lastValidTag = 'ConfigSaveName';

h22 = uicontrol(...
'Parent',h18,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('ConfigSaveName_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','left',...
'Position',[42 0.65 20 1.1],...
'String','nomefile',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('ConfigSaveName_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','ConfigSaveName');

appdata = [];
appdata.lastValidTag = 'ConfigDelete';

h23 = uicontrol(...
'Parent',h18,...
'Units','characters',...
'Callback',@(hObject,eventdata)Main_export('ConfigDelete_Callback',hObject,eventdata,guidata(hObject)),...
'Enable','off',...
'FontSize',10,...
'Position',[33 0.55 8 1.3],...
'String','Delete',...
'Tag','ConfigDelete',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel13';

h24 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderWidth',2,...
'FontWeight','bold',...
'Title','Stato iniziale',...
'Clipping','on',...
'Position',[103.428571428571 11.7 33.4285714285714 10.95],...
'Tag','uipanel13',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel12';

h25 = uipanel(...
'Parent',h24,...
'Units','characters',...
'Title','Livello serbatoio 2 h20 [m]',...
'Clipping','on',...
'Position',[1.14285714285714 0.449999999999999 30.5714285714286 4.6],...
'Tag','uipanel12',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'h20';

h26 = uicontrol(...
'Parent',h25,...
'Units','characters',...
'FontUnits','pixels',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Main_export('h20_Callback',hObject,eventdata,guidata(hObject)),...
'FontSize',10.0168288726683,...
'Max',10,...
'Position',[1 2.18461538461538 28 1],...
'String',{  'Slider' },...
'Style','slider',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('h20_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','h20');

appdata = [];
appdata.lastValidTag = 'h20_min';

h27 = uicontrol(...
'Parent',h25,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('h20_min_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[1 0.634615384615385 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('h20_min_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','h20_min');

appdata = [];
appdata.lastValidTag = 'h20_cur';

h28 = uicontrol(...
'Parent',h25,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('h20_cur_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[10.4285714285714 0.634615384615385 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('h20_cur_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','h20_cur');

appdata = [];
appdata.lastValidTag = 'h20_max';

h29 = uicontrol(...
'Parent',h25,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('h20_max_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[20 0.634615384615385 9 1],...
'String','10.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('h20_max_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','h20_max');

appdata = [];
appdata.lastValidTag = 'uipanel11';

h30 = uipanel(...
'Parent',h24,...
'Units','characters',...
'Title','Livello serbatoio 1 h10 [m]',...
'Clipping','on',...
'Position',[1.2 5.41153846153845 30.6 4.38461538461539],...
'Tag','uipanel11',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'h10';

h31 = uicontrol(...
'Parent',h30,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Main_export('h10_Callback',hObject,eventdata,guidata(hObject)),...
'Max',10,...
'Position',[1 1.98461538461539 28 1],...
'String',{  'Slider' },...
'Style','slider',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('h10_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','h10');

appdata = [];
appdata.lastValidTag = 'h10_min';

h32 = uicontrol(...
'Parent',h30,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('h10_min_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[1 0.584615384615386 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('h10_min_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','h10_min');

appdata = [];
appdata.lastValidTag = 'h10_cur';

h33 = uicontrol(...
'Parent',h30,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('h10_cur_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[10.4285714285714 0.584615384615386 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('h10_cur_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','h10_cur');

appdata = [];
appdata.lastValidTag = 'h10_max';

h34 = uicontrol(...
'Parent',h30,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('h10_max_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[20 0.584615384615386 9 1],...
'String','10.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('h10_max_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','h10_max');

appdata = [];
appdata.lastValidTag = 'uipanel18';

h35 = uipanel(...
'Parent',h1,...
'Units','characters',...
'FontWeight','bold',...
'Title','Schema',...
'Clipping','on',...
'Position',[0.8 8.15000000000003 60.8 27.6153846153846],...
'Tag','uipanel18',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Schema';

h36 = axes(...
'Parent',h35,...
'Units','characters',...
'Position',[1.6 0.538461538461539 57.4 26.0769230769231],...
'Box','on',...
'CameraPosition',[198 218 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Layer','top',...
'LooseInset',[13.1152421964991 2.87559598148166 9.5842154512878 1.96063362373749],...
'XColor',get(0,'defaultaxesXColor'),...
'XLim',[0.5 395.5],...
'XLimMode','manual',...
'YColor',get(0,'defaultaxesYColor'),...
'YDir','reverse',...
'YLim',[0.5 435.5],...
'YLimMode','manual',...
'ZColor',get(0,'defaultaxesZColor'),...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('Schema_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Schema',...
'Visible','off');

h37 = get(h36,'xlabel');

set(h37,...
'Parent',h36,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[197.508706467662 458.460652591171 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','cap',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h38 = get(h36,'ylabel');

set(h38,...
'Parent',h36,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-38.3121890547264 218.834932821497 1.00005459937205],...
'Rotation',90,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h39 = get(h36,'zlabel');

set(h39,...
'Parent',h36,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','right',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-18.660447761194 -11.6065259117082 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','middle',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

appdata = [];
appdata.lastValidTag = 'uipanel19';

h40 = uipanel(...
'Parent',h1,...
'Units','characters',...
'FontWeight','bold',...
'Title','Punto di equilibrio',...
'Clipping','on',...
'Position',[103.428571428571 4.45 33 6.8],...
'Tag','uipanel19',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'punto_eq_txt';

h41 = uicontrol(...
'Parent',h40,...
'Units','characters',...
'HorizontalAlignment','left',...
'Position',[1 0.35 30.1428571428571 5.15],...
'Style','text',...
'Tag','punto_eq_txt',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Punto_eq';

h42 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 0 0],...
'Callback',@(hObject,eventdata)Main_export('Punto_eq_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'ForegroundColor',[1 1 1],...
'Position',[106.857142857143 2.45 27.1428571428571 1.6],...
'String','Punto di equilibrio',...
'UserData',[],...
'Tag','Punto_eq',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel1';

h43 = uipanel(...
'Parent',h1,...
'Units','characters',...
'BorderWidth',2,...
'FontWeight','bold',...
'Title','Parametri',...
'Clipping','on',...
'Position',[63.4285714285714 5.7 39.1428571428571 26.55],...
'Tag','uipanel1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel2';

h44 = uipanel(...
'Parent',h43,...
'Units','characters',...
'Title','Sezione del serbatoio A1 [m^2]',...
'Clipping','on',...
'Position',[1.71428571428571 20.6153846153846 35.5714285714286 4.6],...
'Tag','uipanel2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'A1';

h45 = uicontrol(...
'Parent',h44,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Main_export('A1_Callback',hObject,eventdata,guidata(hObject)),...
'Max',10,...
'Position',[1.7 2.08461538461538 32 1],...
'String',{  'Slider' },...
'Style','slider',...
'Value',2,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('A1_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','A1');

appdata = [];
appdata.lastValidTag = 'A1_min';

h46 = uicontrol(...
'Parent',h44,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('A1_min_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[1.71428571428571 0.584615384615384 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('A1_min_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','A1_min');

appdata = [];
appdata.lastValidTag = 'A1_cur';

h47 = uicontrol(...
'Parent',h44,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('A1_cur_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[13.1428571428571 0.584615384615384 9 1],...
'String','2.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('A1_cur_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','A1_cur');

appdata = [];
appdata.lastValidTag = 'A1_max';

h48 = uicontrol(...
'Parent',h44,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('A1_max_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[24.7142857142857 0.584615384615384 9 1],...
'String','10.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('A1_max_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','A1_max');

appdata = [];
appdata.lastValidTag = 'uipanel3';

h49 = uipanel(...
'Parent',h43,...
'Units','characters',...
'Title','Densità liquido rho [kg/m^3]',...
'Clipping','on',...
'Position',[1.42857142857143 10.4653846153846 35.8571428571429 4.85],...
'Tag','uipanel3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'rho';

h50 = uicontrol(...
'Parent',h49,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Main_export('rho_Callback',hObject,eventdata,guidata(hObject)),...
'Max',10,...
'Position',[1.71428571428571 2.3 32 1],...
'String',{  'Slider' },...
'Style','slider',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('rho_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','rho');

appdata = [];
appdata.lastValidTag = 'rho_min';

h51 = uicontrol(...
'Parent',h49,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('rho_min_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[1.71428571428571 0.65 9 1],...
'String','900',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('rho_min_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','rho_min');

appdata = [];
appdata.lastValidTag = 'rho_cur';

h52 = uicontrol(...
'Parent',h49,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('rho_cur_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[13.1428571428571 0.65 9 1],...
'String','1000',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('rho_cur_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','rho_cur');

appdata = [];
appdata.lastValidTag = 'rho_max';

h53 = uicontrol(...
'Parent',h49,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('rho_max_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[24.7142857142857 0.65 9 1],...
'String','1100',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('rho_max_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','rho_max');

appdata = [];
appdata.lastValidTag = 'uipanel9';

h54 = uipanel(...
'Parent',h43,...
'Units','characters',...
'Title','Resistenza Valvola R1 [Kg/m^4 s]',...
'Clipping','on',...
'Position',[1.14285714285714 5.41538461538461 36.1428571428571 4.85],...
'Tag','uipanel9',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'R1';

h55 = uicontrol(...
'Parent',h54,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Main_export('R1_Callback',hObject,eventdata,guidata(hObject)),...
'Max',10,...
'Position',[1.71428571428571 2.40384615384615 32 1],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.4,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('R1_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','R1');

appdata = [];
appdata.lastValidTag = 'R1_min';

h56 = uicontrol(...
'Parent',h54,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('R1_min_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[1.71428571428571 0.753846153846152 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('R1_min_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','R1_min');

appdata = [];
appdata.lastValidTag = 'R1_cur';

h57 = uicontrol(...
'Parent',h54,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('R1_cur_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[13.1428571428571 0.753846153846152 9 1],...
'String','0.4',...
'Style','edit',...
'Value',0.4,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('R1_cur_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','R1_cur');

appdata = [];
appdata.lastValidTag = 'R1_max';

h58 = uicontrol(...
'Parent',h54,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('R1_max_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[24.7142857142857 0.753846153846152 9 1],...
'String','10.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('R1_max_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','R1_max');

appdata = [];
appdata.lastValidTag = 'uipanel10';

h59 = uipanel(...
'Parent',h43,...
'Units','characters',...
'Title','Resistenza Valvola R2 [Kg/m^4 s]',...
'Clipping','on',...
'Position',[1.28571428571429 0.365384615384614 36 4.75],...
'Tag','uipanel10',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'R2';

h60 = uicontrol(...
'Parent',h59,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Main_export('R2_Callback',hObject,eventdata,guidata(hObject)),...
'Max',10,...
'Position',[1.71428571428571 2.23076923076923 32 1],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.2,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('R2_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','R2');

appdata = [];
appdata.lastValidTag = 'R2_min';

h61 = uicontrol(...
'Parent',h59,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('R2_min_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[1.71428571428571 0.680769230769231 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('R2_min_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','R2_min');

appdata = [];
appdata.lastValidTag = 'R2_cur';

h62 = uicontrol(...
'Parent',h59,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('R2_cur_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[13.1428571428571 0.680769230769231 9 1],...
'String','0.2',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('R2_cur_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','R2_cur');

appdata = [];
appdata.lastValidTag = 'R2_max';

h63 = uicontrol(...
'Parent',h59,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('R2_max_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[24.7142857142857 0.680769230769231 9 1],...
'String','10.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('R2_max_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','R2_max');

appdata = [];
appdata.lastValidTag = 'uipanel14';

h64 = uipanel(...
'Parent',h43,...
'Units','characters',...
'Title','Sezione del serbatoio A2 [m^2]',...
'Clipping','on',...
'Position',[1.71428571428571 15.6653846153846 35.5714285714286 4.6],...
'Tag','uipanel14',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'A2';

h65 = uicontrol(...
'Parent',h64,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Main_export('A2_Callback',hObject,eventdata,guidata(hObject)),...
'KeyPressFcn',@(hObject,eventdata)Main_export('A2_KeyPressFcn',hObject,eventdata,guidata(hObject)),...
'Max',10,...
'Position',[1.71428571428571 2.23461538461538 32 1],...
'String',{  'Slider' },...
'Style','slider',...
'Value',2,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('A2_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','A2');

appdata = [];
appdata.lastValidTag = 'A2_min';

h66 = uicontrol(...
'Parent',h64,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('A2_min_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[1.71428571428571 0.684615384615384 9 1],...
'String','0.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('A2_min_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','A2_min');

appdata = [];
appdata.lastValidTag = 'A2_cur';

h67 = uicontrol(...
'Parent',h64,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('A2_cur_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[13.1428571428571 0.684615384615384 9 1],...
'String','2.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('A2_cur_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','A2_cur');

appdata = [];
appdata.lastValidTag = 'A2_max';

h68 = uicontrol(...
'Parent',h64,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Main_export('A2_max_Callback',hObject,eventdata,guidata(hObject)),...
'HorizontalAlignment','right',...
'Position',[24.7142857142857 0.684615384615384 9 1],...
'String','10.0',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Main_export('A2_max_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','A2_max');


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % MAIN_EXPORT
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % MAIN_EXPORT(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % MAIN_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % MAIN_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || isprop(fig,'GUIDEFigure');
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    gui_hFigure = openfig(name, singleton, visible);  
    %workaround for CreateFcn not called to create ActiveX
    if feature('HGUsingMATLABClasses')
        peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
        for i=1:length(peers)
            if isappdata(peers(i),'Control')
                actxproxy(peers(i));
            end            
        end
    end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


