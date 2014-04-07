function weigths_out = change_cluster_for_further( weights, pheromone, num_samples )
    ph = 0;
    
    
    for i = 1:length( weights(num_samples,:) )
        if weights(num_samples,i) == 0
            ph = ph + pheromone(num_samples,i);      
        end
    end
    
    pheromone(num_samples,:) = pheromone(num_samples,:) ./ ph;
    
    rand_number = rand();
    prob_sum = 0;
    for i = 1:length( weights(num_samples,:) )     
        if weights(num_samples,i) == 0
            prob_sum = prob_sum + pheromone(num_samples,i);

            if rand_number <= prob_sum
                weights(num_samples,:) = 0;
                weights(num_samples,i) = 1;
                break;
            end
        end
    end
    
    weigths_out = weights;
    
end

