%---------------1. NALOGA----------------------------------------

%iz .txt file rabmo stevilke dat v vektor, prve dve vrstici sta header

podatki_1 = importdata("naloga1_1.txt","", 2);
podatki_1.data;

cas = reshape(podatki_1.data, 1, []); %dobil sem vektor
%z 100 vrsticami, kar je sicer verjetno praivlno, ampak sem ga z reshape
%dal v vektor z 1 vrstico


%--------------------------2. NALOGA-------------------------------
%isto sam da nesmem uporabt importdata -.-
file_1 = fopen("naloga1_2.txt");
P = [];
stevilo_vrstic = [];
i = 0;
l = 0;
while ~feof(file_1)
    l = l+1;
    line =fgetl(file_1);
    if l==1
        line_split = split(line, " ");
        stevilo_vrstic(1) = str2double(line_split(2));
    end

    if l>1
        i = i+1;
        P(i) = str2double(line);
    end

end

figure
plot(cas, P)
title("graf P(t)")
xlabel("t[s]")
ylabel("P[W]")
%-----------------------3. NALOGA-----------------------------------
% poracun integrala

delta_t = (cas(end)-cas(1))/length(cas);

tic;
integral = delta_t/2 * (P(1)+sum(P(2:end-1).*2)+P(end));
toc;
%Nisem uporabil for zanke, saj je z operacijami nad vektorjemi
%poracun hitrejsi in enostavnejsi...

tic;
s_trapz_metodo = trapz(cas, P);
toc;

fprintf("integral z naso funkcijo: %d, integral z trapz: %d\n", integral, s_trapz_metodo)
