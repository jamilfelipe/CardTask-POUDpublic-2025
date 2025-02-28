#!/bin/sh


MAINDIR=/mnt/delgadolab/jamil/opiod_mita/analysis/cardtask
MAINOUTDIR=${MAINDIR}/group/preproc2/basic_conf64plus
PREPROCDIR=/mnt/delgadolab/jamil/opiod_mita/preproc2/fmriprep
FEAT_TEMPLATE_DIR=${MAINDIR}/code/feat_templates
ROIDIR=${MAINDIR}/rois

mkdir -p ${MAINOUTDIR}

cd $MAINDIR


##first create necessary dof images
#for subject in 601 603 604 606 607 608 609 610 611 612 613 614 615 616 617 618 622 624 625 626 627 801 802 803 804 806 807 809 810 811 812 813 814 815 816 817 818 819 820 821 822 823 ; do
#  DOF=`cat ${MAINDIR}/sub-${subject}/preproc2_basicnoaroma/conf64plus_run-01.feat/stats/dof`
#  fslmaths ${MAINDIR}/sub-${subject}/preproc2_basicnoaroma/conf64plus_run-01.feat/stats/cope1 -mul 0 -add ${DOF} ${MAINDIR}/sub-${subject}/preproc2_basicnoaroma/conf64plus_run-01.feat/stats/tdof_jb
#done  

#Now loop through contrasts
for i in 4 1 2 3 5 #4 5 6 7 8 9
do
  OUTDIR=${MAINOUTDIR}/23_21_cope${i} #.gfeat
  #rm -rf $OUTDIR
  mkdir -p ${OUTDIR}
  cd ${OUTDIR}
  echo cope${i}
  
  # create 4D file containing a cope for each subject
  fslmerge -t allfmriprepmask ${PREPROCDIR}/sub-???/func/sub-???_task-persist_run-01_space-MNI152NLin6Asym_desc-brain_mask.nii.gz
  fslmaths allfmriprepmask -Tmean allfmriprepmask
  fslmaths allfmriprepmask -thr .8 -bin allfmriprepmask
  fslmerge -t allmean_func ${MAINDIR}/sub-???/preproc2_basicnoaroma/conf64plus_run-01.feat/mean_func.nii.gz
  fslmaths allmean_func -Tmean allmean_func
  fslmerge -t expcope${i} ${MAINDIR}/sub-6??/preproc2_basicnoaroma/conf64plus_run-01.feat/stats/cope${i}.nii.gz
  fslmerge -t ctlcope${i} ${MAINDIR}/sub-8??/preproc2_basicnoaroma/conf64plus_run-01.feat/stats/cope${i}.nii.gz
  fslmerge -t allcope${i} expcope${i} ctlcope${i}
  fslmaths allcope${i} -mas allfmriprepmask allcope${i}
  
  # run randomise
  cp ../../2321featdesign.* .
  randomise -i allcope${i} -o perm_BMKlrstr_${i} -d 2321featdesign.mat -t 2321featdesign.con -T -m ${ROIDIR}/BMKmeta_RvP_lrstr2mm -n 5000
  randomise -i allcope${i} -o perm_BMKlrvmpfc_${i} -d 2321featdesign.mat -t 2321featdesign.con -T -m ${ROIDIR}/BMKmeta_RvP_vmpfc2mm -n 5000
  randomise -i allcope${i} -o perm_wholebrain${i} -d 2321featdesign.mat -t 2321featdesign.con -T -m allfmriprepmask -n 5000
  randomise -i allcope${i} -o perm_BMKvmpfcstrpcc_${i} -d 2321featdesign.mat -t 2321featdesign.con -T -m ${ROIDIR}/BMKmeta_RvP_vmpfc_str_pcc2mm -n 5000

done

cd $MAINDIR
