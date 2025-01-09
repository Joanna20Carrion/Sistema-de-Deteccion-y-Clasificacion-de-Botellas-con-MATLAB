clear all;
close all;
clc;

% Configuración de la cámara web y resolución
vid = videoinput('winvideo', 1, 'MJPG_1920x1080'); % Iniciar cámara
src = getselectedsource(vid); % Obtener fuente de video

% Previsualización y captura de la imagen
preview(vid);
pause(5);               % Espera para estabilizar la imagen
I = getsnapshot(vid);   % Captura la imagen
closepreview(vid);      % Cierra la previsualización de la cámara

% Oscurecer la imagen ajustando la intensidad
I = I * 0.9; % Reducir la luminosidad de la imagen

% Visualizar la imagen oscurecida
figure(1);
imshow(uint8(I));
title('Imagen Oscurecida');
impixelinfo;

% Recortar la imagen para enfocar en el área central (ajusta las coordenadas según necesites)
x = 480;        % Coordenada x del recorte inicial
y = 0;         % Coordenada y del recorte inicial
width = 880;   % Ancho del recorte
height = 650;   % Altura del recorte

I = imcrop(I, [x y width height]);

% Visualizar la imagen recortada
figure(2);
imshow(uint8(I));
title('Imagen Recortada');
impixelinfo;

%% --- Detección de tapas de colores (rojo/verde/azul/amarillo) ---

% Umbrales de color para cada tapa
% Ajuste de los umbrales basado en observación de impixelinfo
red_mask = (I(:,:,1) > 148 & I(:,:,1) < 225) & ... 
           (I(:,:,2) > 34 & I(:,:,2) < 67) & ...
           (I(:,:,3) > 44 & I(:,:,3) < 98);

green_mask = (I(:,:,1) > 4 & I(:,:,1) < 102) & ... 
             (I(:,:,2) > 84 & I(:,:,2) < 155) & ...
             (I(:,:,3) > 49 & I(:,:,3) < 98);

blue_mask = (I(:,:,1) > 10 & I(:,:,1) < 79) & ... 
            (I(:,:,2) > 35 & I(:,:,2) < 60) & ...
            (I(:,:,3) > 98 & I(:,:,3) < 160);

yellow_mask = (I(:,:,1) > 151 & I(:,:,1) < 211) & ... 
              (I(:,:,2) > 130 & I(:,:,2) < 196) & ...
              (I(:,:,3) > 37 & I(:,:,3) < 115);

%% --- Detección de líquidos de colores (naranja/celeste/marrón/negro) ---
orange_mask = (I(:,:,1) > 156 & I(:,:,1) < 219) & ... 
              (I(:,:,2) > 48 & I(:,:,2) < 101) & ...
              (I(:,:,3) > -1 & I(:,:,3) < 41);

sky_mask = (I(:,:,1) > -1 & I(:,:,1) < 32) & ... 
           (I(:,:,2) > 74 & I(:,:,2) < 120) & ... 
           (I(:,:,3) > 134 & I(:,:,3) < 197);

brown_mask = (I(:,:,1) > 69 & I(:,:,1) < 123) & ... 
             (I(:,:,2) > 49 & I(:,:,2) < 88) & ... 
             (I(:,:,3) > -1 & I(:,:,3) < 59);

black_mask = (I(:,:,1) > -1 & I(:,:,1) < 24) & ... 
             (I(:,:,2) > 10 & I(:,:,2) < 38) & ... 
             (I(:,:,3) > 14 & I(:,:,3) < 59);

%% Mostrar máscaras individuales para cada color
figure(3);
imshow(red_mask);
title('Máscara Roja');

figure(4);
imshow(green_mask);
title('Máscara Verde');

figure(5);
imshow(blue_mask);
title('Máscara Azul');

figure(6);
imshow(yellow_mask);
title('Máscara Amarilla');

figure(7);
imshow(orange_mask);
title('Máscara Naranja');

