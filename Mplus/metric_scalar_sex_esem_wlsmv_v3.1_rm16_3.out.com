Mplus VERSION 8.6
MUTHEN & MUTHEN
01/31/2024   6:24 AM

INPUT INSTRUCTIONS

  TITLE: Sex assigned at birth Metric/Weak + Scalar/Strong Invariance test of
  3-Factor ESEM of PFC-S using WLSMV with missing data
  Version 3.1 -- omitting PFC16

  DATA: FILE IS "C:\Users\forev\Documents\NicolasCamacho\
  pfc_fa\paper\updated_process\data\pfc_mi_gender.dat";

  VARIABLE:
    NAMES ARE subid ageGroup genGroup
    pfc01 pfc02 pfc03 pfc04 pfc05 pfc06
    pfc07 pfc08 pfc09 pfc10 pfc11 pfc12 pfc13
    pfc14 pfc15 pfc16 pfc17 pfc18 pfc19 pfc20
    pfc21 pfc22 pfc23;
    USEVARIABLES ARE pfc01 pfc02 pfc03 pfc04 pfc05 pfc06
    pfc07 pfc08 pfc09 pfc10 pfc11 pfc12 pfc13
    pfc14 pfc15 pfc17 pfc18 pfc19 pfc20
    pfc21 pfc22 pfc23;
    CATEGORICAL ARE pfc01-pfc23;
    MISSING ARE ALL (99);
    GROUPING IS genGroup(1 = Female 2 = Male);

  ANALYSIS:
    ESTIMATOR IS WLSMV;
    ROTATION IS GEOMIN (.5);
    PARAMETERIZATION IS THETA;
    DIFFTEST = sex_config.dif;

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
    pfc08$1 pfc08$2 pfc08$3 pfc08$4
    pfc09$1 pfc09$2
    pfc10$1 pfc10$2 pfc10$3 pfc10$4
    pfc11$1 pfc11$2 pfc11$3 pfc11$4
    pfc12$1 pfc12$2 pfc12$3
    pfc13$1 pfc13$2 pfc13$3 pfc13$4
    pfc14$1 pfc14$2 pfc14$3 pfc14$4
    pfc15$1 pfc15$2 pfc15$3 pfc15$4
    pfc17$1 pfc17$2
    pfc18$1 pfc18$2 pfc18$3
    pfc19$1 pfc19$2 pfc19$3
    pfc20$1 pfc20$2 pfc20$3
    pfc21$1 pfc21$2 pfc21$3 pfc21$4
    pfc22$1 pfc22$2 pfc22$3
    pfc23$1 pfc23$2 pfc23$3 pfc23$4];

    ! latent means constrained to be zero
    [F1@0 F2@0 F3@0];

    ! factor variances fixed at 1
    F1@1 F2@1 F3@1;

  MODEL Male:

    ! in ESEM with ordinal variables, metric/weak invariance should not be investigated alon
    ! metric/weak + scalar/strong invariance must be specified simultaneously

    ! specifications regarding the factor loadings are omitted below for metric/weak invaria
    ! this results in an equality constraint of factor loadings across groups
    ! F1-F3 BY pfc01-pfc23 (*1);

    ! residual variances (uniquenesses) are freed rather than fixed at 1
    ! this specification results in the above group residual variances being
    ! constrained at 1 and freed in this group
    pfc01 pfc02 pfc03 pfc04 pfc05 pfc06
    pfc07 pfc08 pfc09 pfc10 pfc11 pfc12
    pfc13 pfc14 pfc15 pfc17 pfc18 pfc19
    pfc20 pfc21 pfc22 pfc23;

    ! specifications regarding the item thresholds are omitted below for scalar/strong invar
    ! this results in an equality constraint of thresholds across groups
    ! items' thresholds
    ! [pfc01$1 pfc01$2 pfc01$3
    ! pfc02$1 pfc02$2 pfc02$3 pfc02$4
    ! pfc03$1 pfc03$2
    ! pfc04$1 pfc04$2 pfc04$3 pfc04$4
    ! pfc05$1 pfc05$2 pfc05$3 pfc05$4
    ! pfc06$1 pfc06$2 pfc06$3 pfc06$4
    ! pfc07$1 pfc07$2 pfc07$3 pfc07$4
    ! pfc08$1 pfc08$2 pfc08$3 pfc08$4
    ! pfc09$1 pfc09$2
    ! pfc10$1 pfc10$2 pfc10$3 pfc10$4
    ! pfc11$1 pfc11$2 pfc11$3 pfc11$4
    ! pfc12$1 pfc12$2 pfc12$3
    ! pfc13$1 pfc13$2 pfc13$3 pfc13$4
    ! pfc14$1 pfc14$2 pfc14$3 pfc14$4
    ! pfc15$1 pfc15$2 pfc15$3 pfc15$4
    ! pfc17$1 pfc17$2
    ! pfc18$1 pfc18$2 pfc18$3
    ! pfc19$1 pfc19$2 pfc19$3
    ! pfc20$1 pfc20$2 pfc20$3
    ! pfc21$1 pfc21$2 pfc21$3 pfc21$4
    ! pfc22$1 pfc22$2 pfc22$3
    ! pfc23$1 pfc23$2 pfc23$3 pfc23$4];

    ! latent means are freed in this group rather than
    ! constrained at 0 as in the above group
    [F1 F2 F3];

    ! factor variances are freed in this group rather than
    ! constrained at 1 as in the above group
    F1 F2 F3;

  OUTPUT: SAMPSTAT STDY STDYX MODINDICES(3.84);

  PLOT: TYPE = PLOT2;

  SAVEDATA: DIFFTEST = sex_metric_scalar.dif;



*** WARNING
  Input line exceeded 90 characters. Some input may be truncated.
    ! in ESEM with ordinal variables, metric/weak invariance should not be investigated alone
*** WARNING
  Input line exceeded 90 characters. Some input may be truncated.
    ! specifications regarding the factor loadings are omitted below for metric/weak invarian
*** WARNING
  Input line exceeded 90 characters. Some input may be truncated.
    ! specifications regarding the item thresholds are omitted below for scalar/strong invari
   3 WARNING(S) FOUND IN THE INPUT INSTRUCTIONS



Sex assigned at birth Metric/Weak + Scalar/Strong Invariance test of
3-Factor ESEM of PFC-S using WLSMV with missing data
Version 3.1 -- omitting PFC16

SUMMARY OF ANALYSIS

Number of groups                                                 2
Number of observations
   Group FEMALE                                                219
   Group MALE                                                  231
   Total sample size                                           450

Number of dependent variables                                   22
Number of independent variables                                  0
Number of continuous latent variables                            3

Observed dependent variables

  Binary and ordered categorical (ordinal)
   PFC01       PFC02       PFC03       PFC04       PFC05       PFC06
   PFC07       PFC08       PFC09       PFC10       PFC11       PFC12
   PFC13       PFC14       PFC15       PFC17       PFC18       PFC19
   PFC20       PFC21       PFC22       PFC23

Continuous latent variables

  EFA factors
  *1:   F1          F2          F3

Variables with special functions

  Grouping variable     GENGROUP

Estimator                                                    WLSMV
Rotation                                                    GEOMIN
Row standardization                                     COVARIANCE
Type of rotation                                           OBLIQUE
Epsilon value                                            0.500D+00
Maximum number of iterations                                  1000
Convergence criterion                                    0.500D-04
Maximum number of steepest descent iterations                   20
Maximum number of iterations for H1                           2000
Convergence criterion for H1                             0.100D-03
Optimization Specifications for the Exploratory Factor Analysis
Rotation Algorithm
  Number of random starts                                       30
  Maximum number of iterations                               10000
  Derivative convergence criterion                       0.100D-04
Parameterization                                             THETA
Link                                                        PROBIT

Input data file(s)
  C:\Users\forev\Documents\NicolasCamacho\pfc_fa\paper\updated_process\data\pfc_

Input data format  FREE


SUMMARY OF DATA

   Group FEMALE
     Number of missing data patterns             8

   Group MALE
     Number of missing data patterns             6


COVARIANCE COVERAGE OF DATA

Minimum covariance coverage value   0.100


     PROPORTION OF DATA PRESENT FOR FEMALE


           Covariance Coverage
              PFC01         PFC02         PFC03         PFC04         PFC05
              ________      ________      ________      ________      ________
 PFC01          1.000
 PFC02          1.000         1.000
 PFC03          1.000         1.000         1.000
 PFC04          0.995         0.995         0.995         0.995
 PFC05          1.000         1.000         1.000         0.995         1.000
 PFC06          1.000         1.000         1.000         0.995         1.000
 PFC07          0.995         0.995         0.995         0.991         0.995
 PFC08          0.995         0.995         0.995         0.991         0.995
 PFC09          0.991         0.991         0.991         0.986         0.991
 PFC10          0.995         0.995         0.995         0.991         0.995
 PFC11          0.991         0.991         0.991         0.986         0.991
 PFC12          0.995         0.995         0.995         0.991         0.995
 PFC13          0.995         0.995         0.995         0.991         0.995
 PFC14          0.995         0.995         0.995         0.991         0.995
 PFC15          0.986         0.986         0.986         0.982         0.986
 PFC17          0.986         0.986         0.986         0.982         0.986
 PFC18          0.986         0.986         0.986         0.982         0.986
 PFC19          0.986         0.986         0.986         0.982         0.986
 PFC20          0.982         0.982         0.982         0.977         0.982
 PFC21          0.982         0.982         0.982         0.977         0.982
 PFC22          0.986         0.986         0.986         0.982         0.986
 PFC23          0.986         0.986         0.986         0.982         0.986


           Covariance Coverage
              PFC06         PFC07         PFC08         PFC09         PFC10
              ________      ________      ________      ________      ________
 PFC06          1.000
 PFC07          0.995         0.995
 PFC08          0.995         0.995         0.995
 PFC09          0.991         0.991         0.991         0.991
 PFC10          0.995         0.995         0.995         0.991         0.995
 PFC11          0.991         0.991         0.991         0.986         0.991
 PFC12          0.995         0.995         0.995         0.991         0.995
 PFC13          0.995         0.995         0.995         0.991         0.995
 PFC14          0.995         0.995         0.995         0.991         0.995
 PFC15          0.986         0.986         0.986         0.982         0.986
 PFC17          0.986         0.986         0.986         0.982         0.986
 PFC18          0.986         0.986         0.986         0.982         0.986
 PFC19          0.986         0.986         0.986         0.982         0.986
 PFC20          0.982         0.982         0.982         0.977         0.982
 PFC21          0.982         0.982         0.982         0.977         0.982
 PFC22          0.986         0.986         0.986         0.982         0.986
 PFC23          0.986         0.986         0.986         0.982         0.986


           Covariance Coverage
              PFC11         PFC12         PFC13         PFC14         PFC15
              ________      ________      ________      ________      ________
 PFC11          0.991
 PFC12          0.991         0.995
 PFC13          0.991         0.995         0.995
 PFC14          0.991         0.995         0.995         0.995
 PFC15          0.982         0.986         0.986         0.986         0.986
 PFC17          0.982         0.986         0.986         0.986         0.986
 PFC18          0.982         0.986         0.986         0.986         0.986
 PFC19          0.982         0.986         0.986         0.986         0.986
 PFC20          0.977         0.982         0.982         0.982         0.982
 PFC21          0.977         0.982         0.982         0.982         0.982
 PFC22          0.982         0.986         0.986         0.986         0.986
 PFC23          0.982         0.986         0.986         0.986         0.986


           Covariance Coverage
              PFC17         PFC18         PFC19         PFC20         PFC21
              ________      ________      ________      ________      ________
 PFC17          0.986
 PFC18          0.986         0.986
 PFC19          0.986         0.986         0.986
 PFC20          0.982         0.982         0.982         0.982
 PFC21          0.982         0.982         0.982         0.977         0.982
 PFC22          0.986         0.986         0.986         0.982         0.982
 PFC23          0.986         0.986         0.986         0.982         0.982


           Covariance Coverage
              PFC22         PFC23
              ________      ________
 PFC22          0.986
 PFC23          0.986         0.986


     PROPORTION OF DATA PRESENT FOR MALE


           Covariance Coverage
              PFC01         PFC02         PFC03         PFC04         PFC05
              ________      ________      ________      ________      ________
 PFC01          1.000
 PFC02          1.000         1.000
 PFC03          1.000         1.000         1.000
 PFC04          1.000         1.000         1.000         1.000
 PFC05          1.000         1.000         1.000         1.000         1.000
 PFC06          0.996         0.996         0.996         0.996         0.996
 PFC07          1.000         1.000         1.000         1.000         1.000
 PFC08          1.000         1.000         1.000         1.000         1.000
 PFC09          0.996         0.996         0.996         0.996         0.996
 PFC10          1.000         1.000         1.000         1.000         1.000
 PFC11          0.991         0.991         0.991         0.991         0.991
 PFC12          1.000         1.000         1.000         1.000         1.000
 PFC13          1.000         1.000         1.000         1.000         1.000
 PFC14          1.000         1.000         1.000         1.000         1.000
 PFC15          0.991         0.991         0.991         0.991         0.991
 PFC17          0.991         0.991         0.991         0.991         0.991
 PFC18          0.991         0.991         0.991         0.991         0.991
 PFC19          0.983         0.983         0.983         0.983         0.983
 PFC20          0.987         0.987         0.987         0.987         0.987
 PFC21          0.987         0.987         0.987         0.987         0.987
 PFC22          0.987         0.987         0.987         0.987         0.987
 PFC23          0.987         0.987         0.987         0.987         0.987


           Covariance Coverage
              PFC06         PFC07         PFC08         PFC09         PFC10
              ________      ________      ________      ________      ________
 PFC06          0.996
 PFC07          0.996         1.000
 PFC08          0.996         1.000         1.000
 PFC09          0.991         0.996         0.996         0.996
 PFC10          0.996         1.000         1.000         0.996         1.000
 PFC11          0.991         0.991         0.991         0.987         0.991
 PFC12          0.996         1.000         1.000         0.996         1.000
 PFC13          0.996         1.000         1.000         0.996         1.000
 PFC14          0.996         1.000         1.000         0.996         1.000
 PFC15          0.987         0.991         0.991         0.987         0.991
 PFC17          0.987         0.991         0.991         0.987         0.991
 PFC18          0.987         0.991         0.991         0.987         0.991
 PFC19          0.983         0.983         0.983         0.978         0.983
 PFC20          0.983         0.987         0.987         0.983         0.987
 PFC21          0.983         0.987         0.987         0.983         0.987
 PFC22          0.983         0.987         0.987         0.983         0.987
 PFC23          0.983         0.987         0.987         0.983         0.987


           Covariance Coverage
              PFC11         PFC12         PFC13         PFC14         PFC15
              ________      ________      ________      ________      ________
 PFC11          0.991
 PFC12          0.991         1.000
 PFC13          0.991         1.000         1.000
 PFC14          0.991         1.000         1.000         1.000
 PFC15          0.983         0.991         0.991         0.991         0.991
 PFC17          0.983         0.991         0.991         0.991         0.991
 PFC18          0.983         0.991         0.991         0.991         0.991
 PFC19          0.978         0.983         0.983         0.983         0.983
 PFC20          0.978         0.987         0.987         0.987         0.987
 PFC21          0.978         0.987         0.987         0.987         0.987
 PFC22          0.978         0.987         0.987         0.987         0.987
 PFC23          0.978         0.987         0.987         0.987         0.987


           Covariance Coverage
              PFC17         PFC18         PFC19         PFC20         PFC21
              ________      ________      ________      ________      ________
 PFC17          0.991
 PFC18          0.991         0.991
 PFC19          0.983         0.983         0.983
 PFC20          0.987         0.987         0.983         0.987
 PFC21          0.987         0.987         0.983         0.987         0.987
 PFC22          0.987         0.987         0.983         0.987         0.987
 PFC23          0.987         0.987         0.983         0.987         0.987


           Covariance Coverage
              PFC22         PFC23
              ________      ________
 PFC22          0.987
 PFC23          0.987         0.987


