function weigths_out = change_cluster_for_further_v2( weights, mean_cluster, Xin, num_samples_with_further_distance )
    
    X = Xin(num_samples_with_further_distance,:);
    
    f_min = 10^10;
    num_cluster_shortest_distance = -1;
    for i = 1:length( mean_cluster(:,1) )
        f = 0;
        
        for j = 1:length( mean_cluster(i,:) )
            f = f + ( X(j)-mean_cluster(i,j) )^2;
        end
        
        if f < f_min
            f_min = f;
            num_cluster_shortest_distance = i;
        end
    end
    weights(num_samples_with_further_distance,:) = 0;
    weights(num_samples_with_further_distance,num_cluster_shortest_distance) = 1;
    weigths_out = weights;

end

