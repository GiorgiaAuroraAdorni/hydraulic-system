%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           SISTEMA IDRAULICO 4.5                         %
%                               (liquidi)                                 % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% by Alberto Margari  (2011)
% by Barbara Bertani  (2015)
% by Fabio Bernardini (2016)
% by Giorgia Adorni   (2018)
% by F. M. Marchese   (2011-18)
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

% Last Modified by GUIDE v2.5 16-Jun-2018 16:41:59

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
      1        % Uscita
      0        % A1_min    (2)
      2        % A1, A1_cur
      10       % A1_max
      0        % A2_min    (5)
      2        % A2, A2_cur
      10       % A2_max
      900      % rho_min   (8)
      1000     % rho, rho_cur
      1100     % rho_max
      0        % R1_min    (11)
      500      % R1, R1_cur
      1000     % R1_max
      0        % R2_min    (14)
      500      % R2, R2_cur
      1000     % R2_max
      0        % h10_min   (17)
      0        % h10, h10_cur
      10       % h10_max
      0        % h20_min   (20)
      0        % h20, h20_cur
      10       % h20_max
      0        % Mur1_min  (23)
      25       % Mur1, Mur1_cur
      50       % Mur1_max
      0        % Mur2_min  (26)
      15       % Mur2, Mur2_cur
      50       % Mur2_max
      0        % Sph2_min  (29)
      5        % Sph2, Sph2_cur
      10       % Sph2_max
      0        % Ie_min    (32)
      5        % Ie, Ie_cur
      10       % Ie_max
      ];
  
global def_string;
def_string = {      
              '0.1 -9'     % P1 
              '0 -70'      % P2        
              '-2 -10'     % Z1       
              '-8'         % Z2     
              };
    
% Par degli slider
global A1sld A2sld rhosld R1sld R2sld h10sld h20sld Mur1sld Mur2sld Sph2sld Iesld;

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

Mur1sld.stmin = 1;
Mur1sld.stmax = 1;
Mur1sld.Llim = -Inf;
Mur1sld.Hlim = +Inf;

Mur2sld.stmin = 1;
Mur2sld.stmax = 1;
Mur2sld.Llim = -Inf;
Mur2sld.Hlim = +Inf;

Sph2sld.stmin = 0.1;
Sph2sld.stmax = 1;
Sph2sld.Llim = eps;
Sph2sld.Hlim = +Inf;

Iesld.stmin = 0.1;
Iesld.stmax = 1;
Iesld.Llim = eps;
Iesld.Hlim = +Inf;

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

% Leggo i dati inseriti dall'utente
A1   = get(handles.A1, 'Value');
A2   = get(handles.A2, 'Value');
rho = get(handles.rho, 'Value');
R1  = get(handles.R1, 'Value');
R2  = get(handles.R2, 'Value');
h10 = get(handles.h10, 'Value');
h20 = get(handles.h20, 'Value');
Mur1 = get(handles.Mur1, 'Value');
Mur2 = get(handles.Mur2, 'Value');
Sph2 = get(handles.Sph2, 'Value');
Ie = get(handles.Ie, 'Value');
P1 = get(handles.P1, 'String');
P1 = str2num(P1);
P2 = get(handles.P2, 'String');
P2 = str2num(P2);
Z1 = get(handles.Z1, 'String');
Z1 = str2num(Z1);
Z2 = get(handles.Z2, 'String');
Z2 = str2num(Z2);
g = 9.8;

% Esporta tutte le variabili nel Workspace per permettere a1 Simulink
% di averne visibilità
vars = {'A1', A1; 'A2', A2; 'rho', rho; 'R1', R1; 'R2', R2; 'h10', h10; 'h20', h20; 'Mur1', Mur1; 'Mur2', Mur2; 'Sph2', Sph2; 'Ie', Ie; 'P1', P1; 'P2', P2; 'Z1', Z1; 'Z2', Z2};
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

% Modifica della durata della simulazione
 set_param(Uscita, 'StopTime', num2str(5*Tau + 0.5*Tau));
 set_param(Uscita, 'StopTime', num2str(6));

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


%% VALORI DI DEFAULT
% 
function Load_Defaults(handles)