figure(8);
imshow(sky_mask);
title('Máscara Celeste');

figure(9);
imshow(brown_mask);
title('Máscara Marrón');

figure(10);
imshow(black_mask);
title('Máscara Negra');

%% Operación de cierre morfológico para eliminar agujeros
se = strel('disk', 7);                          % Estructura de elemento con un disco de radio
red_mask_cleaned = imclose(red_mask, se);       % Cierre morfológico para rojo
green_mask_cleaned = imclose(green_mask, se);   % Cierre morfológico para verde
blue_mask_cleaned = imclose(blue_mask, se);     % Cierre morfológico para azul
yellow_mask_cleaned = imclose(yellow_mask, se); % Cierre morfológico para amarillo
orange_mask_cleaned = imclose(orange_mask, se); % Cierre morfológico para naranja
sky_mask_cleaned = imclose(sky_mask, se);       % Cierre morfológico para celeste
brown_mask_cleaned = imclose(brown_mask, se);   % Cierre morfológico para marrón
black_mask_cleaned = imclose(black_mask, se);   % Cierre morfológico para negro

% Mostrar la máscara roja después de operación de cierre morfológico
figure(11);
imshow(red_mask_cleaned);
title('Máscara Roja con cierre morfológico');

% Mostrar la máscara verde después de operación de cierre morfológico
figure(12);
imshow(green_mask_cleaned);
title('Máscara Verde con cierre morfológico');

% Mostrar la máscara azul después de operación de cierre morfológico
figure(13);
imshow(blue_mask_cleaned);
title('Máscara Azul con cierre morfológico');

% Mostrar la máscara amarilla después de operación de cierre morfológico
figure(14);
imshow(yellow_mask_cleaned);
title('Máscara Amarilla con cierre morfológico');

% Mostrar la máscara naranja después de operación de cierre morfológico
figure(15);
imshow(orange_mask_cleaned);
title('Máscara Naranja con cierre morfológico');

% Mostrar la máscara celeste después de operación de cierre morfológico
figure(16);
imshow(sky_mask_cleaned);
title('Máscara Celeste con cierre morfológico');

% Mostrar la máscara marrón después de operación de cierre morfológico
figure(17);
imshow(brown_mask_cleaned);
title('Máscara Marrón con cierre morfológico');

% Mostrar la máscara negra después de operación de cierre morfológico
figure(18);
imshow(black_mask_cleaned);
title('Máscara Negra con cierre morfológico');

%% Llenado de agujeros en las máscaras de color
red_mask_cleaned = imfill(red_mask_cleaned, 'holes');       % Llenar agujeros en máscara roja
green_mask_cleaned = imfill(green_mask_cleaned, 'holes');   % Llenar agujeros en máscara verde
blue_mask_cleaned = imfill(blue_mask_cleaned, 'holes');     % Llenar agujeros en máscara azul
yellow_mask_cleaned = imfill(yellow_mask_cleaned, 'holes'); % Llenar agujeros en máscara amarilla
orange_mask_cleaned = imfill(orange_mask_cleaned, 'holes'); % Llenar agujeros en máscara naranja
sky_mask_cleaned = imfill(sky_mask_cleaned, 'holes');       % Llenar agujeros en máscara celeste
brown_mask_cleaned = imfill(brown_mask_cleaned, 'holes');   % Llenar agujeros en máscara marrón
black_mask_cleaned = imfill(black_mask_cleaned, 'holes');   % Llenar agujeros en máscara negra

% Mostrar la máscara roja después de llenado de agujeros
figure(19);
imshow(red_mask_cleaned);
title('Máscara Roja con llenado de agujeros');

% Mostrar la máscara verde después de llenado de agujeros
figure(20);
imshow(green_mask_cleaned);
title('Máscara Verde con llenado de agujeros');

% Mostrar la máscara azul después de llenado de agujeros
figure(21);
imshow(blue_mask_cleaned);
title('Máscara Azul con llenado de agujeros');

