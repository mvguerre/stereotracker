%Max-Svec 2012

close all
clear all
clc

manual = 1;

%% method parameters
maxError = 50;

%% loading extrinsic parameters
load('ExtrinsicParameters')


%% load cameras frames
l = input('Ingrese el nombre del archivo o presione enter para cargar una carpeta: ','s');
if(numel(l>0))
    load(l);
else
    framesa = smLoad(1);
    framesb = smLoad(2);
end

%% selec the initial bounding box

%% se usa para Cov
Ia1 = framesa{1};
Ib1 = framesb{1};

[ib1 ib2 jb1 jb2] = msStart(Ib1);
if(manual == 1)
    [ia1 ia2 ja1 ja2] = msStart(Ia1);
else
%% Auto select of the others camara bounding box
    m1 = [double(ib1) double(jb1) 1]';
    ell = Fc*m1;
    a  = ell(1);
    b  = ell(2);
    c  = ell(3);
    ia1 = ib2+80;
    ja1= int64(-(c+a*(double(ib2)+120))/b);
    ia2= ib1 + 280;
    ja2=int64(-(c+a*(double(ib1)+320))/b);
%%
end

Ga = double(Ia1(ia1:ia2,ja1:ja2,:));
hold on
plot([ja1 ja1 ja2 ja2 ja1],[ia1 ia2 ia2 ia1 ia1])

Gb = double(Ib1(ib1:ib2,jb1:jb2,:));
hold on
plot([jb1 jb1 jb2 jb2 jb1],[ib1 ib2 ib2 ib1 ib1])

PPa = Ga;
PPb = Gb;
Gaa = Ga;
Gba = Gb;

C(1) =  87.0414;

for k=1:133
    tic
    disp(['Procesando imagenes ' k]);
    
    nframea = framesa{k};
    nframeb = framesb{k};
    
    %% track con cov
    [ia1 ia2 ja1 ja2] = trackCamCov(ia1, ia2, ja1, ja2, Ga, PPa, nframea);
    Ga = double(nframea(ia1:ia2,ja1:ja2,:));
    PPa = [PPa Ga];
    
    [ib1 ib2 jb1 jb2] = trackCamCov(ib1, ib2, jb1, jb2, Gb, PPb, nframeb);
    Gb = double(nframeb(ib1:ib2,jb1:jb2,:));
    PPb = [PPb Gb];
    
    %% error adjustment
    ma = [(ia2+ia1)/2 (ja2+ja1)/2];
    mb = [(ib2+ib1)/2 (jb2+jb1)/2];
    
    c = Bmv_epidist(double([ma 1]'),double([mb 1]'),Fc);
    disp(c)
    if((abs(C(k)-c)/c)>0.05) % if there's no correlation
        
        dif1 = abs(mean(Ga(:))-mean(Gaa(:)));
        dif2 = abs(mean(Gb(:))-mean(Gba(:)));
        
        if ( dif1>dif2)
        [ia1 ia2 ja1 ja2] = smLostAndFound(ia1 ,ia2 ,ja1 ,ja2, framesa{k}); 
        disp('corrigiendo cam1')
        else
        [ib1 ib2 jb1 jb2] = smLostAndFound(ib1 ,ib2 ,jb1 ,jb2, framesb{k});
        disp('corrigiendo cam2')
        end

    end

     C(k+1) = c;
     Gaa = Ga;
     Gba = Gb;
     av(k) = toc;
end

