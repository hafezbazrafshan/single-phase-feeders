function fv= calculateIPQIISinglePhase(v, g, sL,iL,yL )


g(:,3)=0;
nvars=length(v); 
fv=zeros(nvars,1);
for i=1:nvars

    iL_PQ=  fPQ( v(i), sL(i,1));
    iL_I=fI(v(i), iL(i,1));
    iL_Y=fY(v(i),yL(i,1));
    fv(i,1)=g(i,:)*[iL_PQ;iL_I;iL_Y];
end


end

