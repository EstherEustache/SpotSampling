#' Internal function of fastflightcubeSPOT
#' @noRd
algofastflightcubeSPOT <- function(X, pik) {
  "jump" <- function(X, pik) {
    EPS <- 1e-11
    N   <- length(pik)
    p   <- round(length(X)/length(pik))
    X   <- array(X, c(N, p))
    X1  <- cbind(X, rep(0, times = N))

    kern   <- svd(X1)$u[, p + 1]
    listek <- abs(kern) > EPS

    buff1 <- (1 - pik[listek])/kern[listek]
    buff2 <- -pik[listek]/kern[listek]
    la1   <- min(c(buff1[(buff1 > 0)], buff2[(buff2 > 0)]))
    pik1  <- pik + la1 * kern

    buff1 <- -(1 - pik[listek])/kern[listek]
    buff2 <- pik[listek]/kern[listek]
    la2   <- min(c(buff1[(buff1 > 0)], buff2[(buff2 > 0)]))
    pik2  <- pik - la2 * kern

    q <- la2/(la1 + la2)
    if (stats::runif(1) < q) {
      pikn <- pik1
    } else {
      pikn <- pik2
    }
    return(pikn)
  }

  EPS <- 1e-11
  N   <- length(pik)
  X   <- matrix(X, nrow = N)
  p   <- ncol(X)
  A   <- X/pik
  B   <- A[1:(p + 1), ]

  psik <- pik[1:(p+1)]
  ind  <- seq(1, p+1, 1)
  pp   <- p + 2
  B    <- array(B, c(p+1, p))


  while (pp <= N) {
    tmp               <- ReducedMatrix(B)
    B_tmp             <- tmp$B
    psik_tmp          <- psik[tmp$ind_row]
    psik[tmp$ind_row] <- jump(B_tmp, psik_tmp)

    TEST <- (psik > (1 - EPS) | psik < EPS)
    i     <- 0
    while ((i <= p) & (pp <= N)) {
      i   <- i + 1
      if (TEST[i]) {
        pik[ind[i]] <- psik[i]
        psik[i]     <- pik[pp]
        B[i, ]      <- A[pp, ]
        B           <- array(B, c(p + 1, p))
        ind[i]      <- pp
        pp          <- pp + 1
      }
    }
  }

  TEST <- (pik > EPS & pik < (1-EPS))
  if (sum(TEST) == (p+1)){
    psik     <- jump(B, psik)
  }
  pik[ind] <- psik
  return(pik)
}