UNIVARIATE PROPORTIONS AND COUNTS FOR CATEGORICAL VARIABLES

  Group FEMALE
    PFC01
      Category 1    0.749          164.000
      Category 2    0.192           42.000
      Category 3    0.055           12.000
      Category 4    0.005            1.000
    PFC02
      Category 1    0.320           70.000
      Category 2    0.539          118.000
      Category 3    0.114           25.000
      Category 4    0.018            4.000
      Category 5    0.009            2.000
    PFC03
      Category 1    0.763          167.000
      Category 2    0.215           47.000
      Category 3    0.023            5.000
    PFC04
      Category 1    0.271           59.000
      Category 2    0.450           98.000
      Category 3    0.234           51.000
      Category 4    0.037            8.000
      Category 5    0.009            2.000
    PFC05
      Category 1    0.616          135.000
      Category 2    0.288           63.000
      Category 3    0.073           16.000
      Category 4    0.009            2.000
      Category 5    0.014            3.000
    PFC06
      Category 1    0.489          107.000
      Category 2    0.347           76.000
      Category 3    0.091           20.000
      Category 4    0.041            9.000
      Category 5    0.032            7.000
    PFC07
      Category 1    0.119           26.000
      Category 2    0.349           76.000
      Category 3    0.390           85.000
      Category 4    0.110           24.000
      Category 5    0.032            7.000
    PFC08
      Category 1    0.358           78.000
      Category 2    0.486          106.000
      Category 3    0.119           26.000
      Category 4    0.028            6.000
      Category 5    0.009            2.000
    PFC09
      Category 1    0.880          191.000
      Category 2    0.106           23.000
      Category 3    0.014            3.000
    PFC10
      Category 1    0.248           54.000
      Category 2    0.477          104.000
      Category 3    0.202           44.000
      Category 4    0.046           10.000
      Category 5    0.028            6.000
    PFC11
      Category 1    0.512          111.000
      Category 2    0.359           78.000
      Category 3    0.097           21.000
      Category 4    0.023            5.000
      Category 5    0.009            2.000
    PFC12
      Category 1    0.615          134.000
      Category 2    0.317           69.000
      Category 3    0.060           13.000
      Category 4    0.009            2.000
    PFC13
      Category 1    0.569          124.000
      Category 2    0.303           66.000
      Category 3    0.106           23.000
      Category 4    0.014            3.000
      Category 5    0.009            2.000
    PFC14
      Category 1    0.803          175.000
      Category 2    0.156           34.000
      Category 3    0.023            5.000
      Category 4    0.014            3.000
      Category 5    0.005            1.000
    PFC15
      Category 1    0.685          148.000
      Category 2    0.213           46.000
      Category 3    0.046           10.000
      Category 4    0.009            2.000
      Category 5    0.046           10.000
    PFC17
      Category 1    0.606          131.000
      Category 2    0.319           69.000
      Category 3    0.074           16.000
    PFC18
      Category 1    0.824          178.000
      Category 2    0.134           29.000
      Category 3    0.037            8.000
      Category 4    0.005            1.000
    PFC19
      Category 1    0.722          156.000
      Category 2    0.181           39.000
      Category 3    0.074           16.000
      Category 4    0.023            5.000
    PFC20
      Category 1    0.712          153.000
      Category 2    0.177           38.000
      Category 3    0.088           19.000
      Category 4    0.023            5.000
    PFC21
      Category 1    0.847          182.000
      Category 2    0.107           23.000
      Category 3    0.028            6.000
      Category 4    0.014            3.000
      Category 5    0.005            1.000
    PFC22
      Category 1    0.644          139.000
      Category 2    0.269           58.000
      Category 3    0.079           17.000
      Category 4    0.005            1.000
      Category 5    0.005            1.000
    PFC23
      Category 1    0.671          145.000
      Category 2    0.190           41.000
      Category 3    0.097           21.000
      Category 4    0.037            8.000
      Category 5    0.005            1.000

  Group MALE
    PFC01
      Category 1    0.727          168.000
      Category 2    0.234           54.000
      Category 3    0.030            7.000
      Category 4    0.009            2.000
    PFC02
      Category 1    0.268           62.000
      Category 2    0.524          121.000
      Category 3    0.169           39.000
      Category 4    0.030            7.000
      Category 5    0.009            2.000
    PFC03
      Category 1    0.719          166.000
      Category 2    0.268           62.000
      Category 3    0.013            3.000
    PFC04
      Category 1    0.169           39.000
      Category 2    0.442          102.000
      Category 3    0.273           63.000
      Category 4    0.091           21.000
      Category 5    0.026            6.000
    PFC05
      Category 1    0.589          136.000
      Category 2    0.333           77.000
      Category 3    0.043           10.000
      Category 4    0.022            5.000
      Category 5    0.013            3.000
    PFC06
      Category 1    0.439          101.000
      Category 2    0.378           87.000
      Category 3    0.100           23.000
      Category 4    0.052           12.000
      Category 5    0.030            7.000
    PFC07
      Category 1    0.100           23.000
      Category 2    0.377           87.000
      Category 3    0.364           84.000
      Category 4    0.117           27.000
      Category 5    0.043           10.000
    PFC08
      Category 1    0.290           67.000
      Category 2    0.416           96.000
      Category 3    0.212           49.000
      Category 4    0.061           14.000
      Category 5    0.022            5.000
    PFC09
      Category 1    0.817          188.000
      Category 2    0.165           38.000
      Category 3    0.017            4.000
    PFC10
      Category 1    0.203           47.000
      Category 2    0.494          114.000
      Category 3    0.251           58.000
      Category 4    0.030            7.000
      Category 5    0.022            5.000
    PFC11
      Category 1    0.410           94.000
      Category 2    0.367           84.000
      Category 3    0.166           38.000
      Category 4    0.048           11.000
      Category 5    0.009            2.000
    PFC12
      Category 1    0.567          131.000
      Category 2    0.320           74.000
      Category 3    0.074           17.000
      Category 4    0.039            9.000
    PFC13
      Category 1    0.532          123.000
      Category 2    0.320           74.000
      Category 3    0.113           26.000
      Category 4    0.026            6.000
      Category 5    0.009            2.000
    PFC14
      Category 1    0.645          149.000
      Category 2    0.212           49.000
      Category 3    0.082           19.000
      Category 4    0.035            8.000
      Category 5    0.026            6.000
    PFC15
      Category 1    0.537          123.000
      Category 2    0.310           71.000
      Category 3    0.061           14.000
      Category 4    0.031            7.000
      Category 5    0.061           14.000
    PFC17
      Category 1    0.603          138.000
      Category 2    0.345           79.000
      Category 3    0.052           12.000
    PFC18
      Category 1    0.782          179.000
      Category 2    0.157           36.000
      Category 3    0.026            6.000
      Category 4    0.035            8.000
    PFC19
      Category 1    0.678          154.000
      Category 2    0.185           42.000
      Category 3    0.101           23.000
      Category 4    0.035            8.000
    PFC20
      Category 1    0.680          155.000
      Category 2    0.193           44.000
      Category 3    0.083           19.000
      Category 4    0.044           10.000
    PFC21
      Category 1    0.750          171.000
      Category 2    0.145           33.000
      Category 3    0.070           16.000
      Category 4    0.026            6.000
      Category 5    0.009            2.000
    PFC22
      Category 1    0.504          115.000
      Category 2    0.368           84.000
      Category 3    0.096           22.000
      Category 4    0.026            6.000
      Category 5    0.004            1.000
    PFC23
      Category 1    0.588          134.000
      Category 2    0.193           44.000
      Category 3    0.136           31.000
      Category 4    0.057           13.000
      Category 5    0.026            6.000


