#' Cluster t-T paths
#'
#' Hierarchical clustering of t-T paths based on the Hausdorff distance
#' between paths.
#'
#' @param x t-T and GOF data of the modeled paths. Output of [read_hefty_xlsx()].
#' @param ncluster an integer scalar or vector with the desired number of groups
#' @param dist character; algorithm to calculate a dissimilarity matrix
#' (distance) for lines; one of `Euclidean`, `Hausdorff` (the default) or
#' `Frechet`.
#'
#' @return a tibble with the path `segment` (integer) and `cluster` (factor)
#' @export
#'
#' @importFrom sf st_as_sf st_distance
#' @importFrom dplyr summarise group_by tibble
#' @importFrom stats hclust cutree as.dist
#'
#' @examples
#' \dontrun{
#' data(tT_paths)
#' cluster_paths(tT_paths, ncluster = 3)
#' }
cluster_paths <- function(x, ncluster, dist = c("Hausdorff", "Frechet", "Euclidean")) {
  segment <- NULL
  x_lines <- x |>
    sf::st_as_sf(coords = c("time", "temperature")) |>
    dplyr::group_by(segment) |>
    dplyr::summarise(do_union = FALSE) |>
    sf::st_cast("LINESTRING")

  dist <- match.arg(dist)
  dmat <- sf::st_distance(x_lines, which = dist)

  cl <- stats::hclust(stats::as.dist(dmat))
  dplyr::tibble(segment = x_lines$segment, cluster = as.factor(stats::cutree(cl, ncluster)))
}
