Mplus VERSION 8.6
MUTHEN & MUTHEN
01/31/2024   6:15 AM

INPUT INSTRUCTIONS

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



Age Metric/Weak + Scalar/Strong Invariance test of
3-Factor ESEM of PFC-S using WLSMV with missing data
Version 3.1 -- omitting PFC16;

SUMMARY OF ANALYSIS

Number of groups                                                 2
Number of observations
   Group UNDERSIX                                              294
   Group SIXPLUS                                               156
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

  Grouping variable     AGEGROUP

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

   Group UNDERSIX
     Number of missing data patterns             7

   Group SIXPLUS
     Number of missing data patterns             6


COVARIANCE COVERAGE OF DATA

Minimum covariance coverage value   0.100


     PROPORTION OF DATA PRESENT FOR UNDERSIX


           Covariance Coverage
              PFC01         PFC02         PFC03         PFC04         PFC05
              ________      ________      ________      ________      ________
 PFC01          1.000
 PFC02          1.000         1.000
 PFC03          1.000         1.000         1.000
 PFC04          0.997         0.997         0.997         0.997
 PFC05          1.000         1.000         1.000         0.997         1.000
 PFC06          0.997         0.997         0.997         0.993         0.997
 PFC07          1.000         1.000         1.000         0.997         1.000
 PFC08          1.000         1.000         1.000         0.997         1.000
 PFC09          0.997         0.997         0.997         0.993         0.997
 PFC10          1.000         1.000         1.000         0.997         1.000
 PFC11          0.990         0.990         0.990         0.986         0.990
 PFC12          1.000         1.000         1.000         0.997         1.000
 PFC13          1.000         1.000         1.000         0.997         1.000
 PFC14          1.000         1.000         1.000         0.997         1.000
 PFC15          0.993         0.993         0.993         0.990         0.993
 PFC17          0.993         0.993         0.993         0.990         0.993
 PFC18          0.993         0.993         0.993         0.990         0.993
 PFC19          0.986         0.986         0.986         0.983         0.986
 PFC20          0.990         0.990         0.990         0.986         0.990
 PFC21          0.990         0.990         0.990         0.986         0.990
 PFC22          0.990         0.990         0.990         0.986         0.990
 PFC23          0.990         0.990         0.990         0.986         0.990


           Covariance Coverage
              PFC06         PFC07         PFC08         PFC09         PFC10
              ________      ________      ________      ________      ________
 PFC06          0.997
 PFC07          0.997         1.000
 PFC08          0.997         1.000         1.000
 PFC09          0.993         0.997         0.997         0.997
 PFC10          0.997         1.000         1.000         0.997         1.000
 PFC11          0.990         0.990         0.990         0.986         0.990
 PFC12          0.997         1.000         1.000         0.997         1.000
 PFC13          0.997         1.000         1.000         0.997         1.000
 PFC14          0.997         1.000         1.000         0.997         1.000
 PFC15          0.990         0.993         0.993         0.990         0.993
 PFC17          0.990         0.993         0.993         0.990         0.993
 PFC18          0.990         0.993         0.993         0.990         0.993
 PFC19          0.986         0.986         0.986         0.983         0.986
 PFC20          0.986         0.990         0.990         0.986         0.990
 PFC21          0.986         0.990         0.990         0.986         0.990
 PFC22          0.986         0.990         0.990         0.986         0.990
 PFC23          0.986         0.990         0.990         0.986         0.990


           Covariance Coverage
              PFC11         PFC12         PFC13         PFC14         PFC15
              ________      ________      ________      ________      ________
 PFC11          0.990
 PFC12          0.990         1.000
 PFC13          0.990         1.000         1.000
 PFC14          0.990         1.000         1.000         1.000
 PFC15          0.983         0.993         0.993         0.993         0.993
 PFC17          0.983         0.993         0.993         0.993         0.993
 PFC18          0.983         0.993         0.993         0.993         0.993
 PFC19          0.980         0.986         0.986         0.986         0.986
 PFC20          0.980         0.990         0.990         0.990         0.990
 PFC21          0.980         0.990         0.990         0.990         0.990
 PFC22          0.980         0.990         0.990         0.990         0.990
 PFC23          0.980         0.990         0.990         0.990         0.990


           Covariance Coverage
              PFC17         PFC18         PFC19         PFC20         PFC21
              ________      ________      ________      ________      ________
 PFC17          0.993
 PFC18          0.993         0.993
 PFC19          0.986         0.986         0.986
 PFC20          0.990         0.990         0.986         0.990
 PFC21          0.990         0.990         0.986         0.990         0.990
 PFC22          0.990         0.990         0.986         0.990         0.990
 PFC23          0.990         0.990         0.986         0.990         0.990


           Covariance Coverage
              PFC22         PFC23
              ________      ________
 PFC22          0.990
 PFC23          0.990         0.990


     PROPORTION OF DATA PRESENT FOR SIXPLUS


           Covariance Coverage
              PFC01         PFC02         PFC03         PFC04         PFC05
              ________      ________      ________      ________      ________
 PFC01          1.000
 PFC02          1.000         1.000
 PFC03          1.000         1.000         1.000
 PFC04          1.000         1.000         1.000         1.000
 PFC05          1.000         1.000         1.000         1.000         1.000
 PFC06          1.000         1.000         1.000         1.000         1.000
 PFC07          0.994         0.994         0.994         0.994         0.994
 PFC08          0.994         0.994         0.994         0.994         0.994
 PFC09          0.987         0.987         0.987         0.987         0.987
 PFC10          0.994         0.994         0.994         0.994         0.994
 PFC11          0.994         0.994         0.994         0.994         0.994
 PFC12          0.994         0.994         0.994         0.994         0.994
 PFC13          0.994         0.994         0.994         0.994         0.994
 PFC14          0.994         0.994         0.994         0.994         0.994
 PFC15          0.981         0.981         0.981         0.981         0.981
 PFC17          0.981         0.981         0.981         0.981         0.981
 PFC18          0.981         0.981         0.981         0.981         0.981
 PFC19          0.981         0.981         0.981         0.981         0.981
 PFC20          0.974         0.974         0.974         0.974         0.974
 PFC21          0.974         0.974         0.974         0.974         0.974
 PFC22          0.981         0.981         0.981         0.981         0.981
 PFC23          0.981         0.981         0.981         0.981         0.981


           Covariance Coverage
              PFC06         PFC07         PFC08         PFC09         PFC10
              ________      ________      ________      ________      ________
 PFC06          1.000
 PFC07          0.994         0.994
 PFC08          0.994         0.994         0.994
 PFC09          0.987         0.987         0.987         0.987
 PFC10          0.994         0.994         0.994         0.987         0.994
 PFC11          0.994         0.994         0.994         0.987         0.994
 PFC12          0.994         0.994         0.994         0.987         0.994
 PFC13          0.994         0.994         0.994         0.987         0.994
 PFC14          0.994         0.994         0.994         0.987         0.994
 PFC15          0.981         0.981         0.981         0.974         0.981
 PFC17          0.981         0.981         0.981         0.974         0.981
 PFC18          0.981         0.981         0.981         0.974         0.981
 PFC19          0.981         0.981         0.981         0.974         0.981
 PFC20          0.974         0.974         0.974         0.968         0.974
 PFC21          0.974         0.974         0.974         0.968         0.974
 PFC22          0.981         0.981         0.981         0.974         0.981
 PFC23          0.981         0.981         0.981         0.974         0.981


           Covariance Coverage
              PFC11         PFC12         PFC13         PFC14         PFC15
              ________      ________      ________      ________      ________
 PFC11          0.994
 PFC12          0.994         0.994
 PFC13          0.994         0.994         0.994
 PFC14          0.994         0.994         0.994         0.994
 PFC15          0.981         0.981         0.981         0.981         0.981
 PFC17          0.981         0.981         0.981         0.981         0.981
 PFC18          0.981         0.981         0.981         0.981         0.981
 PFC19          0.981         0.981         0.981         0.981         0.981
 PFC20          0.974         0.974         0.974         0.974         0.974
 PFC21          0.974         0.974         0.974         0.974         0.974
 PFC22          0.981         0.981         0.981         0.981         0.981
 PFC23          0.981         0.981         0.981         0.981         0.981


           Covariance Coverage
              PFC17         PFC18         PFC19         PFC20         PFC21
              ________      ________      ________      ________      ________
 PFC17          0.981
 PFC18          0.981         0.981
 PFC19          0.981         0.981         0.981
 PFC20          0.974         0.974         0.974         0.974
 PFC21          0.974         0.974         0.974         0.968         0.974
 PFC22          0.981         0.981         0.981         0.974         0.974
 PFC23          0.981         0.981         0.981         0.974         0.974


           Covariance Coverage
              PFC22         PFC23
              ________      ________
 PFC22          0.981
 PFC23          0.981         0.981


