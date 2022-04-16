#' Check one SSH public key
#'
#' @param key Either a path to one or more files or literal public key strings
#' @return data frame
#' @export
#' @examples \dontrun{
#' check_ssh_pub_key("~/.ssh/id_rsa.pub")
#' }
check_ssh_pub_key <- function(keys) {

  res <- lapply(keys, parse_key)

  data.frame(
    key = sapply(res, `[[`, "ssh"),
    algo = sapply(res, `[[`, "type"),
    len = sapply(res, `[[`, "size")
  ) -> keys

  apply(keys, 1, \(row) {
    key_check(row[["algo"]], row[["len"]])
  }) -> keys$status

  keys

}

