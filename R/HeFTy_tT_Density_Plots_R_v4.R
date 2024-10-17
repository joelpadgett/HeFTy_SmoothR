######## --------- HeFTy tT Density Plots v4 --------

                # Last revised: 11 October 2024 #

# 1. Set Working Directory, Install & Load Packages -----------------------

setwd("A:/Joel Padgett/Y121_Data/HeFTy_v2.0_Models/Y121_paths/Y121_paths_xlsx")

install.packages("readxl")
install.packages("dplyr")
install.packages("tibble")
install.packages("ggplot2")
install.packages("data.table")
install.packages("smoothr")
install.packages("scico")
install.packages("ggh4x")

library(readxl)
library(dplyr)
library(tibble)
library(ggplot2)
library(data.table)
library(smoothr)
library(scico)
library(ggh4x)

# 2. Load Functions -------------------------------------------------------

combine_rows <- function(x){
  for(i in 1:nrow(x)){    #for row number i in rows 1 through the-number-of-rows-in-the-sheet,
    if((i %% 2) != 0) { # if the modulus of i is zero,
      # off row no. ==  Time
      time.i <- x[i, ] # then make row i time.i
      #time.i[1] <- NULL
      time.i <- as.numeric(time.i) # now make time.i a numeric string
      if(i == 1){ # if i equals 1, 
        time.col <- c(time.i) # then make that time.col
      } else { 
        time.col <- c(time.col, time.i) # otherwise, make time.col and time.col a numeric string called time.col
      }
    } else {
      # even row no. = Temperature
      temp.i <- x[i, ] # if modulus of i is NOT zero, then take those rows and call them temp.i
      #temp.i[1] <- NULL
      temp.i <- as.numeric(temp.i) # make temp.i a numeric string
      if(i == 2){ # if i equals 2 
        temp.col <- c(temp.i) # then make temp.i called temp.col
      } else { 
        temp.col <- c(temp.col,temp.i)
      }
    }
  }
  data.frame("time" = time.col, "temperature" = temp.col) # make a dataframe with first column time, from time.col, and a second column temp, from temp.col
}
Assign_segment <- function(x){  # create new function called Assign_segment
  segment <- c(1) # create a vector with first value of 1
  for(i in 2:length(x)){ # start with index 2 of vector (second position in vector) 
    if(x[i] < x[i-1]){ # if the value of x (time) in position i is less than the value of x in the previous position (i -1),
      segment[i] <- segment[i-1] # then give that position the same segment value as position before it
    } else { # otherwise
      segment[i] <- segment[i-1] + 1 # take the segment value from the position before it, add one, and give that position the new segment value 
    }
  }
  return(as.character(segment)) # return the output of segment as a character (this is easier for ggplot according to Tobi)
}


# 3. Load Input Data ------------------------------------------------------

hs.input <- read_xlsx("s4MM_v6.xlsx", sheet = 1, col_names = FALSE) # load t-T data
  
hs.GOF <- read_xlsx("s4MM_v6.xlsx", sheet = 2, col_names = TRUE) # load GOF sheet

# 3a. Create Spreadsheet -----------------------------------------------------

hs.input <- hs.input %>% 
  dplyr::select(-'...1') %>% # select and remove the '...1' from the column names
  combine_rows() %>% # run combine_rows function
  mutate(segment = Assign_segment(time)) # run Assign_segment function on the time column of hs.input; then mutate function takes output of assign_segment

hs.input.GOF <- merge(hs.input, hs.GOF, by = "segment") 

# 3b. Subset Data  --------------------------------------------

# Subset Data by Highest N GOF Values (If Desired)

hs.input.GOF$rank <- dense_rank(-hs.input.GOF$Comp_GOF) # Rank Comp_GOF values with lowest rank (1) being highest GOF value
hs.input <- filter(hs.input.GOF, rank <= 50) # Remove all t-T points with rank greater than N; new table shows top N GOF t-T points

# Subset data by randmon N number of segments (If Desired)

subset_segments <- hs.input %>% #get unique segments 
  distinct(segment) %>% #distinct() gets unique records from the desired field, segments
  sample_n(N)  # Randomly select N unique segments
hs.input <- hs.input %>% #filter the original data for the segments selected in unique_segments
  semi_join(subset_segments, by = "segment") #semi_join filters the original data to include only rows that match the selected segments


# 4. Make Density Plot ---------------------------------------------

hs.OG.denser <- hs.input %>% 
  mutate(x = time, y = temperature) %>% 
  sf::st_as_sf(coords = c('x', 'y')) %>% # make a spatial feature where x and y are the spatial coordinates
  summarise(do_union = FALSE) %>%
  sf::st_cast('LINESTRING') %>% sf::st_cast('MULTILINESTRING') %>% 
  smoothr::densify(n = 10L) # this sets the number of points that will be added to each segment. This can be changed as desired

hs.OG.denser.coords <- sf::st_coordinates(hs.OG.denser)
hs.OG.denser <- sf::st_drop_geometry(hs.OG.denser) %>% cbind(hs.OG.denser.coords) %>%
  rename(time=X, temperature=Y) %>%
  dplyr::select(-L1, -L2)

ggplot(data = hs.OG.denser, aes(x = time, y = temperature)) + 
  ggtitle("TITLE HERE") + # type title of plot and put in double quotes
  coord_cartesian(xlim = c(110, 0), ylim = c(200, 0)) + # set x and y limits of plot
  scale_x_continuous(breaks = seq(0, 110, 50), minor_breaks = seq(0, 110, by = 10), guide = "axis_minor") + # set the major ticks: (breaks = seq(0, 110, 50) --> axis major ticks go from 0 to 110 with divisions of 50. Set the minor ticks: minor_breaks = seq(0, 110, by = 10) --> minor ticks range from 0 to 110 with divisions of 10
  scale_y_continuous(breaks = seq(200, 0, -20), minor_breaks = seq(200, 0, by = -10), guide = "axis_minor") + # set the major ticks: (breaks = seq(200, 0, -20) --> axis major ticks go from 220 to 0 with divisions of 20 (negative because 0 is at the top of the plot). Set the minor ticks: minor_breaks = seq(200, 0, by = -10) --> minor ticks range from 200 to 0 with divisions of 10 (negative because 0 is at the top of the plot)
  geom_density2d_filled(contour_var = "ndensity", bins = 50) +
  scico::scale_fill_scico_d(palette = "davos", direction = -1) + # view available color palette options: https://www.data-imaginist.com/posts/2018-05-30-scico-and-the-colour-conundrum/
  theme(legend.position = "none", 
        ggh4x.axis.ticks.length.minor = rel(1))
        

