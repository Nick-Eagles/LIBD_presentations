#   This script is intended for use at JHPCE, where local files are linked into
#   this repository in preparation for later analysis. Note that all data used
#   here is public, so the appropriate files may also be obtained following the
#   guidelines here:
#
#   http://research.libd.org/spatialLIBD/#raw-data

src_dir=/dcl02/lieber/ajaffe/SpatialTranscriptomics/HumanPilot/10X
sample=151507

#   Symlink outputs from spaceranger that we'll reference later
mkdir data
ln -s $src_dir/$sample/tissue_hires_image.png data/
ln -s $src_dir/$sample/scalefactors_json.json data/
