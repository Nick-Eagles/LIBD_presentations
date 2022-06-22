library('spatialLIBD')
library('zellkonverter')
library('reticulate')
library('here')
library('basilisk')

out_path = here('data', 'spe.h5ad')
sample_id = '151507'

write_anndata = function(sce, out_path) {
    invisible(
        basiliskRun(
            fun = function(sce, filename) {
                library('zellkonverter')
                library('reticulate')
                
                # Convert SCE to AnnData:
                adata <- SCE2AnnData(sce)
                
                #  Write AnnData object to disk
                adata$write(filename = filename)
                
                return()
            },
            env = zellkonverterAnnDataEnv(),
            sce = sce,
            filename = out_path
        )
    )
}

#   Load the spatialLIBD SpatialExperiment and subset to one sample
spe = fetch_data(type = "spe")
spe = spe[, spe$sample_id == sample_id]

#   zellkonverter doesn't know how to convert the 'spatialCoords' slot. We'd
#   ultimately like the spatialCoords in the .obsm['spatial'] slot of the
#   resulting AnnData, which corresponds to reducedDims(spe)$spatial in R
reducedDims(spe)$spatial = spatialCoords(spe)

write_anndata(spe, out_path)
