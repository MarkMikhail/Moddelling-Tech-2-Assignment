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
    
    if y > 969 & y < 1116
        if x > 121 & x < 262
            [p, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', 'temp502', false);
        elseif x > 932 & x < 1087
            [p, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', 'temp590', false);
        elseif x > 2350 & x < 2482
            [p, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', 'temp468', false);
        end
        break
    elseif x > 1440 & x < 1597
        if y > 737 & y < 888
            [p, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', 'temp597', false);
        elseif y > 1165 & y < 1319
            [p, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', 'temp480', false);
        end
        break
    elseif y > 1703 & y < 1838 & x > 447 & x < 588
        [p, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', 'temp850', false);
        break
    elseif y > 1795 & y < 1950 & x > 588 & x < 738
        [p, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', 'temp711', false);
        break
    elseif y > 1940 & x > 472 & x < 622
        [p, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', 'temp730', false);
        break
    else
        waitfor(msgbox('Please click on a RED dot', 'Error','error'));
    end
end
pause(1)

close(figure(4))

figure(1)
surf(p, t, u);
xlabel('Thickness')
ylabel('Time')
zlabel('Temperature')
shading interp