UNIVARIATE PROPORTIONS AND COUNTS FOR CATEGORICAL VARIABLES

  Group UNDERSIX
    PFC01
      Category 1    0.748          220.000
      Category 2    0.204           60.000
      Category 3    0.044           13.000
      Category 4    0.003            1.000
    PFC02
      Category 1    0.279           82.000
      Category 2    0.551          162.000
      Category 3    0.143           42.000
      Category 4    0.024            7.000
      Category 5    0.003            1.000
    PFC03
      Category 1    0.769          226.000
      Category 2    0.211           62.000
      Category 3    0.020            6.000
    PFC04
      Category 1    0.177           52.000
      Category 2    0.454          133.000
      Category 3    0.276           81.000
      Category 4    0.072           21.000
      Category 5    0.020            6.000
    PFC05
      Category 1    0.602          177.000
      Category 2    0.310           91.000
      Category 3    0.058           17.000
      Category 4    0.014            4.000
      Category 5    0.017            5.000
    PFC06
      Category 1    0.447          131.000
      Category 2    0.362          106.000
      Category 3    0.102           30.000
      Category 4    0.051           15.000
      Category 5    0.038           11.000
    PFC07
      Category 1    0.078           23.000
      Category 2    0.347          102.000
      Category 3    0.412          121.000
      Category 4    0.119           35.000
      Category 5    0.044           13.000
    PFC08
      Category 1    0.276           81.000
      Category 2    0.469          138.000
      Category 3    0.184           54.000
      Category 4    0.071           21.000
    PFC09
      Category 1    0.860          252.000
      Category 2    0.119           35.000
      Category 3    0.020            6.000
    PFC10
      Category 1    0.221           65.000
      Category 2    0.497          146.000
      Category 3    0.218           64.000
      Category 4    0.037           11.000
      Category 5    0.027            8.000
    PFC11
      Category 1    0.430          125.000
      Category 2    0.364          106.000
      Category 3    0.155           45.000
      Category 4    0.052           15.000
    PFC12
      Category 1    0.619          182.000
      Category 2    0.306           90.000
      Category 3    0.051           15.000
      Category 4    0.020            6.000
      Category 5    0.003            1.000
    PFC13
      Category 1    0.575          169.000
      Category 2    0.289           85.000
      Category 3    0.105           31.000
      Category 4    0.020            6.000
      Category 5    0.010            3.000
    PFC14
      Category 1    0.704          207.000
      Category 2    0.207           61.000
      Category 3    0.058           17.000
      Category 4    0.010            3.000
      Category 5    0.020            6.000
    PFC15
      Category 1    0.616          180.000
      Category 2    0.257           75.000
      Category 3    0.062           18.000
      Category 4    0.007            2.000
      Category 5    0.058           17.000
    PFC17
      Category 1    0.640          187.000
      Category 2    0.295           86.000
      Category 3    0.065           19.000
    PFC18
      Category 1    0.818          239.000
      Category 2    0.127           37.000
      Category 3    0.038           11.000
      Category 4    0.017            5.000
    PFC19
      Category 1    0.690          200.000
      Category 2    0.193           56.000
      Category 3    0.076           22.000
      Category 4    0.041           12.000
    PFC20
      Category 1    0.711          207.000
      Category 2    0.168           49.000
      Category 3    0.086           25.000
      Category 4    0.034           10.000
    PFC21
      Category 1    0.790          230.000
      Category 2    0.141           41.000
      Category 3    0.045           13.000
      Category 4    0.024            7.000
    PFC22
      Category 1    0.567          165.000
      Category 2    0.326           95.000
      Category 3    0.086           25.000
      Category 4    0.021            6.000
    PFC23
      Category 1    0.615          179.000
      Category 2    0.186           54.000
      Category 3    0.124           36.000
      Category 4    0.076           22.000

  Group SIXPLUS
    PFC01
      Category 1    0.718          112.000
      Category 2    0.231           36.000
      Category 3    0.038            6.000
      Category 4    0.013            2.000
    PFC02
      Category 1    0.321           50.000
      Category 2    0.494           77.000
      Category 3    0.141           22.000
      Category 4    0.026            4.000
      Category 5    0.019            3.000
    PFC03
      Category 1    0.686          107.000
      Category 2    0.301           47.000
      Category 3    0.013            2.000
    PFC04
      Category 1    0.295           46.000
      Category 2    0.429           67.000
      Category 3    0.212           33.000
      Category 4    0.051            8.000
      Category 5    0.013            2.000
    PFC05
      Category 1    0.603           94.000
      Category 2    0.314           49.000
      Category 3    0.058            9.000
      Category 4    0.019            3.000
      Category 5    0.006            1.000
    PFC06
      Category 1    0.494           77.000
      Category 2    0.365           57.000
      Category 3    0.083           13.000
      Category 4    0.038            6.000
      Category 5    0.019            3.000
    PFC07
      Category 1    0.168           26.000
      Category 2    0.394           61.000
      Category 3    0.310           48.000
      Category 4    0.103           16.000
      Category 5    0.026            4.000
    PFC08
      Category 1    0.413           64.000
      Category 2    0.413           64.000
      Category 3    0.135           21.000
      Category 4    0.039            6.000
    PFC09
      Category 1    0.825          127.000
      Category 2    0.169           26.000
      Category 3    0.006            1.000
    PFC10
      Category 1    0.232           36.000
      Category 2    0.465           72.000
      Category 3    0.245           38.000
      Category 4    0.039            6.000
      Category 5    0.019            3.000
    PFC11
      Category 1    0.516           80.000
      Category 2    0.361           56.000
      Category 3    0.090           14.000
      Category 4    0.032            5.000
    PFC12
      Category 1    0.535           83.000
      Category 2    0.342           53.000
      Category 3    0.097           15.000
      Category 4    0.013            2.000
      Category 5    0.013            2.000
    PFC13
      Category 1    0.503           78.000
      Category 2    0.355           55.000
      Category 3    0.116           18.000
      Category 4    0.019            3.000
      Category 5    0.006            1.000
    PFC14
      Category 1    0.755          117.000
      Category 2    0.142           22.000
      Category 3    0.045            7.000
      Category 4    0.052            8.000
      Category 5    0.006            1.000
    PFC15
      Category 1    0.595           91.000
      Category 2    0.275           42.000
      Category 3    0.039            6.000
      Category 4    0.046            7.000
      Category 5    0.046            7.000
    PFC17
      Category 1    0.536           82.000
      Category 2    0.405           62.000
      Category 3    0.059            9.000
    PFC18
      Category 1    0.771          118.000
      Category 2    0.183           28.000
      Category 3    0.020            3.000
      Category 4    0.026            4.000
    PFC19
      Category 1    0.719          110.000
      Category 2    0.163           25.000
      Category 3    0.111           17.000
      Category 4    0.007            1.000
    PFC20
      Category 1    0.664          101.000
      Category 2    0.217           33.000
      Category 3    0.086           13.000
      Category 4    0.033            5.000
    PFC21
      Category 1    0.809          123.000
      Category 2    0.099           15.000
      Category 3    0.059            9.000
      Category 4    0.033            5.000
    PFC22
      Category 1    0.582           89.000
      Category 2    0.307           47.000
      Category 3    0.092           14.000
      Category 4    0.020            3.000
    PFC23
      Category 1    0.654          100.000
      Category 2    0.203           31.000
      Category 3    0.105           16.000
      Category 4    0.039            6.000


SAMPLE STATISTICS


     ESTIMATED SAMPLE STATISTICS FOR UNDERSIX


           MEANS/INTERCEPTS/THRESHOLDS
              PFC01$1       PFC01$2       PFC01$3       PFC02$1       PFC02$2
              ________      ________      ________      ________      ________
                0.669         1.668         2.706        -0.586         0.954


           MEANS/INTERCEPTS/THRESHOLDS
              PFC02$3       PFC02$4       PFC03$1       PFC03$2       PFC04$1
              ________      ________      ________      ________      ________
                1.923         2.706         0.735         2.045        -0.925


           MEANS/INTERCEPTS/THRESHOLDS
              PFC04$2       PFC04$3       PFC04$4       PFC05$1       PFC05$2
              ________      ________      ________      ________      ________
                0.336         1.328         2.044         0.259         1.350


           MEANS/INTERCEPTS/THRESHOLDS
              PFC05$3       PFC05$4       PFC06$1       PFC06$2       PFC06$3
              ________      ________      ________      ________      ________
                1.872         2.120        -0.133         0.874         1.349


           MEANS/INTERCEPTS/THRESHOLDS
              PFC06$4       PFC07$1       PFC07$2       PFC07$3       PFC07$4
              ________      ________      ________      ________      ________
                1.780        -1.417        -0.189         0.981         1.704


           MEANS/INTERCEPTS/THRESHOLDS
              PFC08$1       PFC08$2       PFC08$3       PFC09$1       PFC09$2
              ________      ________      ________      ________      ________
               -0.596         0.659         1.465         1.081         2.044


           MEANS/INTERCEPTS/THRESHOLDS
              PFC10$1       PFC10$2       PFC10$3       PFC10$4       PFC11$1
              ________      ________      ________      ________      ________
               -0.769         0.576         1.517         1.923        -0.178


           MEANS/INTERCEPTS/THRESHOLDS
              PFC11$2       PFC11$3       PFC12$1       PFC12$2       PFC12$3
              ________      ________      ________      ________      ________
                0.820         1.630         0.303         1.441         1.981


           MEANS/INTERCEPTS/THRESHOLDS
              PFC12$4       PFC13$1       PFC13$2       PFC13$3       PFC13$4
              ________      ________      ________      ________      ________
                2.706         0.189         1.098         1.872         2.319


           MEANS/INTERCEPTS/THRESHOLDS
              PFC14$1       PFC14$2       PFC14$3       PFC14$4       PFC15$1
              ________      ________      ________      ________      ________
                0.536         1.350         1.872         2.045         0.296


           MEANS/INTERCEPTS/THRESHOLDS
              PFC15$2       PFC15$3       PFC15$4       PFC17$1       PFC17$2
              ________      ________      ________      ________      ________
                1.142         1.514         1.570         0.360         1.514


           MEANS/INTERCEPTS/THRESHOLDS
              PFC18$1       PFC18$2       PFC18$3       PFC19$1       PFC19$2
              ________      ________      ________      ________      ________
                0.910         1.600         2.117         0.495         1.189


           MEANS/INTERCEPTS/THRESHOLDS
              PFC19$3       PFC20$1       PFC20$2       PFC20$3       PFC21$1
              ________      ________      ________      ________      ________
                1.735         0.557         1.174         1.820         0.808


           MEANS/INTERCEPTS/THRESHOLDS
              PFC21$2       PFC21$3       PFC22$1       PFC22$2       PFC22$3
              ________      ________      ________      ________      ________
                1.485         1.976         0.169         1.245         2.041


           MEANS/INTERCEPTS/THRESHOLDS
              PFC23$1       PFC23$2       PFC23$3
              ________      ________      ________
                0.293         0.844         1.435


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC01         PFC02         PFC03         PFC04         PFC05
              ________      ________      ________      ________      ________
 PFC01
 PFC02          0.088
 PFC03          0.514         0.237
 PFC04          0.203         0.369         0.295
 PFC05          0.335         0.469         0.333         0.372
 PFC06          0.166         0.358         0.210         0.358         0.317
 PFC07          0.010         0.465         0.270         0.429         0.291
 PFC08          0.206         0.296         0.195         0.754         0.409
 PFC09          0.547         0.216         0.839         0.272         0.312
 PFC10          0.502         0.148         0.180         0.113         0.298
 PFC11          0.244         0.375         0.250         0.382         0.220
 PFC12          0.159         0.458         0.225         0.280         0.332
 PFC13          0.127         0.349         0.234         0.185         0.318
 PFC14          0.157         0.389         0.353         0.525         0.300
 PFC15          0.308         0.194         0.246         0.246         0.317
 PFC17          0.296         0.407         0.541         0.267         0.359
 PFC18          0.333         0.456         0.435         0.340         0.279
 PFC19          0.267         0.482         0.406         0.373         0.399
 PFC20          0.207         0.441         0.425         0.359         0.350
 PFC21          0.191         0.415         0.361         0.441         0.393
 PFC22          0.458         0.358         0.371         0.438         0.407
 PFC23          0.359         0.454         0.366         0.437         0.400


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC06         PFC07         PFC08         PFC09         PFC10
              ________      ________      ________      ________      ________
 PFC07          0.270
 PFC08          0.368         0.414
 PFC09          0.193         0.262         0.232
 PFC10          0.025         0.054         0.175         0.146
 PFC11          0.231         0.413         0.356         0.275         0.285
 PFC12          0.414         0.357         0.339         0.326         0.203
 PFC13          0.199         0.330         0.241         0.240         0.301
 PFC14          0.279         0.279         0.451         0.442         0.174
 PFC15          0.215         0.208         0.264         0.276         0.281
 PFC17          0.146         0.320         0.258         0.480         0.292
 PFC18          0.375         0.399         0.409         0.504         0.269
 PFC19          0.327         0.433         0.375         0.369         0.338
 PFC20          0.301         0.404         0.316         0.271         0.181
 PFC21          0.227         0.427         0.358         0.369         0.228
 PFC22          0.263         0.337         0.483         0.299         0.327
 PFC23          0.326         0.567         0.452         0.370         0.241


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC11         PFC12         PFC13         PFC14         PFC15
              ________      ________      ________      ________      ________
 PFC12          0.408
 PFC13          0.403         0.647
 PFC14          0.517         0.431         0.434
 PFC15          0.328         0.398         0.444         0.427
 PFC17          0.288         0.514         0.468         0.400         0.344
 PFC18          0.380         0.819         0.627         0.401         0.389
 PFC19          0.410         0.615         0.597         0.434         0.472
 PFC20          0.379         0.483         0.492         0.311         0.395
 PFC21          0.492         0.437         0.394         0.540         0.403
 PFC22          0.499         0.416         0.420         0.617         0.464
 PFC23          0.470         0.498         0.438         0.429         0.344


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC17         PFC18         PFC19         PFC20         PFC21
              ________      ________      ________      ________      ________
 PFC18          0.591
 PFC19          0.534         0.657
 PFC20          0.409         0.616         0.546
 PFC21          0.364         0.420         0.433         0.533
 PFC22          0.386         0.394         0.513         0.418         0.508
 PFC23          0.402         0.507         0.553         0.534         0.529


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC22         PFC23
              ________      ________
 PFC23          0.627


     ESTIMATED SAMPLE STATISTICS FOR SIXPLUS


           MEANS/INTERCEPTS/THRESHOLDS
              PFC01$1       PFC01$2       PFC01$3       PFC02$1       PFC02$2
              ________      ________      ________      ________      ________
                0.577         1.633         2.232        -0.466         0.893


           MEANS/INTERCEPTS/THRESHOLDS
              PFC02$3       PFC02$4       PFC03$1       PFC03$2       PFC04$1
              ________      ________      ________      ________      ________
                1.697         2.070         0.484         2.232        -0.539


           MEANS/INTERCEPTS/THRESHOLDS
              PFC04$2       PFC04$3       PFC04$4       PFC05$1       PFC05$2
              ________      ________      ________      ________      ________
                0.596         1.521         2.232         0.260         1.383


           MEANS/INTERCEPTS/THRESHOLDS
              PFC05$3       PFC05$4       PFC06$1       PFC06$2       PFC06$3
              ________      ________      ________      ________      ________
                1.949         2.489        -0.016         1.076         1.574


           MEANS/INTERCEPTS/THRESHOLDS
              PFC06$4       PFC07$1       PFC07$2       PFC07$3       PFC07$4
              ________      ________      ________      ________      ________
                2.070        -0.963         0.154         1.131         1.946


           MEANS/INTERCEPTS/THRESHOLDS
              PFC08$1       PFC08$2       PFC08$3       PFC09$1       PFC09$2
              ________      ________      ________      ________      ________
               -0.220         0.938         1.766         0.933         2.484


           MEANS/INTERCEPTS/THRESHOLDS
              PFC10$1       PFC10$2       PFC10$3       PFC10$4       PFC11$1
              ________      ________      ________      ________      ________
               -0.731         0.515         1.571         2.067         0.040


           MEANS/INTERCEPTS/THRESHOLDS
              PFC11$2       PFC11$3       PFC12$1       PFC12$2       PFC12$3
              ________      ________      ________      ________      ________
                1.162         1.849         0.089         1.162         1.946


           MEANS/INTERCEPTS/THRESHOLDS
              PFC12$4       PFC13$1       PFC13$2       PFC13$3       PFC13$4
              ________      ________      ________      ________      ________
                2.229         0.008         1.072         1.946         2.486


           MEANS/INTERCEPTS/THRESHOLDS
              PFC14$1       PFC14$2       PFC14$3       PFC14$4       PFC15$1
              ________      ________      ________      ________      ________
                0.690         1.263         1.571         2.486         0.240


           MEANS/INTERCEPTS/THRESHOLDS
              PFC15$2       PFC15$3       PFC15$4       PFC17$1       PFC17$2
              ________      ________      ________      ________      ________
                1.123         1.332         1.688         0.090         1.565


           MEANS/INTERCEPTS/THRESHOLDS
              PFC18$1       PFC18$2       PFC18$3       PFC19$1       PFC19$2
              ________      ________      ________      ________      ________
                0.743         1.688         1.941         0.580         1.187


           MEANS/INTERCEPTS/THRESHOLDS
              PFC19$3       PFC20$1       PFC20$2       PFC20$3       PFC21$1
              ________      ________      ________      ________      ________
                2.482         0.425         1.183         1.840         0.875


           MEANS/INTERCEPTS/THRESHOLDS
              PFC21$2       PFC21$3       PFC22$1       PFC22$2       PFC22$3
              ________      ________      ________      ________      ________
                1.328         1.840         0.206         1.221         2.062


           MEANS/INTERCEPTS/THRESHOLDS
              PFC23$1       PFC23$2       PFC23$3
              ________      ________      ________
                0.395         1.063         1.760


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC01         PFC02         PFC03         PFC04         PFC05
              ________      ________      ________      ________      ________
 PFC01
 PFC02          0.438
 PFC03          0.668         0.543
 PFC04          0.303         0.346         0.349
 PFC05          0.658         0.493         0.492         0.506
 PFC06          0.417         0.369         0.399         0.388         0.397
 PFC07          0.429         0.547         0.468         0.458         0.531
 PFC08          0.365         0.416         0.385         0.673         0.398
 PFC09          0.603         0.295         0.702         0.452         0.480
 PFC10          0.509         0.512         0.294         0.106         0.423
 PFC11          0.381         0.303         0.309         0.449         0.414
 PFC12          0.326         0.547         0.294         0.462         0.349
 PFC13          0.318         0.445         0.167         0.426         0.379
 PFC14          0.301         0.324         0.324         0.634         0.424
 PFC15          0.438         0.478         0.360         0.469         0.548
 PFC17          0.380         0.472         0.332         0.436         0.599
 PFC18          0.167         0.588         0.142         0.492         0.410
 PFC19          0.473         0.545         0.349         0.363         0.566
 PFC20          0.342         0.381         0.364         0.294         0.490
 PFC21          0.244         0.282         0.077         0.451         0.333
 PFC22          0.651         0.456         0.452         0.569         0.542
 PFC23          0.563         0.535         0.540         0.477         0.636


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC06         PFC07         PFC08         PFC09         PFC10
              ________      ________      ________      ________      ________
 PFC07          0.384
 PFC08          0.321         0.468
 PFC09          0.142         0.353         0.462
 PFC10          0.246         0.319         0.198         0.212
 PFC11          0.293         0.318         0.474         0.413         0.248
 PFC12          0.421         0.355         0.344         0.303         0.354
 PFC13          0.389         0.371         0.432         0.231         0.253
 PFC14          0.375         0.287         0.529         0.427         0.313
 PFC15          0.357         0.337         0.440         0.560         0.362
 PFC17          0.404         0.514         0.450         0.288         0.269
 PFC18          0.274         0.340         0.334         0.397         0.304
 PFC19          0.418         0.460         0.432         0.277         0.400
 PFC20          0.337         0.489         0.301         0.430         0.304
 PFC21          0.227         0.373         0.413         0.315         0.176
 PFC22          0.363         0.489         0.451         0.447         0.437
 PFC23          0.351         0.537         0.392         0.501         0.389


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC11         PFC12         PFC13         PFC14         PFC15
              ________      ________      ________      ________      ________
 PFC12          0.519
 PFC13          0.432         0.647
 PFC14          0.468         0.558         0.427
 PFC15          0.383         0.403         0.441         0.547
 PFC17          0.265         0.370         0.381         0.340         0.557
 PFC18          0.410         0.861         0.596         0.450         0.465
 PFC19          0.479         0.550         0.517         0.504         0.615
 PFC20          0.349         0.498         0.329         0.324         0.445
 PFC21          0.432         0.326         0.290         0.434         0.308
 PFC22          0.369         0.448         0.281         0.607         0.581
 PFC23          0.381         0.392         0.368         0.445         0.481


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC17         PFC18         PFC19         PFC20         PFC21
              ________      ________      ________      ________      ________
 PFC18          0.430
 PFC19          0.558         0.641
 PFC20          0.504         0.525         0.555
 PFC21          0.495         0.546         0.431         0.470
 PFC22          0.520         0.475         0.683         0.468         0.504
 PFC23          0.551         0.507         0.539         0.542         0.547


           CORRELATION MATRIX (WITH VARIANCES ON THE DIAGONAL)
              PFC22         PFC23
              ________      ________
 PFC23          0.787


