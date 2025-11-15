#include <RcppArmadillo.h>
using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
List lm_qr_extended_cpp(const arma::mat& X, const arma::vec& y) {
  if (X.n_rows != y.n_rows) {
    stop("Number of rows in X must match length of y.");
  }
  arma::mat Q, R;
  arma::qr(Q, R, X);

  unsigned int p = X.n_cols;
  Q = Q.cols(0, p - 1);
  R = R.rows(0, p - 1);

  arma::vec beta = arma::solve(R, Q.t() * y);

  return List::create(
    Named("beta") = beta,  // 回归系数
    Named("R") = R         // QR 分解中的 R，用于计算协方差矩阵
  );
}
