function [ weights ] = getProbablyWeights( probably )

    weights = zeros( 1, length(probably) );
    rand_number = rand();
    prob_sum = 0;
    
    for i = 1:length( probably )     
        prob_sum = prob_sum + probably(i);
        
        if rand_number <= prob_sum
            weights(i) = 1;
            break;
        end
    end
    
end

