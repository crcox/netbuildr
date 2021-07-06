#' Generate weighted directed network from word associations
#'
#' @param cues A factor of character vector. Unique values determine network nodes
#' @param targets A factor of character vector. \code{cue -> target} associations determine network edges.
#' @return An igraph object representing weighted directed network.
#'
#' Dubossarsky, De Deyne, and Hills (2017) project the cue by response
#' "bipartite graph" to a "unipartite graph".
#'
#' Quoting from Dubossarsky et al. (2017, p1569):
#'
#' "[The] edge weights are defined asymmetrically as the count of associates from
#' \eqn{\text{word}_i}{word_i} to the associates shared with
#' \eqn{\text{word}_j}{word_j}. This is normalized by the relative
#' distinctiveness of the shared associates by dividing the number of times
#' these associations are shared over all the cue words.
#'
#' \deqn{w_{i,j} = \sum_{i=1}^P \frac{w_{i,p}}{N_p - 1}}
#'
#' "\eqn{w_{i,j}} is an edge's weight in the one-mode graph directed from node i
#' to node j. P is the number of shared associations between cue words i and j.
#' w_{i,p} is the number of times cue i produced p as an associate. N_p is the
#' number of cue words that produced p. Cue words idiosyncratic responses were
#' removed prior to projection."
#'
#' See \code{bipartite_to_unipartite} for implementation details.
#'
#' @references
#' Dubossarsky, H., De Deyne, S., & Hills, T. T. (2017). Quantifying the
#' structure of free association networks across the life span. Developmental
#' psychology, 53(8), 1560.
#'
#' @seealso \code{\link[netbuildr]{bipartite_to_unipartite}}
#'
#' @export
create_dubossarsky_net <- function(cues, targets) {
    generate_response_profiles <- function(cues, targets) {
        d <- data.frame(CUE = cues, TARGET = targets)
        w <- tidyr::pivot_wider(
            data = d,
            id_cols = CUE,
            names_from = TARGET,
            values_from = TARGET,
            values_fn = list(TARGET = length),
            values_fill = list(TARGET = 0))
        w <- w[order(w$CUE), ]
        rownames(w) <- w[["CUE"]]
        w[[var]] <- NULL
        return(data.matrix(w))
    }

    response_profiles <- generate_response_profiles(cues, targets)
    upg <- bipartite_to_unipartite(response_profiles)
    diag(upg) <- 0
    upg[upg < 1] <- 0
    g <- igraph::graph_from_adjacency_matrix(upg, mode = 'directed', weighted = TRUE)
    return(g)
}

#' Project cue by response "bipartite graph" to a cue by cue "unipartite graph"
#'
#' @param bpg Cue by response matrix representing a bipartite graph
#' @return A cue by cue matrix representing a directed unipartite graph.
#'
#' This projection can be efficiently represented as the inner product of the
#' bipartite graph and projection matrix. The projection matrix has the same
#' dimensions as the bipartite graph, but transposed. To compose the
#' projection matrix, we first count the number of cues for which each response
#' was provided. Then, replicate this to fill the whole matrix (i.e., repeat
#' this vector once per cue, and reshape into a response by cue matrix).
#' Next, in each column of this new matrix, set values to zero to indicate
#' responses that did not occur for each cue.
#'
#' At this point, the projection matrix contains the values that would by used
#' as N_p in the equation:
#'
#' \deqn{w_{i,j} = \sum_{i=1}^P \frac{w_{i,p}}{N_p - 1}}
#'
#' Before using as a product, (N_p - 1) must be inverted (\eqn{\frac{1}{N_p -
#' 1}}). During the inversion, we ensure that the minimum value in the
#' denominator is zero. Of course, when the denominator is zero this will
#' produce infinities, but this corresponds to where word j is not associated
#' with a particular response. Thus, infinities resulting from this inversion
#' can be set to zero.
#'
#' Finally, bpg %*% Y will yield the projection, where Y
#' represents the projection matrix.
bipartite_to_unipartite <- function(bpg) {
    Np <- colSums(bpg > 0)
    Y <- (t(bpg > 0) * Np)
    Y <- 1 / pmax(Y - 1, 0)
    Y[is.infinite(Y)] <- 0
    return(bpg %*% Y)
}

#' Inefficient but more transparent implementation of w_ij calculation
#'
#' @param bpg Cue by response matrix
#' @return Cue by cue matrix of w_ij
bipartite_to_unipartite_slow <- function(bpg) {
    Np <- colSums(bpg > 0)
    n <- nrow(bpg)
    upg <- matrix(
        data = 0,
        nrow = n,
        ncol = n,
        dimnames = list(rownames(bpg), rownames(bpg)))
    for (i in 1:n) {
        for (j in 1:n) {
            x <- bpg[c(i,j), ]
            z <- (x[1, ] > 0) & (x[2, ] > 0)
            w <- x[1, z]
            upg[i, j] <- sum(w / (Np[z] - 1))
        }
    }
    return(upg)
}