% Mostrar la máscara amarilla después de llenado de agujeros
figure(22);
imshow(yellow_mask_cleaned);
title('Máscara Amarilla con llenado de agujeros');

% Mostrar la máscara naranja después de llenado de agujeros
figure(23);
imshow(orange_mask_cleaned);
title('Máscara Naranja con llenado de agujeros');

% Mostrar la máscara celeste después de llenado de agujeros
figure(24);
imshow(sky_mask_cleaned);
title('Máscara Celeste con llenado de agujeros');

% Mostrar la máscara marrón después de llenado de agujeros
figure(25);
imshow(brown_mask_cleaned);
title('Máscara Marrón con llenado de agujeros');

% Mostrar la máscara negra después de llenado de agujeros
figure(26);
imshow(black_mask_cleaned);
title('Máscara Negra con llenado de agujeros');

%% Eliminación de pequeñas regiones de píxeles (ruido) en las máscaras
min_area = 250; % Tamaño mínimo de área en píxeles
red_mask_cleaned = bwareaopen(red_mask_cleaned, min_area);
green_mask_cleaned = bwareaopen(green_mask_cleaned, min_area);
blue_mask_cleaned = bwareaopen(blue_mask_cleaned, min_area);
yellow_mask_cleaned = bwareaopen(yellow_mask_cleaned, min_area);
orange_mask_cleaned = bwareaopen(orange_mask_cleaned, min_area);
sky_mask_cleaned = bwareaopen(sky_mask_cleaned, min_area);
brown_mask_cleaned = bwareaopen(brown_mask_cleaned, min_area);
black_mask_cleaned = bwareaopen(black_mask_cleaned, min_area);

% Mostrar la máscara roja después de la eliminación de pequeñas regiones de
% píxeles (ruido)
figure(27);
imshow(red_mask_cleaned);
title('Máscara Roja sin ruido');

% Mostrar la máscara verde después de la eliminación de pequeñas regiones de
% píxeles (ruido)
figure(28);
imshow(green_mask_cleaned);
title('Máscara Verde sin ruido');

% Mostrar la máscara azul después de la eliminación de pequeñas regiones de
% píxeles (ruido)
figure(29);
imshow(blue_mask_cleaned);
title('Máscara Azul sin ruido');

% Mostrar la máscara amarilla después de la eliminación de pequeñas regiones de
% píxeles (ruido)
figure(30);
imshow(yellow_mask_cleaned);
title('Máscara Amarilla sin ruido');

% Mostrar la máscara naranja después de la eliminación de pequeñas regiones de
% píxeles (ruido)
figure(31);
imshow(orange_mask_cleaned);
title('Máscara Naranja sin ruido');

% Mostrar la máscara celeste después de la eliminación de pequeñas regiones de
% píxeles (ruido)
figure(32);
imshow(sky_mask_cleaned);
title('Máscara Celeste sin ruido');

% Mostrar la máscara marrón después de la eliminación de pequeñas regiones de
% píxeles (ruido)
figure(33);
imshow(brown_mask_cleaned);
title('Máscara Marrón sin ruido');

% Mostrar la máscara negra después de la eliminación de pequeñas regiones de
% píxeles (ruido)
figure(34);
imshow(black_mask_cleaned);
title('Máscara Negra sin ruido');

% Detección de objetos en la máscara roja
[red_labels, red_num] = bwlabel(red_mask_cleaned);                      % Etiquetar objetos conectados en la máscara roja
red_props = regionprops(red_labels, 'BoundingBox', 'Centroid');         % Obtener propiedades

% Detección de objetos en la máscara verde
[green_labels, green_num] = bwlabel(green_mask_cleaned);                % Etiquetar objetos conectados en la máscara verde
green_props = regionprops(green_labels, 'BoundingBox', 'Centroid');     % Obtener propiedades

