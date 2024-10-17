combine_rows <- function(x) {
  xm <- as.matrix(x)

  odd_rows <- xm[seq_along(xm[, 1]) %% 2 != 0, ] # all odd rows
  even_rows <- xm[seq_along(xm[, 1]) %% 2 == 0, ] # all even rows

  time.col <- as.vector(t(odd_rows))
  temp.col <- as.vector(t(even_rows))


  data.frame("time" = as.numeric(time.col), "temperature" = as.numeric(temp.col))
}

assign_segment <- function(x) { # create new function called assign_segment
  n <- length(x)
  segment <- integer(n)

  segment[1] <- 1L # create a vector with first value of 1
  for (i in 2:n) { # start with index 2 of vector (second position in vector)
    if (x[i] < x[i - 1]) { # if the value of x (time) in position i is less than the value of x in the previous position (i -1),
      segment[i] <- segment[i - 1] # then give that position the same segment value as position before it
    } else { # otherwise
      segment[i] <- segment[i - 1] + 1L # take the segment value from the position before it, add one, and give that position the new segment value
    }
  }
  return(as.character(segment)) # return the output of segment as a character (this is easier for ggplot according to Tobi)
}




#' Read time, temperature and GOF data from HeFTy output from excel file
#'
#' @param fname path to the excel spreadsheet that contains the HeFTy out pouts, i.e. the t-T-paths in sheet 1 and the GOF values in sheet 2
#'
#' @return `data.frame` of the combined data
#'
#' @importFrom readxl read_xlsx
#' @importFrom dplyr mutate
#' @export
#'
#' @examples
#' path2myfile <- system.file("s14MM_v1.xlsx", package = "HeFTy.SmoothR")
#' read_hefty_xlsx(path2myfile)
read_hefty_xlsx <- function(fname) {
  time <- NULL

  x <- readxl::read_xlsx(fname, sheet = 1, col_names = FALSE) # load t-T data
  GOF <- readxl::read_xlsx(fname, sheet = 2, col_names = TRUE) # load GOF sheet

  hs.input <- dplyr::select(x, -1) %>% # select and remove the '...1' from the column names
    combine_rows() %>% # run combine_rows function
    dplyr::mutate(segment = assign_segment(time)) # run Assign_segment function on the time column of hs.input; then mutate function takes output of assign_segment

  merge(hs.input, GOF, by = "segment")
}
