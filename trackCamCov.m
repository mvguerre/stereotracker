%% trackCam uses the following parametes:
% i1, i2, j1, j2 bounding box coordinates
% G y PP images cropped with boundingbox
% nframe next frame

%% it returns
% i1, i2, j1, j2 the bounding box coordinates for the next search
%% code

function [i1 i2 j1 j2] = trackCamCov(i1, i2, j1, j2, G, PP, nframe)

P1 = G;
I2 = nframe;
figure(2)
imshow(I2,[])
hold on
R1 = P1(:,:,1);
G1 = P1(:,:,2);
B1 = P1(:,:,3);
z1 = [R1(:) G1(:) B1(:)];
C1 = cov(z1);
rhomin = Inf;
d = 50;
plot([j1-d j1-d j2+d j2+d j1-d],[i1-d i2+d i2+d i1-d i1-d],'r')

disp('buscando...')
for i=-d:2:d
    for j=-d:2:d
        try

            P2 = double(I2(i1+i:i2+i,j1+j:j2+j,:));

            R2 = P2(:,:,1);
            G2 = P2(:,:,2);
            B2 = P2(:,:,3);
            z2 = [R2(:) G2(:) B2(:)];
            C2 = cov(z2);

            [V,D] = eig(C1,C2);

            lni = log(diag(D));

            rho = sqrt(sum(lni.*lni));


            if rho<rhomin
                imin = i;
                jmin = j;
                i1m = i1+imin;
                i2m = i2+imin;
                j1m = j1+jmin;
                j2m = j2+jmin;
                rhomin = rho;
                P2s = P2;
            end
        catch exception
            %simplemente no consideramos las imagenes que esten fuera de
            %limites
        end
    end
end


figure(2)
hold on
hold on
plot([j1m j1m j2m j2m j1m],[i1m i2m i2m i1m i1m])

i1 = i1+imin;
i2 = i2+imin;
j1 = j1+jmin;
j2 = j2+jmin;

%figure(3)
%imshow(P1/256)


%figure(4)
%imshow(P2s/256)

PP = [PP P2s];
figure(5)
imshow(PP/256)
P1 = P2s;
