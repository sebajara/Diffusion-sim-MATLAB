function [] = mypdfpngexpfig(STR1,STR1val,STR2,STR2val,STR3,STR3val,STR4,STR4val)

    OPTIONAL_STRS = {'PaperPosition','outname'};

    PaperPosition = [0 0 7 7];
    outname = 'fig';
    fig = gcf;
    
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
            PaperPosition = STRval;
        elseif z == 2
            outname = STRval;
        else
            error ('WTH!');
        end
    end

    fig.PaperUnits = 'centimeters';
    fig.PaperPosition = PaperPosition;

    print('-r600',fig,['./',outname,'.pdf'],'-dpdf');
    system(['convert -density 600 -trim ',outname,'.pdf',' -quality 100 ',outname,'.png']);

end