SAMPLE STATISTICS


     ESTIMATED SAMPLE STATISTICS FOR FEMALE


           MEANS/INTERCEPTS/THRESHOLDS
              PFC01$1       PFC01$2       PFC01$3       PFC02$1       PFC02$2
              ________      ________      ________      ________      ________
                0.671         1.560         2.607        -0.469         1.073


           MEANS/INTERCEPTS/THRESHOLDS
              PFC02$3       PFC02$4       PFC03$1       PFC03$2       PFC04$1
              ________      ________      ________      ________      ________
                1.921         2.360         0.715         1.999        -0.611


           MEANS/INTERCEPTS/THRESHOLDS
              PFC04$2       PFC04$3       PFC04$4       PFC05$1       PFC05$2
              ________      ________      ________      ________      ________
                0.583         1.686         2.359         0.296         1.305


           MEANS/INTERCEPTS/THRESHOLDS
              PFC05$3       PFC05$4       PFC06$1       PFC06$2       PFC06$3
              ________      ________      ________      ________      ________
                1.999         2.206        -0.029         0.977         1.453


           MEANS/INTERCEPTS/THRESHOLDS
              PFC06$4       PFC07$1       PFC07$2       PFC07$3       PFC07$4
              ________      ________      ________      ________      ________
                1.853        -1.179        -0.081         1.070         1.851


           MEANS/INTERCEPTS/THRESHOLDS
              PFC08$1       PFC08$2       PFC08$3       PFC08$4       PFC09$1
              ________      ________      ________      ________      ________
               -0.364         1.011         1.790         2.359         1.176


           MEANS/INTERCEPTS/THRESHOLDS
              PFC09$2       PFC10$1       PFC10$2       PFC10$3       PFC10$4
              ________      ________      ________      ________      ________
                2.202        -0.682         0.597         1.451         1.919


           MEANS/INTERCEPTS/THRESHOLDS
              PFC11$1       PFC11$2       PFC11$3       PFC11$4       PFC12$1
              ________      ________      ________      ________      ________
                0.029         1.131         1.849         2.357         0.292


           MEANS/INTERCEPTS/THRESHOLDS
              PFC12$2       PFC12$3       PFC13$1       PFC13$2       PFC13$3
              ________      ________      ________      ________      ________
                1.485         2.359         0.173         1.134         1.997


           MEANS/INTERCEPTS/THRESHOLDS
              PFC13$4       PFC14$1       PFC14$2       PFC14$3       PFC14$4
              ________      ________      ________      ________      ________
                2.359         0.851         1.736         2.089         2.605


           MEANS/INTERCEPTS/THRESHOLDS
              PFC15$1       PFC15$2       PFC15$3       PFC15$4       PFC17$1
              ________      ________      ________      ________      ________
                0.482         1.271         1.593         1.682         0.270


           MEANS/INTERCEPTS/THRESHOLDS
              PFC17$2       PFC18$1       PFC18$2       PFC18$3       PFC19$1
              ________      ________      ________      ________      ________
                1.446         0.931         1.732         2.602         0.589


           MEANS/INTERCEPTS/THRESHOLDS
              PFC19$2       PFC19$3       PFC20$1       PFC20$2       PFC20$3
              ________      ________      ________      ________      ________
                1.298         1.993         0.558         1.218         1.991


           MEANS/INTERCEPTS/THRESHOLDS
              PFC21$1       PFC21$2       PFC21$3       PFC21$4       PFC22$1
              ________      ________      ________      ________      ________
                1.022         1.680         2.083         2.601         0.368


           MEANS/INTERCEPTS/THRESHOLDS
              PFC22$2       PFC22$3       PFC22$4       PFC23$1       PFC23$2
              ________      ________      ________      ________      ________
                1.353         2.355         2.602         0.443         1.085


           MEANS/INTERCEPTS/THRESHOLDS
              PFC23$3       PFC23$4
              ________      ________
                1.732         2.602


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC01         PFC02         PFC03         PFC04         PFC05
              ________      ________      ________      ________      ________
 PFC01
 PFC02          0.311
 PFC03          0.568         0.278
 PFC04          0.240         0.321         0.224
 PFC05          0.518         0.406         0.280         0.357
 PFC06          0.323         0.376         0.119         0.397         0.311
 PFC07          0.165         0.540         0.245         0.416         0.272
 PFC08          0.285         0.253         0.150         0.731         0.399
 PFC09          0.608         0.122         0.726         0.252         0.315
 PFC10          0.540         0.374         0.143         0.288         0.419
 PFC11          0.225         0.345         0.185         0.359         0.278
 PFC12          0.252         0.450         0.111         0.100         0.210
 PFC13          0.220         0.345         0.134         0.227         0.344
 PFC14          0.206         0.300         0.244         0.526         0.337
 PFC15          0.362         0.228         0.178         0.316         0.497
 PFC17          0.403         0.392         0.433         0.302         0.420
 PFC18          0.225         0.386         0.115         0.203         0.144
 PFC19          0.305         0.563         0.337         0.323         0.373
 PFC20          0.224         0.388         0.246         0.157         0.248
 PFC21          0.130         0.354         0.091         0.403         0.195
 PFC22          0.569         0.534         0.452         0.566         0.455
 PFC23          0.459         0.595         0.337         0.441         0.429


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC06         PFC07         PFC08         PFC09         PFC10
              ________      ________      ________      ________      ________
 PFC07          0.394
 PFC08          0.297         0.402
 PFC09          0.083         0.164         0.220
 PFC10          0.172         0.204         0.355         0.153
 PFC11          0.230         0.406         0.358         0.203         0.395
 PFC12          0.355         0.337         0.119         0.230         0.346
 PFC13          0.282         0.339         0.198         0.193         0.365
 PFC14          0.327         0.304         0.439         0.433         0.378
 PFC15          0.255         0.239         0.327         0.354         0.321
 PFC17          0.195         0.382         0.291         0.381         0.265
 PFC18          0.176         0.411         0.360         0.392         0.290
 PFC19          0.363         0.507         0.377         0.284         0.408
 PFC20          0.221         0.404         0.124         0.133         0.224
 PFC21          0.259         0.447         0.330         0.153         0.192
 PFC22          0.411         0.513         0.541         0.400         0.403
 PFC23          0.370         0.593         0.397         0.224         0.300


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC11         PFC12         PFC13         PFC14         PFC15
              ________      ________      ________      ________      ________
 PFC12          0.380
 PFC13          0.349         0.543
 PFC14          0.551         0.480         0.472
 PFC15          0.297         0.384         0.454         0.487
 PFC17          0.236         0.417         0.465         0.392         0.386
 PFC18          0.395         0.779         0.555         0.393         0.312
 PFC19          0.446         0.578         0.620         0.534         0.465
 PFC20          0.254         0.366         0.332         0.229         0.255
 PFC21          0.343         0.339         0.184         0.476         0.296
 PFC22          0.415         0.381         0.354         0.644         0.467
 PFC23          0.425         0.286         0.391         0.476         0.366


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC17         PFC18         PFC19         PFC20         PFC21
              ________      ________      ________      ________      ________
 PFC18          0.557
 PFC19          0.516         0.620
 PFC20          0.339         0.447         0.522
 PFC21          0.522         0.351         0.298         0.393
 PFC22          0.481         0.345         0.572         0.360         0.544
 PFC23          0.489         0.348         0.551         0.405         0.560


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC22         PFC23
              ________      ________
 PFC23          0.715


     ESTIMATED SAMPLE STATISTICS FOR MALE


           MEANS/INTERCEPTS/THRESHOLDS
              PFC01$1       PFC01$2       PFC01$3       PFC02$1       PFC02$2
              ________      ________      ________      ________      ________
                0.605         1.763         2.380        -0.618         0.814


           MEANS/INTERCEPTS/THRESHOLDS
              PFC02$3       PFC02$4       PFC03$1       PFC03$2       PFC04$1
              ________      ________      ________      ________      ________
                1.763         2.380         0.579         2.227        -0.959


           MEANS/INTERCEPTS/THRESHOLDS
              PFC04$2       PFC04$3       PFC04$4       PFC05$1       PFC05$2
              ________      ________      ________      ________      ________
                0.280         1.191         1.944         0.224         1.419


           MEANS/INTERCEPTS/THRESHOLDS
              PFC05$3       PFC05$4       PFC06$1       PFC06$2       PFC06$3
              ________      ________      ________      ________      ________
                1.817         2.227        -0.153         0.905         1.388


           MEANS/INTERCEPTS/THRESHOLDS
              PFC06$4       PFC07$1       PFC07$2       PFC07$3       PFC07$4
              ________      ________      ________      ________      ________
                1.874        -1.284        -0.060         0.994         1.714


           MEANS/INTERCEPTS/THRESHOLDS
              PFC08$1       PFC08$2       PFC08$3       PFC08$4       PFC09$1
              ________      ________      ________      ________      ________
               -0.553         0.541         1.390         2.021         0.905


           MEANS/INTERCEPTS/THRESHOLDS
              PFC09$2       PFC10$1       PFC10$2       PFC10$3       PFC10$4
              ________      ________      ________      ________      ________
                2.111        -0.829         0.516         1.626         2.021


           MEANS/INTERCEPTS/THRESHOLDS
              PFC11$1       PFC11$2       PFC11$3       PFC11$4       PFC12$1
              ________      ________      ________      ________      ________
               -0.226         0.763         1.582         2.377         0.169


           MEANS/INTERCEPTS/THRESHOLDS
              PFC12$2       PFC12$3       PFC13$1       PFC13$2       PFC13$3
              ________      ________      ________      ________      ________
                1.213         1.763         0.081         1.049         1.817


           MEANS/INTERCEPTS/THRESHOLDS
              PFC13$4       PFC14$1       PFC14$2       PFC14$3       PFC14$4
              ________      ________      ________      ________      ________
                2.380         0.372         1.068         1.550         1.944


           MEANS/INTERCEPTS/THRESHOLDS
              PFC15$1       PFC15$2       PFC15$3       PFC15$4       PFC17$1
              ________      ________      ________      ________      ________
                0.093         1.024         1.330         1.545         0.260


           MEANS/INTERCEPTS/THRESHOLDS
              PFC17$2       PFC18$1       PFC18$2       PFC18$3       PFC19$1
              ________      ________      ________      ________      ________
                1.622         0.778         1.545         1.813         0.463


           MEANS/INTERCEPTS/THRESHOLDS
              PFC19$2       PFC19$3       PFC20$1       PFC20$2       PFC20$3
              ________      ________      ________      ________      ________
                1.096         1.809         0.467         1.140         1.708


           MEANS/INTERCEPTS/THRESHOLDS
              PFC21$1       PFC21$2       PFC21$3       PFC21$4       PFC22$1
              ________      ________      ________      ________      ________
                0.674         1.252         1.811         2.375         0.011


           MEANS/INTERCEPTS/THRESHOLDS
              PFC22$2       PFC22$3       PFC22$4       PFC23$1       PFC23$2
              ________      ________      ________      ________      ________
                1.140         1.871         2.621         0.222         0.775


           MEANS/INTERCEPTS/THRESHOLDS
              PFC23$3       PFC23$4
              ________      ________
                1.383         1.938


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC01         PFC02         PFC03         PFC04         PFC05
              ________      ________      ________      ________      ________
 PFC01
 PFC02          0.163
 PFC03          0.570         0.408
 PFC04          0.230         0.363         0.363
 PFC05          0.381         0.539         0.482         0.481
 PFC06          0.187         0.340         0.386         0.350         0.377
 PFC07          0.152         0.447         0.405         0.489         0.475
 PFC08          0.216         0.384         0.305         0.716         0.410
 PFC09          0.535         0.318         0.850         0.363         0.408
 PFC10          0.463         0.204         0.295        -0.067         0.257
 PFC11          0.336         0.309         0.312         0.437         0.286
 PFC12          0.200         0.507         0.381         0.484         0.436
 PFC13          0.180         0.408         0.285         0.281         0.336
 PFC14          0.212         0.380         0.403         0.560         0.358
 PFC15          0.353         0.334         0.373         0.288         0.312
 PFC17          0.251         0.471         0.520         0.341         0.463
 PFC18          0.311         0.580         0.489         0.506         0.458
 PFC19          0.364         0.441         0.426         0.407         0.523
 PFC20          0.284         0.428         0.536         0.457         0.513
 PFC21          0.238         0.342         0.349         0.417         0.474
 PFC22          0.497         0.262         0.348         0.398         0.448
 PFC23          0.400         0.366         0.452         0.445         0.516


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC06         PFC07         PFC08         PFC09         PFC10
              ________      ________      ________      ________      ________
 PFC07          0.241
 PFC08          0.407         0.483
 PFC09          0.236         0.381         0.337
 PFC10          0.027         0.098         0.018         0.180
 PFC11          0.266         0.382         0.414         0.355         0.154
 PFC12          0.442         0.343         0.440         0.365         0.186
 PFC13          0.236         0.329         0.355         0.268         0.202
 PFC14          0.299         0.286         0.481         0.420         0.126
 PFC15          0.259         0.251         0.279         0.397         0.297
 PFC17          0.257         0.355         0.334         0.463         0.298
 PFC18          0.437         0.325         0.366         0.509         0.265
 PFC19          0.357         0.397         0.414         0.372         0.308
 PFC20          0.379         0.440         0.417         0.455         0.221
 PFC21          0.176         0.354         0.362         0.413         0.203
 PFC22          0.201         0.287         0.393         0.300         0.333
 PFC23          0.307         0.556         0.448         0.519         0.271


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC11         PFC12         PFC13         PFC14         PFC15
              ________      ________      ________      ________      ________
 PFC12          0.439
 PFC13          0.443         0.721
 PFC14          0.450         0.453         0.413
 PFC15          0.332         0.405         0.431         0.421
 PFC17          0.294         0.530         0.421         0.394         0.458
 PFC18          0.345         0.859         0.658         0.417         0.476
 PFC19          0.423         0.588         0.518         0.412         0.539
 PFC20          0.433         0.570         0.521         0.357         0.521
 PFC21          0.487         0.405         0.449         0.474         0.374
 PFC22          0.471         0.448         0.380         0.594         0.512
 PFC23          0.456         0.523         0.412         0.402         0.367


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC17         PFC18         PFC19         PFC20         PFC21
              ________      ________      ________      ________      ________
 PFC18          0.535
 PFC19          0.547         0.657
 PFC20          0.539         0.676         0.569
 PFC21          0.329         0.508         0.497         0.562
 PFC22          0.395         0.468         0.561         0.484         0.442
 PFC23          0.382         0.569         0.542         0.599         0.481


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC22         PFC23
              ________      ________
 PFC23          0.625


THE MODEL ESTIMATION TERMINATED NORMALLY



MODEL FIT INFORMATION

Number of Free Parameters                      171

Chi-Square Test of Model Fit

          Value                            665.513*
          Degrees of Freedom                   445
          P-Value                           0.0000

Chi-Square Contribution From Each Group

          FEMALE                           370.527
          MALE                             294.985

Chi-Square Test for Difference Testing

          Value                            150.239*
          Degrees of Freedom                   108
          P-Value                           0.0045

*   The chi-square value for MLM, MLMV, MLR, ULSMV, WLSM and WLSMV cannot be used
    for chi-square difference testing in the regular way.  MLM, MLR and WLSM
    chi-square difference testing is described on the Mplus website.  MLMV, WLSMV,
    and ULSMV difference testing is done using the DIFFTEST option.  The DIFFTEST
    option assumes the models are nested.  The NESTED option can be used to verify
    that the models are nested.

RMSEA (Root Mean Square Error Of Approximation)

          Estimate                           0.047
          90 Percent C.I.                    0.039  0.054
          Probability RMSEA <= .05           0.750

CFI/TLI

          CFI                                0.969
          TLI                                0.968

Chi-Square Test of Model Fit for the Baseline Model

          Value                           7531.301
          Degrees of Freedom                   462
          P-Value                           0.0000

SRMR (Standardized Root Mean Square Residual)

          Value                              0.064

Optimum Function Value for Weighted Least-Squares Estimator

          Value                     0.60988865D+00



MODEL RESULTS

                                                    Two-Tailed
                    Estimate       S.E.  Est./S.E.    P-Value