global def;
global def_string;
global A1sld A2sld rhosld R1sld R2sld h10sld h20sld Mur1sld Mur2sld Sph2sld Iesld;

% slider A1
set(handles.A1_min, 'Value', def(2));
set(handles.A1_min, 'String', num2str(def(2),  '%.1f')); 
set(handles.A1_cur, 'Value', def(3));
set(handles.A1_cur, 'String', num2str(def(3), '%.2f')); 
set(handles.A1_max, 'Value', def(4));
set(handles.A1_max, 'String', num2str(def(4), '%.1f'));

set(handles.A1, 'Min',   def(2)); 
set(handles.A1, 'Value', def(3));
set(handles.A1, 'Max',   def(4)); 
majorstep = A1sld.stmax / (def(4)-def(2));
minorstep = A1sld.stmin / (def(4)-def(2));
set(handles.A1, 'SliderStep', [minorstep majorstep]);

% slider A2
set(handles.A2_min, 'Value', def(5));
set(handles.A2_min, 'String', num2str(def(5),  '%.1f')); 
set(handles.A2_cur, 'Value', def(6));
set(handles.A2_cur, 'String', num2str(def(6), '%.2f')); 
set(handles.A2_max, 'Value', def(7));
set(handles.A2_max, 'String', num2str(def(7), '%.1f'));

set(handles.A2, 'Min',   def(5)); 
set(handles.A2, 'Value', def(6));
set(handles.A2, 'Max',   def(7)); 
majorstep = A2sld.stmax / (def(7)-def(5));
minorstep = A2sld.stmin / (def(7)-def(5));
set(handles.A2, 'SliderStep', [minorstep majorstep]);

% slider rho
set(handles.rho_min, 'Value', def(8));
set(handles.rho_min, 'String', num2str(def(8), '%.1f'));
set(handles.rho_cur, 'Value', def(9));
set(handles.rho_cur, 'String', num2str(def(9), '%.2f'));
set(handles.rho_max, 'Value', def(10));
set(handles.rho_max, 'String', num2str(def(10), '%.1f'));

set(handles.rho, 'Min',   def(8)); 
set(handles.rho, 'Value', def(9));
set(handles.rho, 'Max',   def(10)); 
majorstep = rhosld.stmax / (def(10)-def(8));
minorstep = rhosld.stmin / (def(10)-def(8));
set(handles.rho, 'SliderStep', [minorstep majorstep]);

% slider R1
set(handles.R1_min, 'Value', def(11));
set(handles.R1_min, 'String', num2str(def(11), '%.1f'));
set(handles.R1_cur, 'Value', def(12));
set(handles.R1_cur, 'String', num2str(def(12), '%.2f'));
set(handles.R1_max, 'Value', def(13));
set(handles.R1_max, 'String', num2str(def(13), '%.1f'));

set(handles.R1, 'Min',   def(11)); 
set(handles.R1, 'Value', def(12));
set(handles.R1, 'Max',   def(13)); 
majorstep = R1sld.stmax / (def(13)-def(11));
minorstep = R1sld.stmin / (def(13)-def(11));
set(handles.R1, 'SliderStep', [minorstep majorstep]);

% slider R2
set(handles.R2_min, 'Value', def(14));
set(handles.R2_min, 'String', num2str(def(14), '%.1f'));
set(handles.R2_cur, 'Value', def(15));
set(handles.R2_cur, 'String', num2str(def(15), '%.2f'));
set(handles.R2_max, 'Value', def(16));
set(handles.R2_max, 'String', num2str(def(16), '%.1f'));

set(handles.R2, 'Min',   def(14)); 
set(handles.R2, 'Value', def(15));
set(handles.R2, 'Max',   def(16)); 
majorstep = R2sld.stmax / (def(16)-def(14));
minorstep = R2sld.stmin / (def(16)-def(14));
set(handles.R2, 'SliderStep', [minorstep majorstep]);

% slider h10
set(handles.h10_min, 'Value', def(17));
set(handles.h10_min, 'String', num2str(def(17), '%.1f'));
set(handles.h10_cur, 'Value', def(18));
set(handles.h10_cur, 'String', num2str(def(17), '%.2f'));
set(handles.h10_max, 'Value', def(19));
set(handles.h10_max, 'String', num2str(def(17), '%.1f'));