THE MODEL ESTIMATION TERMINATED NORMALLY



MODEL FIT INFORMATION

Number of Free Parameters                      167

Chi-Square Test of Model Fit

          Value                            635.469*
          Degrees of Freedom                   441
          P-Value                           0.0000

Chi-Square Contribution From Each Group

          UNDERSIX                         324.197
          SIXPLUS                          311.272

Chi-Square Test for Difference Testing

          Value                            137.983*
          Degrees of Freedom                   105
          P-Value                           0.0171

*   The chi-square value for MLM, MLMV, MLR, ULSMV, WLSM and WLSMV cannot be used
    for chi-square difference testing in the regular way.  MLM, MLR and WLSM
    chi-square difference testing is described on the Mplus website.  MLMV, WLSMV,
    and ULSMV difference testing is done using the DIFFTEST option.  The DIFFTEST
    option assumes the models are nested.  The NESTED option can be used to verify
    that the models are nested.

RMSEA (Root Mean Square Error Of Approximation)

          Estimate                           0.044
          90 Percent C.I.                    0.036  0.052
          Probability RMSEA <= .05           0.894

CFI/TLI

          CFI                                0.972
          TLI                                0.971

Chi-Square Test of Model Fit for the Baseline Model

          Value                           7443.787
          Degrees of Freedom                   462
          P-Value                           0.0000

SRMR (Standardized Root Mean Square Residual)

          Value                              0.060

Optimum Function Value for Weighted Least-Squares Estimator

          Value                     0.56041658D+00



MODEL RESULTS

                                                    Two-Tailed
                    Estimate       S.E.  Est./S.E.    P-Value

