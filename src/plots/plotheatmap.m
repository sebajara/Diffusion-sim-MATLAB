function [] = plotheatmap(mat,STR1,STR1val,STR2,STR2val,STR3,STR3val,STR4,STR4val,STR5,STR5val,STR6,STR6val)

OPTIONAL_STRS = {'xlabel','ylabel','title','fsize','axis','nticks'};

xlab   = '';
ylab   = '';
tit    = '';
fsize  = 12;
nticks = 5;
axisv  = [0,0,0,0];
axisp  = 0;

if nargin < 3
elseif nargin == 3
    Input_Values = {STR1, STR1val};
elseif nargin == 5
    Input_Values = {STR1 STR1val; STR2, STR2val};
elseif nargin == 7
    Input_Values = {STR1 STR1val; STR2, STR2val; STR3, STR3val};
elseif nargin == 9
    Input_Values = {STR1 STR1val; STR2, STR2val; STR3, STR3val; STR4, STR4val};
elseif nargin == 11
    Input_Values = {STR1 STR1val; STR2, STR2val; STR3, STR3val; STR4, STR4val; STR5, STR5val};
elseif nargin == 13
    Input_Values = {STR1 STR1val; STR2, STR2val; STR3, STR3val; STR4, STR4val; STR5, STR5val; STR6, STR6val};
else
    error('Incorrect paired values');
end

if(nargin>2)
    for i=1:1:((nargin-1)/2)
        STR = Input_Values{i,1};
        STRval = Input_Values{i,2};
        z = strmatch(STR,OPTIONAL_STRS,'exact');
        if z == 1
            xlab = STRval;
        elseif z == 2
            ylab = STRval;
        elseif z == 3
            tit  = STRval;
        elseif z == 4
            fsize = STRval;
        elseif z == 5
            axisv = STRval;
            axisp = 1;
        elseif z == 6
            nticks = STRval;
        else
            error ('WTH!');
        end
    end
end

sobj = surf(mat');
sobj.EdgeColor = 'none';
%colormap('jet');
%colormap('gray');
%colormap('autumn');
colormap('hot');
view([0,90]);
figlabels('title',['\bf ',tit],...
          'xlabel',xlab,...
          'ylabel',ylab,...
          'fsize',fsize);
if(axisp==1)
    xts = {};
    yts = {};
    xbins = round(linspace(axisv(1),axisv(2),nticks),2);
    ybins = round(linspace(axisv(3),axisv(4),nticks),2);
    for n = 1:nticks
        xts{n} = num2str(xbins(n));
        yts{n} = num2str(ybins(n));
    end
    [nx,ny] = size(mat);
    axis([1 nx 1 ny]);
    xticks(linspace(1,nx,nticks));
    yticks(linspace(1,ny,nticks));
    xticklabels(xts);
    yticklabels(yts);
end
end 