Group FEMALE

 F1       BY
    PFC01             -0.041      0.077     -0.525      0.599
    PFC02              0.248      0.075      3.325      0.001
    PFC03              0.105      0.060      1.754      0.079
    PFC04              1.949      0.378      5.158      0.000
    PFC05              0.288      0.071      4.062      0.000
    PFC06              0.293      0.069      4.228      0.000
    PFC07              0.499      0.079      6.288      0.000
    PFC08              1.250      0.186      6.731      0.000
    PFC09              0.136      0.081      1.681      0.093
    PFC10             -0.155      0.068     -2.272      0.023
    PFC11              0.378      0.077      4.930      0.000
    PFC12             -0.009      0.064     -0.135      0.893
    PFC13              0.001      0.066      0.016      0.987
    PFC14              0.670      0.118      5.681      0.000
    PFC15              0.116      0.067      1.738      0.082
    PFC17              0.043      0.070      0.608      0.543
    PFC18             -0.019      0.081     -0.239      0.811
    PFC19              0.178      0.097      1.831      0.067
    PFC20              0.137      0.062      2.200      0.028
    PFC21              0.378      0.077      4.897      0.000
    PFC22              0.650      0.112      5.819      0.000
    PFC23              0.567      0.119      4.773      0.000

 F2       BY
    PFC01              1.358      0.234      5.806      0.000
    PFC02              0.325      0.096      3.377      0.001
    PFC03              0.899      0.145      6.212      0.000
    PFC04             -0.049      0.048     -1.021      0.307
    PFC05              0.489      0.089      5.494      0.000
    PFC06              0.140      0.083      1.686      0.092
    PFC07              0.159      0.078      2.034      0.042
    PFC08              0.055      0.087      0.637      0.524
    PFC09              1.102      0.241      4.577      0.000
    PFC10              0.698      0.116      6.006      0.000
    PFC11              0.173      0.080      2.160      0.031
    PFC12             -0.169      0.075     -2.253      0.024
    PFC13              0.128      0.086      1.491      0.136
    PFC14              0.252      0.116      2.184      0.029
    PFC15              0.438      0.089      4.943      0.000
    PFC17              0.488      0.107      4.572      0.000
    PFC18              0.059      0.110      0.536      0.592
    PFC19              0.478      0.121      3.949      0.000
    PFC20              0.225      0.078      2.896      0.004
    PFC21              0.233      0.104      2.238      0.025
    PFC22              0.892      0.158      5.636      0.000
    PFC23              0.625      0.130      4.793      0.000

 F3       BY
    PFC01             -0.150      0.089     -1.681      0.093
    PFC02              0.514      0.076      6.789      0.000
    PFC03             -0.131      0.075     -1.748      0.081
    PFC04             -0.144      0.054     -2.657      0.008
    PFC05              0.175      0.071      2.469      0.014
    PFC06              0.246      0.068      3.629      0.000
    PFC07              0.365      0.083      4.387      0.000
    PFC08             -0.014      0.090     -0.153      0.878
    PFC09             -0.139      0.094     -1.491      0.136
    PFC10              0.199      0.078      2.542      0.011
    PFC11              0.362      0.081      4.478      0.000
    PFC12              1.932      0.304      6.365      0.000
    PFC13              0.936      0.106      8.849      0.000
    PFC14              0.477      0.107      4.443      0.000
    PFC15              0.397      0.086      4.590      0.000
    PFC17              0.537      0.093      5.757      0.000
    PFC18              1.617      0.274      5.901      0.000
    PFC19              0.981      0.137      7.163      0.000
    PFC20              0.496      0.091      5.476      0.000
    PFC21              0.400      0.111      3.615      0.000
    PFC22              0.335      0.099      3.392      0.001
    PFC23              0.422      0.110      3.837      0.000

 F2       WITH
    F1                 0.455      0.051      8.880      0.000

 F3       WITH
    F1                 0.330      0.061      5.437      0.000
    F2                 0.370      0.056      6.567      0.000

 Means
    F1                 0.000      0.000    999.000    999.000
    F2                 0.000      0.000    999.000    999.000
    F3                 0.000      0.000    999.000    999.000

 Thresholds
    PFC01$1            1.173      0.202      5.792      0.000
    PFC01$2            2.720      0.375      7.244      0.000
    PFC01$3            3.917      0.586      6.680      0.000
    PFC02$1           -0.606      0.104     -5.843      0.000
    PFC02$2            1.415      0.136     10.398      0.000
    PFC02$3            2.647      0.231     11.466      0.000
    PFC02$4            3.342      0.305     10.951      0.000
    PFC03$1            0.801      0.129      6.228      0.000
    PFC03$2            2.291      0.298      7.700      0.000
    PFC04$1           -1.416      0.277     -5.109      0.000
    PFC04$2            1.278      0.265      4.816      0.000
    PFC04$3            3.498      0.616      5.674      0.000
    PFC04$4            5.134      0.904      5.680      0.000
    PFC05$1            0.458      0.090      5.091      0.000
    PFC05$2            1.721      0.140     12.328      0.000
    PFC05$3            2.307      0.185     12.476      0.000
    PFC05$4            2.694      0.229     11.777      0.000
    PFC06$1           -0.009      0.077     -0.124      0.902
    PFC06$2            1.169      0.108     10.871      0.000
    PFC06$3            1.717      0.140     12.253      0.000
    PFC06$4            2.217      0.180     12.298      0.000
    PFC07$1           -1.530      0.129    -11.878      0.000
    PFC07$2            0.037      0.094      0.397      0.692
    PFC07$3            1.535      0.121     12.690      0.000
    PFC07$4            2.565      0.181     14.204      0.000
    PFC08$1           -0.560      0.131     -4.279      0.000
    PFC08$2            1.525      0.186      8.181      0.000
    PFC08$3            2.924      0.302      9.669      0.000
    PFC08$4            3.973      0.424      9.367      0.000
    PFC09$1            1.453      0.271      5.361      0.000
    PFC09$2            2.831      0.517      5.477      0.000
    PFC10$1           -0.856      0.105     -8.161      0.000
    PFC10$2            0.791      0.107      7.364      0.000
    PFC10$3            2.000      0.162     12.369      0.000
    PFC10$4            2.549      0.205     12.421      0.000
    PFC11$1           -0.001      0.085     -0.011      0.991
    PFC11$2            1.295      0.125     10.387      0.000
    PFC11$3            2.267      0.204     11.096      0.000
    PFC11$4            3.077      0.298     10.340      0.000
    PFC12$1            0.624      0.202      3.094      0.002
    PFC12$2            2.924      0.434      6.731      0.000
    PFC12$3            4.164      0.647      6.435      0.000
    PFC13$1            0.280      0.108      2.594      0.009
    PFC13$2            1.620      0.154     10.550      0.000
    PFC13$3            2.741      0.233     11.783      0.000
    PFC13$4            3.397      0.295     11.512      0.000
    PFC14$1            1.175      0.152      7.724      0.000
    PFC14$2            2.434      0.240     10.161      0.000
    PFC14$3            3.171      0.302     10.508      0.000
    PFC14$4            3.914      0.406      9.645      0.000
    PFC15$1            0.467      0.095      4.929      0.000
    PFC15$2            1.535      0.141     10.856      0.000
    PFC15$3            1.918      0.163     11.735      0.000
    PFC15$4            2.120      0.182     11.662      0.000
    PFC17$1            0.477      0.101      4.721      0.000
    PFC17$2            2.083      0.192     10.851      0.000
    PFC18$1            1.721      0.292      5.892      0.000
    PFC18$2            3.147      0.455      6.911      0.000
    PFC18$3            3.741      0.524      7.142      0.000
    PFC19$1            1.081      0.163      6.634      0.000
    PFC19$2            2.225      0.221     10.087      0.000
    PFC19$3            3.432      0.304     11.271      0.000
    PFC20$1            0.653      0.093      6.987      0.000
    PFC20$2            1.341      0.134     10.023      0.000
    PFC20$3            1.966      0.202      9.730      0.000
    PFC21$1            1.222      0.135      9.069      0.000
    PFC21$2            2.003      0.189     10.604      0.000
    PFC21$3            2.653      0.249     10.674      0.000
    PFC21$4            3.364      0.356      9.455      0.000
    PFC22$1            0.622      0.161      3.875      0.000
    PFC22$2            2.656      0.243     10.915      0.000
    PFC22$3            4.325      0.357     12.109      0.000
    PFC22$4            5.213      0.483     10.800      0.000
    PFC23$1            0.774      0.136      5.693      0.000
    PFC23$2            1.757      0.179      9.817      0.000
    PFC23$3            2.791      0.262     10.657      0.000
    PFC23$4            3.838      0.406      9.453      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              1.000      0.000    999.000    999.000
    PFC02              1.000      0.000    999.000    999.000
    PFC03              1.000      0.000    999.000    999.000
    PFC04              1.000      0.000    999.000    999.000
    PFC05              1.000      0.000    999.000    999.000
    PFC06              1.000      0.000    999.000    999.000
    PFC07              1.000      0.000    999.000    999.000
    PFC08              1.000      0.000    999.000    999.000
    PFC09              1.000      0.000    999.000    999.000
    PFC10              1.000      0.000    999.000    999.000
    PFC11              1.000      0.000    999.000    999.000
    PFC12              1.000      0.000    999.000    999.000
    PFC13              1.000      0.000    999.000    999.000
    PFC14              1.000      0.000    999.000    999.000
    PFC15              1.000      0.000    999.000    999.000
    PFC17              1.000      0.000    999.000    999.000
    PFC18              1.000      0.000    999.000    999.000
    PFC19              1.000      0.000    999.000    999.000
    PFC20              1.000      0.000    999.000    999.000
    PFC21              1.000      0.000    999.000    999.000
    PFC22              1.000      0.000    999.000    999.000
    PFC23              1.000      0.000    999.000    999.000

Group MALE

 F1       BY
    PFC01             -0.041      0.077     -0.525      0.599
    PFC02              0.248      0.075      3.325      0.001
    PFC03              0.105      0.060      1.754      0.079
    PFC04              1.949      0.378      5.158      0.000
    PFC05              0.288      0.071      4.062      0.000
    PFC06              0.293      0.069      4.228      0.000
    PFC07              0.499      0.079      6.288      0.000
    PFC08              1.250      0.186      6.731      0.000
    PFC09              0.136      0.081      1.681      0.093
    PFC10             -0.155      0.068     -2.272      0.023
    PFC11              0.378      0.077      4.930      0.000
    PFC12             -0.009      0.064     -0.135      0.893
    PFC13              0.001      0.066      0.016      0.987
    PFC14              0.670      0.118      5.681      0.000
    PFC15              0.116      0.067      1.738      0.082
    PFC17              0.043      0.070      0.608      0.543
    PFC18             -0.019      0.081     -0.239      0.811
    PFC19              0.178      0.097      1.831      0.067
    PFC20              0.137      0.062      2.200      0.028
    PFC21              0.378      0.077      4.897      0.000
    PFC22              0.650      0.112      5.819      0.000
    PFC23              0.567      0.119      4.773      0.000

 F2       BY
    PFC01              1.358      0.234      5.806      0.000
    PFC02              0.325      0.096      3.377      0.001
    PFC03              0.899      0.145      6.212      0.000
    PFC04             -0.049      0.048     -1.021      0.307
    PFC05              0.489      0.089      5.494      0.000
    PFC06              0.140      0.083      1.686      0.092
    PFC07              0.159      0.078      2.034      0.042
    PFC08              0.055      0.087      0.637      0.524
    PFC09              1.102      0.241      4.577      0.000
    PFC10              0.698      0.116      6.006      0.000
    PFC11              0.173      0.080      2.160      0.031
    PFC12             -0.169      0.075     -2.253      0.024
    PFC13              0.128      0.086      1.491      0.136
    PFC14              0.252      0.116      2.184      0.029
    PFC15              0.438      0.089      4.943      0.000
    PFC17              0.488      0.107      4.572      0.000
    PFC18              0.059      0.110      0.536      0.592
    PFC19              0.478      0.121      3.949      0.000
    PFC20              0.225      0.078      2.896      0.004
    PFC21              0.233      0.104      2.238      0.025
    PFC22              0.892      0.158      5.636      0.000
    PFC23              0.625      0.130      4.793      0.000

 F3       BY
    PFC01             -0.150      0.089     -1.681      0.093
    PFC02              0.514      0.076      6.789      0.000
    PFC03             -0.131      0.075     -1.748      0.081
    PFC04             -0.144      0.054     -2.657      0.008
    PFC05              0.175      0.071      2.469      0.014
    PFC06              0.246      0.068      3.629      0.000
    PFC07              0.365      0.083      4.387      0.000
    PFC08             -0.014      0.090     -0.153      0.878
    PFC09             -0.139      0.094     -1.491      0.136
    PFC10              0.199      0.078      2.542      0.011
    PFC11              0.362      0.081      4.478      0.000
    PFC12              1.932      0.304      6.365      0.000
    PFC13              0.936      0.106      8.849      0.000
    PFC14              0.477      0.107      4.443      0.000
    PFC15              0.397      0.086      4.590      0.000
    PFC17              0.537      0.093      5.757      0.000
    PFC18              1.617      0.274      5.901      0.000
    PFC19              0.981      0.137      7.163      0.000
    PFC20              0.496      0.091      5.476      0.000
    PFC21              0.400      0.111      3.615      0.000
    PFC22              0.335      0.099      3.392      0.001
    PFC23              0.422      0.110      3.837      0.000

 F2       WITH
    F1                 0.324      0.098      3.302      0.001

 F3       WITH
    F1                 0.604      0.121      4.979      0.000
    F2                 0.417      0.091      4.581      0.000

 Means
    F1                 0.359      0.114      3.147      0.002
    F2                 0.296      0.120      2.455      0.014
    F3                 0.173      0.125      1.383      0.167

 Thresholds
    PFC01$1            1.173      0.202      5.792      0.000
    PFC01$2            2.720      0.375      7.244      0.000
    PFC01$3            3.917      0.586      6.680      0.000
    PFC02$1           -0.606      0.104     -5.843      0.000
    PFC02$2            1.415      0.136     10.398      0.000
    PFC02$3            2.647      0.231     11.466      0.000
    PFC02$4            3.342      0.305     10.951      0.000
    PFC03$1            0.801      0.129      6.228      0.000
    PFC03$2            2.291      0.298      7.700      0.000
    PFC04$1           -1.416      0.277     -5.109      0.000
    PFC04$2            1.278      0.265      4.816      0.000
    PFC04$3            3.498      0.616      5.674      0.000
    PFC04$4            5.134      0.904      5.680      0.000
    PFC05$1            0.458      0.090      5.091      0.000
    PFC05$2            1.721      0.140     12.328      0.000
    PFC05$3            2.307      0.185     12.476      0.000
    PFC05$4            2.694      0.229     11.777      0.000
    PFC06$1           -0.009      0.077     -0.124      0.902
    PFC06$2            1.169      0.108     10.871      0.000
    PFC06$3            1.717      0.140     12.253      0.000
    PFC06$4            2.217      0.180     12.298      0.000
    PFC07$1           -1.530      0.129    -11.878      0.000
    PFC07$2            0.037      0.094      0.397      0.692
    PFC07$3            1.535      0.121     12.690      0.000
    PFC07$4            2.565      0.181     14.204      0.000
    PFC08$1           -0.560      0.131     -4.279      0.000
    PFC08$2            1.525      0.186      8.181      0.000
    PFC08$3            2.924      0.302      9.669      0.000
    PFC08$4            3.973      0.424      9.367      0.000
    PFC09$1            1.453      0.271      5.361      0.000
    PFC09$2            2.831      0.517      5.477      0.000
    PFC10$1           -0.856      0.105     -8.161      0.000
    PFC10$2            0.791      0.107      7.364      0.000
    PFC10$3            2.000      0.162     12.369      0.000
    PFC10$4            2.549      0.205     12.421      0.000
    PFC11$1           -0.001      0.085     -0.011      0.991
    PFC11$2            1.295      0.125     10.387      0.000
    PFC11$3            2.267      0.204     11.096      0.000
    PFC11$4            3.077      0.298     10.340      0.000
    PFC12$1            0.624      0.202      3.094      0.002
    PFC12$2            2.924      0.434      6.731      0.000
    PFC12$3            4.164      0.647      6.435      0.000
    PFC13$1            0.280      0.108      2.594      0.009
    PFC13$2            1.620      0.154     10.550      0.000
    PFC13$3            2.741      0.233     11.783      0.000
    PFC13$4            3.397      0.295     11.512      0.000
    PFC14$1            1.175      0.152      7.724      0.000
    PFC14$2            2.434      0.240     10.161      0.000
    PFC14$3            3.171      0.302     10.508      0.000
    PFC14$4            3.914      0.406      9.645      0.000
    PFC15$1            0.467      0.095      4.929      0.000
    PFC15$2            1.535      0.141     10.856      0.000
    PFC15$3            1.918      0.163     11.735      0.000
    PFC15$4            2.120      0.182     11.662      0.000
    PFC17$1            0.477      0.101      4.721      0.000
    PFC17$2            2.083      0.192     10.851      0.000
    PFC18$1            1.721      0.292      5.892      0.000
    PFC18$2            3.147      0.455      6.911      0.000
    PFC18$3            3.741      0.524      7.142      0.000
    PFC19$1            1.081      0.163      6.634      0.000
    PFC19$2            2.225      0.221     10.087      0.000
    PFC19$3            3.432      0.304     11.271      0.000
    PFC20$1            0.653      0.093      6.987      0.000
    PFC20$2            1.341      0.134     10.023      0.000
    PFC20$3            1.966      0.202      9.730      0.000
    PFC21$1            1.222      0.135      9.069      0.000
    PFC21$2            2.003      0.189     10.604      0.000
    PFC21$3            2.653      0.249     10.674      0.000
    PFC21$4            3.364      0.356      9.455      0.000
    PFC22$1            0.622      0.161      3.875      0.000
    PFC22$2            2.656      0.243     10.915      0.000
    PFC22$3            4.325      0.357     12.109      0.000
    PFC22$4            5.213      0.483     10.800      0.000
    PFC23$1            0.774      0.136      5.693      0.000
    PFC23$2            1.757      0.179      9.817      0.000
    PFC23$3            2.791      0.262     10.657      0.000
    PFC23$4            3.838      0.406      9.453      0.000

 Variances
    F1                 1.257      0.230      5.462      0.000
    F2                 0.706      0.169      4.176      0.000
    F3                 1.001      0.209      4.783      0.000

 Residual Variances
    PFC01              0.919      0.369      2.491      0.013
    PFC02              1.232      0.258      4.766      0.000
    PFC03              0.105      0.055      1.906      0.057
    PFC04              1.024      0.479      2.135      0.033
    PFC05              0.598      0.129      4.644      0.000
    PFC06              0.997      0.233      4.274      0.000
    PFC07              1.281      0.229      5.599      0.000
    PFC08              1.196      0.286      4.180      0.000
    PFC09              0.321      0.160      2.003      0.045
    PFC10              1.189      0.249      4.768      0.000
    PFC11              1.036      0.240      4.311      0.000
    PFC12              0.747      0.296      2.518      0.012
    PFC13              0.898      0.213      4.214      0.000
    PFC14              1.881      0.495      3.804      0.000
    PFC15              0.952      0.214      4.457      0.000
    PFC17              0.798      0.237      3.370      0.001
    PFC18              0.504      0.236      2.131      0.033
    PFC19              1.214      0.333      3.649      0.000
    PFC20              0.378      0.105      3.598      0.000
    PFC21              1.043      0.252      4.146      0.000
    PFC22              2.075      0.497      4.175      0.000
    PFC23              1.271      0.325      3.912      0.000


