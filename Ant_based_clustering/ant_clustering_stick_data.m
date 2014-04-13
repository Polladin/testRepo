function [ grid ] = ant_clustering_stick_data( iterations, clusteringData, grid_size )

    grid = zeros( grid_size ); % 2D grid
    neighbors_size = 1;
    max_positions_to_data_stick = 8;
    pos_maped = [ -1 1; 0 1; 1 1; -1 0; 0 0; 1 0; -1 -1; 0 -1; 1 -1];
    max_atempt = 4;
    
    amount_data = length( clusteringData(:,1) );
    dimention = length( clusteringData(1,:) );
    
    dataOnLattice = zeros( amount_data, dimention );
    bDataOnLattice = zeros( 1, amount_data );
    
    pheromone_table = zeros( amount_data, 1 );
    
    % Initial
    
    % randomly set position of data on grid 
    %ant_data = randperm( count_data );
    ant_location = randperm( grid_size * grid_size );
    
    %-------------- calc Distance Matrix ----------------------
    distanceMatrix = zeros( amount_data );
    for i = 1:amount_data
        for j = i+1:amount_data
            distanceMatrix(i,j) = sqrt( (clusteringData(i,1) - clusteringData(j,1))^2 + (clusteringData(i,2) - clusteringData(j,2))^2 );
            distanceMatrix(j,i) =  distanceMatrix(i,j);
        end
    end
    %-------------- end calc Distance Matrix ------------------
    
    %-------------- Put data ramdomly to grid ---------------------
    % only for dimention = 2 //TODO for all dimentions
    for dataNum = 1:amount_data
        dataOnLattice( dataNum, 1 ) = ceil( ant_location(dataNum) / grid_size );
        dataOnLattice( dataNum, 2 ) =  ceil( mod(ant_location(dataNum), grid_size) + 1 );
        grid( dataOnLattice(dataNum,1), dataOnLattice(dataNum,2) ) = dataNum;
        bDataOnLattice( dataNum ) = 1;
    end
    %-------------- end Put data ramdomly to grid ------------------
    
    %-------------- Calc pheromone table ----------------------
    for dataNum = 1:amount_data
        pheromone_table(dataNum) = get_evaluate_function( grid, dataOnLattice, dataNum, distanceMatrix, neighbors_size );
    end
    %-------------- end Calc pheromone table ------------------
    
    
    
    
    
    %------------------- Main Cycle -------------------------
    for iter = 1:iterations
        dataNum = get_randomly_data( pheromone_table );
        % Remove_data_from_grid
        curX = dataOnLattice( dataNum, 1 );
        curY = dataOnLattice( dataNum, 2 );
        grid( curX, curY ) = 0;
        
        bChange = 0;
        for attempt = 1:max_atempt
            % TODO to stick the data with probabylity, more probably to data with less value from pheromone_talbe 
            dataStick = randi( amount_data );
            if dataStick == dataNum
                continue;
            end
            
            min_func = -1;
            for position = 1:max_positions_to_data_stick  % 8 position around celll
                
                if position_to_stick_enable( dataStick, position, grid, dataOnLattice )
                    grid( dataOnLattice(dataStick,1) + pos_maped(position,1), ...
                          dataOnLattice(dataStick,2) + pos_maped(position,2) ) = dataNum;
                    dataOnLattice( dataNum, 1 ) = dataOnLattice(dataStick,1) + pos_maped(position,1);
                    dataOnLattice( dataNum, 2 ) = dataOnLattice(dataStick,2) + pos_maped(position,2);
        
                    evaluate_value = get_evaluate_function( grid, dataOnLattice, dataNum, distanceMatrix, neighbors_size );
                    
                    grid( dataOnLattice(dataStick,1) + pos_maped(position,1), ...
                          dataOnLattice(dataStick,2) + pos_maped(position,2) ) = 0;
                    
                    if min_func > evaluate_value
                        minX = dataOnLattice(dataStick,1) + pos_maped(position,1);
                        minY = dataOnLattice(dataStick,2) + pos_maped(position,2);
                        min_func = evaluate_value;
                    end
                end
            end
            
            if min_func ~= -1 && min_func < pheromone_table(dataNum)
                dataOnLattice( dataNum, 1 ) = minX;
                dataOnLattice( dataNum, 2 ) = minY;
                pheromone_table(dataNum) = min_func;
                grid( minX, minY ) = dataNum;
                
                bChange = 1;
                break;
            end
            
        end
        
        if ~bChange
            grid( curX, curY ) = dataNum;
            dataOnLattice( dataNum, 1 ) = curX;
            dataOnLattice( dataNum, 2 ) = curY;
        end
        
        
    end
    %------------------- end Main Cycle ----------------------
     
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    