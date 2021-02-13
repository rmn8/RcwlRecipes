cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript
requirements:
- class: InitialWorkDirRequirement
  listing:
  - entryname: mvOut.R
    entry: |-
      .libPaths('/Users/qi31566/homebrew/lib/R/4.0/site-library')
      suppressPackageStartupMessages(library(R.utils))
      suppressPackageStartupMessages(library(codetools))
      args <- commandArgs(trailingOnly = TRUE, asValues = TRUE)
      mvOut <-
      function(logFile){
          log1 <- readLines(logFile)
          startn <- grep('Final Outputs:', log1)+1
          endn <- grep('}$', log1)
          endn <- endn[endn > startn][1]
          logOut <- jsonlite::fromJSON(log1[startn:endn])
          logOut <- logOut[lengths(logOut)>0]
          dir.create('output', showWarnings = FALSE)
          lapply(logOut, function(x)file.rename(x, file.path('output', basename(x))))
      }
      do.call(mvOut, args)
    writable: false
arguments:
- mvOut.R
id: mvOut
inputs:
  logFile:
    type: File
    inputBinding:
      prefix: logFile=
      separate: false
outputs:
  OutDir:
    type: Directory
    outputBinding:
      glob: output
