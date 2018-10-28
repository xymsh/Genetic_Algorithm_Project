function rgb = ESUpdateColor(rgb1, mu)
coe = randi([-1,1]);
rgb = abs(rgb1 + rand(3,1)*mu*coe);

if ~(all(rgb(:)>=0) && all(rgb(:)<=1))
    for i = 1:3
        if rgb(i,1)>1
            rgb(i,1)=0.5 + randi([-1,1])*rand*0.5*mu;
        end
    end
end

end