set(handles.h10, 'Min',   def(17)); 
set(handles.h10, 'Value', def(18));
set(handles.h10, 'Max',   def(19)); 
majorstep = h10sld.stmax / (def(19)-def(17));
minorstep = h10sld.stmin / (def(19)-def(17));
set(handles.h10, 'SliderStep', [minorstep majorstep]);

% slider h20
set(handles.h20_min, 'Value', def(20));
set(handles.h20_min, 'String', num2str(def(20), '%.1f'));
set(handles.h20_cur, 'Value', def(21));
set(handles.h20_cur, 'String', num2str(def(21), '%.2f'));
set(handles.h20_max, 'Value', def(22));
set(handles.h20_max, 'String', num2str(def(22), '%.1f'));

set(handles.h20, 'Min',   def(20)); 
set(handles.h20, 'Value', def(21));
set(handles.h20, 'Max',   def(22)); 
majorstep = h20sld.stmax / (def(22)-def(21));
minorstep = h20sld.stmin / (def(22)-def(21));
set(handles.h20, 'SliderStep', [minorstep majorstep]);

% slider Mur1
set(handles.Mur1_min, 'Value', def(23));
set(handles.Mur1_min, 'String', num2str(def(23), '%.1f'));
set(handles.Mur1_cur, 'Value', def(24));
set(handles.Mur1_cur, 'String', num2str(def(24), '%.2f'));
set(handles.Mur1_max, 'Value', def(25));
set(handles.Mur1_max, 'String', num2str(def(25), '%.1f'));

set(handles.Mur1, 'Min',   def(23)); 
set(handles.Mur1, 'Value', def(24));
set(handles.Mur1, 'Max',   def(25)); 
majorstep = Mur1sld.stmax / (def(25)-def(23));
minorstep = Mur1sld.stmin / (def(25)-def(23));
set(handles.Mur1, 'SliderStep', [minorstep majorstep]);

% slider Mur2
set(handles.Mur2_min, 'Value', def(26));
set(handles.Mur2_min, 'String', num2str(def(26), '%.1f'));
set(handles.Mur2_cur, 'Value', def(27));
set(handles.Mur2_cur, 'String', num2str(def(27), '%.2f'));
set(handles.Mur2_max, 'Value', def(28));
set(handles.Mur2_max, 'String', num2str(def(28), '%.1f'));

set(handles.Mur2, 'Min',   def(26)); 
set(handles.Mur2, 'Value', def(27));
set(handles.Mur2, 'Max',   def(28)); 
majorstep = Mur2sld.stmax / (def(28)-def(26));
minorstep = Mur2sld.stmin / (def(28)-def(26));
set(handles.Mur2, 'SliderStep', [minorstep majorstep]);

% slider Sph2
set(handles.Sph2_min, 'Value', def(29));
set(handles.Sph2_min, 'String', num2str(def(29), '%.1f'));
set(handles.Sph2_cur, 'Value', def(30));
set(handles.Sph2_cur, 'String', num2str(def(30), '%.2f'));
set(handles.Sph2_max, 'Value', def(31));
set(handles.Sph2_max, 'String', num2str(def(31), '%.1f'));

set(handles.Sph2, 'Min',   def(29)); 
set(handles.Sph2, 'Value', def(30));
set(handles.Sph2, 'Max',   def(31)); 
majorstep = Sph2sld.stmax / (def(31)-def(29));
minorstep = Sph2sld.stmin / (def(31)-def(29));
set(handles.Sph2, 'SliderStep', [minorstep majorstep]);

% slider Ie
set(handles.Ie_min, 'Value', def(32));
set(handles.Ie_min, 'String', num2str(def(32), '%.1f'));
set(handles.Ie_cur, 'Value', def(33));
set(handles.Ie_cur, 'String', num2str(def(33), '%.2f'));
set(handles.Ie_max, 'Value', def(34));
set(handles.Ie_max, 'String', num2str(def(34), '%.1f'));

set(handles.Ie, 'Min',   def(32)); 
set(handles.Ie, 'Value', def(33));
set(handles.Ie, 'Max', def(34)); 
majorstep = Iesld.stmax / (def(34)-def(32));
minorstep = Iesld.stmin / (def(34)-def(32));
set(handles.Ie, 'SliderStep', [minorstep majorstep]);