Group UNDERSIX

 F1       BY
    PFC01              0.984      0.143      6.885      0.000
    PFC02              0.193      0.057      3.412      0.001
    PFC03              1.921      0.398      4.827      0.000
    PFC04             -0.040      0.055     -0.729      0.466
    PFC05              0.427      0.076      5.618      0.000
    PFC06              0.067      0.059      1.137      0.256
    PFC07              0.119      0.054      2.189      0.029
    PFC08             -0.003      0.067     -0.042      0.967
    PFC09              1.537      0.321      4.795      0.000
    PFC10              0.365      0.066      5.513      0.000
    PFC11              0.083      0.068      1.214      0.225
    PFC12             -0.098      0.082     -1.199      0.231
    PFC13              0.028      0.073      0.383      0.702
    PFC14              0.162      0.084      1.933      0.053
    PFC15              0.348      0.067      5.191      0.000
    PFC17              0.460      0.087      5.300      0.000
    PFC18              0.051      0.083      0.619      0.536
    PFC19              0.315      0.090      3.485      0.000
    PFC20              0.237      0.084      2.801      0.005
    PFC21              0.144      0.094      1.528      0.127
    PFC22              0.501      0.085      5.898      0.000
    PFC23              0.429      0.094      4.544      0.000

 F2       BY
    PFC01             -0.108      0.106     -1.021      0.307
    PFC02              0.319      0.073      4.349      0.000
    PFC03              0.013      0.069      0.188      0.851
    PFC04              1.714      0.266      6.449      0.000
    PFC05              0.316      0.089      3.554      0.000
    PFC06              0.338      0.077      4.413      0.000
    PFC07              0.588      0.082      7.133      0.000
    PFC08              1.511      0.236      6.412      0.000
    PFC09              0.040      0.096      0.413      0.680
    PFC10             -0.075      0.075     -1.003      0.316
    PFC11              0.475      0.091      5.228      0.000
    PFC12              0.078      0.090      0.863      0.388
    PFC13              0.064      0.085      0.753      0.452
    PFC14              0.676      0.116      5.834      0.000
    PFC15              0.127      0.077      1.638      0.101
    PFC17              0.042      0.081      0.513      0.608
    PFC18             -0.042      0.082     -0.519      0.604
    PFC19              0.268      0.106      2.534      0.011
    PFC20              0.240      0.091      2.625      0.009
    PFC21              0.567      0.109      5.195      0.000
    PFC22              0.584      0.105      5.549      0.000
    PFC23              0.624      0.113      5.503      0.000

 F3       BY
    PFC01              0.048      0.098      0.492      0.623
    PFC02              0.492      0.077      6.423      0.000
    PFC03             -0.081      0.076     -1.065      0.287
    PFC04             -0.083      0.069     -1.202      0.229
    PFC05              0.222      0.077      2.892      0.004
    PFC06              0.236      0.066      3.593      0.000
    PFC07              0.235      0.071      3.317      0.001
    PFC08             -0.074      0.072     -1.029      0.303
    PFC09              0.002      0.117      0.015      0.988
    PFC10              0.282      0.070      4.018      0.000
    PFC11              0.382      0.078      4.915      0.000
    PFC12              1.889      0.237      7.952      0.000
    PFC13              1.037      0.116      8.939      0.000
    PFC14              0.379      0.090      4.210      0.000
    PFC15              0.431      0.077      5.621      0.000
    PFC17              0.625      0.087      7.187      0.000
    PFC18              2.263      0.531      4.263      0.000
    PFC19              0.922      0.120      7.668      0.000
    PFC20              0.663      0.101      6.550      0.000
    PFC21              0.451      0.110      4.116      0.000
    PFC22              0.342      0.088      3.903      0.000
    PFC23              0.419      0.101      4.132      0.000

 F2       WITH
    F1                 0.321      0.054      5.960      0.000

 F3       WITH
    F1                 0.363      0.059      6.118      0.000
    F2                 0.409      0.050      8.247      0.000

 Means
    F1                 0.000      0.000    999.000    999.000
    F2                 0.000      0.000    999.000    999.000
    F3                 0.000      0.000    999.000    999.000

 Thresholds
    PFC01$1            0.886      0.122      7.272      0.000
    PFC01$2            2.334      0.229     10.192      0.000
    PFC01$3            3.464      0.461      7.508      0.000
    PFC02$1           -0.715      0.089     -8.061      0.000
    PFC02$2            1.167      0.109     10.688      0.000
    PFC02$3            2.304      0.183     12.563      0.000
    PFC02$4            2.877      0.314      9.158      0.000
    PFC03$1            1.511      0.300      5.039      0.000
    PFC03$2            4.743      0.812      5.843      0.000
    PFC04$1           -1.848      0.259     -7.132      0.000
    PFC04$2            0.583      0.145      4.016      0.000
    PFC04$3            2.516      0.317      7.929      0.000
    PFC04$4            3.935      0.508      7.745      0.000
    PFC05$1            0.265      0.081      3.277      0.001
    PFC05$2            1.624      0.132     12.299      0.000
    PFC05$3            2.288      0.168     13.619      0.000
    PFC05$4            2.683      0.205     13.097      0.000
    PFC06$1           -0.142      0.069     -2.064      0.039
    PFC06$2            0.986      0.094     10.534      0.000
    PFC06$3            1.512      0.119     12.663      0.000
    PFC06$4            2.005      0.153     13.139      0.000
    PFC07$1           -1.654      0.121    -13.694      0.000
    PFC07$2           -0.171      0.081     -2.101      0.036
    PFC07$3            1.234      0.106     11.593      0.000
    PFC07$4            2.183      0.158     13.838      0.000
    PFC08$1           -1.094      0.170     -6.421      0.000
    PFC08$2            1.158      0.166      6.960      0.000
    PFC08$3            2.643      0.297      8.914      0.000
    PFC09$1            2.049      0.343      5.977      0.000
    PFC09$2            4.024      0.634      6.352      0.000
    PFC10$1           -0.812      0.083     -9.773      0.000
    PFC10$2            0.630      0.079      7.949      0.000
    PFC10$3            1.712      0.125     13.665      0.000
    PFC10$4            2.190      0.162     13.554      0.000
    PFC11$1           -0.180      0.083     -2.164      0.031
    PFC11$2            1.124      0.106     10.611      0.000
    PFC11$3            2.106      0.156     13.507      0.000
    PFC12$1            0.616      0.176      3.496      0.000
    PFC12$2            2.885      0.340      8.491      0.000
    PFC12$3            4.211      0.498      8.460      0.000
    PFC12$4            5.108      0.663      7.699      0.000
    PFC13$1            0.252      0.106      2.385      0.017
    PFC13$2            1.647      0.145     11.329      0.000
    PFC13$3            2.812      0.225     12.520      0.000
    PFC13$4            3.489      0.279     12.528      0.000
    PFC14$1            0.773      0.110      7.023      0.000
    PFC14$2            1.841      0.164     11.192      0.000
    PFC14$3            2.464      0.229     10.783      0.000
    PFC14$4            2.978      0.262     11.378      0.000
    PFC15$1            0.329      0.080      4.106      0.000
    PFC15$2            1.361      0.114     11.932      0.000
    PFC15$3            1.722      0.134     12.859      0.000
    PFC15$4            1.933      0.141     13.727      0.000
    PFC17$1            0.394      0.097      4.037      0.000
    PFC17$2            2.141      0.167     12.814      0.000
    PFC18$1            2.240      0.507      4.421      0.000
    PFC18$2            4.113      0.840      4.898      0.000
    PFC18$3            5.121      0.980      5.223      0.000
    PFC19$1            0.840      0.129      6.515      0.000
    PFC19$2            1.890      0.176     10.726      0.000
    PFC19$3            2.885      0.234     12.334      0.000
    PFC20$1            0.718      0.106      6.768      0.000
    PFC20$2            1.642      0.145     11.286      0.000
    PFC20$3            2.546      0.204     12.510      0.000
    PFC21$1            1.144      0.129      8.887      0.000
    PFC21$2            2.024      0.180     11.236      0.000
    PFC21$3            2.748      0.245     11.203      0.000
    PFC22$1            0.198      0.101      1.967      0.049
    PFC22$2            1.806      0.159     11.361      0.000
    PFC22$3            3.041      0.263     11.564      0.000
    PFC23$1            0.426      0.107      3.993      0.000
    PFC23$2            1.329      0.134      9.898      0.000
    PFC23$3            2.264      0.188     12.044      0.000

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

Group SIXPLUS

 F1       BY
    PFC01              0.984      0.143      6.885      0.000
    PFC02              0.193      0.057      3.412      0.001
    PFC03              1.921      0.398      4.827      0.000
    PFC04             -0.040      0.055     -0.729      0.466
    PFC05              0.427      0.076      5.618      0.000
    PFC06              0.067      0.059      1.137      0.256
    PFC07              0.119      0.054      2.189      0.029
    PFC08             -0.003      0.067     -0.042      0.967
    PFC09              1.537      0.321      4.795      0.000
    PFC10              0.365      0.066      5.513      0.000
    PFC11              0.083      0.068      1.214      0.225
    PFC12             -0.098      0.082     -1.199      0.231
    PFC13              0.028      0.073      0.383      0.702
    PFC14              0.162      0.084      1.933      0.053
    PFC15              0.348      0.067      5.191      0.000
    PFC17              0.460      0.087      5.300      0.000
    PFC18              0.051      0.083      0.619      0.536
    PFC19              0.315      0.090      3.485      0.000
    PFC20              0.237      0.084      2.801      0.005
    PFC21              0.144      0.094      1.528      0.127
    PFC22              0.501      0.085      5.898      0.000
    PFC23              0.429      0.094      4.544      0.000

 F2       BY
    PFC01             -0.108      0.106     -1.021      0.307
    PFC02              0.319      0.073      4.349      0.000
    PFC03              0.013      0.069      0.188      0.851
    PFC04              1.714      0.266      6.449      0.000
    PFC05              0.316      0.089      3.554      0.000
    PFC06              0.338      0.077      4.413      0.000
    PFC07              0.588      0.082      7.133      0.000
    PFC08              1.511      0.236      6.412      0.000
    PFC09              0.040      0.096      0.413      0.680
    PFC10             -0.075      0.075     -1.003      0.316
    PFC11              0.475      0.091      5.228      0.000
    PFC12              0.078      0.090      0.863      0.388
    PFC13              0.064      0.085      0.753      0.452
    PFC14              0.676      0.116      5.834      0.000
    PFC15              0.127      0.077      1.638      0.101
    PFC17              0.042      0.081      0.513      0.608
    PFC18             -0.042      0.082     -0.519      0.604
    PFC19              0.268      0.106      2.534      0.011
    PFC20              0.240      0.091      2.625      0.009
    PFC21              0.567      0.109      5.195      0.000
    PFC22              0.584      0.105      5.549      0.000
    PFC23              0.624      0.113      5.503      0.000

 F3       BY
    PFC01              0.048      0.098      0.492      0.623
    PFC02              0.492      0.077      6.423      0.000
    PFC03             -0.081      0.076     -1.065      0.287
    PFC04             -0.083      0.069     -1.202      0.229
    PFC05              0.222      0.077      2.892      0.004
    PFC06              0.236      0.066      3.593      0.000
    PFC07              0.235      0.071      3.317      0.001
    PFC08             -0.074      0.072     -1.029      0.303
    PFC09              0.002      0.117      0.015      0.988
    PFC10              0.282      0.070      4.018      0.000
    PFC11              0.382      0.078      4.915      0.000
    PFC12              1.889      0.237      7.952      0.000
    PFC13              1.037      0.116      8.939      0.000
    PFC14              0.379      0.090      4.210      0.000
    PFC15              0.431      0.077      5.621      0.000
    PFC17              0.625      0.087      7.187      0.000
    PFC18              2.263      0.531      4.263      0.000
    PFC19              0.922      0.120      7.668      0.000
    PFC20              0.663      0.101      6.550      0.000
    PFC21              0.451      0.110      4.116      0.000
    PFC22              0.342      0.088      3.903      0.000
    PFC23              0.419      0.101      4.132      0.000

 F2       WITH
    F1                 0.834      0.183      4.546      0.000

 F3       WITH
    F1                 0.436      0.135      3.234      0.001
    F2                 0.528      0.110      4.789      0.000

 Means
    F1                -0.121      0.194     -0.626      0.531
    F2                -0.467      0.120     -3.891      0.000
    F3                 0.223      0.131      1.701      0.089

 Thresholds
    PFC01$1            0.886      0.122      7.272      0.000
    PFC01$2            2.334      0.229     10.192      0.000
    PFC01$3            3.464      0.461      7.508      0.000
    PFC02$1           -0.715      0.089     -8.061      0.000
    PFC02$2            1.167      0.109     10.688      0.000
    PFC02$3            2.304      0.183     12.563      0.000
    PFC02$4            2.877      0.314      9.158      0.000
    PFC03$1            1.511      0.300      5.039      0.000
    PFC03$2            4.743      0.812      5.843      0.000
    PFC04$1           -1.848      0.259     -7.132      0.000
    PFC04$2            0.583      0.145      4.016      0.000
    PFC04$3            2.516      0.317      7.929      0.000
    PFC04$4            3.935      0.508      7.745      0.000
    PFC05$1            0.265      0.081      3.277      0.001
    PFC05$2            1.624      0.132     12.299      0.000
    PFC05$3            2.288      0.168     13.619      0.000
    PFC05$4            2.683      0.205     13.097      0.000
    PFC06$1           -0.142      0.069     -2.064      0.039
    PFC06$2            0.986      0.094     10.534      0.000
    PFC06$3            1.512      0.119     12.663      0.000
    PFC06$4            2.005      0.153     13.139      0.000
    PFC07$1           -1.654      0.121    -13.694      0.000
    PFC07$2           -0.171      0.081     -2.101      0.036
    PFC07$3            1.234      0.106     11.593      0.000
    PFC07$4            2.183      0.158     13.838      0.000
    PFC08$1           -1.094      0.170     -6.421      0.000
    PFC08$2            1.158      0.166      6.960      0.000
    PFC08$3            2.643      0.297      8.914      0.000
    PFC09$1            2.049      0.343      5.977      0.000
    PFC09$2            4.024      0.634      6.352      0.000
    PFC10$1           -0.812      0.083     -9.773      0.000
    PFC10$2            0.630      0.079      7.949      0.000
    PFC10$3            1.712      0.125     13.665      0.000
    PFC10$4            2.190      0.162     13.554      0.000
    PFC11$1           -0.180      0.083     -2.164      0.031
    PFC11$2            1.124      0.106     10.611      0.000
    PFC11$3            2.106      0.156     13.507      0.000
    PFC12$1            0.616      0.176      3.496      0.000
    PFC12$2            2.885      0.340      8.491      0.000
    PFC12$3            4.211      0.498      8.460      0.000
    PFC12$4            5.108      0.663      7.699      0.000
    PFC13$1            0.252      0.106      2.385      0.017
    PFC13$2            1.647      0.145     11.329      0.000
    PFC13$3            2.812      0.225     12.520      0.000
    PFC13$4            3.489      0.279     12.528      0.000
    PFC14$1            0.773      0.110      7.023      0.000
    PFC14$2            1.841      0.164     11.192      0.000
    PFC14$3            2.464      0.229     10.783      0.000
    PFC14$4            2.978      0.262     11.378      0.000
    PFC15$1            0.329      0.080      4.106      0.000
    PFC15$2            1.361      0.114     11.932      0.000
    PFC15$3            1.722      0.134     12.859      0.000
    PFC15$4            1.933      0.141     13.727      0.000
    PFC17$1            0.394      0.097      4.037      0.000
    PFC17$2            2.141      0.167     12.814      0.000
    PFC18$1            2.240      0.507      4.421      0.000
    PFC18$2            4.113      0.840      4.898      0.000
    PFC18$3            5.121      0.980      5.223      0.000
    PFC19$1            0.840      0.129      6.515      0.000
    PFC19$2            1.890      0.176     10.726      0.000
    PFC19$3            2.885      0.234     12.334      0.000
    PFC20$1            0.718      0.106      6.768      0.000
    PFC20$2            1.642      0.145     11.286      0.000
    PFC20$3            2.546      0.204     12.510      0.000
    PFC21$1            1.144      0.129      8.887      0.000
    PFC21$2            2.024      0.180     11.236      0.000
    PFC21$3            2.748      0.245     11.203      0.000
    PFC22$1            0.198      0.101      1.967      0.049
    PFC22$2            1.806      0.159     11.361      0.000
    PFC22$3            3.041      0.263     11.564      0.000
    PFC23$1            0.426      0.107      3.993      0.000
    PFC23$2            1.329      0.134      9.898      0.000
    PFC23$3            2.264      0.188     12.044      0.000

 Variances
    F1                 1.781      0.525      3.394      0.001
    F2                 1.008      0.181      5.567      0.000
    F3                 0.854      0.194      4.399      0.000

 Residual Variances
    PFC01              0.577      0.293      1.973      0.048
    PFC02              0.913      0.190      4.801      0.000
    PFC03              3.518      2.064      1.704      0.088
    PFC04              1.580      0.497      3.180      0.001
    PFC05              0.616      0.136      4.538      0.000
    PFC06              0.745      0.185      4.028      0.000
    PFC07              0.960      0.196      4.886      0.000
    PFC08              1.627      0.508      3.202      0.001
    PFC09              2.533      1.269      1.996      0.046
    PFC10              0.806      0.167      4.830      0.000
    PFC11              1.072      0.319      3.357      0.001
    PFC12              0.733      0.273      2.686      0.007
    PFC13              0.952      0.284      3.348      0.001
    PFC14              1.350      0.352      3.831      0.000
    PFC15              0.685      0.160      4.295      0.000
    PFC17              1.091      0.376      2.904      0.004
    PFC18              0.899      0.490      1.832      0.067
    PFC19              0.875      0.277      3.162      0.002
    PFC20              1.274      0.367      3.470      0.001
    PFC21              1.769      0.556      3.179      0.001
    PFC22              0.913      0.270      3.379      0.001
    PFC23              0.904      0.281      3.222      0.001


