%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                P U N T O  D I  E Q U I L I B R I O    2.0              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function RC = PuntoEquilibrioLTI2(F, G, u)
%
% F     square matrix (n x n)
% G     rect matrix   (n x m)
% u     input vector  (m x 1)
%
% x     steady state vector (n x 1)
% stb   stability value     
%
% by F. M. Marchese (2016)
%
% Tested under MatLab R2013b
%


function [x, stb] = PuntoEquilibrioLTI2(F, G, u)
  x   = NaN;
  stb = NaN;
  
  if nargin ~= 3 || isempty(F) || isempty(G) || isempty(u)
    fprintf('PuntoEquilibrioLTI2: wrong parameter(s) number!\n');
    fprintf('Use: PuntoEquilibrioLTI2(F, G, u)\n');    
    return;
  end

  % Risoluzione numerica in forma chiusa (caso lineare)
  % x = -inv(F)*G*u;
  [rF, cF] = size(F);
  [rG, cG] = size(G);
  if rF ~= cF || cF ~= rG  
    % matrice F non quadrata o matrice G non corretta
    return
  end

  if det(F) ~= 0
    % soluzione esatta
    x = -F \ G * u;
  else
    % una delle infinite soluzioni (uso della matrice pseudo-inversa)
    % nel caso F sia singolare
    x = -pinv(F) * G * u;
  end

  stb = StabilityLTI(F);
end