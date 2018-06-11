%% GESTIONE CONTROLLI ASSOCIATI AD UNO SLIDER
%
% function Slider_sld_Callback
%
% ver. 2.0
%
% by F. M. Marchese (2016)
%
% Tested under MatLab R2013b
%


function Slider_sld_Callback(handles, hSld, hCur)
% handles    structure with handles and user data (see GUIDATA)
% hSld       handle slider
% hMin       handle min editbox
% hCur       handle cur editbox
% hMax       handle max editbox
% stmin      step min
% stmax      step max

  % Segnala la modifica della config
  global modified;
  modified = true;
  CfgList  = get(handles.ConfigLoadName, 'String');
  CfgIndex = get(handles.ConfigLoadName, 'Value');
  CfgName  = [CfgList{CfgIndex}, '_'];
  set(handles.ConfigSaveName, 'String', CfgName);
  
  
  
  X_sldval = get(hSld, 'Value');    % valore preciso

  
  
  % Set controlli
  set(hCur, 'Value',  X_sldval);
  X_curstr = num2str(X_sldval, '%.2f');
  set(hCur, 'String', X_curstr);
end
