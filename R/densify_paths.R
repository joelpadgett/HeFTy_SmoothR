#' Densify Paths
#'
#' Adds extra points between the vertices of the path segments
#'
#' @param x t-T and GOF data of the modeled paths. Out put of [read_hefty_xlsx()].
#' @param GOF_rank numeric. Selects only the n highest GOF ranked paths.
#' @param n integer. Adds `n` equally-spaced extra points along each path
#' segment (between vertices). The default is 10.
#' @param samples integer. Number of random samples of the data. This number should
#' be less or equal then the`nrow(x)`. Be aware that a large number will require
#' a long(!) processing time. The default is `100`.
#' @param replace logical. Should sampling be with replacement?
#'
#' @return data.frame
#'
#' @importFrom sf st_as_sf st_cast st_drop_geometry st_coordinates
#' @importFrom smoothr densify
#' @importFrom dplyr dense_rank filter distinct sample_n semi_join mutate summarise bind_cols rename select
#'
#' @export
#'
#' @examples
#' data(s14MM_v1)
#' densify_paths(s14MM_v1)
densify_paths <- function(x, GOF_rank = 10L, n = 10L, samples = 100L, replace = FALSE) {
  L1 <- L2 <- X <- Y <- numeric()
  segment <- time <- temperature <- NULL

  # Subset Data by Highest N GOF Values (If Desired)

  x$rank <- dplyr::dense_rank(-x$Comp_GOF) # Rank Comp_GOF values with lowest rank (1) being highest GOF value

  hs.input <- dplyr::filter(x, rank <= GOF_rank) # Remove all t-T points with rank greater than N; new table shows top N GOF t-T points

  # Subset data by random N number of segments (If Desired)

  ## get unique segments
  remaining_segments <- hs.input %>%
    dplyr::distinct(segment) |> # distinct() gets unique records from the desired field, segments
    dplyr::pull(segment)

  if (replace) {
    sample_size <- samples
  } else {
    sample_size <- min(samples, length(remaining_segments))
  }

  ## Randomly select N unique segments
  subset_segments <- sample(remaining_segments,
    size = sample_size,
    replace = replace
  )



  res <- hs.input %>% # filter the original data for the segments selected in unique_segments
    dplyr::filter(segment %in% subset_segments) %>% # include only rows that match the selected segments
    dplyr::mutate(x = time, y = temperature) %>%
    sf::st_as_sf(coords = c("x", "y")) %>% # make a spatial feature where x and y are the spatial coordinates
    dplyr::summarise(do_union = FALSE) %>%
    sf::st_cast("LINESTRING") %>%
    sf::st_cast("MULTILINESTRING") %>%
    smoothr::densify(n = n) # this sets the number of points that will be added to each segment. This can be changed as desired

  res_coords <- sf::st_coordinates(res)

  dplyr::bind_cols(res, res_coords) %>%
    sf::st_drop_geometry() %>%
    dplyr::rename(time = X, temperature = Y) %>%
    dplyr::select(-L1, -L2)
}
