import scanpy as sc
import os
from pathlib import Path

from pyhere import here
import session_info

#   Use 'here' to define the output path relative to the project's top-level
#   directory. This is automatically inferred to be the git repo, since 'here'
#   will find the '.git' directory at the root.
genes_path = here('rstats_pyhere', 'data', 'mito_genes.txt')

#   Ensure the parent directory exists to write to output file
Path(os.path.dirname(genes_path)).mkdir(exist_ok=True)

#   Load one sample of a public dataset
adata_vis = sc.datasets.visium_sge(sample_id="V1_Human_Lymph_Node")

#   Form a list of Ensembl IDs for mitochondrial genes
a = [gene for gene in adata_vis.var_names if gene.startswith('MT-')]
b = adata_vis.var['gene_ids'].loc[a].tolist()

#   Write to plaintext with one gene ID per line
with open(genes_path, 'w') as f:
    f.writelines('\n'.join(b) + '\n')

#   Print imported modules and versions
session_info.show(html = False)
