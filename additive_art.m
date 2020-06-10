clc;
close all;
clear all;

init_letter = zeros(10);

% EEE416 BIOMEDICAL SYSTEMS: ADDITIVE ART HOMEWORK
% First letter of my name: M
% Generate random gray valued image of M by using random gray values [75,255]

% Left side of M
for left_m_index=2:9
    init_letter(left_m_index, 2) = randi([75,255],1);
end

% Left-lean of M
for left_lean_bridge_m_index=0:2
    init_letter(3+left_lean_bridge_m_index, 3+left_lean_bridge_m_index) = randi([100,255],1);
end

% Right-lean of M
for right_lean_bridge_m_index=0:1
    init_letter(4-right_lean_bridge_m_index, 6+right_lean_bridge_m_index) = randi([100,255],1);
end

% Right-side of M
for right_side_m_index=2:9
    init_letter(right_side_m_index, 8) = randi([75,255],1);
end

% left diagonal measurement
left_diag = zeros(1, 19);
for left_diag_ind=1:19
    left_diag(1, left_diag_ind) = sum(diag(init_letter, 10-left_diag_ind));
end

% right diagonal measurement
index = hankel(1:10,10:(9)+10);
right_diag = accumarray(index(:),init_letter(:));

% horizontal and vertical measurements
horizontal_ray_measurement = sum(init_letter,2);
vertical_ray_measurement = sum(init_letter,1);

% remove unnecessary variables from memory
clear index left_m_index right_side_m_index left_lean_bridge_m_index left_diag_ind right_lean_bridge_m_index;

% Additive ART

reconstruction_matrix = zeros(10);

for iteration=1:250 % greater iteration number takes time but increases precision
    % vertical reconstruction
    vertical_rays_sum_reconned = sum(reconstruction_matrix,1);

    for row=1:10
        for column=1:10
            reconstructed_cell = reconstruction_matrix(row,column) + (vertical_ray_measurement(column) - vertical_rays_sum_reconned(column))/10;
            if (reconstructed_cell < 0)
                reconstruction_matrix(row,column) = 0;
            else    
                reconstruction_matrix(row,column) = reconstructed_cell;
            end
        end
    end

    % horizontal reconstruction
    % horizontal calculation for reconstructed matrix values
    horizontal_rays_sum_reconned = sum(reconstruction_matrix,2);

    %horizontal ART
    for row=1:10
        for column=1:10
            reconstructed_cell = reconstruction_matrix(row,column) + (horizontal_ray_measurement(row) - horizontal_rays_sum_reconned(row))/10;
            if (reconstructed_cell < 0)
                reconstruction_matrix(row,column) = 0;
            else    
                reconstruction_matrix(row,column) = reconstructed_cell;
            end
        end
    end

    % diagonal reconstruction
    % diagonal calculation for reconstructed matrix values
    left_diag_reconned = zeros(1, 19);
    for left_diag_ind=1:19
        left_diag_reconned(1, left_diag_ind) = sum(diag(reconstruction_matrix, 10-left_diag_ind));
    end
    
    % diagonal ART for reconstructed matrix
    for row=1:10
        for column=1:10 
            indis = 10+row-column;
            reconstructed_cell = reconstruction_matrix(row,column) + (left_diag(1, indis) - left_diag_reconned(1, indis))/10;
            if (reconstructed_cell < 0)
                reconstruction_matrix(row,column) = 0;
            else    
                reconstruction_matrix(row,column) = reconstructed_cell;
            end
        end
    end


    % secondary diagonal reconstruction
    % secondary diagonal calculation for reconstructed matrix values
    index = hankel(1:10,10:(9)+10);
    right_diag_reconned = accumarray(index(:),reconstruction_matrix(:));

    % secondary diagonal ART for reconstructed matrix
    for row=1:10
        for column=1:10 
            indis = row-1+column;
            reconstructed_cell = reconstruction_matrix(row,column) + (right_diag(indis, 1) - right_diag_reconned(indis, 1))/10;
            if (reconstructed_cell < 0)
                reconstruction_matrix(row,column) = 0;
            else    
                reconstruction_matrix(row,column) = reconstructed_cell;
            end
        end
    end
end

