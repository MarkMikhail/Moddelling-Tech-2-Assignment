function graphScan(name)

if exist([name '.jpg'], 'file') == 2
    img = imread([name '.jpg']);
elseif exist([name '.png'], 'file') == 2
    img = imread([name '.png']);
else
    error('This file does not exist or is of an unsupported format!');
end

imgbw = im2bw(img);
%imshow(imgbw);

arraySize = size(img);
R = arraySize(1);
C = arraySize(2);

horPer = zeros(R,1);
vertPer = zeros(C,1);

for a = 1:R
    for b = 1:C
        colour = imgbw(a,b,:);
        %colour = (colour(1) + colour(2) + colour(3))/3;
        if (colour == 0)
            horPer(a) = horPer(a) + 1;
        end
    end
end

[Xlength,X] = max(horPer);

for b = 1:C
    for a = X:-1:1
        colour = imgbw(a,b,:);
        %colour = (colour(1) + colour(2) + colour(3))/3;
        if (colour == 0)
            vertPer(b) = vertPer(b) + 1;
        else
            break
        end
    end
end

[Ylength,Y] = max(vertPer);

lineY = zeros(1,Xlength);

for ra = Y:(Y+Xlength)
    lineY(ra+1-Y) = mean(find(img(:,ra,1) > 200 & img(:,ra,2) < 100 & img(:,ra,3) < 150));
end

Ymin = (-32)*5/9;
Ymax = (2000-32)*5/9;
Yrange = Ymax-Ymin;
Xmax = 2000;

lineY = ((lineY-(R-Ylength-(R-X)))/Ylength)*(-1)+1; % 0 to 1 (The error is here)
lineY = lineY*Yrange + Ymin; % Ymin to Ymax (inverted)
lineY = lineY(2:end); % remove the first data point (By trial and error its always wrong)

lineX = (0:length(lineY)-1)*Xmax/length(lineY);

lineX = lineX(~isnan(lineY));
lineY = lineY(~isnan(lineY));

timedata = lineX;
tempdata = lineY;

save(name, 'timedata', 'tempdata')

plot(lineX,lineY,'r');
axis([0 Xmax Ymin Ymax]);

end