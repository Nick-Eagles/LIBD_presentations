import scanpy as sc
import pyhere
from PIL import Image
import json
import numpy as np
import matplotlib.pyplot as plt

adata_path = pyhere.here('data', 'spe.h5ad')
json_path = pyhere.here('data', 'scalefactors_json.json')
hires_img_path = pyhere.here('data', 'tissue_hires_image.png')

sample_name = '151507'
spatial_coords_names = ['pxl_row_in_fullres', 'pxl_col_in_fullres']

###############################################################################
#   Read in the AnnData and add missing information (image and image-related
#   metadata, like scale factors)
###############################################################################

#   Read in the AnnData from disk
adata = sc.read(adata_path)

with open(json_path) as f: 
    json_data = json.load(f)

#   Store scalefactors in AnnData as scanpy/squidpy expects
adata.uns['spatial'] = {
    sample_name: {
        'scalefactors': json_data
    }
}

#   Read in the hires image for this sample. Note that our image is RGB with
#   values in [0, 255] (unsigned 8-bit integers), which we'd like to convert
#   to floating-point values in [0, 1]. The appropriate code should change for
#   different image formats!
img_arr = np.array(Image.open(hires_img_path), dtype = np.float32) / 255

#   Store in the AnnData in the expected format
adata.uns['spatial'][sample_name]['images'] = { 'hires': img_arr }

#   Finally, correct how spatialCoords are stored. Currently, they are a pandas
#   DataFrame, with the columns potentially in the wrong order (depending on the
#   version of SpatialExperiment used in R). We need them as a numpy array.
adata.obsm['spatial'] = np.array(
    adata.obsm['spatial'][spatial_coords_names]
)

###############################################################################
#   Explore the AnnData
###############################################################################

#   Plot pre-computed clusters over spatial grid
sc.pl.spatial(
    adata,
    color = 'Cluster',
    palette = 'viridis'
)

#   The above plot had a bad legend, as the 'Cluster' variable, which we think
#   of categorically, was actually stored as a continuous (int) variable. We
#   could've figured this out and fixed this earlier in R (made
#   colData(spe)$Cluster a factor prior to conversion), but we can also fix this
#   now in python.

adata.obs['Cluster']
# AAACAACGAATAGTTC-1    6
# AAACAAGTATCTCCCA-1    3
# AAACAATCTACTAGCA-1    2
# AAACACCAATAACTGC-1    5
# AAACAGCTTTCAGAAG-1    1
#                      ..
# TTGTTGTGTGTCAAGA-1    1
# TTGTTTCACATCCAGG-1    3
# TTGTTTCATTAGTCTA-1    6
# TTGTTTCCATACAACT-1    3
# TTGTTTGTGTAAATTC-1    2
# Name: Cluster, Length: 4226, dtype: int32

adata.obs['Cluster'] = adata.obs['Cluster'].astype('category')
adata.obs['Cluster']
# AAACAACGAATAGTTC-1    6
# AAACAAGTATCTCCCA-1    3
# AAACAATCTACTAGCA-1    2
# AAACACCAATAACTGC-1    5
# AAACAGCTTTCAGAAG-1    1
#                      ..
# TTGTTGTGTGTCAAGA-1    1
# TTGTTTCACATCCAGG-1    3
# TTGTTTCATTAGTCTA-1    6
# TTGTTTCCATACAACT-1    3
# TTGTTTGTGTAAATTC-1    2
# Name: Cluster, Length: 4226, dtype: category
# Categories (6, int64): [1, 2, 3, 4, 5, 6]

#   Re-plot
sc.pl.spatial(
    adata,
    color = 'Cluster',
    palette = 'viridis'
)

#   Also look at cell count distribution
sc.pl.spatial(
    adata,
    color = 'cell_count',
    palette = 'viridis'
)
