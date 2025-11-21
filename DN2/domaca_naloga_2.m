%DOMAČA NALOGA 2 - INTERPOLACIJA

clc; clear;

fileNodes = 'vozlisca_temperature_dn2_15.txt';
fileCells = 'celice_dn2_15.txt';

xq = 0.403; yq = 0.503;

data = loadData(fileNodes, fileCells);

fprintf('\nInterpolacija v točki (%.3f, %.3f):\n', xq, yq);

% 1) scattered interpolacija
tic;
Fs = scatteredInterpolant(data.x, data.y, data.T, 'linear', 'none');
T_scattered = Fs(xq, yq);
t_scattered = toc;
fprintf('  scatteredInterpolant: T = %.6f  (čas = %.6f s)\n', T_scattered, t_scattered);

% 2) gridded interpolacija
tic;
Fg = griddedInterpolant({data.x_vec, data.y_vec}, data.Tmat, 'linear', 'none');
T_gridded = Fg(xq, yq);
t_gridded = toc;
fprintf('  griddedInterpolant:   T = %.6f  (čas = %.6f s)\n', T_gridded, t_gridded);

% 3) bilinearna interpolacija
tic;
T_my = bilinear(xq, yq, data.x_vec, data.y_vec, data.Tmat);
t_my = toc;
fprintf('  bilinearna:      T = %.6f  (čas = %.6f s)\n', T_my, t_my);

% nearest neighbor
tic;
T_nn = nearestNeighbor(xq, yq, data);
t_nn = toc;
fprintf('  nearest neighbor:     T = %.6f  (čas = %.6f s)\n', T_nn, t_nn);

% Max temperatura
[Tmax, idx] = max(data.T);
i = mod(idx-1, data.Nx) + 1;
j = floor((idx-1)/data.Nx) + 1;
x_max = data.x_vec(i);
y_max = data.y_vec(j);
fprintf('\nNajvišja temp. in njene koordinate: %.6f pri (x=%.6f, y=%.6f)\n', Tmax, x_max, y_max);


%------------funkcije-----------
function data = loadData(fileNodes, fileCells)
%
    fid = fopen(fileNodes,'r');
    fgetl(fid); %sam tok da ignoriramo prvo vrstico

    Nx = extractFirstNumber(fgetl(fid));
    Ny = extractFirstNumber(fgetl(fid));
    Nv = extractFirstNumber(fgetl(fid));

    raw = textscan(fid, '%f%f%f', 'Delimiter', ',', 'CollectOutput', true);
    fclose(fid);

    M = raw{1};
    x = M(:,1);
    y = M(:,2);
    T = M(:,3);

    Tmat = reshape(T, Nx, Ny);


    x_vec = x(1:Nx);
    y_vec = y(1:Nx:end); %vektorja koordinat

    
    cells = [];
    if nargin >= 2 && ~isempty(fileCells) && isfile(fileCells)
        fidc = fopen(fileCells,'r');
        fgetl(fidc);      % header
        fgetl(fidc);      % "st. celic: X" 
        C = textscan(fidc, '%d%d%d%d', 'Delimiter', ',', 'CollectOutput', true);
        fclose(fidc);
        cells = C{1};
    end

   
    dx = x_vec(2) - x_vec(1);
    dy = y_vec(2) - y_vec(1);

    % podatki
    data.x = x;
    data.y = y;
    data.T = T;
    data.Tmat = Tmat;
    data.x_vec = x_vec;
    data.y_vec = y_vec;
    data.Nx = Nx;
    data.Ny = Ny;
    data.Nv = Nv;
    data.dx = dx;
    data.dy = dy;
    data.cells = cells;
    data.Nc = (Nx-1)*(Ny-1);
end

function num = extractFirstNumber(line)
% Vrne prvo število iz vrstice; predpostavljamo da obstaja.
    parts = sscanf(line, '%*[^0-9]%d');
    num = parts(1);
end

function Tq = bilinear(xq, yq, x_vec, y_vec, Tmat)

    if xq < x_vec(1) || xq > x_vec(end) || yq < y_vec(1) || yq > y_vec(end)
        Tq = NaN;
        return;
    end

    if xq == x_vec(end), xq = xq - 1e-12; end
    if yq == y_vec(end), yq = y_vec(end) - 1e-12; end

    dx = x_vec(2) - x_vec(1);
    dy = y_vec(2) - y_vec(1);

    i = floor((xq - x_vec(1))/dx) + 1;
    j = floor((yq - y_vec(1))/dy) + 1;

    xmin = x_vec(i);   xmax = x_vec(i+1);
    ymin = y_vec(j);   ymax = y_vec(j+1);

    T11 = Tmat(i,   j);
    T21 = Tmat(i+1, j);
    T22 = Tmat(i+1, j+1);
    T12 = Tmat(i,   j+1);

    s = (xq - xmin)/(xmax - xmin);
    t = (yq - ymin)/(ymax - ymin);
    %enacba za bilinearno interp
    Tq = (1-s)*(1-t)*T11 + s*(1-t)*T21 + s*t*T22 + (1-s)*t*T12;
end

function Tnn = nearestNeighbor(xq, yq, data)% samo kot test kako hitra je, ker bi sicer mogla bit zelo nenatancna
    [~, ix] = min(abs(data.x_vec - xq));
    [~, iy] = min(abs(data.y_vec - yq));
    Tnn = data.Tmat(ix, iy);
end