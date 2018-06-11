%% GESTIONE CONTROLLI ASSOCIATI AD UNO SLIDER
%
% function Slider_max_Callback
%
% ver. 2.0
%
% by F. M. Marchese (2016)
%
% Tested under MatLab R2013b
%


function Slider_max_Callback(handles, hSld, hMin, hCur, hMax, stmin, stmax, Llim, Hlim)
% handles    structure with handles and user data (see GUIDATA)
% hSld       handle slider
% hMin       handle min editbox
% hCur       handle cur editbox
% hMax       handle max editbox
% stmin      step min
% stmax      step max
% Llim       estremo inferiore range di valori ammissibili
% Hlim       estremo superiore range di valori ammissibili

  if Llim > Hlim, tmp = Llim; Llim = Hlim; Hlim = tmp; end
  if stmin > stmax, tmp = stmin; stmin = stmax; stmax = tmp; end

  % Segnala la modifica della config
  global modified;
  modified = true;
  CfgList  = get(handles.ConfigLoadName, 'String');
  CfgIndex = get(handles.ConfigLoadName, 'Value');
  CfgName  = [CfgList{CfgIndex}, '_'];
  set(handles.ConfigSaveName, 'String', CfgName);

  
  % Gestione controllo hMax
  X_maxstr = get(hMax, 'String');   % valore appena editato
  X_maxval = str2double(X_maxstr);

  if X_maxval < Llim,     X_maxval = Llim;
  elseif X_maxval > Hlim, X_maxval = Hlim; 
  end

  
  % Gestione controllo hMin 
  X_minval = get(hMin, 'Value');   % valore preciso
 
  if X_minval < Llim,         X_minval = Llim;
  elseif X_minval > X_maxval, X_minval = X_maxval; 
  end
  
  
  % Gestione controllo hCur 
  X_curval = get(hCur, 'Value');   % valore preciso
 
  if X_curval < X_minval,     X_curval = X_minval;
  elseif X_curval > X_maxval, X_curval = X_maxval; 
  end

  
  % Set controlli
  set(hMin, 'Value',  X_minval);
  X_minstr = num2str(X_minval, '%.1f');
  set(hMin, 'String', X_minstr);
  
  set(hCur, 'Value',  X_curval);
  X_curstr = num2str(X_curval, '%.2f');
  set(hCur, 'String', X_curstr);

  set(hMax, 'Value',  X_maxval);
  X_maxstr = num2str(X_maxval, '%.1f');
  set(hMax, 'String', X_maxstr);

  set(hSld, 'Min',   X_minval);
  set(hSld, 'Value', X_curval);
  set(hSld, 'Max',   X_maxval);
  if X_maxval > X_minval, majorstep = stmax / (X_maxval-X_minval);
  else majorstep = stmax; end
  if X_maxval > X_minval, minorstep = stmin / (X_maxval-X_minval);
  else minorstep = stmin; end
  set(hSld, 'SliderStep', [minorstep majorstep]);
end