% P1
set(handles.P1, 'String', def_string{1});

% P2
set(handles.P2, 'String', def_string{2});

% Z1
set(handles.Z1, 'String', def_string{3});

% Z2
set(handles.Z2, 'String', def_string{4});

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

% Leggo i dati inseriti dall'utente
A1 = get(handles.A1, 'Value');
A2 = get(handles.A2, 'Value');
rho = get(handles.rho, 'Value');
R1 = get(handles.R1, 'Value');
R2 = get(handles.R2, 'Value');
Ie = get(handles.Ie, 'Value');
g = 9.81;
u = Ie;

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
    {'Non esiste uno stato di equilibrio con l''ingresso di equilibrio: ';...
    ['Ie = ', num2str(u(1), '%.2f'), ' m']});
  return
end


% Preparazione testo da visualizzare
str = sprintf('In presenza dell''ingresso di equilibrio: Ie = %.1f m', u(1));
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
global A1sld A2sld rhosld R1sld R2sld h10sld h20sld Mur1sld Mur2sld Sph2sld Iesld;

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


set(handles.Mur1_min, 'Value',  Mur1_min);
set(handles.Mur1_min, 'String', num2str(Mur1_min, '%.1f'));
set(handles.Mur1_cur, 'Value',  Mur1_cur);
set(handles.Mur1_cur, 'String', num2str(Mur1_cur, '%.2f'));
set(handles.Mur1_max, 'Value',  Mur1_max);
set(handles.Mur1_max, 'String', num2str(Mur1_max, '%.1f'));

set(handles.Mur1, 'Min',   Mur1_min);
set(handles.Mur1, 'Value', Mur1_cur);
set(handles.Mur1, 'Max',   Mur1_max);
majorstep = Mur1sld.stmax / (Mur1_max-Mur1_min);
minorstep = Mur1sld.stmin / (Mur1_max-Mur1_min);
set(handles.Mur1, 'SliderStep', [minorstep majorstep]);


set(handles.Mur2_min, 'Value',  Mur2_min);
set(handles.Mur2_min, 'String', num2str(Mur2_min, '%.1f'));
set(handles.Mur2_cur, 'Value',  Mur2_cur);
set(handles.Mur2_cur, 'String', num2str(Mur2_cur, '%.2f'));
set(handles.Mur2_max, 'Value',  Mur2_max);
set(handles.Mur2_max, 'String', num2str(Mur2_max, '%.1f'));

set(handles.Mur2, 'Min',   Mur2_min);
set(handles.Mur2, 'Value', Mur2_cur);
set(handles.Mur2, 'Max',   Mur2_max);
majorstep = Mur2sld.stmax / (Mur2_max-Mur2_min);
minorstep = Mur2sld.stmin / (Mur2_max-Mur2_min);
set(handles.Mur2, 'SliderStep', [minorstep majorstep]);


set(handles.Sph2_min, 'Value',  Sph2_min);
set(handles.Sph2_min, 'String', num2str(Sph2_min, '%.1f'));
set(handles.Sph2_cur, 'Value',  Sph2_cur);
set(handles.Sph2_cur, 'String', num2str(Sph2_cur, '%.2f'));
set(handles.Sph2_max, 'Value',  Sph2_max);
set(handles.Sph2_max, 'String', num2str(Sph2_max, '%.1f'));

set(handles.Sph2, 'Min',   Sph2_min);
set(handles.Sph2, 'Value', Sph2_cur);
set(handles.Sph2, 'Max',   Sph2_max);
majorstep = Sph2sld.stmax / (Sph2_max-Sph2_min);
minorstep = Sph2sld.stmin / (Sph2_max-Sph2_min);
set(handles.Sph2, 'SliderStep', [minorstep majorstep]);


set(handles.Ie_min, 'Value',  Ie_min);
set(handles.Ie_min, 'String', num2str(Ie_min, '%.1f'));
set(handles.Ie_cur, 'Value',  Ie_cur);
set(handles.Ie_cur, 'String', num2str(Ie_cur, '%.2f'));
set(handles.Ie_max, 'Value',  Ie_max);
set(handles.Ie_max, 'String', num2str(Ie_max, '%.1f'));

