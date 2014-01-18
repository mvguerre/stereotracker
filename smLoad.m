function frames = smLoad(cam)

str = sprintf('Ingrese el nombre de la carpeta donde estan los frames de la camara %i: ', cam);
folder = input(str, 's');
extension = input('Ingrese la extension de los archivos (jpg, png, etc): ','s');

if(numel(extension)==0)
    extension = 'jpg';
end

if(numel(folder)>0)
    folder = strcat(folder,'/');
end
extension = strcat('*.',extension);

path = sprintf('%s%s',folder,extension);
imagefiles = dir(path);      
nfiles = length(imagefiles);    % Number of files found

for i=1:nfiles
   currentfilename = sprintf('%s%s',folder,imagefiles(i).name);
   currentimage = imread(currentfilename);
   frames{i} = imresize(currentimage, [480 640]);
end
