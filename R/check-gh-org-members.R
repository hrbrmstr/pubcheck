#' Check all SSH keys of GitHub users that are members of a specified GitHub organization
#'
#' @param gh_org a single GitHub organization name (e.g. "`GreyNoise-Intelligence`")
#' @return data frame
#' @note this may take a while for organizations with many users
#' @export
#' @examples \dontrun{
#' check_gh_org_members("GreyNoise-Intelligence")
#' }
check_gh_org_members <- function(gh_org) {

  stopifnot(
    `Can only specify one GitHub Organization to check members of` =
    (length(gh_org) == 1)
  )

  res <- members <- gh::gh(sprintf("/orgs/%s/members",  gh_org))

  while (length(res) > 0) {
    res <- p_gh_next(res)
    members <- c(members, res)
  }

  res <- lapply(sapply(members, `[[`, "login"), check_gh_user_keys)

  do.call(rbind.data.frame, res)

}