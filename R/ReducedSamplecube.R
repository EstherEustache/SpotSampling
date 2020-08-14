#' @title Cube method with reduction of the auxiliary variables matrix
#'
#' @description Modified cube method.
#' This function reduces considerably the execution time when the matrix of auxiliary variables \code{X} contains lot of 0s.
#' It is based on the function \code{\link[sampling:samplecube]{samplecube}} from the package \code{sampling}.
#'
#'
#' @param X a matrix of size (N x p) of auxiliary variables on which the sample must be balanced.
#' @param pik a vector of size N of inclusion probabilities.
#' @param order it specifies how the data must be rearrange. 1: the data are randomly arranged (default value),
#' 2: no change in data order, 3: the data are sorted in decreasing order.
#' @param method it specifies the method used to the landing phase of the cube method.
#' 1: for a landing phase by linear programming, 2: for a landing phase by suppression of variables (default value).
#' @param EPS a tolerance parameter. Default value is 1e-8.
#'
#'
#' @details In case where the number of auxiliary variables is great (i.e. p very large), even if we use the fast implementation proposed by
#' (Chauvet and Tille 2005), the problem is time consuming.
#' This function reduces considerably the execution time when the matrix of auxiliary variables \code{X} contains lot of 0s.
#' It considers a reduced matrix \code{X} by removing columns and rows that sum to 0 in the flight phase of the method (see  \code{\link{ReducedMatrix}} and \code{\link{ReducedFlightphase}}).
#' The landing phase remains the same as in \code{\link[sampling:samplecube]{samplecube}} (see also \code{\link[sampling:landingcube]{landingcube}}).
#'
#' @return the updated vector of \code{pik} that contains only 0s and 1s that indicates if a unit is selected or not at each wave.
#'
#'
#' @references
#' Chauvet, G. and Tille, Y. (2006). A fast algorithm of balanced sampling. Computational Statistics, 21/1:53-62
#'
#'
#'  @seealso \code{\link[sampling:samplecube]{samplecube}}, \code{\link[sampling:landingcube]{landingcube}}, \code{\link{ReducedFlightphase}}, \code{\link{ReducedMatrix}}
#'
#'
#' @examples
#' set.seed(1)
#' ## Matrix of 8 auxilary variables and 10 units with lot of 0s ##
#' X   <- matrix(sample(c(0,0,0,1),80,replace=TRUE), nrow = 10, ncol =  8)
#' ## Inclusion probabilities with 10 units ##
#' pik <- stats::runif(10)
#' ## Cube method ##
#' ReducedSamplecube(X, pik, order = 2, method = 2)
#'
#' @export
ReducedSamplecube <- function (X, pik, order = 2, method = 2, EPS = 1e-8)
{
  N       <- length(pik)
  X       <- matrix(X, nrow = N)
  pik_new <- pik

  if (method == 1) {
    TEST1 <- (pik > EPS)&(pik < (1 - EPS))
    if (sum(TEST1) > 0){
      pik_new <- ReducedFlightphase(X, pik, order)
    }
    TEST2 <- (pik_new > EPS)&(pik_new < (1 - EPS))
    if (sum(TEST2) >0){
      pik_new <- sampling::landingcube(X, pik_new, pik)
    }
  } else {
    p       <- ncol(X)
    for (i in 0:(p - 1)) {
      TEST3 <- (pik_new > EPS)&(pik_new < (1 - EPS))
      if (sum(TEST3) > 0){
        pik_new <- ReducedFlightphase(X = X[, 1:(p - i)]/pik * pik_new, pik = pik_new, order)
      }
    }
    for (i in 1:N){
      if (stats::runif(1) < pik_new[i]) {
        pik_new[i] <- 1
      }
    }
  }
  return(round(pik_new))
}
