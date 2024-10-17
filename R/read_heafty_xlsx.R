combine_rows <- function(x) {
  for (i in 1:nrow(x)) { # for row number i in rows 1 through the-number-of-rows-in-the-sheet,
    if ((i %% 2) != 0) { # if the modulus of i is zero,
      # off row no. ==  Time
      time.i <- x[i, ] # then make row i time.i
      # time.i[1] <- NULL
      time.i <- as.numeric(time.i) # now make time.i a numeric string
      if (i == 1) { # if i equals 1,
        time.col <- c(time.i) # then make that time.col
      } else {
        time.col <- c(time.col, time.i) # otherwise, make time.col and time.col a numeric string called time.col
      }
    } else {
      # even row no. = Temperature
      temp.i <- x[i, ] # if modulus of i is NOT zero, then take those rows and call them temp.i
      # temp.i[1] <- NULL
      temp.i <- as.numeric(temp.i) # make temp.i a numeric string
      if (i == 2) { # if i equals 2
        temp.col <- c(temp.i) # then make temp.i called temp.col
      } else {
        temp.col <- c(temp.col, temp.i)
      }
    }
  }
  data.frame("time" = time.col, "temperature" = temp.col) # make a dataframe with first column time, from time.col, and a second column temp, from temp.col
}

assign_segment <- function(x) { # create new function called Assign_segment
  segment <- c(1) # create a vector with first value of 1
  for (i in 2:length(x)) { # start with index 2 of vector (second position in vector)
    if (x[i] < x[i - 1]) { # if the value of x (time) in position i is less than the value of x in the previous position (i -1),
      segment[i] <- segment[i - 1] # then give that position the same segment value as position before it
    } else { # otherwise
      segment[i] <- segment[i - 1] + 1 # take the segment value from the position before it, add one, and give that position the new segment value
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
