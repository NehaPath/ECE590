clc

clear

I = imread('res_proj.png');

I = rgb2gray(I);

I = imresize(I, 5);

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

P = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));

x = theta(P(:,2));

y = rho(P(:,1));

plot(x,y,'s','color','blue');

lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',20);

figure, imshow(I), hold on

max_len = 0;


slopes = zeros(1,length(lines));
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
        if (i~=j && (abs(slopes(i))-abs(slopes(j))<.2))
            inverseCounter = 1;
        end
        
        lineCount(i) = counter;
        inverseCount(i) = inverseCounter;
      
    end
end

infCounter = zeros(1,length(lines));
for j = 1:length(slopes)
    if (slopes(j) == Inf || (slopes(j) <0.1 && slopes(j)>-.1) || slopes(j)> 8.0 || slopes (j)<-8.0)
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

    