QUALITY OF NUMERICAL RESULTS

     Condition Number for the Information Matrix              0.153E-03
       (ratio of smallest to largest eigenvalue)


STANDARDIZED MODEL RESULTS


STDYX Standardization

                                                    Two-Tailed
                    Estimate       S.E.  Est./S.E.    P-Value

Group FEMALE

 F1       BY
    PFC01             -0.025      0.047     -0.529      0.597
    PFC02              0.189      0.055      3.438      0.001
    PFC03              0.078      0.044      1.770      0.077
    PFC04              0.913      0.034     26.715      0.000
    PFC05              0.230      0.055      4.211      0.000
    PFC06              0.260      0.059      4.430      0.000
    PFC07              0.389      0.056      6.972      0.000
    PFC08              0.773      0.057     13.446      0.000
    PFC09              0.090      0.053      1.701      0.089
    PFC10             -0.125      0.053     -2.371      0.018
    PFC11              0.309      0.058      5.349      0.000
    PFC12             -0.004      0.030     -0.135      0.893
    PFC13              0.001      0.047      0.016      0.987
    PFC14              0.452      0.068      6.685      0.000
    PFC15              0.093      0.054      1.724      0.085
    PFC17              0.032      0.053      0.606      0.544
    PFC18             -0.010      0.042     -0.240      0.810
    PFC19              0.107      0.059      1.804      0.071
    PFC20              0.113      0.052      2.187      0.029
    PFC21              0.298      0.057      5.254      0.000
    PFC22              0.362      0.057      6.351      0.000
    PFC23              0.354      0.066      5.337      0.000

 F2       BY
    PFC01              0.831      0.056     14.834      0.000
    PFC02              0.249      0.068      3.657      0.000
    PFC03              0.665      0.063     10.622      0.000
    PFC04             -0.023      0.023     -1.012      0.311
    PFC05              0.389      0.061      6.407      0.000
    PFC06              0.124      0.072      1.715      0.086
    PFC07              0.124      0.061      2.052      0.040
    PFC08              0.034      0.054      0.635      0.526
    PFC09              0.733      0.077      9.505      0.000
    PFC10              0.563      0.071      7.955      0.000
    PFC11              0.141      0.064      2.213      0.027
    PFC12             -0.080      0.035     -2.279      0.023
    PFC13              0.091      0.060      1.519      0.129
    PFC14              0.170      0.075      2.276      0.023
    PFC15              0.350      0.063      5.559      0.000
    PFC17              0.368      0.070      5.262      0.000
    PFC18              0.031      0.058      0.531      0.595
    PFC19              0.288      0.064      4.460      0.000
    PFC20              0.186      0.062      3.015      0.003
    PFC21              0.184      0.080      2.312      0.021
    PFC22              0.497      0.064      7.817      0.000
    PFC23              0.390      0.067      5.864      0.000

 F3       BY
    PFC01             -0.092      0.053     -1.720      0.085
    PFC02              0.393      0.052      7.567      0.000
    PFC03             -0.097      0.055     -1.763      0.078
    PFC04             -0.068      0.028     -2.393      0.017
    PFC05              0.139      0.056      2.466      0.014
    PFC06              0.217      0.058      3.735      0.000
    PFC07              0.285      0.063      4.554      0.000
    PFC08             -0.009      0.055     -0.154      0.878
    PFC09             -0.093      0.062     -1.502      0.133
    PFC10              0.161      0.064      2.526      0.012
    PFC11              0.295      0.062      4.777      0.000
    PFC12              0.910      0.032     28.371      0.000
    PFC13              0.665      0.046     14.578      0.000
    PFC14              0.322      0.065      4.920      0.000
    PFC15              0.317      0.063      5.055      0.000
    PFC17              0.405      0.061      6.652      0.000
    PFC18              0.844      0.050     16.906      0.000
    PFC19              0.590      0.052     11.311      0.000
    PFC20              0.409      0.063      6.497      0.000
    PFC21              0.316      0.081      3.920      0.000
    PFC22              0.187      0.055      3.414      0.001
    PFC23              0.263      0.065      4.040      0.000

 F2       WITH
    F1                 0.455      0.051      8.880      0.000

 F3       WITH
    F1                 0.330      0.061      5.437      0.000
    F2                 0.370      0.056      6.567      0.000

 Means
    F1                 0.000      0.000    999.000    999.000
    F2                 0.000      0.000    999.000    999.000
    F3                 0.000      0.000    999.000    999.000

 Thresholds
    PFC01$1            0.717      0.083      8.601      0.000
    PFC01$2            1.664      0.127     13.075      0.000
    PFC01$3            2.397      0.222     10.780      0.000
    PFC02$1           -0.463      0.081     -5.728      0.000
    PFC02$2            1.081      0.086     12.623      0.000
    PFC02$3            2.023      0.147     13.732      0.000
    PFC02$4            2.554      0.213     12.002      0.000
    PFC03$1            0.593      0.073      8.068      0.000
    PFC03$2            1.695      0.156     10.839      0.000
    PFC04$1           -0.664      0.088     -7.534      0.000
    PFC04$2            0.599      0.083      7.221      0.000
    PFC04$3            1.639      0.131     12.537      0.000
    PFC04$4            2.406      0.212     11.366      0.000
    PFC05$1            0.365      0.067      5.464      0.000
    PFC05$2            1.370      0.094     14.576      0.000
    PFC05$3            1.837      0.132     13.929      0.000
    PFC05$4            2.145      0.175     12.280      0.000
    PFC06$1           -0.008      0.068     -0.124      0.902
    PFC06$2            1.035      0.085     12.191      0.000
    PFC06$3            1.519      0.110     13.816      0.000
    PFC06$4            1.963      0.144     13.604      0.000
    PFC07$1           -1.194      0.101    -11.771      0.000
    PFC07$2            0.029      0.073      0.398      0.691
    PFC07$3            1.198      0.086     13.896      0.000
    PFC07$4            2.001      0.131     15.254      0.000
    PFC08$1           -0.346      0.079     -4.375      0.000
    PFC08$2            0.943      0.087     10.792      0.000
    PFC08$3            1.808      0.129     13.965      0.000
    PFC08$4            2.457      0.193     12.705      0.000
    PFC09$1            0.966      0.099      9.710      0.000
    PFC09$2            1.882      0.193      9.767      0.000
    PFC10$1           -0.691      0.085     -8.129      0.000
    PFC10$2            0.638      0.077      8.311      0.000
    PFC10$3            1.615      0.105     15.340      0.000
    PFC10$4            2.057      0.137     15.044      0.000
    PFC11$1           -0.001      0.070     -0.011      0.991
    PFC11$2            1.057      0.087     12.184      0.000
    PFC11$3            1.851      0.144     12.863      0.000
    PFC11$4            2.513      0.221     11.350      0.000
    PFC12$1            0.294      0.081      3.609      0.000
    PFC12$2            1.376      0.108     12.769      0.000
    PFC12$3            1.960      0.164     11.954      0.000
    PFC13$1            0.199      0.074      2.686      0.007
    PFC13$2            1.151      0.089     12.878      0.000
    PFC13$3            1.948      0.141     13.848      0.000
    PFC13$4            2.414      0.197     12.253      0.000
    PFC14$1            0.793      0.082      9.636      0.000
    PFC14$2            1.643      0.125     13.167      0.000
    PFC14$3            2.141      0.157     13.633      0.000
    PFC14$4            2.642      0.227     11.642      0.000
    PFC15$1            0.373      0.071      5.277      0.000
    PFC15$2            1.225      0.093     13.165      0.000
    PFC15$3            1.532      0.108     14.143      0.000
    PFC15$4            1.693      0.125     13.561      0.000
    PFC17$1            0.360      0.070      5.110      0.000
    PFC17$2            1.571      0.112     14.000      0.000
    PFC18$1            0.898      0.087     10.321      0.000
    PFC18$2            1.643      0.122     13.438      0.000
    PFC18$3            1.953      0.158     12.364      0.000
    PFC19$1            0.651      0.078      8.317      0.000
    PFC19$2            1.339      0.096     14.015      0.000
    PFC19$3            2.065      0.138     14.919      0.000
    PFC20$1            0.538      0.067      8.079      0.000
    PFC20$2            1.106      0.087     12.735      0.000
    PFC20$3            1.621      0.135     12.014      0.000
    PFC21$1            0.965      0.083     11.571      0.000
    PFC21$2            1.580      0.114     13.881      0.000
    PFC21$3            2.093      0.156     13.384      0.000
    PFC21$4            2.654      0.250     10.602      0.000
    PFC22$1            0.347      0.081      4.301      0.000
    PFC22$2            1.480      0.102     14.469      0.000
    PFC22$3            2.409      0.171     14.051      0.000
    PFC22$4            2.904      0.271     10.732      0.000
    PFC23$1            0.483      0.075      6.468      0.000
    PFC23$2            1.097      0.085     12.913      0.000
    PFC23$3            1.743      0.113     15.403      0.000
    PFC23$4            2.396      0.189     12.708      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              0.374      0.081      4.632      0.000
    PFC02              0.584      0.051     11.438      0.000
    PFC03              0.547      0.077      7.082      0.000
    PFC04              0.220      0.069      3.170      0.002
    PFC05              0.634      0.048     13.233      0.000
    PFC06              0.784      0.043     18.314      0.000
    PFC07              0.609      0.042     14.623      0.000
    PFC08              0.382      0.062      6.211      0.000
    PFC09              0.442      0.105      4.213      0.000
    PFC10              0.652      0.059     11.009      0.000
    PFC11              0.667      0.050     13.209      0.000
    PFC12              0.222      0.055      4.040      0.000
    PFC13              0.505      0.052      9.702      0.000
    PFC14              0.456      0.058      7.888      0.000
    PFC15              0.637      0.052     12.285      0.000
    PFC17              0.569      0.057      9.901      0.000
    PFC18              0.273      0.063      4.332      0.000
    PFC19              0.362      0.053      6.789      0.000
    PFC20              0.680      0.055     12.435      0.000
    PFC21              0.623      0.060     10.374      0.000
    PFC22              0.310      0.046      6.693      0.000
    PFC23              0.390      0.055      7.027      0.000

