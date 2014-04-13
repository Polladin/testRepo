function [ dataNum ] = get_randomly_data( pheromone_table )

    pheromone_table = pheromone_table ./ sum(pheromone_table(:));
    ph_summ = 0;
    dataNum = -1;
    
    rand_number = rand();
    
    for i = 1:length(pheromone_table)
        ph_summ = ph_summ + pheromone_table(i);
        if rand_number <= ph_summ
            dataNum = i;
            break;
        end
    end

end

