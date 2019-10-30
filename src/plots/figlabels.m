function [] = figlabels(STR1,STR1val,STR2,STR2val,STR3,STR3val,STR4,STR4val)
% [] = figlabels(str,strvals,...)
% To simplify adding axes labels and title. 
% 
% Example usage
% figlabels('title','\bf Max L',...
%           'xlabel','Displacement [$\mu$m]',...
%           'ylabel','p.d.f',...
%           'fsize',12); 
% 
% Valid string options:
% 'xlabel' 'ylabel' 'title' 'fsize'
%
% Sebastian Jaramillo-Riveri
% November, 2018

    
    OPTIONAL_STRS = {'xlabel','ylabel','title','fsize'};

    xlab = '';
    ylab = '';
    tit  = '';
    fsize = 12;
    
    if nargin < 2
    elseif nargin == 2
        Input_Values = {STR1, STR1val};
    elseif nargin == 4
        Input_Values = {STR1 STR1val; STR2, STR2val};
    elseif nargin == 6
        Input_Values = {STR1 STR1val; STR2, STR2val; STR3, STR3val};
    elseif nargin == 8
        Input_Values = {STR1 STR1val; STR2, STR2val; STR3, STR3val; STR4, STR4val};
    else
        error('Incorrect paired values');
    end
    for i=1:1:(nargin/2)
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
        else
            error ('WTH!');
        end
    end
    ylabel(ylab,'Interpreter','latex','FontSize',fsize,'Color','black');
    xlabel(xlab,'Interpreter','latex','FontSize',fsize,'Color','black');
    title(tit,'Interpreter','latex','FontSize',fsize,'Color','black');
    
end