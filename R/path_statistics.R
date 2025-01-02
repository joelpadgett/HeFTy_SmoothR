#' Path statistics
#'
#' Provides binned statistics (mean, median, IQR, quantiles, etc.) of modeled t-T paths.
#'
#' @param x t-T and GOF data of the modeled paths. Output of [read_hefty()].
#'
#' @return tibble.
#' @export
#'
#' @examples
#' data(tT_paths)
#' path_statistics(tT_paths)
path_statistics <- function(x){
  dplyr::mutate(x,
         bins = cut(time, breaks = 50)) |>
    dplyr::group_by(bins, .add = TRUE) |>
    dplyr::summarise(
      time_min = min(time),
      time_median = median(time, na.rm = TRUE),
      time_max = max(time),
      temp_sd = sd(temperature, na.rm = TRUE),
      temp_IQR = IQR(temperature, na.rm = TRUE),
      temp_median = median(temperature),
      temp_5 = quantile(temperature, probs = .05),
      temp_95 = quantile(temperature, probs = .95),
      temp_max = min(temperature),
      temp_min = max(temperature),
      .groups = "keep"
    )
}
