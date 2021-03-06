function [ evaluate_value ] = get_evaluate_function( grid, dataOnLattice, dataNum, distanceMatrix, neighborSize )

    evaluate_value = 0;
    
    Xbase = dataOnLattice(dataNum,1);
    Ybase = dataOnLattice(dataNum,2);
    
    for x = -neighborSize : neighborSize
        for y = -neighborSize : neighborSize
            if( Xbase+x > 0 && Ybase+y > 0 && Xbase+x <= length(grid) && Ybase+y <= length(grid) )
                if( grid(Xbase+x, Ybase+y) ~= 0 && (x ~= 0 || y ~= 0) )
                    evaluate_value = evaluate_value + distanceMatrix( dataNum, grid(Xbase+x, Ybase+y) );
                end
            end
        end 
    end  
    
    if evaluate_value == 0 
        evaluate_value = 10^10;
    end

end

