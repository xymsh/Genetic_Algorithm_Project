function [x2, y2, numV2] = ESUpdatePoint(numV1, maxN, x1, y1, n, m, mu)
numV2 = numV1 + randi([-mu,mu]);
if (numV2 < 3 || numV2 > maxN)
    numV2 = numV1;
end

x2=randi(n,[numV2,1]);
y2=randi(m,[numV2,1]);

end