QUALITY OF NUMERICAL RESULTS

     Condition Number for the Information Matrix              0.136E-03
       (ratio of smallest to largest eigenvalue)


STANDARDIZED MODEL RESULTS


STDYX Standardization

                                                    Two-Tailed
                    Estimate       S.E.  Est./S.E.    P-Value

Group UNDERSIX

 F1       BY
    PFC01              0.706      0.057     12.352      0.000
    PFC02              0.152      0.044      3.455      0.001
    PFC03              0.896      0.042     21.571      0.000
    PFC04             -0.021      0.027     -0.749      0.454
    PFC05              0.344      0.055      6.288      0.000
    PFC06              0.060      0.053      1.133      0.257
    PFC07              0.094      0.043      2.175      0.030
    PFC08             -0.002      0.037     -0.042      0.967
    PFC09              0.833      0.061     13.763      0.000
    PFC10              0.326      0.054      6.068      0.000
    PFC11              0.066      0.055      1.208      0.227
    PFC12             -0.046      0.038     -1.206      0.228
    PFC13              0.019      0.050      0.382      0.703
    PFC14              0.116      0.060      1.938      0.053
    PFC15              0.284      0.051      5.577      0.000
    PFC17              0.338      0.057      5.899      0.000
    PFC18              0.021      0.034      0.613      0.540
    PFC19              0.199      0.053      3.746      0.000
    PFC20              0.175      0.060      2.932      0.003
    PFC21              0.106      0.069      1.539      0.124
    PFC22              0.339      0.051      6.644      0.000
    PFC23              0.285      0.056      5.059      0.000

 F2       BY
    PFC01             -0.078      0.075     -1.029      0.303
    PFC02              0.251      0.054      4.644      0.000
    PFC03              0.006      0.032      0.188      0.851
    PFC04              0.881      0.038     23.028      0.000
    PFC05              0.254      0.069      3.704      0.000
    PFC06              0.300      0.063      4.787      0.000
    PFC07              0.466      0.054      8.590      0.000
    PFC08              0.845      0.048     17.575      0.000
    PFC09              0.022      0.052      0.412      0.680
    PFC10             -0.067      0.066     -1.010      0.312
    PFC11              0.378      0.063      5.957      0.000
    PFC12              0.037      0.043      0.856      0.392
    PFC13              0.044      0.058      0.758      0.449
    PFC14              0.484      0.064      7.548      0.000
    PFC15              0.103      0.063      1.641      0.101
    PFC17              0.031      0.060      0.514      0.607
    PFC18             -0.017      0.033     -0.516      0.606
    PFC19              0.170      0.066      2.568      0.010
    PFC20              0.177      0.066      2.701      0.007
    PFC21              0.416      0.065      6.362      0.000
    PFC22              0.395      0.062      6.340      0.000
    PFC23              0.415      0.067      6.188      0.000

 F3       BY
    PFC01              0.035      0.070      0.493      0.622
    PFC02              0.387      0.050      7.703      0.000
    PFC03             -0.038      0.035     -1.079      0.281
    PFC04             -0.043      0.036     -1.202      0.229
    PFC05              0.179      0.060      2.969      0.003
    PFC06              0.210      0.056      3.774      0.000
    PFC07              0.186      0.055      3.387      0.001
    PFC08             -0.042      0.039     -1.061      0.289
    PFC09              0.001      0.063      0.015      0.988
    PFC10              0.252      0.059      4.237      0.000
    PFC11              0.304      0.057      5.350      0.000
    PFC12              0.884      0.031     28.323      0.000
    PFC13              0.706      0.043     16.310      0.000
    PFC14              0.271      0.059      4.617      0.000
    PFC15              0.351      0.055      6.342      0.000
    PFC17              0.460      0.052      8.805      0.000
    PFC18              0.914      0.038     24.327      0.000
    PFC19              0.584      0.049     11.847      0.000
    PFC20              0.490      0.058      8.444      0.000
    PFC21              0.331      0.071      4.652      0.000
    PFC22              0.231      0.056      4.161      0.000
    PFC23              0.278      0.064      4.379      0.000

 F2       WITH
    F1                 0.321      0.054      5.960      0.000

 F3       WITH
    F1                 0.363      0.059      6.118      0.000
    F2                 0.409      0.050      8.247      0.000

 Means
    F1                 0.000      0.000    999.000    999.000
    F2                 0.000      0.000    999.000    999.000
    F3                 0.000      0.000    999.000    999.000

 Thresholds
    PFC01$1            0.636      0.072      8.780      0.000
    PFC01$2            1.674      0.118     14.175      0.000
    PFC01$3            2.485      0.274      9.062      0.000
    PFC02$1           -0.562      0.068     -8.300      0.000
    PFC02$2            0.917      0.078     11.796      0.000
    PFC02$3            1.812      0.129     14.076      0.000
    PFC02$4            2.261      0.233      9.703      0.000
    PFC03$1            0.704      0.077      9.124      0.000
    PFC03$2            2.212      0.166     13.301      0.000
    PFC04$1           -0.950      0.081    -11.747      0.000
    PFC04$2            0.300      0.070      4.304      0.000
    PFC04$3            1.293      0.098     13.162      0.000
    PFC04$4            2.022      0.159     12.696      0.000
    PFC05$1            0.213      0.064      3.350      0.001
    PFC05$2            1.307      0.093     14.010      0.000
    PFC05$3            1.841      0.123     14.952      0.000
    PFC05$4            2.159      0.164     13.145      0.000
    PFC06$1           -0.126      0.061     -2.067      0.039
    PFC06$2            0.876      0.078     11.221      0.000
    PFC06$3            1.344      0.098     13.685      0.000
    PFC06$4            1.782      0.127     14.041      0.000
    PFC07$1           -1.311      0.091    -14.401      0.000
    PFC07$2           -0.135      0.064     -2.103      0.035
    PFC07$3            0.978      0.082     11.932      0.000
    PFC07$4            1.730      0.121     14.281      0.000
    PFC08$1           -0.612      0.074     -8.312      0.000
    PFC08$2            0.648      0.075      8.681      0.000
    PFC08$3            1.479      0.106     13.985      0.000
    PFC09$1            1.110      0.089     12.530      0.000
    PFC09$2            2.181      0.167     13.054      0.000
    PFC10$1           -0.724      0.074     -9.724      0.000
    PFC10$2            0.562      0.067      8.382      0.000
    PFC10$3            1.526      0.102     14.911      0.000
    PFC10$4            1.952      0.133     14.653      0.000
    PFC11$1           -0.144      0.066     -2.161      0.031
    PFC11$2            0.896      0.077     11.566      0.000
    PFC11$3            1.679      0.114     14.755      0.000
    PFC12$1            0.288      0.072      4.001      0.000
    PFC12$2            1.350      0.102     13.286      0.000
    PFC12$3            1.972      0.147     13.445      0.000
    PFC12$4            2.391      0.224     10.667      0.000
    PFC13$1            0.172      0.070      2.458      0.014
    PFC13$2            1.121      0.081     13.798      0.000
    PFC13$3            1.914      0.132     14.534      0.000
    PFC13$4            2.375      0.190     12.477      0.000
    PFC14$1            0.554      0.071      7.852      0.000
    PFC14$2            1.318      0.096     13.678      0.000
    PFC14$3            1.764      0.135     13.117      0.000
    PFC14$4            2.132      0.164     13.039      0.000
    PFC15$1            0.268      0.063      4.241      0.000
    PFC15$2            1.109      0.084     13.281      0.000
    PFC15$3            1.403      0.099     14.159      0.000
    PFC15$4            1.576      0.107     14.790      0.000
    PFC17$1            0.290      0.068      4.251      0.000
    PFC17$2            1.576      0.104     15.227      0.000
    PFC18$1            0.905      0.079     11.406      0.000
    PFC18$2            1.661      0.112     14.828      0.000
    PFC18$3            2.069      0.147     14.065      0.000
    PFC19$1            0.533      0.070      7.635      0.000
    PFC19$2            1.199      0.090     13.341      0.000
    PFC19$3            1.829      0.129     14.209      0.000
    PFC20$1            0.530      0.071      7.514      0.000
    PFC20$2            1.212      0.089     13.556      0.000
    PFC20$3            1.881      0.130     14.477      0.000
    PFC21$1            0.840      0.077     10.837      0.000
    PFC21$2            1.486      0.107     13.934      0.000
    PFC21$3            2.018      0.153     13.218      0.000
    PFC22$1            0.134      0.067      2.011      0.044
    PFC22$2            1.222      0.091     13.441      0.000
    PFC22$3            2.058      0.155     13.247      0.000
    PFC23$1            0.283      0.068      4.185      0.000
    PFC23$2            0.883      0.078     11.330      0.000
    PFC23$3            1.504      0.104     14.436      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              0.514      0.071      7.272      0.000
    PFC02              0.618      0.048     12.890      0.000
    PFC03              0.217      0.071      3.077      0.002
    PFC04              0.264      0.060      4.405      0.000
    PFC05              0.648      0.049     13.169      0.000
    PFC06              0.790      0.045     17.590      0.000
    PFC07              0.628      0.043     14.566      0.000
    PFC08              0.313      0.063      4.949      0.000
    PFC09              0.294      0.082      3.567      0.000
    PFC10              0.794      0.041     19.431      0.000
    PFC11              0.635      0.051     12.493      0.000
    PFC12              0.219      0.042      5.281      0.000
    PFC13              0.463      0.052      8.866      0.000
    PFC14              0.513      0.061      8.397      0.000
    PFC15              0.664      0.046     14.527      0.000
    PFC17              0.542      0.051     10.609      0.000
    PFC18              0.163      0.064      2.551      0.011
    PFC19              0.402      0.053      7.575      0.000
    PFC20              0.545      0.059      9.189      0.000
    PFC21              0.539      0.067      8.058      0.000
    PFC22              0.458      0.050      9.180      0.000
    PFC23              0.441      0.051      8.728      0.000

