function answer = chech_validate_clustering( weights, num_clusters )

    answer = 1;
    num_samples_in_cluster = length(weights) / num_clusters;
    for i = 1:num_clusters
        for j = 1:num_samples_in_cluster - 1
            if weights( (i-1)*num_samples_in_cluster + j, :) ~= weights( (i-1)*num_samples_in_cluster + j+1, :)
                answer = 0;
                break;
            end
        end
        if answer == 0
            break;
        end
    end

end

