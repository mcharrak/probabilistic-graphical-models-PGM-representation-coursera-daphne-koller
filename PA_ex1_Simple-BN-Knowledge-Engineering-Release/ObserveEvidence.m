% ObserveEvidence Modify a vector of factors given some evidence.
%   F = ObserveEvidence(F, E) sets all entries in the vector of factors, F,
%   that are not consistent with the evidence, E, to zero. F is a vector of
%   factors, each a data structure with the following fields:
%     .var    Vector of variables in the factor, e.g. [1 2 3]
%     .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%     .val    Value table of size prod(.card)
%   E is an N-by-2 matrix, where each row consists of a variable/value pair. 
%     Variables are in the first column and values are in the second column.

function F = ObserveEvidence(F, E)

% Iterate through all evidence

for i = 1:size(E, 1),
    % for each observed evidence
    % fetch variable
    v = E(i, 1); % variable
    % fetch assigned value
    x = E(i, 2); % value

    % Check validity of evidence
    % evidence value x must be between 1 and cardinality of v
    if (x == 0),
        warning(['Evidence not set for variable ', int2str(v)]);
        continue;
    end;

    % now we iterate through F (here F = FACTORS.INPUT, therefore it
    % contains several factors (i.e. tables)
    for j = 1:length(F),
		  % Does factor contain variable?
        
        % indx denotes the column in our prob. column for which .var = v
        indx = find(F(j).var == v);

        if (~isempty(indx)),
        
		  	   % Check validity of evidence
               % the evidence x cannot be larger than the cardinality of
               % the variable and the evidence x cannot be smaller than 0
            if (x > F(j).card(indx) || x < 0 ),
                error(['Invalid evidence, X_', int2str(v), ' = ', int2str(x)]);
            end;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % YOUR CODE HERE
            % Adjust the factor F(j) to account for observed evidence
            % Hint: You might find it helpful to use IndexToAssignment
            %       and SetValueOfAssignment
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % fetch table of assigned values
            assignments = IndexToAssignment(1:prod(F(j).card),F(j).card);
            
            % fetch column of assigned values for var v via col idx indx
            assignments_col = assignments(:,indx);
            
            % find indices of rows where assigned values are equal to evidence x
            rows_to_remove = find(assignments_col ~= x);
            
            % fetch relevant assignments to update due to evidence
            update_assignments = assignments(rows_to_remove,:);
            
            % set evidence rows values(i.e. probs) to zero
            F(j) = SetValueOfAssignment(F(j),update_assignments,0);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

				% Check validity of evidence / resulting factor
            if (all(F(j).val == 0)),
                warning(['Factor ', int2str(j), ' makes variable assignment impossible']);
            end;

        end;
    end;
end;

end
