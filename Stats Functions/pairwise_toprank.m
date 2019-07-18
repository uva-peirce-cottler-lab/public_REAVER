function output_ranks = pairwise_toprank( pairwise_sig )
%Input: Pairwise Statistical Test Results Array
%Output: A ranking vector v where v(i) is the rank of program i

	decisions_matrix = zeros( length(unique(pairwise_sig(:,1))) ) ;
	
	if ~isequal( logical(pairwise_sig(:,3)) , pairwise_sig(:,3) )
		pairwise_sig(:,3) = pairwise_sig(:,3) < 0.05 ;
	end
	
	test_output_matrix = sortrows(pairwise_sig) ;
	ind = sub2ind( size(decisions_matrix) , test_output_matrix(:,1) , test_output_matrix(:,2) ) ;
	decisions_matrix(ind) = test_output_matrix(:,3) ;
		
	[ num_wins , forward_index ] = sort( sum(decisions_matrix,2) , 'descend' ) ;
	[ ~ , reverse_index ] = sort( forward_index ) ;

	ranks = ones( 1 , numel(num_wins) ) ;
		
%% Ranking
	for i = 2:numel(num_wins)
		% Begin the ranking with program 2 as program 1 will have rank 1
		if num_wins(i) < num_wins(i-1)
			% If the i'th number of wins is strictly less than the wins of
			% i-1, i's rank is equal to i which is the number of programs
			% ranked before it +1
			ranks(i) = i ;
		else
			% If i and i-1 have equal wins, i is assigned the rank of i-1
			ranks(i) = ranks(i-1) ;
		end
	end

	output_ranks = ranks(reverse_index)' ;

end

