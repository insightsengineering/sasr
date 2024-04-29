# rmarkdown engine works

    Code
      rmarkdown::render(system.file("example.Rmd", package = "sasr"), quiet = TRUE)
    Output
      submit the following code: 
      data example1;
      input x y $ z;
      cards;
      6 A 60
      6 A 70
      2 A 100
      2 B 10
      3 B 67
      2 C 81
      3 C 63
      5 C 55
      ;
      run;
      
      proc freq data = example1;
      tables y;
      run;
      format of result is  HTML 