Group SIXPLUS

 F1       BY
    PFC01              0.891      0.080     11.068      0.000
    PFC02              0.201      0.061      3.312      0.001
    PFC03              0.811      0.064     12.596      0.000
    PFC04             -0.026      0.035     -0.748      0.455
    PFC05              0.471      0.072      6.568      0.000
    PFC06              0.088      0.079      1.115      0.265
    PFC07              0.123      0.060      2.039      0.041
    PFC08             -0.002      0.046     -0.042      0.967
    PFC09              0.784      0.060     13.015      0.000
    PFC10              0.457      0.082      5.589      0.000
    PFC11              0.084      0.072      1.175      0.240
    PFC12             -0.068      0.056     -1.199      0.231
    PFC13              0.027      0.069      0.385      0.700
    PFC14              0.137      0.073      1.871      0.061
    PFC15              0.402      0.074      5.393      0.000
    PFC17              0.422      0.077      5.472      0.000
    PFC18              0.030      0.048      0.613      0.540
    PFC19              0.265      0.076      3.506      0.000
    PFC20              0.213      0.075      2.836      0.005
    PFC21              0.116      0.075      1.540      0.124
    PFC22              0.411      0.070      5.828      0.000
    PFC23              0.352      0.072      4.888      0.000

 F2       BY
    PFC01             -0.074      0.074     -1.002      0.316
    PFC02              0.250      0.053      4.686      0.000
    PFC03              0.004      0.022      0.188      0.851
    PFC04              0.831      0.046     18.103      0.000
    PFC05              0.262      0.069      3.810      0.000
    PFC06              0.331      0.066      4.982      0.000
    PFC07              0.457      0.058      7.863      0.000
    PFC08              0.777      0.059     13.158      0.000
    PFC09              0.015      0.037      0.415      0.678
    PFC10             -0.070      0.070     -1.000      0.317
    PFC11              0.363      0.066      5.526      0.000
    PFC12              0.040      0.047      0.850      0.395
    PFC13              0.046      0.060      0.762      0.446
    PFC14              0.430      0.060      7.229      0.000
    PFC15              0.110      0.067      1.646      0.100
    PFC17              0.029      0.055      0.521      0.602
    PFC18             -0.019      0.036     -0.509      0.611
    PFC19              0.170      0.067      2.548      0.011
    PFC20              0.162      0.059      2.743      0.006
    PFC21              0.342      0.054      6.355      0.000
    PFC22              0.360      0.063      5.710      0.000
    PFC23              0.385      0.069      5.583      0.000

 F3       BY
    PFC01              0.030      0.062      0.493      0.622
    PFC02              0.355      0.050      7.103      0.000
    PFC03             -0.024      0.022     -1.061      0.289
    PFC04             -0.037      0.031     -1.211      0.226
    PFC05              0.170      0.060      2.838      0.005
    PFC06              0.213      0.057      3.739      0.000
    PFC07              0.168      0.050      3.355      0.001
    PFC08             -0.035      0.033     -1.066      0.287
    PFC09              0.001      0.041      0.015      0.988
    PFC10              0.244      0.060      4.081      0.000
    PFC11              0.269      0.057      4.687      0.000
    PFC12              0.897      0.046     19.357      0.000
    PFC13              0.682      0.062     11.062      0.000
    PFC14              0.222      0.052      4.232      0.000
    PFC15              0.344      0.065      5.282      0.000
    PFC17              0.398      0.062      6.364      0.000
    PFC18              0.911      0.043     21.191      0.000
    PFC19              0.538      0.064      8.466      0.000
    PFC20              0.413      0.064      6.419      0.000
    PFC21              0.251      0.062      4.054      0.000
    PFC22              0.194      0.050      3.883      0.000
    PFC23              0.238      0.058      4.081      0.000

 F2       WITH
    F1                 0.622      0.070      8.826      0.000

 F3       WITH
    F1                 0.353      0.099      3.569      0.000
    F2                 0.569      0.074      7.682      0.000

 Means
    F1                -0.091      0.138     -0.661      0.509
    F2                -0.465      0.114     -4.084      0.000
    F3                 0.241      0.156      1.542      0.123

 Thresholds
    PFC01$1            0.601      0.105      5.729      0.000
    PFC01$2            1.583      0.201      7.865      0.000
    PFC01$3            2.350      0.274      8.578      0.000
    PFC02$1           -0.558      0.070     -7.930      0.000
    PFC02$2            0.911      0.088     10.320      0.000
    PFC02$3            1.799      0.150     11.982      0.000
    PFC02$4            2.246      0.204     11.010      0.000
    PFC03$1            0.478      0.092      5.186      0.000
    PFC03$2            1.500      0.229      6.539      0.000
    PFC04$1           -0.892      0.086    -10.350      0.000
    PFC04$2            0.282      0.067      4.201      0.000
    PFC04$3            1.215      0.108     11.225      0.000
    PFC04$4            1.900      0.170     11.187      0.000
    PFC05$1            0.219      0.068      3.233      0.001
    PFC05$2            1.342      0.119     11.230      0.000
    PFC05$3            1.890      0.178     10.613      0.000
    PFC05$4            2.216      0.222      9.967      0.000
    PFC06$1           -0.138      0.067     -2.059      0.040
    PFC06$2            0.961      0.099      9.706      0.000
    PFC06$3            1.474      0.135     10.924      0.000
    PFC06$4            1.954      0.185     10.566      0.000
    PFC07$1           -1.282      0.099    -12.924      0.000
    PFC07$2           -0.132      0.064     -2.078      0.038
    PFC07$3            0.956      0.086     11.058      0.000
    PFC07$4            1.691      0.135     12.509      0.000
    PFC08$1           -0.561      0.071     -7.856      0.000
    PFC08$2            0.594      0.075      7.880      0.000
    PFC08$3            1.355      0.125     10.857      0.000
    PFC09$1            0.783      0.118      6.610      0.000
    PFC09$2            1.538      0.226      6.803      0.000
    PFC10$1           -0.761      0.080     -9.553      0.000
    PFC10$2            0.590      0.078      7.549      0.000
    PFC10$3            1.604      0.135     11.872      0.000
    PFC10$4            2.052      0.182     11.244      0.000
    PFC11$1           -0.137      0.063     -2.191      0.028
    PFC11$2            0.857      0.098      8.709      0.000
    PFC11$3            1.606      0.164      9.792      0.000
    PFC12$1            0.317      0.091      3.479      0.001
    PFC12$2            1.483      0.147     10.072      0.000
    PFC12$3            2.165      0.211     10.256      0.000
    PFC12$4            2.626      0.277      9.480      0.000
    PFC13$1            0.179      0.079      2.271      0.023
    PFC13$2            1.172      0.130      9.042      0.000
    PFC13$3            2.001      0.197     10.134      0.000
    PFC13$4            2.482      0.274      9.050      0.000
    PFC14$1            0.490      0.069      7.135      0.000
    PFC14$2            1.167      0.102     11.402      0.000
    PFC14$3            1.563      0.126     12.401      0.000
    PFC14$4            1.888      0.173     10.900      0.000
    PFC15$1            0.285      0.071      4.028      0.000
    PFC15$2            1.176      0.110     10.721      0.000
    PFC15$3            1.488      0.126     11.836      0.000
    PFC15$4            1.671      0.149     11.188      0.000
    PFC17$1            0.271      0.074      3.654      0.000
    PFC17$2            1.473      0.169      8.704      0.000
    PFC18$1            0.976      0.125      7.803      0.000
    PFC18$2            1.791      0.186      9.635      0.000
    PFC18$3            2.230      0.226      9.871      0.000
    PFC19$1            0.531      0.084      6.297      0.000
    PFC19$2            1.195      0.113     10.539      0.000
    PFC19$3            1.823      0.179     10.177      0.000
    PFC20$1            0.483      0.074      6.503      0.000
    PFC20$2            1.105      0.109     10.142      0.000
    PFC20$3            1.714      0.164     10.458      0.000
    PFC21$1            0.687      0.084      8.178      0.000
    PFC21$2            1.217      0.122     10.009      0.000
    PFC21$3            1.652      0.162     10.202      0.000
    PFC22$1            0.122      0.061      1.978      0.048
    PFC22$2            1.109      0.103     10.801      0.000
    PFC22$3            1.868      0.164     11.413      0.000
    PFC23$1            0.262      0.067      3.895      0.000
    PFC23$2            0.816      0.091      8.943      0.000
    PFC23$3            1.390      0.132     10.528      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              0.266      0.096      2.754      0.006
    PFC02              0.557      0.051     10.915      0.000
    PFC03              0.352      0.097      3.635      0.000
    PFC04              0.369      0.061      6.090      0.000
    PFC05              0.420      0.057      7.432      0.000
    PFC06              0.708      0.058     12.316      0.000
    PFC07              0.576      0.056     10.244      0.000
    PFC08              0.427      0.067      6.373      0.000
    PFC09              0.370      0.079      4.701      0.000
    PFC10              0.707      0.061     11.583      0.000
    PFC11              0.623      0.071      8.815      0.000
    PFC12              0.194      0.056      3.468      0.001
    PFC13              0.482      0.068      7.075      0.000
    PFC14              0.543      0.060      9.108      0.000
    PFC15              0.512      0.059      8.746      0.000
    PFC17              0.516      0.077      6.725      0.000
    PFC18              0.170      0.063      2.714      0.007
    PFC19              0.350      0.066      5.283      0.000
    PFC20              0.577      0.065      8.856      0.000
    PFC21              0.639      0.070      9.110      0.000
    PFC22              0.344      0.066      5.182      0.000
    PFC23              0.341      0.061      5.611      0.000


STDY Standardization

                                                    Two-Tailed
                    Estimate       S.E.  Est./S.E.    P-Value