% Detección de objetos en la máscara azul
[blue_labels, blue_num] = bwlabel(blue_mask_cleaned);                   % Etiquetar objetos conectados en la máscara azul
blue_props = regionprops(blue_labels, 'BoundingBox', 'Centroid');       % Obtener propiedades

% Detección de objetos en la máscara amarilla
[yellow_labels, yellow_num] = bwlabel(yellow_mask_cleaned);             % Etiquetar objetos conectados en la máscara amarilla
yellow_props = regionprops(yellow_labels, 'BoundingBox', 'Centroid');   % Obtener propiedades

% Detección de objetos en la máscara naranja
[orange_labels, orange_num] = bwlabel(orange_mask_cleaned);             % Etiquetar objetos conectados en la máscara naranja
orange_props = regionprops(orange_labels, 'BoundingBox', 'Centroid');   % Obtener propiedades

% Detección de objetos en la máscara celeste
[sky_labels, sky_num] = bwlabel(sky_mask_cleaned);                      % Etiquetar objetos conectados en la máscara celeste
sky_props = regionprops(sky_labels, 'BoundingBox', 'Centroid');         % Obtener propiedades

% Detección de objetos en la máscara marrón
[brown_labels, brown_num] = bwlabel(brown_mask_cleaned);                % Etiquetar objetos conectados en la máscara marrón
brown_props = regionprops(brown_labels, 'BoundingBox', 'Centroid');     % Obtener propiedades

% Detección de objetos en la máscara negra
[black_labels, black_num] = bwlabel(black_mask_cleaned);                % Etiquetar objetos conectados en la máscara negra
black_props = regionprops(black_labels, 'BoundingBox', 'Centroid');     % Obtener propiedades

%% Mostrar la imagen original con los objetos detectados
figure(35);
imshow(I);
hold on;

% Inicializar lista para almacenar todas las propiedades con IDs
all_ids = [];
id_counter = 1;

% Lista de colores y sus propiedades correspondientes
props_list = {red_props, green_props, blue_props, yellow_props};
color_names = ["Rojo", "Verde", "Azul", "Amarillo"];
color_edges = ['r', 'g', 'b', 'y'];

% Inicializar contadores por color
red_count = 0;
green_count = 0;
blue_count = 0;
yellow_count = 0;

% Mostrar detecciones y medir altura - Relación píxeles a centímetros
f1_pixels_to_cm = 0.0374; % Fila 1
f2_pixels_to_cm = 0.0542; % Fila 2

%% Inicializar lista de IDs con líquidos detectados
ids_with_liquid = []; 

% Verificar alineación de líquidos con IDs existentes
liquids_masks = {orange_props, sky_props, brown_props, black_props};
liquids_names = ["Naranja", "Celeste", "Marrón", "Negro"];

%% Procesar cada conjunto de propiedades por color
for color_idx = 1:length(props_list)
    props = props_list{color_idx};
    color_count = 0;

    for k = 1:length(props)
        y_min = props(k).BoundingBox(2);
        size_label = 'Pequeña';
        row_label = 'Fila 2';

        % Clasificación por tamaño y fila
        if y_min < 200
            size_label = 'Grande';
            if y_min < 100
                row_label = 'Fila 1';
            end
        elseif y_min < 240
            row_label = 'Fila 1';
        end

        % Dibujar cuadro y etiquetar el ID
        rectangle('Position', props(k).BoundingBox, 'EdgeColor', color_edges(color_idx), 'LineWidth', 2);
        centroid = props(k).Centroid;
        text(centroid(1), centroid(2) - 33, sprintf('ID: %d', id_counter), 'Color', 'b', 'FontSize', 14, 'FontWeight', 'bold');

        % Almacenar ID, color y centroide
        all_ids = [all_ids; struct('ID', id_counter, 'Color', color_names(color_idx), 'Centroid', centroid, 'Size', size_label, 'Row', row_label)];

        % Imprimir información en el Command Window
        %fprintf('ID: %d | Color tapa: %s | Tamaño: %s | Fila: %s\n', id_counter, color_names(color_idx), size_label, row_label);

        % Incrementar contadores
        id_counter = id_counter + 1;
        color_count = color_count + 1;
    end

    % Actualizar conteos por color
    switch color_idx
        case 1, red_count = color_count;
        case 2, green_count = color_count;
        case 3, blue_count = color_count;
        case 4, yellow_count = color_count;
    end
