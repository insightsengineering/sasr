df2sd(fev_data, "fev")

a = run_sas("
PROC MIXED DATA = fev cl method=reml;
      CLASS RACE(ref = 'Asian') AVISIT(ref = 'VIS4') SEX(ref = 'Male') ARMCD(ref = 'PBO') USUBJID;
      MODEL FEV1 = ARMCD AVISIT ARMCD*AVISIT / ddfm=satterthwaite solution chisq;
      REPEATED AVISIT / subject=USUBJID type=un r rcorr;
      WEIGHT WEIGHT;
      LSMEANS AVISIT*ARMCD / pdiff=all cl alpha=0.05 slice=AVISIT;
    RUN;
")

cat(a$LST)