Group UNDERSIX

 F1       BY
    PFC01              0.706      0.057     12.352      0.000
    PFC02              0.152      0.044      3.455      0.001
    PFC03              0.896      0.042     21.571      0.000
    PFC04             -0.021      0.027     -0.749      0.454
    PFC05              0.344      0.055      6.288      0.000
    PFC06              0.060      0.053      1.133      0.257
    PFC07              0.094      0.043      2.175      0.030
    PFC08             -0.002      0.037     -0.042      0.967
    PFC09              0.833      0.061     13.763      0.000
    PFC10              0.326      0.054      6.068      0.000
    PFC11              0.066      0.055      1.208      0.227
    PFC12             -0.046      0.038     -1.206      0.228
    PFC13              0.019      0.050      0.382      0.703
    PFC14              0.116      0.060      1.938      0.053
    PFC15              0.284      0.051      5.577      0.000
    PFC17              0.338      0.057      5.899      0.000
    PFC18              0.021      0.034      0.613      0.540
    PFC19              0.199      0.053      3.746      0.000
    PFC20              0.175      0.060      2.932      0.003
    PFC21              0.106      0.069      1.539      0.124
    PFC22              0.339      0.051      6.644      0.000
    PFC23              0.285      0.056      5.059      0.000

 F2       BY
    PFC01             -0.078      0.075     -1.029      0.303
    PFC02              0.251      0.054      4.644      0.000
    PFC03              0.006      0.032      0.188      0.851
    PFC04              0.881      0.038     23.028      0.000
    PFC05              0.254      0.069      3.704      0.000
    PFC06              0.300      0.063      4.787      0.000
    PFC07              0.466      0.054      8.590      0.000
    PFC08              0.845      0.048     17.575      0.000
    PFC09              0.022      0.052      0.412      0.680
    PFC10             -0.067      0.066     -1.010      0.312
    PFC11              0.378      0.063      5.957      0.000
    PFC12              0.037      0.043      0.856      0.392
    PFC13              0.044      0.058      0.758      0.449
    PFC14              0.484      0.064      7.548      0.000
    PFC15              0.103      0.063      1.641      0.101
    PFC17              0.031      0.060      0.514      0.607
    PFC18             -0.017      0.033     -0.516      0.606
    PFC19              0.170      0.066      2.568      0.010
    PFC20              0.177      0.066      2.701      0.007
    PFC21              0.416      0.065      6.362      0.000
    PFC22              0.395      0.062      6.340      0.000
    PFC23              0.415      0.067      6.188      0.000

 F3       BY
    PFC01              0.035      0.070      0.493      0.622
    PFC02              0.387      0.050      7.703      0.000
    PFC03             -0.038      0.035     -1.079      0.281
    PFC04             -0.043      0.036     -1.202      0.229
    PFC05              0.179      0.060      2.969      0.003
    PFC06              0.210      0.056      3.774      0.000
    PFC07              0.186      0.055      3.387      0.001
    PFC08             -0.042      0.039     -1.061      0.289
    PFC09              0.001      0.063      0.015      0.988
    PFC10              0.252      0.059      4.237      0.000
    PFC11              0.304      0.057      5.350      0.000
    PFC12              0.884      0.031     28.323      0.000
    PFC13              0.706      0.043     16.310      0.000
    PFC14              0.271      0.059      4.617      0.000
    PFC15              0.351      0.055      6.342      0.000
    PFC17              0.460      0.052      8.805      0.000
    PFC18              0.914      0.038     24.327      0.000
    PFC19              0.584      0.049     11.847      0.000
    PFC20              0.490      0.058      8.444      0.000
    PFC21              0.331      0.071      4.652      0.000
    PFC22              0.231      0.056      4.161      0.000
    PFC23              0.278      0.064      4.379      0.000

 F2       WITH
    F1                 0.321      0.054      5.960      0.000

 F3       WITH
    F1                 0.363      0.059      6.118      0.000
    F2                 0.409      0.050      8.247      0.000

 Means
    F1                 0.000      0.000    999.000    999.000
    F2                 0.000      0.000    999.000    999.000
    F3                 0.000      0.000    999.000    999.000

 Thresholds
    PFC01$1            0.636      0.072      8.780      0.000
    PFC01$2            1.674      0.118     14.175      0.000
    PFC01$3            2.485      0.274      9.062      0.000
    PFC02$1           -0.562      0.068     -8.300      0.000
    PFC02$2            0.917      0.078     11.796      0.000
    PFC02$3            1.812      0.129     14.076      0.000
    PFC02$4            2.261      0.233      9.703      0.000
    PFC03$1            0.704      0.077      9.124      0.000
    PFC03$2            2.212      0.166     13.301      0.000
    PFC04$1           -0.950      0.081    -11.747      0.000
    PFC04$2            0.300      0.070      4.304      0.000
    PFC04$3            1.293      0.098     13.162      0.000
    PFC04$4            2.022      0.159     12.696      0.000
    PFC05$1            0.213      0.064      3.350      0.001
    PFC05$2            1.307      0.093     14.010      0.000
    PFC05$3            1.841      0.123     14.952      0.000
    PFC05$4            2.159      0.164     13.145      0.000
    PFC06$1           -0.126      0.061     -2.067      0.039
    PFC06$2            0.876      0.078     11.221      0.000
    PFC06$3            1.344      0.098     13.685      0.000
    PFC06$4            1.782      0.127     14.041      0.000
    PFC07$1           -1.311      0.091    -14.401      0.000
    PFC07$2           -0.135      0.064     -2.103      0.035
    PFC07$3            0.978      0.082     11.932      0.000
    PFC07$4            1.730      0.121     14.281      0.000
    PFC08$1           -0.612      0.074     -8.312      0.000
    PFC08$2            0.648      0.075      8.681      0.000
    PFC08$3            1.479      0.106     13.985      0.000
    PFC09$1            1.110      0.089     12.530      0.000
    PFC09$2            2.181      0.167     13.054      0.000
    PFC10$1           -0.724      0.074     -9.724      0.000
    PFC10$2            0.562      0.067      8.382      0.000
    PFC10$3            1.526      0.102     14.911      0.000
    PFC10$4            1.952      0.133     14.653      0.000
    PFC11$1           -0.144      0.066     -2.161      0.031
    PFC11$2            0.896      0.077     11.566      0.000
    PFC11$3            1.679      0.114     14.755      0.000
    PFC12$1            0.288      0.072      4.001      0.000
    PFC12$2            1.350      0.102     13.286      0.000
    PFC12$3            1.972      0.147     13.445      0.000
    PFC12$4            2.391      0.224     10.667      0.000
    PFC13$1            0.172      0.070      2.458      0.014
    PFC13$2            1.121      0.081     13.798      0.000
    PFC13$3            1.914      0.132     14.534      0.000
    PFC13$4            2.375      0.190     12.477      0.000
    PFC14$1            0.554      0.071      7.852      0.000
    PFC14$2            1.318      0.096     13.678      0.000
    PFC14$3            1.764      0.135     13.117      0.000
    PFC14$4            2.132      0.164     13.039      0.000
    PFC15$1            0.268      0.063      4.241      0.000
    PFC15$2            1.109      0.084     13.281      0.000
    PFC15$3            1.403      0.099     14.159      0.000
    PFC15$4            1.576      0.107     14.790      0.000
    PFC17$1            0.290      0.068      4.251      0.000
    PFC17$2            1.576      0.104     15.227      0.000
    PFC18$1            0.905      0.079     11.406      0.000
    PFC18$2            1.661      0.112     14.828      0.000
    PFC18$3            2.069      0.147     14.065      0.000
    PFC19$1            0.533      0.070      7.635      0.000
    PFC19$2            1.199      0.090     13.341      0.000
    PFC19$3            1.829      0.129     14.209      0.000
    PFC20$1            0.530      0.071      7.514      0.000
    PFC20$2            1.212      0.089     13.556      0.000
    PFC20$3            1.881      0.130     14.477      0.000
    PFC21$1            0.840      0.077     10.837      0.000
    PFC21$2            1.486      0.107     13.934      0.000
    PFC21$3            2.018      0.153     13.218      0.000
    PFC22$1            0.134      0.067      2.011      0.044
    PFC22$2            1.222      0.091     13.441      0.000
    PFC22$3            2.058      0.155     13.247      0.000
    PFC23$1            0.283      0.068      4.185      0.000
    PFC23$2            0.883      0.078     11.330      0.000
    PFC23$3            1.504      0.104     14.436      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              0.514      0.071      7.272      0.000
    PFC02              0.618      0.048     12.890      0.000
    PFC03              0.217      0.071      3.077      0.002
    PFC04              0.264      0.060      4.405      0.000
    PFC05              0.648      0.049     13.169      0.000
    PFC06              0.790      0.045     17.590      0.000
    PFC07              0.628      0.043     14.566      0.000
    PFC08              0.313      0.063      4.949      0.000
    PFC09              0.294      0.082      3.567      0.000
    PFC10              0.794      0.041     19.431      0.000
    PFC11              0.635      0.051     12.493      0.000
    PFC12              0.219      0.042      5.281      0.000
    PFC13              0.463      0.052      8.866      0.000
    PFC14              0.513      0.061      8.397      0.000
    PFC15              0.664      0.046     14.527      0.000
    PFC17              0.542      0.051     10.609      0.000
    PFC18              0.163      0.064      2.551      0.011
    PFC19              0.402      0.053      7.575      0.000
    PFC20              0.545      0.059      9.189      0.000
    PFC21              0.539      0.067      8.058      0.000
    PFC22              0.458      0.050      9.180      0.000
    PFC23              0.441      0.051      8.728      0.000

