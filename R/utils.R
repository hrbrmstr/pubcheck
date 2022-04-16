possibly <- function(.f, otherwise, quiet = TRUE) {
  force(otherwise)
  function(...) {
    tryCatch(
      .f(...),
      error = function(e) {
        if (!quiet)
          message("Error: ", e$message)
        otherwise
      },
      interrupt = function(e) {
        stop("Terminated by user", call. = FALSE)
      }
    )
  }
}

p_gh_next <- possibly(gh::gh_next, list())

parse_key <- function(key) {
  if (is.na(key)) {
    list(
      type = NA_character_,
      size = NA_integer_
    )
  } else {
    openssl::read_pubkey(key)
  }
}