set(handles.Ie, 'Min',   Ie_min);
set(handles.Ie, 'Value', Ie_cur);
set(handles.Ie, 'Max',   Ie_max);
majorstep = Iesld.stmax / (Ie_max-Ie_min);
minorstep = Iesld.stmin / (Ie_max-Ie_min);
set(handles.Ie, 'SliderStep', [minorstep majorstep]);


set(handles.P1, 'String', P1);

set(handles.P2, 'String', P2);

set(handles.Z1, 'String', Z1);

set(handles.Z2, 'String', Z2);

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
Sph2_min = get(handles.Sph2_min, 'Value');
Sph2_cur = get(handles.Sph2_cur, 'Value');
Sph2_max = get(handles.Sph2_max, 'Value');

Ie_min = get(handles.Ie_min, 'Value');
Ie_cur = get(handles.Ie_cur, 'Value');
Ie_max = get(handles.Ie_max, 'Value');

% pannello stato iniziale
h10_min = get(handles.h10_min, 'Value');
h10_cur = get(handles.h10_cur, 'Value');
h10_max = get(handles.h10_max, 'Value');

h20_min = get(handles.h20_min, 'Value');
h20_cur = get(handles.h20_cur, 'Value');
h20_max = get(handles.h20_max, 'Value');

% pannello regolatore
Mur1_min = get(handles.Mur1_min, 'Value');
Mur1_cur = get(handles.Mur1_cur, 'Value');
Mur1_max = get(handles.Mur1_max, 'Value');

Mur2_min = get(handles.Mur2_min, 'Value');
Mur2_cur = get(handles.Mur2_cur, 'Value');
Mur2_max = get(handles.Mur2_max, 'Value');

P1 = get(handles.P1, 'String');
P2 = get(handles.P2, 'String');
Z1 = get(handles.Z1, 'String');
Z2 = get(handles.Z2, 'String');

% pannello uscita
Uscita = get(handles.Uscita, 'Value');

% Salvataggio parametri su file
fid = fopen(namem, 'w');

fprintf(fid, 'Uscita = %f;\n', Uscita);

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

fprintf(fid, 'Mur1_min = %f;\n', Mur1_min);
fprintf(fid, 'Mur1_cur = %f;\n', Mur1_cur);
fprintf(fid, 'Mur1_max = %f;\n', Mur1_max);

fprintf(fid, 'Mur2_min = %f;\n', Mur2_min);
fprintf(fid, 'Mur2_cur = %f;\n', Mur2_cur);
fprintf(fid, 'Mur2_max = %f;\n', Mur2_max);

fprintf(fid, 'Sph2_min = %f;\n', Sph2_min);
fprintf(fid, 'Sph2_cur = %f;\n', Sph2_cur);
fprintf(fid, 'Sph2_max = %f;\n', Sph2_max);

fprintf(fid, 'Ie_min = %f;\n', Ie_min);
fprintf(fid, 'Ie_cur = %f;\n', Ie_cur);
fprintf(fid, 'Ie_max = %f;\n', Ie_max);

fprintf(fid, 'P1 = %s;\n', P1);
fprintf(fid, 'P2 = %s;\n', P2);
fprintf(fid, 'Z1 = %s;\n', Z1);
fprintf(fid, 'Z2 = %s;\n', Z2);

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
function Mur2_Callback(hObject, eventdata, handles)
% hObject    handle to Mur2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Slider_sld_Callback(handles, handles.Mur2, handles.Mur2_cur);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function Mur2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mur2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Mur2_min_Callback(hObject, eventdata, handles)
% hObject    handle to Mur2_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mur2sld;
Slider_min_Callback(handles, handles.Mur2, handles.Mur2_min, handles.Mur2_cur, handles.Mur2_max, Mur2sld.stmin, Mur2sld.stmax, Mur2sld.Llim, Mur2sld.Hlim);


% Hints: get(hObject,'String') returns contents of Mur2_min as text
%        str2double(get(hObject,'String')) returns contents of Mur2_min as a double


% --- Executes during object creation, after setting all properties.
function Mur2_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mur2_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mur2_cur_Callback(hObject, eventdata, handles)
% hObject    handle to Mur2_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mur2sld;
Slider_cur_Callback(handles, handles.Mur2, handles.Mur2_min, handles.Mur2_cur, handles.Mur2_max, Mur2sld.stmin, Mur2sld.stmax, Mur2sld.Llim, Mur2sld.Hlim);


