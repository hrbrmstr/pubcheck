.check_one_gh_user <- function(gh_user) {

  keys <- readLines(sprintf("https://github.com/%s.keys", gh_user))

  if (length(keys) == 0) keys <- NA_character_

  data.frame(
    user = gh_user,
    key = keys
  ) -> user

  res <- lapply(user$key, parse_key)

  user$algo <- sapply(res, `[[`, "type")
  user$len <- sapply(res, `[[`, "size")

  apply(user, 1, \(row) {
    key_check(row[["algo"]], row[["len"]])
  }) -> user$status

  user

}

#' Check one or more GitHub user's keys
#'
#' @param gh_users (chr) a character vector of GitHub user ids
#' @return data frame
#' @export
#' @examples \dontrun{
#' check_gh_user_keys("hrbrmstr")
#' }
check_gh_user_keys <- function(gh_users) {
  do.call(rbind.data.frame, lapply(gh_users, .check_one_gh_user))
}

#' Check all SSH keys of GitHub users a particular account is following
#'
#' @param gh_user a single GitHub user id
#' @return data frame
#' @note this may take a while for accounts that follow many users
#' @export
#' @examples \dontrun{
#' check_gh_following("koenrh")
#' }
check_gh_following <- function(gh_user) {

  stopifnot(`Can only specify one GitHub user to check followers of`=(length(gh_user)==1))

  res <- following <- gh::gh(sprintf("/users/%s/following", gh_user))
  while (length(res) > 0) {
    res <- p_gh_next(res)
    following <- c(following, res)
  }

  sapply(following, `[[`, "login") |>
    lapply(check_gh_user_keys) -> res

  do.call(rbind.data.frame, res)

}