horizontal_y_values = {'1→' + string(horizontal_ray_measurement(1)), '2→' + string(horizontal_ray_measurement(2)), '3→' + string(horizontal_ray_measurement(3)), '4→' + string(horizontal_ray_measurement(4)), '5→' + string(horizontal_ray_measurement(5)), '6→' + string(horizontal_ray_measurement(6)), '7→' + string(horizontal_ray_measurement(7)), '8→' + string(horizontal_ray_measurement(8)), '9→' + string(horizontal_ray_measurement(9)), '10→' + string(horizontal_ray_measurement(10))};
vertical_x_values = {'1→' + string(vertical_ray_measurement(1)), '2→' + string(vertical_ray_measurement(2)), '3→' + string(vertical_ray_measurement(3)), '4→' + string(vertical_ray_measurement(4)), '5→' + string(vertical_ray_measurement(5)), '6→' + string(vertical_ray_measurement(6)), '7→' + string(vertical_ray_measurement(7)), '8→' + string(vertical_ray_measurement(8)), '9→' + string(vertical_ray_measurement(9)), '10→' + string(vertical_ray_measurement(10))};
primary_diag_y = {'1→' + string(left_diag(1)), '2→' + string(left_diag(2)), '3→' + string(left_diag(3)), '4→' + string(left_diag(4)), '5→' + string(left_diag(5)), '6→' + string(left_diag(6)), '7→' + string(left_diag(7)), '8→' + string(left_diag(8)), '9→' + string(left_diag(9)), '10→' + string(left_diag(10))};
primary_diag_x = {'1→' + string(left_diag(19)), '2→' + string(left_diag(18)), '3→' + string(left_diag(17)), '4→' + string(left_diag(16)), '5→' + string(left_diag(15)), '6→' + string(left_diag(14)), '7→' + string(left_diag(13)), '8→' + string(left_diag(12)), '9→' + string(left_diag(11)), '10→' + string(left_diag(10))};
secondary_diag_y = {'1→' + string(right_diag(1)), '2→' + string(right_diag(2)), '3→' + string(right_diag(3)), '4→' + string(right_diag(4)), '5→' + string(right_diag(5)), '6→' + string(right_diag(6)), '7→' + string(right_diag(7)), '8→' + string(right_diag(8)), '9→' + string(right_diag(9)), '10→' + string(right_diag(10))};
secondary_diag_x = {'1→' + string(right_diag(19)), '2→' + string(right_diag(18)), '3→' + string(right_diag(17)), '4→' + string(right_diag(16)), '5→' + string(right_diag(15)), '6→' + string(right_diag(14)), '7→' + string(right_diag(13)), '8→' + string(right_diag(12)), '9→' + string(right_diag(11)), '10→' + string(right_diag(10))};

f = figure;
p = uipanel('Parent',f,'BorderType','none'); 
p.Title = 'Measurements for Horizontal, Vertical, Diagonal & RECONSTRUCTION'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

subplot(2,2,1,'Parent',p) 
    h = heatmap(vertical_x_values,horizontal_y_values,init_letter);
    h.Title = 'Horizontal and Vertical';
    h.Colormap = gray;
    h.xlabel('column number->sum');
    h.ylabel('row number->sum');
title('Horizontal and Vertical Measurement') 

subplot(2,2,2,'Parent',p) 
    h2 = heatmap(primary_diag_x,primary_diag_y,init_letter);
    h2.Title = 'Lower Diagonal';
    h2.Colormap = gray;
    h2.xlabel('column number');
    h2.ylabel('row number');
    h2.ColorbarVisible = 'off';
    axp = struct(h2); % throws warning but it's not important
    axp.Axes.YAxisLocation = 'right';
title('Primary Diagonal (NW->SE) Measurement')

subplot(2,2,3,'Parent',p)
    h4 = heatmap(flip(secondary_diag_x),secondary_diag_y,init_letter);
    h4.Title = 'Upper Diagonal';
    h4.Colormap = gray;
    h4.xlabel('column number');
    h4.ylabel('row number');
    h4.ColorbarVisible = 'off';
    axp = struct(h4); % throws warning but it's not important
    axp.Axes.XAxisLocation = 'bottom';
    axp.Axes.YAxisLocation = 'left';
title('Secondary Diagonal (NE->SW) Measurement')

subplot(2,2,4,'Parent',p)
    h3 = heatmap(1:10,1:10,reconstruction_matrix);
    h3.Title = 'Reconstructed through Additive ART';
    h3.Colormap = gray;
    h3.xlabel('column number');
    h3.ylabel('row number');
    h3.ColorbarVisible = 'off';
title('Reconstructed through Additive ART')
