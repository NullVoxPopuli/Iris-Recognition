function [retVoters] = cleanVoters(buf)
    % set constants
    %threshconst = 0.05;
    
    % remove noise by eroding/dilating
    se = ones(2,2);
    retVoters = imerode(imerode(imdilate(imdilate(buf,se),se),se),se);
    %figure;imshow(retVoters);
    %retVoters = imdilate(imerode(buf,se),se);
    %figure;imshow(retVoters);
    
%     % group the objects
%     [l1,num1]=bwlabel(retVoters,8);
%     
%     % get the size of the largest object
%     r=0;
%     for n = 1:num1
%         x = size(find(l1 == n));
%         if(x(1) > r)
%             r = x(1);
%         end;
%     end;
% 
%     % apply threshold to remove noise
%     thresh = r*threshconst;
%     for n = 1:num1
%         % get the indexes and the size of the group
%         items = find(l1==n);
%         sz = size(items);
%         
%         % if the group doesn't make the threshold, remove it
%         if(sz(1) < thresh)
%             l1(items) = 0;
%         end;
%     end;
%     
%     % reset the groups to binary
%     l1(find(l1~=0)) = 1;    
%     retVoters = l1;