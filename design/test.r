library(sasr)# devtools::load_all()

#get_sas_session() will be called automatically; or use `sas <- sas_session_ssh()` manually

sascode = "proc candisc data=sashelp.iris out=outcan distance anova;
   class Species;
   var SepalLength SepalWidth PetalLength PetalWidth;
run;"

a <- run_sas(
  sascode,
  results = "TEXT"
)

b <- run_sas(
  sascode,
  results = "HTML"
)

# renaming column variable to replace . to _
iris2 <- iris
colnames(iris2) <- stringr::str_replace(colnames(iris2), "\\.", "_")
df2sd(iris2, table = "oros")

# oros must exist! oros is defined through df2sd
sascode = "proc candisc data=oros out=outcan2 distance anova;
   class Species;
   var Sepal_Length Sepal_Width Petal_Length Petal_Width;
run;"

d <- run_sas(
  sascode,
  results = "TEXT"
)

cat(d$LOG)
cat(d$LST)

