#!/bin/bash

# �]�w���|�P�ɮ�
filepath="PATH"
taxa="NAME.txt"

# Step 1: �p���l correlation �P�إ� permutation
python SparCC.py "${filepath}/${taxa}" -i 100 --cor_file="${filepath}/cor_sparcc.txt"
python MakeBootstraps.py "${filepath}/${taxa}" -n 100 -t permutation_#.txt -p "${filepath}/"

# Step 2: �]�C�� permutation �� correlation
for file in "${filepath}"/permutation_*.txt; do
    echo "Processing file: $file"

    index=$(basename "$file" .txt | awk -F_ '{print $NF}')
    cor_file="${filepath}/perm_cor_${index}.txt"

    python SparCC.py "$file" -i 100 --cor_file "$cor_file"
done

# Step 3: �p�� pseudo p-values
python PseudoPvals.py "${filepath}/cor_sparcc.txt" "${filepath}/perm_cor_#.txt" 100 \
    -o "${filepath}/pvals.two_sided.txt" -t two_sided

# Step 4: ��z��X
mkdir -p "${filepath}/${taxa}/pvals"
mv "${filepath}"/permutation_*.txt "${filepath}/pvals"
mv "${filepath}"/perm_cor_*.txt "${filepath}/pvals"
