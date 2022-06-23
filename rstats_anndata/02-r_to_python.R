#   This script is intended to be run interactively. At JHPCE, one should load
#   the conda_R/devel module (at the time, R 4.1.2) prior to running this
#   script. Package versions used here can also be seen at the bottom of this
#   script in the session info.

library('spatialLIBD')
library('zellkonverter')
library('reticulate')
library('here')
library('basilisk')
library('sessioninfo')

out_path = here('rstats_anndata', 'data', 'spe.h5ad')
sample_id = '151507'

#   Given a SingleCellExperiment, convert to an AnnData and write to disk at the
#   path [out_path] (as an h5ad file)
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

session_info()
# ─ Session info ──────────────────────────────────────────────────────────────────────────────────────────────────
# setting  value
# version  R Under development (unstable) (2021-11-06 r81149)
# os       CentOS Linux 7 (Core)
# system   x86_64, linux-gnu
# ui       X11
# language (EN)
# collate  en_US.UTF-8
# ctype    en_US.UTF-8
# tz       US/Eastern
# date     2022-06-22
# pandoc   2.11.0.4 @ /jhpce/shared/jhpce/core/conda/miniconda3-4.6.14/envs/svnR-devel/bin/pandoc
# 
# ─ Packages ──────────────────────────────────────────────────────────────────────────────────────────────────────
# package                * version   date (UTC) lib source
# AnnotationDbi            1.58.0    2022-04-26 [2] Bioconductor
# AnnotationHub            3.4.0     2022-04-26 [2] Bioconductor
# assertthat               0.2.1     2019-03-21 [2] CRAN (R 4.1.0)
# attempt                  0.3.1     2020-05-03 [1] CRAN (R 4.2.0)
# basilisk               * 1.8.0     2022-04-26 [1] Bioconductor
# basilisk.utils           1.8.0     2022-04-26 [1] Bioconductor
# beachmat                 2.12.0    2022-04-26 [2] Bioconductor
# beeswarm                 0.4.0     2021-06-01 [2] CRAN (R 4.2.0)
# benchmarkme              1.0.7     2021-03-21 [1] CRAN (R 4.2.0)
# benchmarkmeData          1.0.4     2020-04-23 [1] CRAN (R 4.2.0)
# Biobase                * 2.56.0    2022-04-26 [2] Bioconductor
# BiocFileCache            2.4.0     2022-04-26 [2] Bioconductor
# BiocGenerics           * 0.42.0    2022-04-26 [2] Bioconductor
# BiocIO                   1.6.0     2022-04-26 [2] Bioconductor
# BiocManager              1.30.18   2022-05-18 [2] CRAN (R 4.2.0)
# BiocNeighbors            1.14.0    2022-04-26 [2] Bioconductor
# BiocParallel             1.30.3    2022-06-05 [2] Bioconductor
# BiocSingular             1.12.0    2022-04-26 [2] Bioconductor
# BiocVersion              3.15.2    2022-03-29 [2] Bioconductor
# Biostrings               2.64.0    2022-04-26 [2] Bioconductor
# bit                      4.0.4     2020-08-04 [2] CRAN (R 4.1.0)
# bit64                    4.0.5     2020-08-30 [2] CRAN (R 4.1.0)
# bitops                   1.0-7     2021-04-24 [2] CRAN (R 4.2.0)
# blob                     1.2.3     2022-04-10 [2] CRAN (R 4.2.0)
# brio                     1.1.3     2021-11-30 [2] CRAN (R 4.2.0)
# bslib                    0.3.1     2021-10-06 [2] CRAN (R 4.2.0)
# cachem                   1.0.6     2021-08-19 [2] CRAN (R 4.2.0)
# cli                      3.3.0     2022-04-25 [2] CRAN (R 4.2.0)
# codetools                0.2-18    2020-11-04 [3] CRAN (R 4.2.0)
# colorspace               2.0-3     2022-02-21 [2] CRAN (R 4.2.0)
# config                   0.3.1     2020-12-17 [1] CRAN (R 4.2.0)
# cowplot                  1.1.1     2020-12-30 [2] CRAN (R 4.2.0)
# crayon                   1.5.1     2022-03-26 [2] CRAN (R 4.2.0)
# curl                     4.3.2     2021-06-23 [2] CRAN (R 4.2.0)
# data.table               1.14.2    2021-09-27 [2] CRAN (R 4.2.0)
# DBI                      1.1.3     2022-06-18 [2] CRAN (R 4.2.0)
# dbplyr                   2.2.0     2022-06-05 [2] CRAN (R 4.2.0)
# DelayedArray             0.22.0    2022-04-26 [2] Bioconductor
# DelayedMatrixStats       1.18.0    2022-04-26 [2] Bioconductor
# desc                     1.4.1     2022-03-06 [2] CRAN (R 4.2.0)
# digest                   0.6.29    2021-12-01 [2] CRAN (R 4.2.0)
# dir.expiry               1.4.0     2022-04-26 [1] Bioconductor
# doParallel               1.0.17    2022-02-07 [2] CRAN (R 4.2.0)
# dotCall64                1.0-1     2021-02-11 [2] CRAN (R 4.1.0)
# dplyr                    1.0.9     2022-04-28 [2] CRAN (R 4.2.0)
# dqrng                    0.3.0     2021-05-01 [2] CRAN (R 4.2.0)
# DropletUtils             1.16.0    2022-04-26 [2] Bioconductor
# DT                       0.23      2022-05-10 [2] CRAN (R 4.2.0)
# edgeR                    3.38.1    2022-05-15 [2] Bioconductor
# ellipsis                 0.3.2     2021-04-29 [2] CRAN (R 4.2.0)
# ExperimentHub            2.4.0     2022-04-26 [2] Bioconductor
# fansi                    1.0.3     2022-03-24 [2] CRAN (R 4.2.0)
# fastmap                  1.1.0     2021-01-25 [2] CRAN (R 4.1.0)
# fields                   13.3      2021-10-30 [2] CRAN (R 4.2.0)
# filelock                 1.0.2     2018-10-05 [2] CRAN (R 4.1.0)
# foreach                  1.5.2     2022-02-02 [2] CRAN (R 4.2.0)
# fs                       1.5.2     2021-12-08 [2] CRAN (R 4.2.0)
# generics                 0.1.2     2022-01-31 [2] CRAN (R 4.2.0)
# GenomeInfoDb           * 1.32.2    2022-05-15 [2] Bioconductor
# GenomeInfoDbData         1.2.8     2022-04-16 [2] Bioconductor
# GenomicAlignments        1.32.0    2022-04-26 [2] Bioconductor
# GenomicRanges          * 1.48.0    2022-04-26 [2] Bioconductor
# ggbeeswarm               0.6.0     2017-08-07 [2] CRAN (R 4.2.0)
# ggplot2                  3.3.6     2022-05-03 [2] CRAN (R 4.2.0)
# ggrepel                  0.9.1     2021-01-15 [2] CRAN (R 4.1.0)
# glue                     1.6.2     2022-02-24 [2] CRAN (R 4.2.0)
# golem                    0.3.2     2022-03-04 [1] CRAN (R 4.2.0)
# gridExtra                2.3       2017-09-09 [2] CRAN (R 4.1.0)
# gtable                   0.3.0     2019-03-25 [2] CRAN (R 4.1.0)
# HDF5Array                1.24.1    2022-06-02 [2] Bioconductor
# here                   * 1.0.1     2020-12-13 [1] CRAN (R 4.2.0)
# htmltools                0.5.2     2021-08-25 [2] CRAN (R 4.2.0)
# htmlwidgets              1.5.4     2021-09-08 [2] CRAN (R 4.2.0)
# httpuv                   1.6.5     2022-01-05 [2] CRAN (R 4.2.0)
# httr                     1.4.3     2022-05-04 [2] CRAN (R 4.2.0)
# interactiveDisplayBase   1.34.0    2022-04-26 [2] Bioconductor
# IRanges                * 2.30.0    2022-04-26 [2] Bioconductor
# irlba                    2.3.5     2021-12-06 [2] CRAN (R 4.2.0)
# iterators                1.0.14    2022-02-05 [2] CRAN (R 4.2.0)
# jquerylib                0.1.4     2021-04-26 [2] CRAN (R 4.2.0)
# jsonlite                 1.8.0     2022-02-22 [2] CRAN (R 4.2.0)
# KEGGREST                 1.36.2    2022-06-09 [2] Bioconductor
# knitr                    1.39      2022-04-26 [2] CRAN (R 4.2.0)
# later                    1.3.0     2021-08-18 [2] CRAN (R 4.2.0)
# lattice                  0.20-45   2021-09-22 [3] CRAN (R 4.2.0)
# lazyeval                 0.2.2     2019-03-15 [2] CRAN (R 4.1.0)
# lifecycle                1.0.1     2021-09-24 [2] CRAN (R 4.2.0)
# limma                    3.52.2    2022-06-19 [2] Bioconductor
# locfit                   1.5-9.5   2022-03-03 [2] CRAN (R 4.2.0)
# magick                   2.7.3     2021-08-18 [2] CRAN (R 4.2.0)
# magrittr                 2.0.3     2022-03-30 [2] CRAN (R 4.2.0)
# maps                     3.4.0     2021-09-25 [2] CRAN (R 4.2.0)
# Matrix                   1.4-1     2022-03-23 [3] CRAN (R 4.2.0)
# MatrixGenerics         * 1.8.0     2022-04-26 [2] Bioconductor
# matrixStats            * 0.62.0    2022-04-19 [2] CRAN (R 4.2.0)
# memoise                  2.0.1     2021-11-26 [2] CRAN (R 4.2.0)
# mime                     0.12      2021-09-28 [2] CRAN (R 4.2.0)
# munsell                  0.5.0     2018-06-12 [2] CRAN (R 4.1.0)
# pillar                   1.7.0     2022-02-01 [2] CRAN (R 4.2.0)
# pkgconfig                2.0.3     2019-09-22 [2] CRAN (R 4.1.0)
# pkgload                  1.2.4     2021-11-30 [2] CRAN (R 4.2.0)
# plotly                   4.10.0    2021-10-09 [2] CRAN (R 4.2.0)
# png                      0.1-7     2013-12-03 [2] CRAN (R 4.1.0)
# Polychrome               1.3.1     2021-07-16 [1] CRAN (R 4.2.0)
# promises                 1.2.0.1   2021-02-11 [2] CRAN (R 4.1.0)
# purrr                    0.3.4     2020-04-17 [2] CRAN (R 4.1.0)
# R.methodsS3              1.8.2     2022-06-13 [2] CRAN (R 4.2.0)
# R.oo                     1.25.0    2022-06-12 [2] CRAN (R 4.2.0)
# R.utils                  2.11.0    2021-09-26 [2] CRAN (R 4.2.0)
# R6                       2.5.1     2021-08-19 [2] CRAN (R 4.2.0)
# rappdirs                 0.3.3     2021-01-31 [2] CRAN (R 4.1.0)
# RColorBrewer             1.1-3     2022-04-03 [2] CRAN (R 4.2.0)
# Rcpp                     1.0.8.3   2022-03-17 [2] CRAN (R 4.2.0)
# RCurl                    1.98-1.7  2022-06-09 [2] CRAN (R 4.2.0)
# restfulr                 0.0.15    2022-06-16 [2] CRAN (R 4.2.0)
# reticulate             * 1.25      2022-05-11 [1] CRAN (R 4.2.0)
# rhdf5                    2.40.0    2022-04-26 [2] Bioconductor
# rhdf5filters             1.8.0     2022-04-26 [2] Bioconductor
# Rhdf5lib                 1.18.2    2022-05-15 [2] Bioconductor
# rjson                    0.2.21    2022-01-09 [2] CRAN (R 4.2.0)
# rlang                    1.0.2     2022-03-04 [2] CRAN (R 4.2.0)
# roxygen2                 7.2.0     2022-05-13 [2] CRAN (R 4.2.0)
# rprojroot                2.0.3     2022-04-02 [2] CRAN (R 4.2.0)
# Rsamtools                2.12.0    2022-04-26 [2] Bioconductor
# RSQLite                  2.2.14    2022-05-07 [2] CRAN (R 4.2.0)
# rstudioapi               0.13      2020-11-12 [2] CRAN (R 4.1.0)
# rsvd                     1.0.5     2021-04-16 [2] CRAN (R 4.2.0)
# rtracklayer              1.56.0    2022-04-26 [2] Bioconductor
# S4Vectors              * 0.34.0    2022-04-26 [2] Bioconductor
# sass                     0.4.1     2022-03-23 [2] CRAN (R 4.2.0)
# ScaledMatrix             1.4.0     2022-04-26 [2] Bioconductor
# scales                   1.2.0     2022-04-13 [2] CRAN (R 4.2.0)
# scater                   1.24.0    2022-04-26 [2] Bioconductor
# scatterplot3d            0.3-41    2018-03-14 [1] CRAN (R 4.2.0)
# scuttle                  1.6.2     2022-05-15 [2] Bioconductor
# sessioninfo            * 1.2.2     2021-12-06 [2] CRAN (R 4.2.0)
# shiny                    1.7.1     2021-10-02 [2] CRAN (R 4.2.0)
# shinyWidgets             0.7.0     2022-05-11 [2] CRAN (R 4.2.0)
# SingleCellExperiment   * 1.18.0    2022-04-26 [2] Bioconductor
# spam                     2.8-0     2022-01-06 [2] CRAN (R 4.2.0)
# sparseMatrixStats        1.8.0     2022-04-26 [2] Bioconductor
# SpatialExperiment      * 1.6.0     2022-04-26 [2] Bioconductor
# spatialLIBD            * 1.7.11    2022-02-24 [1] Bioconductor
# stringi                  1.7.6     2021-11-29 [2] CRAN (R 4.2.0)
# stringr                  1.4.0     2019-02-10 [2] CRAN (R 4.1.0)
# SummarizedExperiment   * 1.26.1    2022-04-29 [2] Bioconductor
# testthat                 3.1.4     2022-04-26 [2] CRAN (R 4.2.0)
# tibble                   3.1.7     2022-05-03 [2] CRAN (R 4.2.0)
# tidyr                    1.2.0     2022-02-01 [2] CRAN (R 4.2.0)
# tidyselect               1.1.2     2022-02-21 [2] CRAN (R 4.2.0)
# usethis                  2.1.6     2022-05-25 [2] CRAN (R 4.2.0)
# utf8                     1.2.2     2021-07-24 [2] CRAN (R 4.2.0)
# vctrs                    0.4.1     2022-04-13 [2] CRAN (R 4.2.0)
# vipor                    0.4.5     2017-03-22 [2] CRAN (R 4.2.0)
# viridis                  0.6.2     2021-10-13 [2] CRAN (R 4.2.0)
# viridisLite              0.4.0     2021-04-13 [2] CRAN (R 4.2.0)
# withr                    2.5.0     2022-03-03 [2] CRAN (R 4.2.0)
# xfun                     0.31      2022-05-10 [2] CRAN (R 4.2.0)
# XML                      3.99-0.10 2022-06-09 [2] CRAN (R 4.2.0)
# xml2                     1.3.3     2021-11-30 [2] CRAN (R 4.2.0)
# xtable                   1.8-4     2019-04-21 [2] CRAN (R 4.1.0)
# XVector                  0.36.0    2022-04-26 [2] Bioconductor
# yaml                     2.3.5     2022-02-21 [2] CRAN (R 4.2.0)
# zellkonverter          * 1.7.1     2022-05-25 [1] Github (theislab/zellkonverter@45e7782)
# zlibbioc                 1.42.0    2022-04-26 [2] Bioconductor
# 
# [1] /users/neagles/R/devel
# [2] /jhpce/shared/jhpce/core/conda/miniconda3-4.6.14/envs/svnR-devel/R/devel/lib64/R/site-library
# [3] /jhpce/shared/jhpce/core/conda/miniconda3-4.6.14/envs/svnR-devel/R/devel/lib64/R/library
#
# ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────
