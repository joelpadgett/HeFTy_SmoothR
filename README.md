# HeFTy_SmoothR

Density plots derived from HeFTy inverse thermal history models as seen in Padgett et al. (submitted) and Johns-Buss et al. (submitted). 



## Prerequisites
You must have R installed on your system (see http://r-project.org). To install 
`HeFTy.SmoothR` from CRAN, type the following code at the R command line prompt:

```
# install.packages("remotes") # install if needed
remotes::install_github('padgett/HeFTy_SmoothR')

library('HeFTy.SmoothR')
```

Using the stress measurements from the San Andreas Fault - Gulf of California example, a quick analysis and test against the right-lateral transform plate boundary can be achieved by:

```
# load example data
path2myfile <- system.file('s14MM_v1.xlsx', package = 'HeFTy.SmoothR')
tT_paths <- read_hefty_xlsx(path2myfile)


 plot_path_density(tT_paths) +
  labs(title = "TITLE HERE", x = "Time (Ma)", y = bquote("Temperature ("*degree*")")) + # type title of plot and put in double quotes
  theme_bw() + # sets a ggplot theme
  coord_cartesian(xlim = c(110, 0), ylim = c(200, 0), expand = FALSE) + # set x and y limits of plot
  scale_x_continuous(breaks = seq(0, 110, 25), transform = "reverse") + # set the major ticks: (breaks = seq(0, 110, 50) --> axis major ticks go from 0 to 110 with divisions of 50. Set the minor ticks: minor_breaks = seq(0, 110, by = 10) --> minor ticks range from 0 to 110 with divisions of 10
  scale_y_continuous(breaks = seq(200, 0, -20), transform = "reverse") + # set the major ticks: (breaks = seq(200, 0, -20) --> axis major ticks go from 220 to 0 with divisions of 20 (negative because 0 is at the top of the plot). Set the minor ticks: minor_breaks = seq(200, 0, by = -10) --> minor ticks range from 200 to 0 with divisions of 10 (negative because 0 is at the top of the plot)
  scico::scale_fill_scico_d(palette = "davos", direction = -1)
```
The code produces the following image:

<img src="man/figures/Fig1.png" width="864" />

## Documentation
The detailed documentation can be found at
https://tobiste.github.io/tectonicr/articles/tectonicr.html


## Authors
Joell padgett (<joel.padgett@ucalgary.ca>)
Tobias Stephan (<tstephan@lakeheadu.ca>)

## Feedback, issues, and contributions

I welcome feedback, suggestions, issues, and contributions! If you have
found a bug, please file it
[here](https://github.com/padgett/HeFTy_SmoothR/issues) with minimal code to
reproduce the issue.


## License
MIT License
