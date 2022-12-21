# run_sas call the correct method

    Code
      run_sas("this is test", sas_session = dummy_session)
    Output
      submit the following code: 
      this is test
      format of result is  TEXT 

# df2sd call the correct method

    Code
      df2sd(iris2, "iris2", "work", sas_session = dummy_session)
    Output
      submit iris2 into SAS work.iris2

# sd2df call the correct method

    Code
      sd2df("iris2", "work", sas_session = dummy_session)
    Output
      obtain SAS dataset work.iris2