Group SIXPLUS

 F1       BY
    PFC01              0.891      0.080     11.068      0.000
    PFC02              0.201      0.061      3.312      0.001
    PFC03              0.811      0.064     12.596      0.000
    PFC04             -0.026      0.035     -0.748      0.455
    PFC05              0.471      0.072      6.568      0.000
    PFC06              0.088      0.079      1.115      0.265
    PFC07              0.123      0.060      2.039      0.041
    PFC08             -0.002      0.046     -0.042      0.967
    PFC09              0.784      0.060     13.015      0.000
    PFC10              0.457      0.082      5.589      0.000
    PFC11              0.084      0.072      1.175      0.240
    PFC12             -0.068      0.056     -1.199      0.231
    PFC13              0.027      0.069      0.385      0.700
    PFC14              0.137      0.073      1.871      0.061
    PFC15              0.402      0.074      5.393      0.000
    PFC17              0.422      0.077      5.472      0.000
    PFC18              0.030      0.048      0.613      0.540
    PFC19              0.265      0.076      3.506      0.000
    PFC20              0.213      0.075      2.836      0.005
    PFC21              0.116      0.075      1.540      0.124
    PFC22              0.411      0.070      5.828      0.000
    PFC23              0.352      0.072      4.888      0.000

 F2       BY
    PFC01             -0.074      0.074     -1.002      0.316
    PFC02              0.250      0.053      4.686      0.000
    PFC03              0.004      0.022      0.188      0.851
    PFC04              0.831      0.046     18.103      0.000
    PFC05              0.262      0.069      3.810      0.000
    PFC06              0.331      0.066      4.982      0.000
    PFC07              0.457      0.058      7.863      0.000
    PFC08              0.777      0.059     13.158      0.000
    PFC09              0.015      0.037      0.415      0.678
    PFC10             -0.070      0.070     -1.000      0.317
    PFC11              0.363      0.066      5.526      0.000
    PFC12              0.040      0.047      0.850      0.395
    PFC13              0.046      0.060      0.762      0.446
    PFC14              0.430      0.060      7.229      0.000
    PFC15              0.110      0.067      1.646      0.100
    PFC17              0.029      0.055      0.521      0.602
    PFC18             -0.019      0.036     -0.509      0.611
    PFC19              0.170      0.067      2.548      0.011
    PFC20              0.162      0.059      2.743      0.006
    PFC21              0.342      0.054      6.355      0.000
    PFC22              0.360      0.063      5.710      0.000
    PFC23              0.385      0.069      5.583      0.000

 F3       BY
    PFC01              0.030      0.062      0.493      0.622
    PFC02              0.355      0.050      7.103      0.000
    PFC03             -0.024      0.022     -1.061      0.289
    PFC04             -0.037      0.031     -1.211      0.226
    PFC05              0.170      0.060      2.838      0.005
    PFC06              0.213      0.057      3.739      0.000
    PFC07              0.168      0.050      3.355      0.001
    PFC08             -0.035      0.033     -1.066      0.287
    PFC09              0.001      0.041      0.015      0.988
    PFC10              0.244      0.060      4.081      0.000
    PFC11              0.269      0.057      4.687      0.000
    PFC12              0.897      0.046     19.357      0.000
    PFC13              0.682      0.062     11.062      0.000
    PFC14              0.222      0.052      4.232      0.000
    PFC15              0.344      0.065      5.282      0.000
    PFC17              0.398      0.062      6.364      0.000
    PFC18              0.911      0.043     21.191      0.000
    PFC19              0.538      0.064      8.466      0.000
    PFC20              0.413      0.064      6.419      0.000
    PFC21              0.251      0.062      4.054      0.000
    PFC22              0.194      0.050      3.883      0.000
    PFC23              0.238      0.058      4.081      0.000

 F2       WITH
    F1                 0.622      0.070      8.826      0.000

 F3       WITH
    F1                 0.353      0.099      3.569      0.000
    F2                 0.569      0.074      7.682      0.000

 Means
    F1                -0.091      0.138     -0.661      0.509
    F2                -0.465      0.114     -4.084      0.000
    F3                 0.241      0.156      1.542      0.123

 Thresholds
    PFC01$1            0.601      0.105      5.729      0.000
    PFC01$2            1.583      0.201      7.865      0.000
    PFC01$3            2.350      0.274      8.578      0.000
    PFC02$1           -0.558      0.070     -7.930      0.000
    PFC02$2            0.911      0.088     10.320      0.000
    PFC02$3            1.799      0.150     11.982      0.000
    PFC02$4            2.246      0.204     11.010      0.000
    PFC03$1            0.478      0.092      5.186      0.000
    PFC03$2            1.500      0.229      6.539      0.000
    PFC04$1           -0.892      0.086    -10.350      0.000
    PFC04$2            0.282      0.067      4.201      0.000
    PFC04$3            1.215      0.108     11.225      0.000
    PFC04$4            1.900      0.170     11.187      0.000
    PFC05$1            0.219      0.068      3.233      0.001
    PFC05$2            1.342      0.119     11.230      0.000
    PFC05$3            1.890      0.178     10.613      0.000
    PFC05$4            2.216      0.222      9.967      0.000
    PFC06$1           -0.138      0.067     -2.059      0.040
    PFC06$2            0.961      0.099      9.706      0.000
    PFC06$3            1.474      0.135     10.924      0.000
    PFC06$4            1.954      0.185     10.566      0.000
    PFC07$1           -1.282      0.099    -12.924      0.000
    PFC07$2           -0.132      0.064     -2.078      0.038
    PFC07$3            0.956      0.086     11.058      0.000
    PFC07$4            1.691      0.135     12.509      0.000
    PFC08$1           -0.561      0.071     -7.856      0.000
    PFC08$2            0.594      0.075      7.880      0.000
    PFC08$3            1.355      0.125     10.857      0.000
    PFC09$1            0.783      0.118      6.610      0.000
    PFC09$2            1.538      0.226      6.803      0.000
    PFC10$1           -0.761      0.080     -9.553      0.000
    PFC10$2            0.590      0.078      7.549      0.000
    PFC10$3            1.604      0.135     11.872      0.000
    PFC10$4            2.052      0.182     11.244      0.000
    PFC11$1           -0.137      0.063     -2.191      0.028
    PFC11$2            0.857      0.098      8.709      0.000
    PFC11$3            1.606      0.164      9.792      0.000
    PFC12$1            0.317      0.091      3.479      0.001
    PFC12$2            1.483      0.147     10.072      0.000
    PFC12$3            2.165      0.211     10.256      0.000
    PFC12$4            2.626      0.277      9.480      0.000
    PFC13$1            0.179      0.079      2.271      0.023
    PFC13$2            1.172      0.130      9.042      0.000
    PFC13$3            2.001      0.197     10.134      0.000
    PFC13$4            2.482      0.274      9.050      0.000
    PFC14$1            0.490      0.069      7.135      0.000
    PFC14$2            1.167      0.102     11.402      0.000
    PFC14$3            1.563      0.126     12.401      0.000
    PFC14$4            1.888      0.173     10.900      0.000
    PFC15$1            0.285      0.071      4.028      0.000
    PFC15$2            1.176      0.110     10.721      0.000
    PFC15$3            1.488      0.126     11.836      0.000
    PFC15$4            1.671      0.149     11.188      0.000
    PFC17$1            0.271      0.074      3.654      0.000
    PFC17$2            1.473      0.169      8.704      0.000
    PFC18$1            0.976      0.125      7.803      0.000
    PFC18$2            1.791      0.186      9.635      0.000
    PFC18$3            2.230      0.226      9.871      0.000
    PFC19$1            0.531      0.084      6.297      0.000
    PFC19$2            1.195      0.113     10.539      0.000
    PFC19$3            1.823      0.179     10.177      0.000
    PFC20$1            0.483      0.074      6.503      0.000
    PFC20$2            1.105      0.109     10.142      0.000
    PFC20$3            1.714      0.164     10.458      0.000
    PFC21$1            0.687      0.084      8.178      0.000
    PFC21$2            1.217      0.122     10.009      0.000
    PFC21$3            1.652      0.162     10.202      0.000
    PFC22$1            0.122      0.061      1.978      0.048
    PFC22$2            1.109      0.103     10.801      0.000
    PFC22$3            1.868      0.164     11.413      0.000
    PFC23$1            0.262      0.067      3.895      0.000
    PFC23$2            0.816      0.091      8.943      0.000
    PFC23$3            1.390      0.132     10.528      0.000

 Variances
    F1                 1.000      0.000    999.000    999.000
    F2                 1.000      0.000    999.000    999.000
    F3                 1.000      0.000    999.000    999.000

 Residual Variances
    PFC01              0.266      0.096      2.754      0.006
    PFC02              0.557      0.051     10.915      0.000
    PFC03              0.352      0.097      3.635      0.000
    PFC04              0.369      0.061      6.090      0.000
    PFC05              0.420      0.057      7.432      0.000
    PFC06              0.708      0.058     12.316      0.000
    PFC07              0.576      0.056     10.244      0.000
    PFC08              0.427      0.067      6.373      0.000
    PFC09              0.370      0.079      4.701      0.000
    PFC10              0.707      0.061     11.583      0.000
    PFC11              0.623      0.071      8.815      0.000
    PFC12              0.194      0.056      3.468      0.001
    PFC13              0.482      0.068      7.075      0.000
    PFC14              0.543      0.060      9.108      0.000
    PFC15              0.512      0.059      8.746      0.000
    PFC17              0.516      0.077      6.725      0.000
    PFC18              0.170      0.063      2.714      0.007
    PFC19              0.350      0.066      5.283      0.000
    PFC20              0.577      0.065      8.856      0.000
    PFC21              0.639      0.070      9.110      0.000
    PFC22              0.344      0.066      5.182      0.000
    PFC23              0.341      0.061      5.611      0.000


R-SQUARE

Group UNDERSIX

    Observed                                        Two-Tailed     Scale
    Variable        Estimate       S.E.  Est./S.E.    P-Value     Factors

    PFC01              0.486      0.071      6.863      0.000      0.717
    PFC02              0.382      0.048      7.968      0.000      0.786
    PFC03              0.783      0.071     11.071      0.000      0.466
    PFC04              0.736      0.060     12.285      0.000      0.514
    PFC05              0.352      0.049      7.169      0.000      0.805
    PFC06              0.210      0.045      4.678      0.000      0.889
    PFC07              0.372      0.043      8.632      0.000      0.792
    PFC08              0.687      0.063     10.864      0.000      0.559
    PFC09              0.706      0.082      8.582      0.000      0.542
    PFC10              0.206      0.041      5.028      0.000      0.891
    PFC11              0.365      0.051      7.172      0.000      0.797
    PFC12              0.781      0.042     18.815      0.000      0.468
    PFC13              0.537      0.052     10.266      0.000      0.681
    PFC14              0.487      0.061      7.982      0.000      0.716
    PFC15              0.336      0.046      7.337      0.000      0.815
    PFC17              0.458      0.051      8.975      0.000      0.736
    PFC18              0.837      0.064     13.081      0.000      0.404
    PFC19              0.598      0.053     11.260      0.000      0.634
    PFC20              0.455      0.059      7.659      0.000      0.739
    PFC21              0.461      0.067      6.889      0.000      0.734
    PFC22              0.542      0.050     10.867      0.000      0.677
    PFC23              0.559      0.051     11.042      0.000      0.664

Group SIXPLUS

    Observed                                        Two-Tailed     Scale
    Variable        Estimate       S.E.  Est./S.E.    P-Value     Factors

    PFC01              0.734      0.096      7.613      0.000      0.678
    PFC02              0.443      0.051      8.693      0.000      0.781
    PFC03              0.648      0.097      6.699      0.000      0.316
    PFC04              0.631      0.061     10.437      0.000      0.483
    PFC05              0.580      0.057     10.253      0.000      0.826
    PFC06              0.292      0.058      5.073      0.000      0.975
    PFC07              0.424      0.056      7.544      0.000      0.775
    PFC08              0.573      0.067      8.545      0.000      0.512
    PFC09              0.630      0.079      8.007      0.000      0.382
    PFC10              0.293      0.061      4.789      0.000      0.937
    PFC11              0.377      0.071      5.329      0.000      0.762
    PFC12              0.806      0.056     14.436      0.000      0.514
    PFC13              0.518      0.068      7.607      0.000      0.711
    PFC14              0.457      0.060      7.664      0.000      0.634
    PFC15              0.488      0.059      8.333      0.000      0.864
    PFC17              0.484      0.077      6.298      0.000      0.688
    PFC18              0.830      0.063     13.213      0.000      0.435
    PFC19              0.650      0.066      9.829      0.000      0.632
    PFC20              0.423      0.065      6.483      0.000      0.673
    PFC21              0.361      0.070      5.143      0.000      0.601
    PFC22              0.656      0.066      9.864      0.000      0.614
    PFC23              0.659      0.061     10.860      0.000      0.614


MODEL MODIFICATION INDICES

NOTE:  Modification indices for direct effects of observed dependent variables
regressed on covariates and residual covariances among observed dependent
variables may not be included.  To include these, request MODINDICES (ALL).

Minimum M.I. value for printing the modification index     3.840

                                   M.I.     E.P.C.  Std E.P.C.  StdYX E.P.C.
Group UNDERSIX


BY Statements

F1       BY PFC02                  7.823    -0.117     -0.117       -0.092

WITH Statements

PFC02    WITH PFC01                4.473    -0.322     -0.322       -0.322
PFC05    WITH PFC02                7.097     0.231      0.231        0.231
PFC07    WITH PFC01                8.294    -0.386     -0.386       -0.386
PFC07    WITH PFC02                4.377     0.210      0.210        0.210
PFC08    WITH PFC04                8.997     0.940      0.940        0.940
PFC09    WITH PFC03               22.130     1.910      1.910        1.910
PFC10    WITH PFC01               18.461     0.457      0.457        0.457
PFC10    WITH PFC03                5.857    -0.493     -0.493       -0.493
PFC10    WITH PFC07                4.105    -0.180     -0.180       -0.180
PFC10    WITH PFC09                4.222    -0.443     -0.443       -0.443
PFC14    WITH PFC07                4.803    -0.293     -0.293       -0.293
PFC15    WITH PFC02                6.039    -0.257     -0.257       -0.257
PFC18    WITH PFC09                5.566     1.293      1.293        1.293
PFC22    WITH PFC09                4.463    -0.576     -0.576       -0.576
PFC22    WITH PFC14                6.624     0.323      0.323        0.323
PFC23    WITH PFC07                7.255     0.300      0.300        0.300

Group SIXPLUS


BY Statements

F1       BY PFC02                  7.821     0.121      0.158        0.123

WITH Statements

PFC03    WITH PFC02                5.488     0.835      0.835        0.466
PFC05    WITH PFC01                3.980     0.327      0.327        0.548
PFC10    WITH PFC02                8.680     0.277      0.277        0.323
PFC10    WITH PFC09                4.615    -0.620     -0.620       -0.434
PFC14    WITH PFC07                4.346    -0.314     -0.314       -0.276
PFC15    WITH PFC09                7.236     0.868      0.868        0.659
PFC23    WITH PFC22               10.106     0.556      0.556        0.612



PLOT INFORMATION

The following plots are available:

  Sample proportions and estimated probabilities
  Item characteristic curves
  Information curves
  Measurement parameter plots

SAVEDATA INFORMATION


  Difference testing

  Save file
    age_metric_scalar.dif
  Save format      Free

DIAGRAM INFORMATION

  Use View Diagram under the Diagram menu in the Mplus Editor to view the diagram.
  If running Mplus from the Mplus Diagrammer, the diagram opens automatically.

  Diagram output
    c:\users\forev\documents\nicolascamacho\pfc_fa\paper\updated_process\code\mplus\metric_scalar_age_esem_wlsmv_v3.1_rm

     Beginning Time:  06:15:56
        Ending Time:  06:16:01
       Elapsed Time:  00:00:05



MUTHEN & MUTHEN
3463 Stoner Ave.
Los Angeles, CA  90066

Tel: (310) 391-9971
Fax: (310) 391-8971
Web: www.StatModel.com
Support: Support@StatModel.com

Copyright (c) 1998-2021 Muthen & Muthen
