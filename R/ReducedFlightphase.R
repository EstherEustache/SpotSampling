#' @title Flight phase of the cube method with reduction of the auxiliary variables matrix
#'
#' @description Modified flight phase of the cube method.
#' This function reduces considerably the execution time when the matrix of auxiliary variables \code{X} contains lot of 0s (see details).
#' It is based on the function \code{\link[sampling:fastflightcube]{fastflightcube}} from the package \code{sampling}.
#'
#'
#' @param X a matrix of size (N x p) of auxiliary variables on which the sample must be balanced.
#' @param pik a vector of size N with inclusion probabilities.
#' @param order it specifies how the data must be rearranged. 1: the data are randomly arranged,
#' 2: no change in data order (default value), 3: the data are sorted in decreasing order.
#' @param EPS a tolerance parameter. Default value is 1e-8.
#'
#'
#' @details In case where the number of auxiliary variables is great (i.e. p very large), even if we use the fast implementation proposed by
#' (Chauvet and Tille 2005), the problem is time consuming.
#' This function reduces considerably the execution time when the matrix of auxiliary variables \code{X} contains lot of 0s.
#' It considers a reduced matrix \code{X} by removing columns and rows that sum to 0 (see \code{\link{ReducedMatrix}}).
#'
#'
#' @return the updated vector of \code{pik} with at most p values not equal to 0 or 1.
#'
#'
#' @author Esther Eustache \email{esther.eustache@@unine.ch}
#'
#'
#' @references
#' Chauvet, G. and Tille, Y. (2006). A fast algorithm of balanced sampling. Computational Statistics, 21/1:53-62
#'
#'
#' @seealso \code{\link[sampling:fastflightcube]{fastflightcube}}, \code{\link{ReducedMatrix}}
#'
#'
#' @examples
#' set.seed(1)
#' ## Matrix of 8 auxilary variables and 10 units with lot of 0s ##
#' X   <- matrix(sample(c(0,0,0,stats::runif(1)), 80, replace=TRUE), nrow = 10, ncol =  8)
#' ## Inclusion probabilities with 10 units ##
#' pik <- stats::runif(10)
#' ## Flight phase ##
#' ReducedFlightphase(X, pik)
#'
#' @export
ReducedFlightphase <- function (X, pik, order = 2, EPS = 1e-8)
{
  "svdReduction" <- function(X) {
    EPS <- 1e-10
    N   <- dim(X)[1]
    Re  <- svd(X)
    array(Re$u[, (Re$d > EPS)], c(N, sum(as.integer(Re$d > EPS))))
  }
  ########################### START ALGO
  N    <- length(pik)
  X    <- matrix(X, nrow = N)
  p    <- ncol(X)

  if(order == 1){
    o <- sample(N)
  } else {
    if(order == 2){
      o <- 1:N
    } else {
      o <- order(pik, decreasing = TRUE)
    }
  }
  TEST  <- (pik[o] > EPS & pik[o] < (1 - EPS))
  liste <- o[TEST]

  pik_new    <- pik
  pik_remain <- pik[liste]
  NN         <- length(pik_remain)
  XX         <- matrix(X[liste,], nrow = NN)

  if (NN > p) {
    pik_new[liste] <- algofastflightcubeSPOT(X = XX, pik = pik_remain)
  }

  # reupdate the liste and the extract element no equal to 0 or 1
  TEST       <- (pik_new[o] > EPS) & (pik_new[o] < (1 - EPS))
  liste      <- o[TEST]
  pik_remain <- pik_new[liste]
  NN         <- length(pik_remain)
  XX         <- array(X[liste,], c(NN, p))
  pp         <- p

  # if you still have value that are not equal to 0 or 1, the matrix is reduced and loop until
  if (NN > 0) {
    XX <- svdReduction(XX)
    pp <- dim(XX)[2]
  }
  k <- 1
  while ((NN > pp) & (NN > 0)) {
    k              <-  k + 1
    pik_new[liste] <- algofastflightcubeSPOT(X = (XX/pik[liste])*pik_remain, pik = pik_remain)
    TEST           <- (pik_new[o] > EPS & pik_new[o] < (1 - EPS))
    liste          <- o[TEST]
    pik_remain     <- pik_new[liste]
    NN             <- length(pik_remain)
    XX             <- matrix(X[liste, ], nrow = NN)
    if (NN > 0) {
      XX             <- svdReduction(XX)
      pp             <- dim(XX)[2]
    }
  }
  return(pik_new)
}