end

%% Verificar alineación de máscaras naranjas con IDs existentes
for i = 1:length(orange_props)
    orange_centroid = orange_props(i).Centroid;
    orange_bbox = orange_props(i).BoundingBox; 

    % Altura en píxeles y conversión a centímetros
    altura_pixels = orange_bbox(4);

    % Dibujar el centroide
    plot(orange_centroid(1), orange_centroid(2), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [1, 0.5, 0]);
    text(orange_centroid(1) + 10, orange_centroid(2), 'Naranja', 'Color', [1, 0.5, 0], 'FontSize', 10, 'FontWeight', 'bold');

    % Verificar alineación en el eje X con otras máscaras
    aligned_ids = [];
    for j = 1:length(all_ids)
        if abs(all_ids(j).Centroid(1) - orange_centroid(1)) < 20
            aligned_ids = [aligned_ids; all_ids(j)];
        end
    end

    % Si hay elementos alineados, realizar cálculo de altura
    if ~isempty(aligned_ids)
        % Iterar sobre los IDs alineados
        for k = 1:length(aligned_ids)
            % Verificar que Row sea una cadena y realizar la comparación
            if isfield(aligned_ids(k), 'Row') && (ischar(aligned_ids(k).Row) || isstring(aligned_ids(k).Row))
                if strcmp(aligned_ids(k).Row, 'Fila 1') % Si está en Fila 1
                    altura_cm = altura_pixels * f1_pixels_to_cm;
                elseif strcmp(aligned_ids(k).Row, 'Fila 2') % Si está en Fila 2
                    altura_cm = altura_pixels * f2_pixels_to_cm;
                else
                    % Si no es 'Fila 1' ni 'Fila 2'
                    altura_cm = NaN; % Asignar NaN o alguna otra acción
                    disp('Fila no reconocida');
                end

                % Imprimir los resultados
                fprintf('ID: %d | Color tapa: %s | Tamaño: %s | Fila: %s | Altura: %.2f cm | Líquido: Naranja\n', ...
                    aligned_ids(k).ID, aligned_ids(k).Color, aligned_ids(k).Size, aligned_ids(k).Row, altura_cm);
            else
                % Manejo del caso cuando no se encuentra el campo 'Row' o es inválido
                disp('No se encuentra la fila en el objeto alineado.');
            end
        end
    else
        fprintf('La detección naranja no está alineada con ninguna máscara.\n');
    end
end

