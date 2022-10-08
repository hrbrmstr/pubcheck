#!/usr/local/bin/Rscript --vanilla

suppressPackageStartupMessages({
  library(pubcheck, quietly = TRUE)
  library(argparser, quietly = TRUE)
  library(pander, quietly = TRUE)
  library(digest, quietly = TRUE)
  library(jsonlite, include.only = "stream_out", quietly = TRUE)
})

arg_parser(
  description = "Check safety configuration of SSH public keys",
  hide.opts = TRUE
) -> p

add_argument(
  parser = p,
  arg = "--format",
  flag = FALSE,
  default = "json",
  help = "Results output format. One of `json` or `table`. Note that the key itself will not be displayed if `table` is chosen."
) -> p

add_argument(
  parser = p,
  arg = "--file",
  flag = FALSE,
  help = "Check local ssh public key file."
) -> p

add_argument(
  parser = p,
  arg = "--user",
  flag = FALSE,
  help = "Check SSH keys for a specified GitHub user. NOTE: if using this option with `table` as the format, the MD5 value of the keys will be used to make the output more readable."
) -> p

argv <- parse_args(p)

if (utils::hasName(argv, "help") && argv$help) {
  print(p)
  quit(save = "no", status = 0, runLast = FALSE)
}

if (utils::hasName(argv, "file") && (!is.na(argv$file))) {

  res <- check_ssh_pub_key(path.expand(argv$file))
  res$file <- argv$file

  if (argv$format == "json") {
    jsonlite::stream_out(res, verbose = FALSE)
    quit(save = "no", status = 0, runLast = FALSE)
  } else if (argv$format == "table") {
    res <- res[, c("file", "algo", "len", "status")]
    pander::pandoc.table(res, style = 'simple')
    quit(save = "no", status = 0, runLast = FALSE)
  } else {
    message("Unknown format: ", p$format)
    quit(save = "no", status = 1, runLast = FALSE)
  }

} else if (utils::hasName(argv, "user")) {

  res <- check_gh_user_keys(argv$user)
  # res$file <- argv$file
  if (argv$format == "json") {
    jsonlite::stream_out(res, verbose = FALSE)
    quit(save = "no", status = 0, runLast = FALSE)
  } else if (argv$format == "table") {
    res$md5 <- sapply(res$key, digest::digest, "md5", USE.NAMES = FALSE)
    res$key <- NULL
    pander::pandoc.table(res, style = 'simple')
    quit(save = "no", status = 0, runLast = FALSE)
  } else {
    message("Unknown format: ", p$format)
    quit(save = "no", status = 1, runLast = FALSE)
  }

}

print(p)

