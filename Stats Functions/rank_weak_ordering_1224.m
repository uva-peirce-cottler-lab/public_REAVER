function r = assign_weak_ranks(w)
% Apply weak ordering with 1224 convention
%   w: vector of total wins for each player/study group
%   r: rank assignment for each player-study group



[ws, ix] = sort(w,'descend');
[~,rix] = sort(ix);

rs=zeros(1,numel(ws));
% rs(1)=1;

for n=1:numel(ws)
    if n==1
        rs(n)=1;
    elseif ws(n) < ws(n-1)
%         rs(n)=rs(n-1)+1;
        rs(n)=n;
    else
        rs(n)=rs(n-1);
	end
	rs
end

r = rs(rix);

% keyboard
end