%% Verificar alineación de máscaras celestes con IDs existentes
for i = 1:length(sky_props)
    sky_centroid = sky_props(i).Centroid;
    sky_bbox = sky_props(i).BoundingBox;

    % Altura en píxeles y conversión a centímetros
    altura_pixels = sky_bbox(4);

    % Dibujar el centroide
    plot(sky_centroid(1), sky_centroid(2), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [1, 0.5, 0]);
    text(sky_centroid(1) + 10, sky_centroid(2), 'Celeste', 'Color', [1, 0.5, 0], 'FontSize', 10, 'FontWeight', 'bold');

    % Verificar alineación en el eje X con otras máscaras
    aligned_ids = [];
    for j = 1:length(all_ids)
        if abs(all_ids(j).Centroid(1) - sky_centroid(1)) < 20
            aligned_ids = [aligned_ids; all_ids(j)];
        end
    end

    % Si hay elementos alineados, realizar cálculo de altura
    if ~isempty(aligned_ids)
        % Iterar sobre los IDs alineados
        for k = 1:length(aligned_ids)
            % Verificar que Row sea una cadena y realizar la comparación
            if isfield(aligned_ids(k), 'Row') && (ischar(aligned_ids(k).Row) || isstring(aligned_ids(k).Row))
                if strcmp(aligned_ids(k).Row, 'Fila 1') % Si está en Fila 1
                    altura_cm = altura_pixels * f1_pixels_to_cm;
                elseif strcmp(aligned_ids(k).Row, 'Fila 2') % Si está en Fila 2
                    altura_cm = altura_pixels * f2_pixels_to_cm;
                else
                    % Si no es 'Fila 1' ni 'Fila 2'
                    altura_cm = NaN; % Asignar NaN o alguna otra acción
                    disp('Fila no reconocida');
                end

                % Imprimir los resultados
                fprintf('ID: %d | Color tapa: %s | Tamaño: %s | Fila: %s | Altura: %.2f cm | Líquido: Celeste\n', ...
                    aligned_ids(k).ID, aligned_ids(k).Color, aligned_ids(k).Size, aligned_ids(k).Row, altura_cm);
            else
                % Manejo del caso cuando no se encuentra el campo 'Row' o es inválido
                disp('No se encuentra la fila en el objeto alineado.');
            end
        end
    else
        fprintf('La detección celeste no está alineada con ninguna máscara.\n');
    end
end

%% Verificar alineación de máscaras marrón con IDs existentes
for i = 1:length(brown_props)
    brown_centroid = brown_props(i).Centroid;
    brown_bbox = brown_props(i).BoundingBox;

    % Altura en píxeles y conversión a centímetros
    altura_pixels = brown_bbox(4);

    % Dibujar el centroide
    plot(brown_centroid(1), brown_centroid(2), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [1, 0.5, 0]);
    text(brown_centroid(1) + 10, brown_centroid(2), 'Marrón', 'Color', [1, 0.5, 0], 'FontSize', 10, 'FontWeight', 'bold');

    % Verificar alineación en el eje X con otras máscaras
    aligned_ids = [];
    for j = 1:length(all_ids)
        if abs(all_ids(j).Centroid(1) - brown_centroid(1)) < 20
            aligned_ids = [aligned_ids; all_ids(j)];
        end
    end

    % Si hay elementos alineados, realizar cálculo de altura
    if ~isempty(aligned_ids)
        % Iterar sobre los IDs alineados
        for k = 1:length(aligned_ids)
            % Verificar que Row sea una cadena y realizar la comparación
            if isfield(aligned_ids(k), 'Row') && (ischar(aligned_ids(k).Row) || isstring(aligned_ids(k).Row))
                if strcmp(aligned_ids(k).Row, 'Fila 1') % Si está en Fila 1
                    altura_cm = altura_pixels * f1_pixels_to_cm;
                elseif strcmp(aligned_ids(k).Row, 'Fila 2') % Si está en Fila 2
                    altura_cm = altura_pixels * f2_pixels_to_cm;
                else
                    % Si no es 'Fila 1' ni 'Fila 2'
                    altura_cm = NaN; % Asignar NaN o alguna otra acción
                    disp('Fila no reconocida');
                end

                % Imprimir los resultados
                fprintf('ID: %d | Color tapa: %s | Tamaño: %s | Fila: %s | Altura: %.2f cm | Líquido: Marrón\n', ...
                    aligned_ids(k).ID, aligned_ids(k).Color, aligned_ids(k).Size, aligned_ids(k).Row, altura_cm);
            else
                % Manejo del caso cuando no se encuentra el campo 'Row' o es inválido
                disp('No se encuentra la fila en el objeto alineado.');
            end
        end
    else
        fprintf('La detección marrón no está alineada con ninguna máscara.\n');
    end
end

