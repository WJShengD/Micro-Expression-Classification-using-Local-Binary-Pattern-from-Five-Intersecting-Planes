
function main_LBPFIP(z_l,f_l,alpha,XY)
data_path=['.\alpha',num2str(alpha),'\EVM_image'];
cd (data_path);

a = dir(); %Layer 2

feature = [];

for i = 1 : length(a)
    if (strcmp(a(i).name, '.') == 1)|| (strcmp(a(i).name, '..') == 1)%#
        continue;
    end
    a(i).name
    b = dir (fullfile(a(i).folder,'/',a(i).name)); %Layer 2
    
    for j = 1 : length(b)
        
        if (strcmp(b(j).name, '.') == 1)|| (strcmp(b(j).name, '..') == 1)%#
            continue;    
        end
        b(j).name
        cd (fullfile(b(j).folder,'/',b(j).name));%#Layer 3
        c = dir('*.jpg');
        
        
        
        for k = 1 : length(c)

            Imgdat = imread(getfield(c, {k}, 'name'));
            
            if size(Imgdat, 3) == 3 % if color images, convert it to gray
                Imgdat = rgb2gray(Imgdat); 
            end
            [height, width] = size(Imgdat);
            if k ==1
                VolData = zeros(height, width, length(c));
            end
            
            VolData(:, :, k) = Imgdat;        
        end
        %Points=linspace(0,1,tim);
        %VolData=TIM(VolData,Points,tim);
        
       %% LBP-TOP
        % parameter set
        FxRadius = 1; 
        FyRadius = 1;
        TInterval = z_l;
        TimeLength = z_l;
        if z_l>=f_l
            TimeLength=z_l;
        end
        if z_l<f_l
            TimeLength=f_l;
        end
        F_length=f_l;
        BorderLength = XY;
        bBilinearInterpolation = 1;  % 0: not / 1: bilinear interpolation
        %59 is only for neighboring points with 8. If won't compute uniform
        %patterns, please set it to 0, then basic LBP will be computed
        Bincount = 59; %59 / 0
        NeighborPoints = [8 8 8]; % XY, XT, and YT planes, respectively
        if Bincount == 0
            Code = 0;
            nDim = 2 ^ (NeighborPoints(1));  %dimensionality of basic LBP
        else
            % uniform patterns for neighboring points with 8
            cd ('..');
            cd ('..');
            cd ('..');
            cd ('..');
            
            U8File = importdata('UniformLBP8.txt');

            BinNum = U8File(1, 1);%#256
            
            nDim = U8File(1, 2); %dimensionality of uniform patterns  #59
            Code = U8File(2 : end, :);%#
            clear U8File;
            
        end

        %5*5 block
        Histogram_block = [];
        x = floor(height/5);
        y = floor(width/5);
        for ii = 1:5
            for jj = 1:5
                % call LBPTOP
                Histogram = LBPFIP(VolData((ii*x+1-x):(ii*x),(jj*y+1-y):(jj*y),:),FxRadius, FyRadius, TInterval, NeighborPoints, TimeLength, F_length,BorderLength, bBilinearInterpolation, Bincount, Code,XY);
                Histogram_block = [Histogram_block,Histogram];
            end
        end
        Histogram_block=Histogram_block';
        feature =[feature,Histogram_block(:)];

        
    end
end
      

mkdir(['./feature/alpha',num2str(alpha)]);
save(['./feature/alpha',num2str(alpha),'/FGLBP_block55_X1Y1Z',num2str(z_l),'F',num2str(f_l),'XY',num2str(XY),'.mat'],'feature');
end
