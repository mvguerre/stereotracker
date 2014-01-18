%% trackCam uses the following parametes:
% i1, i2, j1, j2 bounding box coordinates
% G y PP images cropped with boundingbox
% nframe next frame

%% it returns
% i1, i2, j1, j2 the bounding box coordinates for the next search
%% code

function [i1 i2 j1 j2] = trackCam(i1, i2, j1, j2, G, PP, nframe)

I2 = double(histeq(rgb2gray(nframe)));
I2x = conv2(I2,[-1 1]','same');
I2y = conv2(I2,[-1 1],'same');
figure(2)
imshow(I2,[])
hold on
rhomin = Inf;
d = 50;
plot([j1-d j1-d j2+d j2+d j1-d],[i1-d i2+d i2+d i1-d i1-d],'r')


disp('buscando...')
sh1 = 0;
sh2 = 0;
k = 0;
i = 0;
j = 0;
iter = 1;
while (iter)
        F   = I2(i1+i:i2+i,j1+j:j2+j,:);
%         figure(4)
%         imshow(F,[]);
        pause(0)
        Fx  = I2x(i1+i:i2+i,j1+j:j2+j,:);
        Fy  = I2y(i1+i:i2+i,j1+j:j2+j,:);
        dF  = [Fx(:) Fy(:)];
        sh1 = dF'*(G(:)-F(:));
        sh2 = dF'*dF;
        h   = inv(sh2)*sh1;
        imin   = round(i-h(1));
        jmin   = round(j-h(2));
        if and((imin==i),(jmin==j))
            iter = 0;
        else
            i = imin;
            j = jmin;
        end

end
i1 = i1+imin;
i2 = i2+imin;
j1 = j1+jmin;
j2 = j2+jmin;

G = double(I2(i1:i2,j1:j2,:));

figure(2)
hold on
hold on
plot([j1 j1 j2 j2 j1],[i1 i2 i2 i1 i1])


PP = [PP G];
%figure(5)
%imshow(PP,[])
pause(1)