% Hints: get(hObject,'String') returns contents of Mur2_cur as text
%        str2double(get(hObject,'String')) returns contents of Mur2_cur as a double


% --- Executes during object creation, after setting all properties.
function Mur2_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mur2_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mur2_max_Callback(hObject, eventdata, handles)
% hObject    handle to Mur2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mur2sld;
Slider_max_Callback(handles, handles.Mur2, handles.Mur2_min, handles.Mur2_cur, handles.Mur2_max, Mur2sld.stmin, Mur2sld.stmax, Mur2sld.Llim, Mur2sld.Hlim);


% Hints: get(hObject,'String') returns contents of Mur2_max as text
%        str2double(get(hObject,'String')) returns contents of Mur2_max as a double


% --- Executes during object creation, after setting all properties.
function Mur2_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mur2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Sph2_Callback(hObject, eventdata, handles)
% hObject    handle to Sph2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Slider_sld_Callback(handles, handles.Sph2, handles.Sph2_cur);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function Sph2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sph2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Sph2_min_Callback(hObject, eventdata, handles)
% hObject    handle to Sph2_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sph2sld;
Slider_min_Callback(handles, handles.Sph2, handles.Sph2_min, handles.Sph2_cur, handles.Sph2_max, Sph2sld.stmin, Sph2sld.stmax, Sph2sld.Llim, Sph2sld.Hlim);


% Hints: get(hObject,'String') returns contents of Sph2_min as text
%        str2double(get(hObject,'String')) returns contents of Sph2_min as a double


% --- Executes during object creation, after setting all properties.
function Sph2_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sph2_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sph2_cur_Callback(hObject, eventdata, handles)
% hObject    handle to Sph2_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sph2sld;
Slider_cur_Callback(handles, handles.Sph2, handles.Sph2_min, handles.Sph2_cur, handles.Sph2_max, Sph2sld.stmin, Sph2sld.stmax, Sph2sld.Llim, Sph2sld.Hlim);

% Hints: get(hObject,'String') returns contents of Sph2_cur as text
%        str2double(get(hObject,'String')) returns contents of Sph2_cur as a double


% --- Executes during object creation, after setting all properties.
function Sph2_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sph2_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sph2_max_Callback(hObject, eventdata, handles)
% hObject    handle to Sph2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sph2sld;
Slider_max_Callback(handles, handles.Sph2, handles.Sph2_min, handles.Sph2_cur, handles.Sph2_max, Sph2sld.stmin, Sph2sld.stmax, Sph2sld.Llim, Sph2sld.Hlim);

% Hints: get(hObject,'String') returns contents of Sph2_max as text
%        str2double(get(hObject,'String')) returns contents of Sph2_max as a double


% --- Executes during object creation, after setting all properties.
function Sph2_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sph2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Mur1_Callback(hObject, eventdata, handles)
% hObject    handle to Mur1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Slider_sld_Callback(handles, handles.Mur1, handles.Mur1_cur);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');

% --- Executes during object creation, after setting all properties.
function Mur1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mur1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Mur1_min_Callback(hObject, eventdata, handles)
% hObject    handle to Mur1_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mur1sld;
Slider_min_Callback(handles, handles.Mur1, handles.Mur1_min, handles.Mur1_cur, handles.Mur1_max, Mur1sld.stmin, Mur1sld.stmax, Mur1sld.Llim, Mur1sld.Hlim);

% Hints: get(hObject,'String') returns contents of Mur1_min as text
%        str2double(get(hObject,'String')) returns contents of Mur1_min as a double


% --- Executes during object creation, after setting all properties.
function Mur1_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mur1_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mur1_cur_Callback(hObject, eventdata, handles)
% hObject    handle to Mur1_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mur1sld;
Slider_cur_Callback(handles, handles.Mur1, handles.Mur1_min, handles.Mur1_cur, handles.Mur1_max, Mur1sld.stmin, Mur1sld.stmax, Mur1sld.Llim, Mur1sld.Hlim);

