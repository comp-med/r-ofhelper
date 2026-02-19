# dx_run_cmd returns output correctly

    Code
      res
    Output
      $exit_code
      [1] 0
      
      $stdout
      [1] "stdout"  "content"
      
      $stderr
      [1] "stderr"  "content"
      

# dx_run_cmd returns errors correctly if set

    Code
      res
    Output
      $exit_code
      [1] 1
      
      $stdout
      character(0)
      
      $stderr
      [1] "some"   "error"  "output"
      

