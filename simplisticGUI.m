name = 'Shuttle';
img=imread([name '.png']);

figure(4);
image(img);
axis image
axis off
hold on

while 1
    [x, y, button] = ginput(1); % get one point using mouse
    
    plot(x, y, 'ob', ...
        'MarkerSize', 12, ...
        'MarkerFaceColor', 'b')
    
    if y > 969 && y < 1116
        if x > 121 && x < 262
            tile = 'temp502';
        elseif x > 932 && x < 1087
            tile = 'temp590';
        elseif x > 2350 && x < 2482
            tile = 'temp468';
        end
        break
    elseif x > 1440 && x < 1597
        if y > 737 && y < 888
            tile = 'temp597';
        elseif y > 1165 && y < 1319
            tile = 'temp480';
        end
        break
    elseif y > 1703 && y < 1838 && x > 447 && x < 588
        tile = 'temp850';
        break
    elseif y > 1795 && y < 1950 && x > 588 && x < 738
        tile = 'temp711';
        break
    elseif y > 1940 && x > 472 && x < 622
        tile = 'temp730';
        break
    else
        waitfor(msgbox('Please click on a RED dot', 'Error','error'));
    end
end
pause(1)

close(figure(4))

[p, t, u] = shuttle(4000, 501, 0.05, 21, 'crank-nick', tile, false);

figure(1)
surf(p, t, u);
xlabel('Thickness')
ylabel('Time')
zlabel('Temperature')
shading interp