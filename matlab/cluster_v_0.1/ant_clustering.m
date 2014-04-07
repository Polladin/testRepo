function [ pheromone, set_min, f_min, mean_min ] = ant_clustering( X, num_iterations, count_ants, init_pheromone, num_samples, num_clusters, dimention )
    ro = 0.0;
    coeff = 10;
    coeff_each = 0.1;
    alfa = 1;
    MAX_VAL = 10^10;
    unless_perm = 0;
    calc_new_mean = 0;
    
    %pheromone_ants = zeros( num_samples, num_clusters, count_ants );
    %pheromone_ants(:,:,:) = init_pheromone;
    weights_ants = zeros( num_samples, num_clusters, count_ants );
    mean_cluster_ants = zeros( num_clusters, dimention, count_ants );
    
    f_min = MAX_VAL;
    set_min = zeros( num_samples, num_clusters );
    pheromone_min = zeros( num_samples, num_clusters );
    mean_min = zeros( num_clusters, dimention );
    
    f = zeros( count_ants, 1 );
    pheromone = zeros( num_samples, num_clusters );
    pheromone(:,:) = init_pheromone;
    
    mean_cluster = zeros( num_clusters, dimention );
    weights = zeros( num_samples, num_clusters );

    for itaration = 1:num_iterations
        itaration;
        for ant = 1:count_ants
            
            %Initialization ant arrays
            %pheromone(:,:) = pheromone_ants(:,:,ant);
            weights(:,:) = weights_ants(:,:,ant);
            %End initialization ant arrays
            
            %Evalution of ant
            for i = 1:num_samples
                probably = pheromone(i,:) ./ sum( pheromone(i,:) );
                weights(i, :) = getProbablyWeights( probably );
            end
            %End evalution of ant
            
            %Calc mean for each clusters
            for i = 1:num_clusters
                for j = 1:dimention
                    mean_cluster(i,j) = 0;
                    
                    for k = 1:num_samples
                        mean_cluster(i,j) = mean_cluster(i,j) + weights(k,i)*X(k,j);
                    end
                    if sum( weights(:,i) ) > 0
                        mean_cluster(i,j) = mean_cluster(i,j) / sum( weights(:,i) );
                    end
                end
            end
            %End calc mean for each clusters
            
            %Calc optimization funtion
            f(ant) = 0;
            for i = 1:num_clusters
                for j = 1:num_samples
                    for k = 1:dimention
                        f(ant) = f(ant) + weights(j,i)*(X(j,k)-mean_cluster(i,k))^2;
                    end
                end
            end
            %End calc optimization function f  
            
            %Get further point and change cluster for it
            for i = 1:num_clusters
                further_point_not_valid_cluster = 1;
                num_of_samples_with_further_distance = 0;
                
              %  while further_point_not_valid_cluster == 1 & num_of_samples_with_further_distance ~= -1
%Bred ------------
                for ii = 1:num_samples    
                    num_of_samples_with_further_distance = -1;
                    max_distance = 0;
                    %{
                    for j = 1:num_samples
                        sample_distance_to_mean = 0;

                        if weights(j,i) > 0
                            for k = 1:dimention
                                sample_distance_to_mean =  sample_distance_to_mean + (X(j,k)-mean_cluster(i,k))^2;
                            end

                            if max_distance < sample_distance_to_mean
                                max_distance = sample_distance_to_mean;
                                num_of_samples_with_further_distance = j;
                            end
                        end

                    end
                    %}
%Bred -------------------
                    num_of_samples_with_further_distance = ii;
                    %if num_of_samples_with_further_distance ~= -1
                    weights_old = weights(num_of_samples_with_further_distance,:);
                    %weights = change_cluster_for_further( weights, pheromone, num_of_samples_with_further_distance );
                    weights = change_cluster_for_further_v2( weights, mean_cluster, X, num_of_samples_with_further_distance );

                    if( calc_new_mean )
                        f_new = 0;
                        for u = 1:num_clusters
                            for j = 1:num_samples
                                for k = 1:dimention
                                    f_new = f_new + weights(j,u)*(X(j,k)-mean_cluster(u,k))^2;
                                end
                            end
                        end

                        if f_new < f(ant)
                            f(ant) = f_new;
                            further_point_not_valid_cluster = 1;
                            for jj = 1:num_clusters
                                for j = 1:dimention
                                    mean_cluster(jj,j) = 0;

                                    for k = 1:num_samples
                                        mean_cluster(jj,j) = mean_cluster(jj,j) + weights(k,jj)*X(k,j);
                                    end
                                    if sum( weights(:,jj) ) > 0
                                        mean_cluster(jj,j) = mean_cluster(jj,j) / sum( weights(:,jj) );
                                    end
                                end
                            end
                        else
                            weights(num_of_samples_with_further_distance,:) = weights_old;
                            further_point_not_valid_cluster = 0;
                            unless_perm = unless_perm + 1;
                        end
                    end

                end
                
                if( ~calc_new_mean )
                    f_new = 0;
                    for u = 1:num_clusters
                        for j = 1:num_samples
                            for k = 1:dimention
                                f_new = f_new + weights(j,u)*(X(j,k)-mean_cluster(u,k))^2;
                            end
                        end
                    end
                    f(ant) = f_new;
                    for jj = 1:num_clusters
                        for j = 1:dimention
                            mean_cluster(jj,j) = 0;

                            for k = 1:num_samples
                                mean_cluster(jj,j) = mean_cluster(jj,j) + weights(k,jj)*X(k,j);
                            end
                            if sum( weights(:,jj) ) > 0
                                mean_cluster(jj,j) = mean_cluster(jj,j) / sum( weights(:,jj) );
                            end
                        end
                    end
                end
                
            end
            %End get further point and change cluster for it
            
            
            %Save pheromone and weights and mean for ant
            %pheromone_ants(:,:,ant) = pheromone(:,:);
            weights_ants(:,:,ant) = weights(:,:);
            mean_cluster_ants(:,:,ant) = mean_cluster(:,:);
            %End save pheromone and weights and mean for ant
            
            
            
%Evaluate pheramone for each ant            
            %Evolution pheromones
            for i = 1:num_samples
                for j = 1:num_clusters
                    %pheromone(i,j) = (1-ro)*pheromone(i,j);

                    if set_min(i,j) == 1  %if i sample assigned to j cluster
                        pheromone(i,j) = pheromone(i,j) + coeff_each*(1/f(ant))^alfa;
                    end
                end
            end            
%End evaluate pheramone for each ant          
            
        end % end ants
        
        %Find best set and save it
        for i = 1:count_ants
            if f_min > f(i)
                f_min = f(i);
                set_min = weights_ants(:,:,i);
                %pheromone_min = pheromone_ants(:,:,i);
                mean_min = mean_cluster_ants(:,:,i);
            end
        end
        %End find best set and save it
        
        %Evolution pheromones
        for i = 1:num_samples
            for j = 1:num_clusters
                pheromone(i,j) = (1-ro)*pheromone(i,j);

                if set_min(i,j) == 1  %if i sample assigned to j cluster
                    pheromone(i,j) = pheromone(i,j) + coeff*1/f_min;
                end
            end
        end 
        %End calc evolution pheromones

        
    end % end itarations
    
    unless_perm;
end