% Hints: get(hObject,'String') returns contents of Mur1_cur as text
%        str2double(get(hObject,'String')) returns contents of Mur1_cur as a double


% --- Executes during object creation, after setting all properties.
function Mur1_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mur1_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mur1_max_Callback(hObject, eventdata, handles)
% hObject    handle to Mur1_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mur1sld;
Slider_max_Callback(handles, handles.Mur1, handles.Mur1_min, handles.Mur1_cur, handles.Mur1_max, Mur1sld.stmin, Mur1sld.stmax, Mur1sld.Llim, Mur1sld.Hlim);

% Hints: get(hObject,'String') returns contents of Mur1_max as text
%        str2double(get(hObject,'String')) returns contents of Mur1_max as a double


% --- Executes during object creation, after setting all properties.
function Mur1_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mur1_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ie_min_Callback(hObject, eventdata, handles)
% hObject    handle to Ie_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iesld;
Slider_min_Callback(handles, handles.Ie, handles.Ie_min, handles.Ie_cur, handles.Ie_max, Iesld.stmin, Iesld.stmax, Iesld.Llim, Iesld.Hlim);

% Hints: get(hObject,'String') returns contents of Ie_min as text
%        str2double(get(hObject,'String')) returns contents of Ie_min as a double


% --- Executes during object creation, after setting all properties.
function Ie_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ie_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ie_cur_Callback(hObject, eventdata, handles)
% hObject    handle to Ie_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iesld;
Slider_cur_Callback(handles, handles.Ie, handles.Ie_min, handles.Ie_cur, handles.Ie_max, Iesld.stmin, Iesld.stmax, Iesld.Llim, Iesld.Hlim);

% Hints: get(hObject,'String') returns contents of Ie_cur as text
%        str2double(get(hObject,'String')) returns contents of Ie_cur as a double


% --- Executes during object creation, after setting all properties.
function Ie_cur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ie_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ie_max_Callback(hObject, eventdata, handles)
% hObject    handle to Ie_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iesld;
Slider_max_Callback(handles, handles.Ie, handles.Ie_min, handles.Ie_cur, handles.Ie_max, Iesld.stmin, Iesld.stmax, Iesld.Llim, Iesld.Hlim);

% Hints: get(hObject,'String') returns contents of Ie_max as text
%        str2double(get(hObject,'String')) returns contents of Ie_max as a double


% --- Executes during object creation, after setting all properties.
function Ie_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ie_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Ie_Callback(hObject, eventdata, handles)
% hObject    handle to Ie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Slider_sld_Callback(handles, handles.Ie, handles.Ie_cur);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Reset testo punto di equilibrio
set(handles.punto_eq_txt, 'String', '');


% --- Executes during object creation, after setting all properties.
function Ie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit60_Callback(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit60 as text
%        str2double(get(hObject,'String')) returns contents of edit60 as a double


% --- Executes during object creation, after setting all properties.
function edit60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Z2_Callback(hObject, eventdata, handles)
% hObject    handle to Z2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Z2 as text
%        str2double(get(hObject,'String')) returns contents of Z2 as a double


% --- Executes during object creation, after setting all properties.
function Z2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Z2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit58_Callback(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit58 as text
%        str2double(get(hObject,'String')) returns contents of edit58 as a double


% --- Executes during object creation, after setting all properties.
function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P2_Callback(hObject, eventdata, handles)
% hObject    handle to P2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P2 as text
%        str2double(get(hObject,'String')) returns contents of P2 as a double


% --- Executes during object creation, after setting all properties.
function P2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit56_Callback(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit56 as text
%        str2double(get(hObject,'String')) returns contents of edit56 as a double


% --- Executes during object creation, after setting all properties.
function edit56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Z1_Callback(hObject, eventdata, handles)
% hObject    handle to Z1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Z1 as text
%        str2double(get(hObject,'String')) returns contents of Z1 as a double


% --- Executes during object creation, after setting all properties.
function Z1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Z1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit54 as text
%        str2double(get(hObject,'String')) returns contents of edit54 as a double


% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function P1_Callback(hObject, eventdata, handles)
% hObject    handle to P1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P1 as text
%        str2double(get(hObject,'String')) returns contents of P1 as a double


% --- Executes during object creation, after setting all properties.
function P1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