Group MALE

 F1       BY
    PFC01             -0.032      0.059     -0.538      0.591
    PFC02              0.197      0.058      3.370      0.001
    PFC03              0.146      0.086      1.699      0.089
    PFC04              0.938      0.044     21.491      0.000
    PFC05              0.305      0.074      4.122      0.000
    PFC06              0.286      0.066      4.315      0.000
    PFC07              0.389      0.058      6.683      0.000
    PFC08              0.785      0.059     13.245      0.000
    PFC09              0.141      0.086      1.642      0.101
    PFC10             -0.137      0.057     -2.399      0.016
    PFC11              0.333      0.059      5.669      0.000
    PFC12             -0.005      0.035     -0.134      0.893
    PFC13              0.001      0.054      0.016      0.987
    PFC14              0.413      0.066      6.261      0.000
    PFC15              0.107      0.062      1.726      0.084
    PFC17              0.039      0.064      0.605      0.545
    PFC18             -0.012      0.051     -0.241      0.810
    PFC19              0.115      0.063      1.832      0.067
    PFC20              0.164      0.074      2.225      0.026
    PFC21              0.321      0.057      5.629      0.000
    PFC22              0.357      0.059      6.097      0.000
    PFC23              0.375      0.067      5.595      0.000

 F2       BY
    PFC01              0.797      0.061     13.067      0.000
    PFC02              0.194      0.055      3.500      0.000
    PFC03              0.935      0.064     14.618      0.000
    PFC04             -0.018      0.018     -0.990      0.322
    PFC05              0.387      0.061      6.305      0.000
    PFC06              0.102      0.059      1.736      0.083
    PFC07              0.093      0.047      1.966      0.049
    PFC08              0.026      0.041      0.630      0.529
    PFC09              0.857      0.069     12.382      0.000
    PFC10              0.462      0.059      7.825      0.000
    PFC11              0.114      0.054      2.117      0.034
    PFC12             -0.069      0.030     -2.286      0.022
    PFC13              0.078      0.049      1.582      0.114
    PFC14              0.117      0.056      2.100      0.036
    PFC15              0.301      0.060      5.058      0.000
    PFC17              0.333      0.068      4.893      0.000
    PFC18              0.028      0.052      0.531      0.595
    PFC19              0.231      0.060      3.833      0.000
    PFC20              0.202      0.071      2.850      0.004
    PFC21              0.148      0.069      2.161      0.031
    PFC22              0.367      0.060      6.124      0.000
    PFC23              0.310      0.062      4.969      0.000

 F3       BY
    PFC01             -0.105      0.062     -1.684      0.092
    PFC02              0.364      0.054      6.801      0.000
    PFC03             -0.162      0.092     -1.750      0.080
    PFC04             -0.062      0.027     -2.281      0.023
    PFC05              0.165      0.068      2.428      0.015
    PFC06              0.214      0.057      3.743      0.000
    PFC07              0.254      0.058      4.362      0.000
    PFC08             -0.008      0.050     -0.154      0.878
    PFC09             -0.129      0.087     -1.479      0.139
    PFC10              0.157      0.063      2.476      0.013
    PFC11              0.284      0.058      4.863      0.000
    PFC12              0.942      0.037     25.724      0.000
    PFC13              0.681      0.051     13.356      0.000
    PFC14              0.262      0.056      4.708      0.000
    PFC15              0.325      0.063      5.185      0.000
    PFC17              0.436      0.064      6.833      0.000
    PFC18              0.909      0.054     16.847      0.000
    PFC19              0.563      0.058      9.783      0.000
    PFC20              0.530      0.072      7.377      0.000
    PFC21              0.304      0.076      3.991      0.000
    PFC22              0.164      0.049      3.330      0.001
    PFC23              0.249      0.057      4.339      0.000

 F2       WITH
    F1                 0.344      0.086      3.997      0.000

 F3       WITH
    F1                 0.538      0.066      8.100      0.000
    F2                 0.496      0.078      6.323      0.000

 Means
    F1                 0.320      0.104      3.073      0.002
    F2                 0.352      0.163      2.162      0.031
    F3                 0.173      0.135      1.289      0.198

 Thresholds
    PFC01$1            0.819      0.126      6.519      0.000
    PFC01$2            1.901      0.203      9.366      0.000
    PFC01$3            2.737      0.300      9.113      0.000
    PFC02$1           -0.429      0.069     -6.183      0.000
    PFC02$2            1.002      0.090     11.099      0.000
    PFC02$3            1.875      0.136     13.756      0.000
    PFC02$4            2.367      0.205     11.556      0.000
    PFC03$1            0.991      0.155      6.409      0.000
    PFC03$2            2.834      0.285      9.959      0.000
    PFC04$1           -0.608      0.078     -7.771      0.000
    PFC04$2            0.549      0.081      6.782      0.000
    PFC04$3            1.502      0.113     13.342      0.000
    PFC04$4            2.204      0.166     13.275      0.000
    PFC05$1            0.432      0.086      5.048      0.000
    PFC05$2            1.623      0.128     12.670      0.000
    PFC05$3            2.176      0.155     14.004      0.000
    PFC05$4            2.540      0.189     13.411      0.000
    PFC06$1           -0.008      0.067     -0.124      0.902
    PFC06$2            1.017      0.092     11.043      0.000
    PFC06$3            1.493      0.116     12.872      0.000
    PFC06$4            1.929      0.152     12.689      0.000
    PFC07$1           -1.065      0.085    -12.471      0.000
    PFC07$2            0.026      0.065      0.396      0.692
    PFC07$3            1.068      0.088     12.091      0.000
    PFC07$4            1.785      0.130     13.684      0.000
    PFC08$1           -0.314      0.069     -4.558      0.000
    PFC08$2            0.854      0.082     10.465      0.000
    PFC08$3            1.639      0.117     13.972      0.000
    PFC08$4            2.226      0.170     13.125      0.000
    PFC09$1            1.345      0.153      8.782      0.000
    PFC09$2            2.619      0.242     10.819      0.000
    PFC10$1           -0.674      0.077     -8.783      0.000
    PFC10$2            0.623      0.082      7.591      0.000
    PFC10$3            1.575      0.133     11.871      0.000
    PFC10$4            2.008      0.171     11.733      0.000
    PFC11$1           -0.001      0.067     -0.011      0.991
    PFC11$2            1.015      0.088     11.497      0.000
    PFC11$3            1.777      0.124     14.278      0.000
    PFC11$4            2.412      0.206     11.730      0.000
    PFC12$1            0.304      0.096      3.167      0.002
    PFC12$2            1.425      0.143      9.977      0.000
    PFC12$3            2.029      0.183     11.103      0.000
    PFC13$1            0.204      0.081      2.503      0.012
    PFC13$2            1.180      0.110     10.693      0.000
    PFC13$3            1.996      0.161     12.380      0.000
    PFC13$4            2.474      0.230     10.745      0.000
    PFC14$1            0.645      0.078      8.283      0.000
    PFC14$2            1.337      0.104     12.830      0.000
    PFC14$3            1.742      0.129     13.541      0.000
    PFC14$4            2.150      0.167     12.865      0.000
    PFC15$1            0.382      0.079      4.811      0.000
    PFC15$2            1.255      0.109     11.477      0.000
    PFC15$3            1.568      0.122     12.805      0.000
    PFC15$4            1.733      0.128     13.509      0.000
    PFC17$1            0.387      0.087      4.456      0.000
    PFC17$2            1.691      0.149     11.369      0.000
    PFC18$1            0.967      0.120      8.038      0.000
    PFC18$2            1.769      0.159     11.132      0.000
    PFC18$3            2.103      0.184     11.424      0.000
    PFC19$1            0.621      0.091      6.791      0.000
    PFC19$2            1.277      0.116     11.043      0.000
    PFC19$3            1.970      0.163     12.083      0.000
    PFC20$1            0.696      0.096      7.263      0.000
    PFC20$2            1.431      0.119     12.021      0.000
    PFC20$3            2.097      0.151     13.901      0.000
    PFC21$1            0.927      0.090     10.245      0.000
    PFC21$2            1.519      0.115     13.219      0.000
    PFC21$3            2.012      0.153     13.191      0.000
    PFC21$4            2.551      0.225     11.320      0.000
    PFC22$1            0.305      0.078      3.928      0.000
    PFC22$2            1.301      0.110     11.796      0.000
    PFC22$3            2.118      0.164     12.921      0.000
    PFC22$4            2.554      0.257      9.935      0.000
    PFC23$1            0.457      0.081      5.634      0.000
    PFC23$2            1.038      0.097     10.669      0.000
    PFC23$3            1.648      0.126     13.117      0.000
    PFC23$4            2.266      0.174     13.007      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              0.449      0.078      5.746      0.000
    PFC02              0.618      0.046     13.560      0.000
    PFC03              0.160      0.062      2.595      0.009
    PFC04              0.189      0.072      2.612      0.009
    PFC05              0.532      0.058      9.215      0.000
    PFC06              0.754      0.052     14.613      0.000
    PFC07              0.620      0.049     12.641      0.000
    PFC08              0.376      0.059      6.316      0.000
    PFC09              0.275      0.081      3.406      0.001
    PFC10              0.738      0.049     15.152      0.000
    PFC11              0.636      0.053     12.016      0.000
    PFC12              0.177      0.045      3.920      0.000
    PFC13              0.476      0.053      8.952      0.000
    PFC14              0.568      0.064      8.829      0.000
    PFC15              0.636      0.050     12.613      0.000
    PFC17              0.526      0.062      8.526      0.000
    PFC18              0.159      0.063      2.510      0.012
    PFC19              0.400      0.063      6.323      0.000
    PFC20              0.430      0.061      6.993      0.000
    PFC21              0.600      0.059     10.098      0.000
    PFC22              0.498      0.056      8.859      0.000
    PFC23              0.443      0.054      8.257      0.000


STDY Standardization

                                                    Two-Tailed
                    Estimate       S.E.  Est./S.E.    P-Value

