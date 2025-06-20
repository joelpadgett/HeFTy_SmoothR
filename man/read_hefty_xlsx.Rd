% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_hefty.R
\name{read_hefty_xlsx}
\alias{read_hefty_xlsx}
\title{Read time, temperature and GOF data from HeFTy output from excel file}
\usage{
read_hefty_xlsx(fname)
}
\arguments{
\item{fname}{path to the excel spreadsheet that contains the HeFTy outputs, i.e. the t-T-paths in sheet 1 and the GOF values in sheet 2}
}
\value{
\code{data.frame} of the combined data
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#superseded}{\figure{lifecycle-superseded.svg}{options: alt='[Superseded]'}}}{\strong{[Superseded]}}

\code{read_hefty_xlsx()} has been superseded in favor of \code{\link[=read_hefty]{read_hefty()}} to allow
direct import from HeFTy output files with out additional format
manipulation. The function \code{read_hefty_xlsx()}will be removed in a future
release.
}
\examples{
path2myfile <- system.file("s14MM_v1.xlsx", package = "HeFTy.SmoothR")
read_hefty_xlsx(path2myfile)
}
\seealso{
\code{\link[=read_hefty]{read_hefty()}}
}
