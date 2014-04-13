function [ enable ] = position_to_stick_enable( dataStick, position, grid, dataOnLattice )

    enable = 0;
    
    Xbase = dataOnLattice(dataStick,1);
    Ybase = dataOnLattice(dataStick,2);
    
    pos_maped = [ -1 1; 0 1; 1 1; -1 0; 0 0; 1 0; -1 -1; 0 -1; 1 -1];
    x = pos_maped( position, 1);
    y = pos_maped( position, 2);
        
    if( Xbase+x > 0 && Ybase+y > 0 && Xbase+x <= length(grid) && Ybase+y <= length(grid) )
        if grid(Xbase+x, Ybase+y) == 0
            enable = 1;
        end
    end      

end

