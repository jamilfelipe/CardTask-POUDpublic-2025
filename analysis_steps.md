# Card Task POUD Analysis  
- jamilfelipe@gmail.com  
- with Jaleesa Stringfellow, Mauricio Delgado, Suchismita Ray  

## 1. Description of the initial Card Task data analysis (re-run after updated preproc)  
#### A. preprocessing with fmriprep  1.5.8
        - BIDS formatted data (face removed from structurals) in BIDS folder  
        - preprocessed data in preproc2/fmriprep  
        - quality check reports in preproc2/mriqc  
        - resampled to 2mm voxels  
        - exclusions for missing >25% of trials (602,620,808), >5mm vol-to-vol (605,628)  
        - leaves 23 POUD and 21 CTL  

#### B. Subject-level GLM with FSL 5.0.9, FEAT 6.0  
        - location: analysis/cardtask/sub-???/preproc2_basicrt/conf64_run-01.feat  
        - feat template: analysis/cardtask/code/feat_templates/cardtask_basicrt_runlevel.fsf  
        - Explanatory Variables: EV1-rew_out (dur=1s), EV2-pun_out (dur=1s), EV3-neut_out (dur=1s), EV4-input (dur=response time)  
        - confounds: 
                - 6 motion descriptors (6 rigid-body transformations)
                - acompcor: 5 whitematter, 5 csf signal components
                - derivative, square, squared derivative of the 16 confounds above
                - "spike" regressors (1 per dvars outlier, using default boxplot threshold)
        - COPES:  
            1. reward v null  
            2. punishment v null  
            3. neutral v null  
            **4. reward v punish**  
            5. punish v reward  
            6. reward v neutral  
            7. neutral v reward  
            8. punish v neutral  
            9. neutral v punish  
        - Region of interest (L/R) Ventral striatum, (L/R) VMPFC
                - regions defined by Pos vs Neg value meta-analytic map from [Bartra, McGuire, Kable (2013)](https://doi.org/10.1016/j.neuroimage.2013.02.063)  
                - feedback signal change event-averaged time series (0-18s) per condition in analysis/cardtask/roi_timeseries_cleaned.csv (code and plots in code/Cardtask-event-average-timeseries.ipynb)  
                	- time series extracted as average of all voxels at each tr, then 0-12s after each event taken from residuals after fitting all other events and confounds, then averaged by trial type and timepoint

#### C. Group level with randomise (10000 iterations)  
        - location: analysis/cardtask/group/preproc2/basicnoaroma  
        - script: analysis/cardtask/code/basicnoaroma_23_21groupfeatrandomise.sh  
        - threshold at p < .05 corrected (whole brain)  
        - CONTRASTS (group level - in 2321featdesign.*)  
            1. POUD > CTL
            2. CTL > POUD
            3. POUD > 0
            4. POUD < 0
            5. CTL > 0
            6. CTL < 0