Group FEMALE

 F1       BY
    PFC01             -0.025      0.047     -0.529      0.597
    PFC02              0.189      0.055      3.438      0.001
    PFC03              0.078      0.044      1.770      0.077
    PFC04              0.913      0.034     26.715      0.000
    PFC05              0.230      0.055      4.211      0.000
    PFC06              0.260      0.059      4.430      0.000
    PFC07              0.389      0.056      6.972      0.000
    PFC08              0.773      0.057     13.446      0.000
    PFC09              0.090      0.053      1.701      0.089
    PFC10             -0.125      0.053     -2.371      0.018
    PFC11              0.309      0.058      5.349      0.000
    PFC12             -0.004      0.030     -0.135      0.893
    PFC13              0.001      0.047      0.016      0.987
    PFC14              0.452      0.068      6.685      0.000
    PFC15              0.093      0.054      1.724      0.085
    PFC17              0.032      0.053      0.606      0.544
    PFC18             -0.010      0.042     -0.240      0.810
    PFC19              0.107      0.059      1.804      0.071
    PFC20              0.113      0.052      2.187      0.029
    PFC21              0.298      0.057      5.254      0.000
    PFC22              0.362      0.057      6.351      0.000
    PFC23              0.354      0.066      5.337      0.000

 F2       BY
    PFC01              0.831      0.056     14.834      0.000
    PFC02              0.249      0.068      3.657      0.000
    PFC03              0.665      0.063     10.622      0.000
    PFC04             -0.023      0.023     -1.012      0.311
    PFC05              0.389      0.061      6.407      0.000
    PFC06              0.124      0.072      1.715      0.086
    PFC07              0.124      0.061      2.052      0.040
    PFC08              0.034      0.054      0.635      0.526
    PFC09              0.733      0.077      9.505      0.000
    PFC10              0.563      0.071      7.955      0.000
    PFC11              0.141      0.064      2.213      0.027
    PFC12             -0.080      0.035     -2.279      0.023
    PFC13              0.091      0.060      1.519      0.129
    PFC14              0.170      0.075      2.276      0.023
    PFC15              0.350      0.063      5.559      0.000
    PFC17              0.368      0.070      5.262      0.000
    PFC18              0.031      0.058      0.531      0.595
    PFC19              0.288      0.064      4.460      0.000
    PFC20              0.186      0.062      3.015      0.003
    PFC21              0.184      0.080      2.312      0.021
    PFC22              0.497      0.064      7.817      0.000
    PFC23              0.390      0.067      5.864      0.000

 F3       BY
    PFC01             -0.092      0.053     -1.720      0.085
    PFC02              0.393      0.052      7.567      0.000
    PFC03             -0.097      0.055     -1.763      0.078
    PFC04             -0.068      0.028     -2.393      0.017
    PFC05              0.139      0.056      2.466      0.014
    PFC06              0.217      0.058      3.735      0.000
    PFC07              0.285      0.063      4.554      0.000
    PFC08             -0.009      0.055     -0.154      0.878
    PFC09             -0.093      0.062     -1.502      0.133
    PFC10              0.161      0.064      2.526      0.012
    PFC11              0.295      0.062      4.777      0.000
    PFC12              0.910      0.032     28.371      0.000
    PFC13              0.665      0.046     14.578      0.000
    PFC14              0.322      0.065      4.920      0.000
    PFC15              0.317      0.063      5.055      0.000
    PFC17              0.405      0.061      6.652      0.000
    PFC18              0.844      0.050     16.906      0.000
    PFC19              0.590      0.052     11.311      0.000
    PFC20              0.409      0.063      6.497      0.000
    PFC21              0.316      0.081      3.920      0.000
    PFC22              0.187      0.055      3.414      0.001
    PFC23              0.263      0.065      4.040      0.000

 F2       WITH
    F1                 0.455      0.051      8.880      0.000

 F3       WITH
    F1                 0.330      0.061      5.437      0.000
    F2                 0.370      0.056      6.567      0.000

 Means
    F1                 0.000      0.000    999.000    999.000
    F2                 0.000      0.000    999.000    999.000
    F3                 0.000      0.000    999.000    999.000

 Thresholds
    PFC01$1            0.717      0.083      8.601      0.000
    PFC01$2            1.664      0.127     13.075      0.000
    PFC01$3            2.397      0.222     10.780      0.000
    PFC02$1           -0.463      0.081     -5.728      0.000
    PFC02$2            1.081      0.086     12.623      0.000
    PFC02$3            2.023      0.147     13.732      0.000
    PFC02$4            2.554      0.213     12.002      0.000
    PFC03$1            0.593      0.073      8.068      0.000
    PFC03$2            1.695      0.156     10.839      0.000
    PFC04$1           -0.664      0.088     -7.534      0.000
    PFC04$2            0.599      0.083      7.221      0.000
    PFC04$3            1.639      0.131     12.537      0.000
    PFC04$4            2.406      0.212     11.366      0.000
    PFC05$1            0.365      0.067      5.464      0.000
    PFC05$2            1.370      0.094     14.576      0.000
    PFC05$3            1.837      0.132     13.929      0.000
    PFC05$4            2.145      0.175     12.280      0.000
    PFC06$1           -0.008      0.068     -0.124      0.902
    PFC06$2            1.035      0.085     12.191      0.000
    PFC06$3            1.519      0.110     13.816      0.000
    PFC06$4            1.963      0.144     13.604      0.000
    PFC07$1           -1.194      0.101    -11.771      0.000
    PFC07$2            0.029      0.073      0.398      0.691
    PFC07$3            1.198      0.086     13.896      0.000
    PFC07$4            2.001      0.131     15.254      0.000
    PFC08$1           -0.346      0.079     -4.375      0.000
    PFC08$2            0.943      0.087     10.792      0.000
    PFC08$3            1.808      0.129     13.965      0.000
    PFC08$4            2.457      0.193     12.705      0.000
    PFC09$1            0.966      0.099      9.710      0.000
    PFC09$2            1.882      0.193      9.767      0.000
    PFC10$1           -0.691      0.085     -8.129      0.000
    PFC10$2            0.638      0.077      8.311      0.000
    PFC10$3            1.615      0.105     15.340      0.000
    PFC10$4            2.057      0.137     15.044      0.000
    PFC11$1           -0.001      0.070     -0.011      0.991
    PFC11$2            1.057      0.087     12.184      0.000
    PFC11$3            1.851      0.144     12.863      0.000
    PFC11$4            2.513      0.221     11.350      0.000
    PFC12$1            0.294      0.081      3.609      0.000
    PFC12$2            1.376      0.108     12.769      0.000
    PFC12$3            1.960      0.164     11.954      0.000
    PFC13$1            0.199      0.074      2.686      0.007
    PFC13$2            1.151      0.089     12.878      0.000
    PFC13$3            1.948      0.141     13.848      0.000
    PFC13$4            2.414      0.197     12.253      0.000
    PFC14$1            0.793      0.082      9.636      0.000
    PFC14$2            1.643      0.125     13.167      0.000
    PFC14$3            2.141      0.157     13.633      0.000
    PFC14$4            2.642      0.227     11.642      0.000
    PFC15$1            0.373      0.071      5.277      0.000
    PFC15$2            1.225      0.093     13.165      0.000
    PFC15$3            1.532      0.108     14.143      0.000
    PFC15$4            1.693      0.125     13.561      0.000
    PFC17$1            0.360      0.070      5.110      0.000
    PFC17$2            1.571      0.112     14.000      0.000
    PFC18$1            0.898      0.087     10.321      0.000
    PFC18$2            1.643      0.122     13.438      0.000
    PFC18$3            1.953      0.158     12.364      0.000
    PFC19$1            0.651      0.078      8.317      0.000
    PFC19$2            1.339      0.096     14.015      0.000
    PFC19$3            2.065      0.138     14.919      0.000
    PFC20$1            0.538      0.067      8.079      0.000
    PFC20$2            1.106      0.087     12.735      0.000
    PFC20$3            1.621      0.135     12.014      0.000
    PFC21$1            0.965      0.083     11.571      0.000
    PFC21$2            1.580      0.114     13.881      0.000
    PFC21$3            2.093      0.156     13.384      0.000
    PFC21$4            2.654      0.250     10.602      0.000
    PFC22$1            0.347      0.081      4.301      0.000
    PFC22$2            1.480      0.102     14.469      0.000
    PFC22$3            2.409      0.171     14.051      0.000
    PFC22$4            2.904      0.271     10.732      0.000
    PFC23$1            0.483      0.075      6.468      0.000
    PFC23$2            1.097      0.085     12.913      0.000
    PFC23$3            1.743      0.113     15.403      0.000
    PFC23$4            2.396      0.189     12.708      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              0.374      0.081      4.632      0.000
    PFC02              0.584      0.051     11.438      0.000
    PFC03              0.547      0.077      7.082      0.000
    PFC04              0.220      0.069      3.170      0.002
    PFC05              0.634      0.048     13.233      0.000
    PFC06              0.784      0.043     18.314      0.000
    PFC07              0.609      0.042     14.623      0.000
    PFC08              0.382      0.062      6.211      0.000
    PFC09              0.442      0.105      4.213      0.000
    PFC10              0.652      0.059     11.009      0.000
    PFC11              0.667      0.050     13.209      0.000
    PFC12              0.222      0.055      4.040      0.000
    PFC13              0.505      0.052      9.702      0.000
    PFC14              0.456      0.058      7.888      0.000
    PFC15              0.637      0.052     12.285      0.000
    PFC17              0.569      0.057      9.901      0.000
    PFC18              0.273      0.063      4.332      0.000
    PFC19              0.362      0.053      6.789      0.000
    PFC20              0.680      0.055     12.435      0.000
    PFC21              0.623      0.060     10.374      0.000
    PFC22              0.310      0.046      6.693      0.000
    PFC23              0.390      0.055      7.027      0.000

Group MALE

 F1       BY
    PFC01             -0.032      0.059     -0.538      0.591
    PFC02              0.197      0.058      3.370      0.001
    PFC03              0.146      0.086      1.699      0.089
    PFC04              0.938      0.044     21.491      0.000
    PFC05              0.305      0.074      4.122      0.000
    PFC06              0.286      0.066      4.315      0.000
    PFC07              0.389      0.058      6.683      0.000
    PFC08              0.785      0.059     13.245      0.000
    PFC09              0.141      0.086      1.642      0.101
    PFC10             -0.137      0.057     -2.399      0.016
    PFC11              0.333      0.059      5.669      0.000
    PFC12             -0.005      0.035     -0.134      0.893
    PFC13              0.001      0.054      0.016      0.987
    PFC14              0.413      0.066      6.261      0.000
    PFC15              0.107      0.062      1.726      0.084
    PFC17              0.039      0.064      0.605      0.545
    PFC18             -0.012      0.051     -0.241      0.810
    PFC19              0.115      0.063      1.832      0.067
    PFC20              0.164      0.074      2.225      0.026
    PFC21              0.321      0.057      5.629      0.000
    PFC22              0.357      0.059      6.097      0.000
    PFC23              0.375      0.067      5.595      0.000

 F2       BY
    PFC01              0.797      0.061     13.067      0.000
    PFC02              0.194      0.055      3.500      0.000
    PFC03              0.935      0.064     14.618      0.000
    PFC04             -0.018      0.018     -0.990      0.322
    PFC05              0.387      0.061      6.305      0.000
    PFC06              0.102      0.059      1.736      0.083
    PFC07              0.093      0.047      1.966      0.049
    PFC08              0.026      0.041      0.630      0.529
    PFC09              0.857      0.069     12.382      0.000
    PFC10              0.462      0.059      7.825      0.000
    PFC11              0.114      0.054      2.117      0.034
    PFC12             -0.069      0.030     -2.286      0.022
    PFC13              0.078      0.049      1.582      0.114
    PFC14              0.117      0.056      2.100      0.036
    PFC15              0.301      0.060      5.058      0.000
    PFC17              0.333      0.068      4.893      0.000
    PFC18              0.028      0.052      0.531      0.595
    PFC19              0.231      0.060      3.833      0.000
    PFC20              0.202      0.071      2.850      0.004
    PFC21              0.148      0.069      2.161      0.031
    PFC22              0.367      0.060      6.124      0.000
    PFC23              0.310      0.062      4.969      0.000

 F3       BY
    PFC01             -0.105      0.062     -1.684      0.092
    PFC02              0.364      0.054      6.801      0.000
    PFC03             -0.162      0.092     -1.750      0.080
    PFC04             -0.062      0.027     -2.281      0.023
    PFC05              0.165      0.068      2.428      0.015
    PFC06              0.214      0.057      3.743      0.000
    PFC07              0.254      0.058      4.362      0.000
    PFC08             -0.008      0.050     -0.154      0.878
    PFC09             -0.129      0.087     -1.479      0.139
    PFC10              0.157      0.063      2.476      0.013
    PFC11              0.284      0.058      4.863      0.000
    PFC12              0.942      0.037     25.724      0.000
    PFC13              0.681      0.051     13.356      0.000
    PFC14              0.262      0.056      4.708      0.000
    PFC15              0.325      0.063      5.185      0.000
    PFC17              0.436      0.064      6.833      0.000
    PFC18              0.909      0.054     16.847      0.000
    PFC19              0.563      0.058      9.783      0.000
    PFC20              0.530      0.072      7.377      0.000
    PFC21              0.304      0.076      3.991      0.000
    PFC22              0.164      0.049      3.330      0.001
    PFC23              0.249      0.057      4.339      0.000

 F2       WITH
    F1                 0.344      0.086      3.997      0.000

 F3       WITH
    F1                 0.538      0.066      8.100      0.000
    F2                 0.496      0.078      6.323      0.000

 Means
    F1                 0.320      0.104      3.073      0.002
    F2                 0.352      0.163      2.162      0.031
    F3                 0.173      0.135      1.289      0.198

 Thresholds
    PFC01$1            0.819      0.126      6.519      0.000
    PFC01$2            1.901      0.203      9.366      0.000
    PFC01$3            2.737      0.300      9.113      0.000
    PFC02$1           -0.429      0.069     -6.183      0.000
    PFC02$2            1.002      0.090     11.099      0.000
    PFC02$3            1.875      0.136     13.756      0.000
    PFC02$4            2.367      0.205     11.556      0.000
    PFC03$1            0.991      0.155      6.409      0.000
    PFC03$2            2.834      0.285      9.959      0.000
    PFC04$1           -0.608      0.078     -7.771      0.000
    PFC04$2            0.549      0.081      6.782      0.000
    PFC04$3            1.502      0.113     13.342      0.000
    PFC04$4            2.204      0.166     13.275      0.000
    PFC05$1            0.432      0.086      5.048      0.000
    PFC05$2            1.623      0.128     12.670      0.000
    PFC05$3            2.176      0.155     14.004      0.000
    PFC05$4            2.540      0.189     13.411      0.000
    PFC06$1           -0.008      0.067     -0.124      0.902
    PFC06$2            1.017      0.092     11.043      0.000
    PFC06$3            1.493      0.116     12.872      0.000
    PFC06$4            1.929      0.152     12.689      0.000
    PFC07$1           -1.065      0.085    -12.471      0.000
    PFC07$2            0.026      0.065      0.396      0.692
    PFC07$3            1.068      0.088     12.091      0.000
    PFC07$4            1.785      0.130     13.684      0.000
    PFC08$1           -0.314      0.069     -4.558      0.000
    PFC08$2            0.854      0.082     10.465      0.000
    PFC08$3            1.639      0.117     13.972      0.000
    PFC08$4            2.226      0.170     13.125      0.000
    PFC09$1            1.345      0.153      8.782      0.000
    PFC09$2            2.619      0.242     10.819      0.000
    PFC10$1           -0.674      0.077     -8.783      0.000
    PFC10$2            0.623      0.082      7.591      0.000
    PFC10$3            1.575      0.133     11.871      0.000
    PFC10$4            2.008      0.171     11.733      0.000
    PFC11$1           -0.001      0.067     -0.011      0.991
    PFC11$2            1.015      0.088     11.497      0.000
    PFC11$3            1.777      0.124     14.278      0.000
    PFC11$4            2.412      0.206     11.730      0.000
    PFC12$1            0.304      0.096      3.167      0.002
    PFC12$2            1.425      0.143      9.977      0.000
    PFC12$3            2.029      0.183     11.103      0.000
    PFC13$1            0.204      0.081      2.503      0.012
    PFC13$2            1.180      0.110     10.693      0.000
    PFC13$3            1.996      0.161     12.380      0.000
    PFC13$4            2.474      0.230     10.745      0.000
    PFC14$1            0.645      0.078      8.283      0.000
    PFC14$2            1.337      0.104     12.830      0.000
    PFC14$3            1.742      0.129     13.541      0.000
    PFC14$4            2.150      0.167     12.865      0.000
    PFC15$1            0.382      0.079      4.811      0.000
    PFC15$2            1.255      0.109     11.477      0.000
    PFC15$3            1.568      0.122     12.805      0.000
    PFC15$4            1.733      0.128     13.509      0.000
    PFC17$1            0.387      0.087      4.456      0.000
    PFC17$2            1.691      0.149     11.369      0.000
    PFC18$1            0.967      0.120      8.038      0.000
    PFC18$2            1.769      0.159     11.132      0.000
    PFC18$3            2.103      0.184     11.424      0.000
    PFC19$1            0.621      0.091      6.791      0.000
    PFC19$2            1.277      0.116     11.043      0.000
    PFC19$3            1.970      0.163     12.083      0.000
    PFC20$1            0.696      0.096      7.263      0.000
    PFC20$2            1.431      0.119     12.021      0.000
    PFC20$3            2.097      0.151     13.901      0.000
    PFC21$1            0.927      0.090     10.245      0.000
    PFC21$2            1.519      0.115     13.219      0.000
    PFC21$3            2.012      0.153     13.191      0.000
    PFC21$4            2.551      0.225     11.320      0.000
    PFC22$1            0.305      0.078      3.928      0.000
    PFC22$2            1.301      0.110     11.796      0.000
    PFC22$3            2.118      0.164     12.921      0.000
    PFC22$4            2.554      0.257      9.935      0.000
    PFC23$1            0.457      0.081      5.634      0.000
    PFC23$2            1.038      0.097     10.669      0.000
    PFC23$3            1.648      0.126     13.117      0.000
    PFC23$4            2.266      0.174     13.007      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              0.449      0.078      5.746      0.000
    PFC02              0.618      0.046     13.560      0.000
    PFC03              0.160      0.062      2.595      0.009
    PFC04              0.189      0.072      2.612      0.009
    PFC05              0.532      0.058      9.215      0.000
    PFC06              0.754      0.052     14.613      0.000
    PFC07              0.620      0.049     12.641      0.000
    PFC08              0.376      0.059      6.316      0.000
    PFC09              0.275      0.081      3.406      0.001
    PFC10              0.738      0.049     15.152      0.000
    PFC11              0.636      0.053     12.016      0.000
    PFC12              0.177      0.045      3.920      0.000
    PFC13              0.476      0.053      8.952      0.000
    PFC14              0.568      0.064      8.829      0.000
    PFC15              0.636      0.050     12.613      0.000
    PFC17              0.526      0.062      8.526      0.000
    PFC18              0.159      0.063      2.510      0.012
    PFC19              0.400      0.063      6.323      0.000
    PFC20              0.430      0.061      6.993      0.000
    PFC21              0.600      0.059     10.098      0.000
    PFC22              0.498      0.056      8.859      0.000
    PFC23              0.443      0.054      8.257      0.000


