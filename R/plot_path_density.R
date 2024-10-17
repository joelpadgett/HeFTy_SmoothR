#' Path Density Plot
#'
#' Creates a 2d kernel density estimate of the t-T paths and plots it using
#' ggplot
#'
#' @param x data.frame containing the t-T paths. Output of [read_hefty_xlsx()] or [densify_paths()]
#' @param bins integer. Amount of bins used for the kernel density estimate. 50 by default.
#' @param densify logical. Whether the paths in `x` should be densified first?
#' Default is `TRUE`.
#' @param ... optional arguments passed to [densify_paths()] (only if `densify==TRUE`).
#'
#' @return ggplot
#' @import ggplot2
#' @import ggh4x

#' @export
#'
#' @examples
#' data(s14MM_v1)
#' plot_path_density(s14MM_v1)
plot_path_density <- function(x, bins = 50L, densify = TRUE, ...) {
  # globalVariables(c("time", "temperature"))
  time <- temperature <- NULL
  if (densify) x <- densify_paths(x, ...)

  ggplot(data = x, aes(x = time, y = temperature)) +
    geom_density2d_filled(contour_var = "ndensity", bins = bins) +
    theme(
      ggh4x.axis.ticks.length.minor = rel(1)
    )
}
