function [i1 i2 j1 j2] = msStart(I1)

resp = true;
while(resp)
    figure(1)
    imshow(I1);
    bbx = uint32(getrect);
    hold on,
    rectangle('Position',bbx,'EdgeColor','b');
    resp = input('Para continuar presione enter, o ingese 1 para volver a marcar ','s');
    if(numel(resp)==0)
        resp = false;
    end
end

i1 = bbx(2);
i2 = bbx(2)+bbx(4);
j1 = bbx(1);
j2 = bbx(1)+bbx(3);