%% Verificar alineación de máscaras negras con IDs existentes
for i = 1:length(black_props)
    black_centroid = black_props(i).Centroid;
    black_bbox = black_props(i).BoundingBox; 

    % Altura en píxeles y conversión a centímetros
    altura_pixels = black_bbox(4);

    % Dibujar el centroide
    plot(black_centroid(1), black_centroid(2), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [1, 0.5, 0]);
    text(black_centroid(1) + 10, black_centroid(2), 'Negra', 'Color', [1, 0.5, 0], 'FontSize', 10, 'FontWeight', 'bold');

    % Verificar alineación en el eje X con otras máscaras
    aligned_ids = [];
    for j = 1:length(all_ids)
        if abs(all_ids(j).Centroid(1) - black_centroid(1)) < 20
            aligned_ids = [aligned_ids; all_ids(j)];
        end
    end

    % Si hay elementos alineados, realizar cálculo de altura
    if ~isempty(aligned_ids)
        % Iterar sobre los IDs alineados
        for k = 1:length(aligned_ids)
            % Verificar que Row sea una cadena y realizar la comparación
            if isfield(aligned_ids(k), 'Row') && (ischar(aligned_ids(k).Row) || isstring(aligned_ids(k).Row))
                if strcmp(aligned_ids(k).Row, 'Fila 1') % Si está en Fila 1
                    altura_cm = altura_pixels * f1_pixels_to_cm;
                elseif strcmp(aligned_ids(k).Row, 'Fila 2') % Si está en Fila 2
                    altura_cm = altura_pixels * f2_pixels_to_cm;
                else
                    % Si no es 'Fila 1' ni 'Fila 2'
                    altura_cm = NaN; % Asignar NaN o alguna otra acción
                    disp('Fila no reconocida');
                end

                % Imprimir los resultados
                fprintf('ID: %d | Color tapa: %s | Tamaño: %s | Fila: %s | Altura: %.2f cm | Líquido: Negro\n', ...
                    aligned_ids(k).ID, aligned_ids(k).Color, aligned_ids(k).Size, aligned_ids(k).Row, altura_cm);
            else
                % Manejo del caso cuando no se encuentra el campo 'Row' o es inválido
                disp('No se encuentra la fila en el objeto alineado.');
            end
        end
    else
        fprintf('La detección negra no está alineada con ninguna máscara.\n');
    end
end

%% Verificar otros casos
for liquid_idx = 1:length(liquids_masks)
    liquid_props = liquids_masks{liquid_idx};
    liquid_name = liquids_names(liquid_idx);

    for i = 1:length(liquid_props)
        liquid_centroid = liquid_props(i).Centroid;

        % Verificar alineación en el eje X con las tapas detectadas
        aligned_ids = [];
        for j = 1:length(all_ids)
            if abs(all_ids(j).Centroid(1) - liquid_centroid(1)) < 20
                aligned_ids = [aligned_ids; all_ids(j)];
            end
        end

        % Agregar las IDs alineadas a la lista de IDs con líquidos
        for k = 1:length(aligned_ids)
            ids_with_liquid = [ids_with_liquid; aligned_ids(k).ID];
        end
    end
end

% Eliminar duplicados de la lista de IDs con líquidos
ids_with_liquid = unique(ids_with_liquid);

% Determinar IDs sin líquidos
ids_without_liquid = setdiff([all_ids.ID], ids_with_liquid);

% Imprimir detalles de las IDs que no tienen líquido detectado
if isempty(ids_without_liquid)
else
    for i = 1:length(ids_without_liquid)
        % Buscar los detalles en la estructura all_ids
        id_info = all_ids([all_ids.ID] == ids_without_liquid(i));
        fprintf('ID: %d | Color tapa: %s | Tamaño: %s | Fila: %s\n', ...
            id_info.ID, id_info.Color, id_info.Size, id_info.Row);
    end
end

%% Imprimir el total de detecciones por color
fprintf('Total Rojo: %d\n', red_count);
fprintf('Total Verde: %d\n', green_count);
fprintf('Total Azul: %d\n', blue_count);
fprintf('Total Amarillo: %d\n', yellow_count);

hold off;

%% Apagar la cámara
delete(vid);
