#' qplot for altair
#'
#' `alt_qplot` is inspired by `qplot` from ggplot2, and is similarly intended
#' to be a convenient wrapper for making many different kinds of plots with a
#' simple and consistent interface. In this case, the generated plot
#' is made via altair, instead of ggplot2.
#'
#' Paraphrasing the `qplot` documentation in ggplot, alt_qplot is great
#' for allowing you to produce plots quickly, but I highly recommend
#' learning altair as it makes it easier to create complex graphics.
#' @md
#' @param x,y,... encodings. These should either be strings or symbols matching
#' column names in data if data is provided, or a variable in the calling
#' environment otherwise
#' @param data a data.frame or tibble. If missing, the data for the plot will be
#' taken from the encoding variables passed in.
#' @param mark the mark to use. if "auto", will default to point except when only
#' the y encoding is missing in which case the mark will default to bar and y
#' will default to count()
#'
#' @return an altair plot specification
#'
#' @import altair
#' @export
#'
#' @examples
#'
alt_qplot <- function(x, y, ..., data,
                      mark = c("auto", "area", "bar", "circle",
                               "geoshape", "line", "point", "rect", "rule",
                               "square", "text", "tick")) {

  # If data is not provided, make data.frame
  in_exprs <- rlang::enquos(x = x, y = y, ...)
  is_missing <- vapply(in_exprs, rlang::quo_is_missing, logical(1))
  in_exprs_present <- in_exprs[!is_missing]
  if (missing(data)){
    in_exprs_names <- vapply(in_exprs_present, rlang::quo_name, character(1))
    in_exprs_named <- in_exprs_present
    names(in_exprs_named) <- in_exprs_names
    data <- tibble::tibble(!!!in_exprs_named)
    encode_list <- as.list(in_exprs_names)
    names(encode_list) <- names(in_exprs_present)
  } else {
    encode_list <- lapply(in_exprs_present, function(x){
        if (rlang::quo_is_symbol(x)){
          return(rlang::quo_name(x))
        } else if (rlang::quo_is_call(x)){
          return(rlang::eval_tidy(x))
        } else {
          return(rlang::quo_name(x))
        }
      })
  }

  mark <- rlang::arg_match(mark)
  if (mark == "auto"){
    # Figure out the mark
    if (missing(y)){
      mark <- "bar"
      encode_list$y <- "count()"
      encode_list$x <- alt$X(encode_list$x, bin = TRUE)
    } else if (missing(x)) {
      mark <- "point"
      encode_list$x <- seq_along(data[[encode_list$y]])
    } else {
      mark <- "point"
    }
  }
  mark_fn <- paste0("mark_", mark)

  chart <-  alt$Chart(r_to_py(data))[[mark_fn]]()
  chart <- do.call(chart$encode, encode_list)

  return(chart)
}

