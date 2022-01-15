% Gene data

    % These are some of the reasons why a gene would be 
    % hard to edit. 

    -editable(Gene) :- many_copies(Gene). 
    % Many gene copies make a gene uneconomical to edit.
    -editable(Gene) :- essential_gene(Gene).
     % Essential genes are dangerous to edit.

    % These are the facts relating to the editability of a certain gene.

    essential_gene(gene1).
    many_copies(gene3).
    editable(gene4).

    % Note that some genes are not defined as editable because
    % Negation as Failure (NAF) is used where if the 
    % information is not available, it is assumed to be editable,
    % which simulates the common sense reasoning that humans use.

    % Facts about the relationships between genes.
    decreases(gene2, gene1).
    decreases(gene5, gene3).
    decreases(gene4, gene3).
    decreases(gene3, gene2).

    increases(gene1, gene3).
    increases(gene4, gene2).
    increases(gene3, gene1).
    increases(gene6, gene5).

    % These genetic diseases really exist, and are caused by either overactive or underactive genes,  
    % according to what is listed in the table below.

    causes(gene1, sickle_cell_anemia, underactive).
    causes(gene2, thalassemia ,underactive).
    causes(gene3, down_syndrome, overactive).
    causes(gene4, cystic_fibrosis, underactive).
    causes(gene5, huntingtons_disease, overactive).
    causes(gene6, poland_anomaly, underactive).

% Drug data

    % Facts about the relationships between genes and drugs.
decreases(drug1, gene2).
    decreases(drug2, gene3).
    decreases(drug3, gene4).

    increases(drug1, gene3).
    increases(drug4, gene2).
    increases(drug3, gene1).

% Disease data
 
    % Symptoms related to diseases
    creates(sickle_cell_anemia, vision_problems).
    creates(sickle_cell_anemia, growth_delay).

    creates(thalassemia, fatigue).
    creates(thalassemia, growth_delay).

    creates(down_syndrome, learning_disabilities).
    creates(down_syndrome, facial_abnormality).

    creates(cystic_fibrosis, breathing_difficulty).
    creates(cystic_fibrosis, infections).

    creates(huntingtons_disease, vision_problems).
    creates(huntingtons_disease, fatigue).

    creates(poland_anomaly, chest_abnormalities).
    creates(poland_anomaly, breathing_difficulty).


% Aggresive definitions where if we do not have the information, we assume it to be true
    editable(Gene) :- not -editable(Gene).
    -may_treat(Drug, Disease) :- not may_treat(Drug, Disease).

% Recursive decreasing rule for gene knowledge graph

    also_decreases(X, Y) :- decreases(X, Y). 
    % Base case for also_decreases, ensuring that all listed genes are editable
    also_decreases(X, Y) :- increases(X, Z), also_decreases(Z, Y). 
    % Finds all possible ways to decrease Y by increasing other genes that lead to the base case.

% Recursive increasing rule for gene knowledge graph

    also_increases(X, Y) :- increases(X, Y), not -editable(X). % Base case for also_increases, ensuring that all listed genes are editable
    also_increases(X, Y) :- increases(X, Z), not -editable(X), also_increases(Z, Y). % Finds all possible ways to increase Y by increasing other genes that lead to the base case.

% There are two cases to consider when determining if a Drug or Gene may treat a disease.
% First case: Decrease what is overactive
% Second case: Increase what is underactive
% The solutions are recursivily found by using the above rules.

    may_treat(DrugorGene, Disease) :- causes(Gene, Disease, overactive), also_decreases(DrugorGene, Gene).
    may_treat(DrugorGene, Disease) :- causes(Gene, Disease, underactive), also_increases(DrugorGene, Gene).
