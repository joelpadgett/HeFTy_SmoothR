% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_path_density.R
\name{plt_density}
\alias{plt_density}
\alias{plot_path_density_filled}
\alias{plot_path_density}
\title{Path Density Plot}
\usage{
plot_path_density_filled(x, bins = 50L, densify = TRUE, show.legend = NA, ...)

plot_path_density(x, bins = 50L, densify = TRUE, show.legend = NA, ...)
}
\arguments{
\item{x}{data.frame containing the t-T paths. Output of \code{\link[=read_hefty]{read_hefty()}} or \code{\link[=densify_paths]{densify_paths()}}}

\item{bins}{integer. Amount of bins used for the kernel density estimate. 50 by default.}

\item{densify}{logical. Whether the paths in \code{x} should be densified first?
Default is \code{TRUE}.}

\item{show.legend}{logical. Should this layer be included in the legends? \code{NA},
the default, includes if any aesthetics are mapped. \code{FALSE} never includes,
and \code{TRUE} always includes. It can also be a named logical vector to finely
select the aesthetics to display.}

\item{...}{Arguments passed on to \code{\link[=densify_paths]{densify_paths()}} (only if \code{densify=TRUE}).}
}
\value{
ggplot
}
\description{
Creates a 2d kernel density estimate of the t-T paths and plots it using
ggplot
}
\examples{
data(tT_paths)
plot_path_density(tT_paths)
plot_path_density_filled(tT_paths)
}
