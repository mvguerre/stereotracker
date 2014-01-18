function [ix1 ix2 jx1 jx2] = smLostAndFound(ia1, ia2, ja1, ja2, frame)

minDif = 10000;
ia1_o =ia1;
ia2_o =ia2;
ja1_o =ja1;
ja2_o =ja2;
Ibase = frame(ia1:ia2,ja1:ja2);
%hacer que este for haga un barrido en los adyacentes
for i=-5:5
    for j = -5:5
        ia1 =ia1+i;
        ia2 =ia2+i;
        ja1 =ja1+j;
        ja2 =ja2+j;
        try
            Imax = frame(ia1:ia2,ja1:ja2);
            dif = abs(mean(Imax(:))-mean(Ibase(:)));%cambiame!!
        catch err
            dif = 1000000;   
        end
        
        if(minDif>dif)
            minDif = dif;
            indexi = i;
            indexj = j;
        end
    end
end
ix1 =ia1_o+indexi;
ix2 =ia2_o+indexi;
jx1 =ja1_o+indexj;
jx2 =ja2_o+indexj;

end

