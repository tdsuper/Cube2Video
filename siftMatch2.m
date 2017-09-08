function [m1, m2] = siftMatch2(des1, des2, loc1, loc2)

[b, m] = unique(loc1(:,1:3), 'rows', 'first');
des1 = des1(m, :);
loc1 = loc1(m, :);

[b, m] = unique(loc2(:,1:3), 'rows', 'first');
des2 = des2(m, :);
loc2 = loc2(m, :);

distRatio = 0.6;   

for i = 1 : size(des1,1)
   diff = repmat(des1(i,:), size(des2,1), 1) - des2;
   distance = zeros(size(des2,1),1);
   for j = 1:size(des2,1)
       distance(j) = sqrt(sum(diff(j,:).^2));
   end
   [vals,indx] = sort(distance);  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end

% code added
all = 1:length(match);
[b, m] = unique(match);
match(setdiff(all,m)) = 0;
% end of code

m1 = loc1(match>0,1:3);
m2 = loc2(match(match>0),1:3);
m1 = m1';
m2 = m2';