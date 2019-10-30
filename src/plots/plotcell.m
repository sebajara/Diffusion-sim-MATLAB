function [] = plotcell(length,width)

% Sebastian Jaramillo-Riveri
% November, 2018

    d = length/2 - width/2;
    r = width/2;
    % X == long axis
    % Y == width
    % Z == height
    titles    = {'X v/s Y','X v/s Z','Y v/s Z'};
    lw = 2;
    color = 0.5*[1,1,1];
    for i = 1:2
        subplot(1,4,i); hold on;
        plot([-d,d],[r,r],'-','LineWidth',lw,'Color',color);
        plot([-d,d],-1*[r,r],'-','LineWidth',lw,'Color',color);
        xs = linspace(-width/2,0,100);
        ys = sqrt(r^2-xs.^2);
        plot(xs-d,ys,'-','LineWidth',lw,'Color',color);
        plot(xs-d,-1*ys,'-','LineWidth',lw,'Color',color);
        xs = linspace(0,width/2,100);
        ys = sqrt(r^2-xs.^2);
        plot(xs+d,ys,'-','LineWidth',lw,'Color',color);
        plot(xs+d,-1*ys,'-','LineWidth',lw,'Color',color);
        axis([-length/2,length/2,-length/2,length/2]);
        plot(d,0,'o','MarkerSize',2,'MarkerEdgeColor',color,'MarkerFaceColor',color);
        plot(-d,0,'o','MarkerSize',2,'MarkerEdgeColor',color,'MarkerFaceColor',color);
    end
    
    subplot(1,4,3); hold on;
    xs = linspace(-width/2,width/2,100);
    ys = sqrt(r^2-xs.^2);
    plot(xs,ys,'-','LineWidth',lw,'Color',color);
    plot(xs,-1*ys,'-','LineWidth',lw,'Color',color);
    axis([-length/2,length/2,-length/2,length/2]);
    plot(0,0,'o','MarkerSize',2,'MarkerEdgeColor',color,'MarkerFaceColor',color);

    subplot(1,4,4); hold on;
    axis([-length/2,length/2,-length/2,length/2,-length/2,length/2]);
    plot3(d,0,0,'o','MarkerSize',2,'MarkerEdgeColor',color,'MarkerFaceColor',color);
    plot3(-d,0,0,'o','MarkerSize',2,'MarkerEdgeColor',color,'MarkerFaceColor',color);

end