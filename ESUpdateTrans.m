function alpha2 = ESUpdateTrans(alpha1, minTrans, maxTrans, mu)
a = abs(alpha1-minTrans);
b = abs(alpha1-maxTrans);
if b<a
    a = b;
end
a = a*mu;
if a < 0.01
    alpha2 = 0.5*(maxTrans + minTrans);
else
    alpha2 = alpha1 + randi([-1,1])*rand*a;
end

end
