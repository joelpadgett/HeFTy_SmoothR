## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(HeFTy.SmoothR)

## ----packages1, eval=FALSE, include=TRUE--------------------------------------
#  install.packages("scico")
#  library(scico)

## ----packages2, eval=FALSE, include=TRUE--------------------------------------
#  remotes::install_github("joelpadget/HeFTy_SmoothR")
#  library(HeFTy.SmoothR)

## ----fname,eval=FALSE---------------------------------------------------------
#    path2myfile <- "A:/Joel Padgett/Y121_Data/HeFTy_v2.0_Models/Y121_paths/Y121_paths.xlsx"

## ----fname2, include=FALSE----------------------------------------------------
path2myfile <- system.file('s14MM_v1.xlsx', package = 'HeFTy.SmoothR')

## ----data,warning=FALSE, message=FALSE----------------------------------------
tT_paths <- read_hefty_xlsx(path2myfile)

## ----seed1, include=FALSE-----------------------------------------------------
set.seed(123)