R-SQUARE

Group FEMALE

    Observed                                        Two-Tailed     Scale
    Variable        Estimate       S.E.  Est./S.E.    P-Value     Factors

    PFC01              0.626      0.081      7.740      0.000      0.612
    PFC02              0.416      0.051      8.152      0.000      0.764
    PFC03              0.453      0.077      5.856      0.000      0.740
    PFC04              0.780      0.069     11.262      0.000      0.469
    PFC05              0.366      0.048      7.634      0.000      0.796
    PFC06              0.216      0.043      5.058      0.000      0.885
    PFC07              0.391      0.042      9.402      0.000      0.780
    PFC08              0.618      0.062     10.039      0.000      0.618
    PFC09              0.558      0.105      5.324      0.000      0.665
    PFC10              0.348      0.059      5.883      0.000      0.807
    PFC11              0.333      0.050      6.603      0.000      0.817
    PFC12              0.778      0.055     14.185      0.000      0.471
    PFC13              0.495      0.052      9.512      0.000      0.711
    PFC14              0.544      0.058      9.422      0.000      0.675
    PFC15              0.363      0.052      6.987      0.000      0.798
    PFC17              0.431      0.057      7.491      0.000      0.754
    PFC18              0.727      0.063     11.558      0.000      0.522
    PFC19              0.638      0.053     11.954      0.000      0.602
    PFC20              0.320      0.055      5.858      0.000      0.824
    PFC21              0.377      0.060      6.288      0.000      0.789
    PFC22              0.690      0.046     14.876      0.000      0.557
    PFC23              0.610      0.055     10.998      0.000      0.624

Group MALE

    Observed                                        Two-Tailed     Scale
    Variable        Estimate       S.E.  Est./S.E.    P-Value     Factors

    PFC01              0.551      0.078      7.054      0.000      0.699
    PFC02              0.382      0.046      8.389      0.000      0.708
    PFC03              0.840      0.062     13.576      0.000      1.237
    PFC04              0.811      0.072     11.231      0.000      0.429
    PFC05              0.468      0.058      8.117      0.000      0.943
    PFC06              0.246      0.052      4.756      0.000      0.870
    PFC07              0.380      0.049      7.734      0.000      0.696
    PFC08              0.624      0.059     10.503      0.000      0.560
    PFC09              0.725      0.081      8.977      0.000      0.925
    PFC10              0.262      0.049      5.377      0.000      0.788
    PFC11              0.364      0.053      6.866      0.000      0.784
    PFC12              0.823      0.045     18.194      0.000      0.487
    PFC13              0.524      0.053      9.852      0.000      0.728
    PFC14              0.432      0.064      6.728      0.000      0.549
    PFC15              0.364      0.050      7.214      0.000      0.818
    PFC17              0.474      0.062      7.681      0.000      0.812
    PFC18              0.841      0.063     13.264      0.000      0.562
    PFC19              0.600      0.063      9.482      0.000      0.574
    PFC20              0.570      0.061      9.269      0.000      1.067
    PFC21              0.400      0.059      6.735      0.000      0.758
    PFC22              0.502      0.056      8.935      0.000      0.490
    PFC23              0.557      0.054     10.365      0.000      0.591


MODEL MODIFICATION INDICES

NOTE:  Modification indices for direct effects of observed dependent variables
regressed on covariates and residual covariances among observed dependent
variables may not be included.  To include these, request MODINDICES (ALL).

Minimum M.I. value for printing the modification index     3.840

                                   M.I.     E.P.C.  Std E.P.C.  StdYX E.P.C.
Group FEMALE


BY Statements

F1       BY PFC03                  7.399    -0.114     -0.114       -0.084
F1       BY PFC09                 11.386    -0.250     -0.250       -0.166
F1       BY PFC10                 10.114     0.070      0.070        0.056
F1       BY PFC13                  4.096     0.059      0.059        0.042
F1       BY PFC18                  4.794    -0.096     -0.096       -0.050
F1       BY PFC20                  8.726    -0.105     -0.105       -0.087
F2       BY PFC03                 11.694    -0.277     -0.277       -0.205
F2       BY PFC07                  9.790     0.132      0.132        0.103
F2       BY PFC09                  8.919    -0.289     -0.289       -0.192
F2       BY PFC10                 24.615     0.220      0.220        0.178
F2       BY PFC12                  9.318    -0.361     -0.361       -0.170
F2       BY PFC20                  5.732    -0.112     -0.112       -0.092
F3       BY PFC09                  5.771     0.296      0.296        0.196
F3       BY PFC10                 18.440    -0.281     -0.281       -0.227
F3       BY PFC12                  4.017     0.276      0.276        0.130
F3       BY PFC20                  4.405     0.157      0.157        0.129
F3       BY PFC22                  4.278    -0.153     -0.153       -0.085

WITH Statements

PFC07    WITH PFC02                8.519     0.306      0.306        0.306
PFC08    WITH PFC04                4.020     0.665      0.665        0.665
PFC09    WITH PFC03               11.459     0.693      0.693        0.693
PFC10    WITH PFC03                7.873    -0.446     -0.446       -0.446
PFC10    WITH PFC04                6.260     0.591      0.591        0.591
PFC10    WITH PFC05                3.980     0.211      0.211        0.211
PFC10    WITH PFC08               13.834     0.563      0.563        0.563
PFC10    WITH PFC09                6.002    -0.544     -0.544       -0.544
PFC11    WITH PFC10                5.410     0.282      0.282        0.282
PFC14    WITH PFC11                3.986     0.267      0.267        0.267
PFC15    WITH PFC02                4.340    -0.275     -0.275       -0.275
PFC15    WITH PFC05                5.817     0.269      0.269        0.269
PFC21    WITH PFC13                4.070    -0.374     -0.374       -0.374
PFC23    WITH PFC02                4.402     0.283      0.283        0.283
PFC23    WITH PFC07                6.163     0.313      0.313        0.313

Variances/Residual Variances

PFC12                            999.000     0.000      0.000        0.000

Means/Intercepts/Thresholds

[ PFC03$2  ]                       4.430     0.351      0.351        0.259
[ PFC09$1  ]                       6.167     0.247      0.247        0.164
[ PFC12$3  ]                       4.194     0.644      0.644        0.303
[ PFC18$3  ]                       5.874     1.153      1.153        0.602
[ PFC20$3  ]                       6.087     0.418      0.418        0.345

Group MALE


BY Statements

F1       BY PFC03                  7.395     0.288      0.237        0.293
F1       BY PFC09                 11.393     0.366      0.301        0.279
F1       BY PFC10                 10.111    -0.277     -0.228       -0.179
F1       BY PFC13                  4.094    -0.196     -0.161       -0.117
F1       BY PFC18                  4.793     0.360      0.295        0.166
F1       BY PFC20                  8.727     0.206      0.170        0.181
F2       BY PFC03                 11.695     0.098      0.108        0.134
F2       BY PFC07                  9.788    -0.199     -0.220       -0.153
F2       BY PFC09                  8.918     0.127      0.140        0.129
F2       BY PFC10                 24.615    -0.177     -0.195       -0.154
F2       BY PFC12                  9.302     0.414      0.457        0.223
F2       BY PFC20                  5.733     0.129      0.142        0.152
F3       BY PFC09                  5.770    -0.211     -0.213       -0.197
F3       BY PFC10                 18.440     0.294      0.296        0.233
F3       BY PFC12                  4.015    -0.289     -0.291       -0.142
F3       BY PFC20                  4.404    -0.117     -0.118       -0.126
F3       BY PFC22                  4.274     0.235      0.237        0.116

WITH Statements

PFC05    WITH PFC02                7.380     0.257      0.257        0.300
PFC09    WITH PFC03               36.376     0.679      0.679        3.699
PFC10    WITH PFC01                3.938     0.303      0.303        0.290
PFC10    WITH PFC04                4.995    -0.591     -0.591       -0.536
PFC10    WITH PFC09                5.696    -0.394     -0.394       -0.638
PFC12    WITH PFC04                5.399     1.239      1.239        1.417
PFC13    WITH PFC12                6.672     0.521      0.521        0.636
PFC14    WITH PFC07                3.953    -0.482     -0.482       -0.310
PFC18    WITH PFC09                4.671     0.622      0.622        1.546
PFC21    WITH PFC06                3.961    -0.293     -0.293       -0.287
PFC21    WITH PFC11               15.090     0.746      0.746        0.718
PFC21    WITH PFC20                5.064     0.262      0.262        0.417
PFC22    WITH PFC03                4.678    -0.335     -0.335       -0.718
PFC22    WITH PFC06                4.335    -0.357     -0.357       -0.248
PFC22    WITH PFC09                6.957    -0.679     -0.679       -0.831
PFC22    WITH PFC14                8.522     0.800      0.800        0.405
PFC22    WITH PFC15                4.094     0.337      0.337        0.240
PFC23    WITH PFC07                4.079     0.301      0.301        0.236
PFC23    WITH PFC22                5.220     0.511      0.511        0.315

Means/Intercepts/Thresholds

[ PFC03$2  ]                       4.432    -0.478     -0.478       -0.591
[ PFC09$1  ]                       6.161    -0.403     -0.403       -0.373
[ PFC12$3  ]                       4.226    -1.208     -1.208       -0.589
[ PFC18$3  ]                       5.827    -1.295     -1.295       -0.728
[ PFC20$3  ]                       6.077    -0.424     -0.424       -0.453



PLOT INFORMATION

The following plots are available:

  Sample proportions and estimated probabilities
  Item characteristic curves
  Information curves
  Measurement parameter plots

SAVEDATA INFORMATION


  Difference testing

  Save file
    sex_metric_scalar.dif
  Save format      Free

DIAGRAM INFORMATION

  Use View Diagram under the Diagram menu in the Mplus Editor to view the diagram.
  If running Mplus from the Mplus Diagrammer, the diagram opens automatically.

  Diagram output
    c:\users\forev\documents\nicolascamacho\pfc_fa\paper\updated_process\code\mplus\metric_scalar_sex_esem_wlsmv_v3.1_rm

     Beginning Time:  06:24:09
        Ending Time:  06:24:13
       Elapsed Time:  00:00:04



MUTHEN & MUTHEN
3463 Stoner Ave.
Los Angeles, CA  90066

Tel: (310) 391-9971
Fax: (310) 391-8971
Web: www.StatModel.com
Support: Support@StatModel.com

Copyright (c) 1998-2021 Muthen & Muthen
