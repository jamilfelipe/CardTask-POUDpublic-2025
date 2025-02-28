#!/bin/sh


OUTPUT_DIR=/mnt/delgadolab/jamil/opiod_mita/analysis/cardtask
FEAT_STUB=basicmodel/basicrpn_run-01.feat
REG_STUB=${FEAT_STUB}/reg
REGSTD_STUB=${FEAT_STUB}/reg_standard
REF_GEOM=${OUTPUT_DIR}/rois/hires_geom
NII_SUFFIX=nii.gz

PATH=$(echo "$PATH" | sed -e 's@/home/bhanji/anaconda3/bin:@@g')
export PATH

for subject in 601 602 603 604 605 606 607 608 609 610 611 612 613 614 615 616 617 618 620 801 802 803 804 806 807 808 809 810 811 812
do
  echo sub-${subject}
  FEAT_DIR=${OUTPUT_DIR}/sub-${subject}/${FEAT_STUB}
  REG_DIR=${OUTPUT_DIR}/sub-${subject}/${REG_STUB}
  REGSTD_DIR=${OUTPUT_DIR}/sub-${subject}/${REGSTD_STUB}
  if [ -d "$REG_DIR" ]; then
    rm -rv $REG_DIR
  fi
  if [ -d "$REGSTD_DIR" ]; then
    rm -rv $REGSTD_DIR
  fi
  mkdir -p ${REG_DIR}
  ln -s ${FSLDIR}/etc/flirtsch/ident.mat ${FEAT_DIR}/reg/example_func2standard.mat
  ln -s ${FSLDIR}/etc/flirtsch/ident.mat ${FEAT_DIR}/reg/standard2example_func.mat
  ln -s ${FEAT_DIR}/mean_func.nii.gz ${FEAT_DIR}/reg/standard.nii.gz
  #fslcpgeom ${REF_GEOM} ${REG_DIR}/example_func2standard.${NII_SUFFIX}
  #fslcpgeom ${REF_GEOM} ${REG_DIR}/standard.${NII_SUFFIX}
done
  
