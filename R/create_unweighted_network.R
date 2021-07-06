#' Generate unweighted directed network from word associations
#'
#' The number of cues and targets must be equal.
#'
#' @param cues A factor of character vector. Unique values determine network nodes
#' @param targets A factor of character vector. \code{cue -> target} associations determine network edges.
#' @return A square adjacency matrix representing an unweighted directed
#'   network. Directed connections from row to column node.
#'
#' For the associative networks, a pair of cues was connected by a directed link from
#' the cue word to the target word if that cue-target relationship was reported
#' in the association norms.
#'
#' @export
create_unweighted_network <- function(cues, targets) {
    assertthat::are_equal(length(cues), length(targets))
    is_associated <- function(targets, cues) {
        return(cues %in% targets)
    }
    x <- split(targets, cues)
    net <- vapply(x, is_associated, logical(length(x)), cues = names(x))
    rownames(net) <- colnames(net)
    diag(net) <- FALSE
    return(t(net))
}
