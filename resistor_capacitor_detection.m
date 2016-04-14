clc

clear

I = imread('capacitor1.png');

I = rgb2gray(I);

BW = edge(I,'canny');

[H,theta,rho] = hough(BW);

figure

imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');

xlabel('\theta (degrees)')

ylabel('\rho')

axis on

axis normal

hold on

colormap(hot)

P = houghpeaks(H,9,'threshold',ceil(0.3*max(H(:))));

x = theta(P(:,2));

y = rho(P(:,1));

plot(x,y,'s','color','blue');

lines = houghlines(BW,theta,rho,P,'FillGap',8,'MinLength',40);

figure, imshow(I), hold on

max_len = 0;


for k = 1:length(lines)

  xy = [lines(k).point1; lines(k).point2];

  plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');


  slopes(k) = (xy(2,2)-xy(1,2))./(xy(2,1)-xy(1,1));
 
  % Plot beginnings and ends of lines

  plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');

  plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');


  % Determine the endpoints of the longest line segment

  len = norm(lines(k).point1 - lines(k).point2);

  if ( len > max_len)

     max_len = len;

     xy_long = xy;

  end

end

%% Determine if component is resistor or capacitor

for i = 1:length(slopes)
    counter = 0;
    inverseCounter = 0;
    for j = 1:length(slopes)
        if (i~=j && slopes(i) == slopes(j))
            counter = counter + 1;
        end
        if (i~=j && slopes(i) == -slopes(j))
            inverseCounter = 1;
        end
        
        lineCount(i) = counter;
        inverseCount(i) = inverseCounter;
      
    end
end


for j = 1:length(slopes)
    if (slopes(j) == Inf || slopes(j) == 0)
        infCounter(j) = 1;
    else
        infCounter(j) = 0;
    end
    
end


if (sum(infCounter)==length(infCounter))
    capacitor = true; 
elseif (sum(inverseCount)==length(inverseCount))
    resistor = true;  
end

    