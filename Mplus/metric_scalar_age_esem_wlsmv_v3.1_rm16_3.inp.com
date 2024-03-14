TITLE: Age Metric/Weak + Scalar/Strong Invariance test of 
3-Factor ESEM of PFC-S using WLSMV with missing data
Version 3.1 -- omitting PFC16;

DATA: FILE IS "C:\Users\forev\Documents\NicolasCamacho\
pfc_fa\paper\updated_process\data\pfc_mi_age.dat";

VARIABLE: 
  NAMES ARE subid ageGroup genGroup 
  pfc01 pfc02 pfc03 pfc04 pfc05 pfc06 
  pfc07 pfc08 pfc09 pfc10 pfc11 pfc12 pfc13 
  pfc14 pfc15 pfc16 pfc17 pfc18 pfc19 pfc20 
  pfc21 pfc22 pfc23;
  USEVARIABLES ARE 
  pfc01 pfc02 pfc03 pfc04 pfc05 pfc06 
  pfc07 pfc08 pfc09 pfc10 pfc11 pfc12 pfc13 
  pfc14 pfc15 pfc17 pfc18 pfc19 pfc20 
  pfc21 pfc22 pfc23;
  CATEGORICAL ARE pfc01-pfc23;
  MISSING ARE ALL (99);
  GROUPING IS ageGroup(1 = UnderSix 2 = SixPlus);

ANALYSIS:
  ESTIMATOR IS WLSMV;
  ROTATION IS GEOMIN (.5);
  PARAMETERIZATION IS THETA;
  DIFFTEST = age_config.dif;
  
MODEL:
  F1-F3 BY pfc01-pfc23 (*1);

  ! residual variances (uniquenesses) fixed at 1 in line with theta param
  pfc01@1 pfc02@1 pfc03@1 pfc04@1 pfc05@1 pfc06@1
  pfc07@1 pfc08@1 pfc09@1 pfc10@1 pfc11@1 pfc12@1
  pfc13@1 pfc14@1 pfc15@1 pfc17@1 pfc18@1 pfc19@1
  pfc20@1 pfc21@1 pfc22@1 pfc23@1;

  ! items' thresholds
  [pfc01$1 pfc01$2 pfc01$3 
  pfc02$1 pfc02$2 pfc02$3 pfc02$4 
  pfc03$1 pfc03$2 
  pfc04$1 pfc04$2 pfc04$3 pfc04$4 
  pfc05$1 pfc05$2 pfc05$3 pfc05$4
  pfc06$1 pfc06$2 pfc06$3 pfc06$4
  pfc07$1 pfc07$2 pfc07$3 pfc07$4 
  pfc08$1 pfc08$2 pfc08$3 
  pfc09$1 pfc09$2
  pfc10$1 pfc10$2 pfc10$3 pfc10$4 
  pfc11$1 pfc11$2 pfc11$3
  pfc12$1 pfc12$2 pfc12$3 pfc12$4
  pfc13$1 pfc13$2 pfc13$3 pfc13$4
  pfc14$1 pfc14$2 pfc14$3 pfc14$4
  pfc15$1 pfc15$2 pfc15$3 pfc15$4 
  pfc17$1 pfc17$2
  pfc18$1 pfc18$2 pfc18$3 
  pfc19$1 pfc19$2 pfc19$3
  pfc20$1 pfc20$2 pfc20$3
  pfc21$1 pfc21$2 pfc21$3 
  pfc22$1 pfc22$2 pfc22$3 
  pfc23$1 pfc23$2 pfc23$3];

  ! latent means constrained to be zero
  [F1@0 F2@0 F3@0];

  ! factor variances fixed at 1
  F1@1 F2@1 F3@1;

MODEL SixPlus:

  ! in ESEM with ordinal variables, metric/weak invariance should not be investigated alone
  ! metric/weak + scalar/strong invariance must be specified simultaneously

  ! specifications regarding the factor loadings are omitted below for metric/weak invariance
  ! this results in an equality constraint of factor loadings across groups
  ! F1-F3 BY pfc01-pfc23 (*1);

  ! residual variances (uniquenesses) are freed rather than fixed at 1
  ! this specification results in the above group residual variances being
  ! constrained at 1 and freed in this group
  pfc01 pfc02 pfc03 pfc04 pfc05 pfc06
  pfc07 pfc08 pfc09 pfc10 pfc11 pfc12
  pfc13 pfc14 pfc15 pfc17 pfc18 pfc19
  pfc20 pfc21 pfc22 pfc23;
  
  ! specifications regarding the item thresholds are omitted below for scalar/strong invariance
  ! this results in an equality constraint of thresholds across groups
  ! items' thresholds
  ! [pfc01$1 pfc01$2 pfc01$3 
  ! pfc02$1 pfc02$2 pfc02$3 pfc02$4 
  ! pfc03$1 pfc03$2 
  ! pfc04$1 pfc04$2 pfc04$3 pfc04$4 
  ! pfc05$1 pfc05$2 pfc05$3 pfc05$4
  ! pfc06$1 pfc06$2 pfc06$3 pfc06$4
  ! pfc07$1 pfc07$2 pfc07$3 pfc07$4 
  ! pfc08$1 pfc08$2 pfc08$3 
  ! pfc09$1 pfc09$2
  ! pfc10$1 pfc10$2 pfc10$3 pfc10$4 
  ! pfc11$1 pfc11$2 pfc11$3
  ! pfc12$1 pfc12$2 pfc12$3 pfc12$4
  ! pfc13$1 pfc13$2 pfc13$3 pfc13$4
  ! pfc14$1 pfc14$2 pfc14$3 pfc14$4
  ! pfc15$1 pfc15$2 pfc15$3 pfc15$4 
  ! pfc17$1 pfc17$2
  ! pfc18$1 pfc18$2 pfc18$3 
  ! pfc19$1 pfc19$2 pfc19$3
  ! pfc20$1 pfc20$2 pfc20$3
  ! pfc21$1 pfc21$2 pfc21$3 
  ! pfc22$1 pfc22$2 pfc22$3 
  ! pfc23$1 pfc23$2 pfc23$3];

  ! latent means are freed in this group rather than
  ! constrained at 0 as in the above group
  [F1 F2 F3];

  ! factor variances are freed in this group rather than
  ! constrained at 1 as in the above group
  F1 F2 F3;

OUTPUT: SAMPSTAT STDY STDYX MODINDICES(3.84);

PLOT: TYPE = PLOT2;

SAVEDATA: DIFFTEST = age_metric_scalar.dif;