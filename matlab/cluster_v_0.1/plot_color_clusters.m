function  plot_color_clusters( weights, X, num_clusters )
    hold;
    
    for i = 1:length(X)
        for j = 1:num_clusters
            if weights(i,j) == 1
                if j == 1
                    plot( X(i,1), X(i,2), 'or' );
                elseif j == 2
                    plot( X(i,1), X(i,2), 'og' );
                elseif j == 3
                    plot( X(i,1), X(i,2), 'ok' );
                elseif j == 4
                    plot( X(i,1), X(i,2), 'oc' );
                elseif j == 5
                    plot( X(i,1), X(i,2), 'om' );
                else
                    plot( X(i,1), X(i,2), 'oy' );
                end
            end
        end
    end

end

