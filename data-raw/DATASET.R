## code to prepare `DATASET` dataset goes here

fname <- "inst/s14MM_v1.xlsx"

# s14MM_v1_sheet1 <- readxl::read_xlsx(fname, sheet = 1, col_names = FALSE)
# s14MM_v1_sheet2 <- readxl::read_xlsx(fname, sheet = 2, col_names = TRUE)
#
# usethis::use_data(s14MM_v1_sheet1, overwrite = TRUE)
# usethis::use_data(s14MM_v1_sheet2, overwrite = TRUE)

s14MM_v1 <- read_hefty_xlsx(fname)
usethis::use_data(s14MM_v1, overwrite = TRUE)
