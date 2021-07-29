#' Create co-occurrence matrix from a list of transcripts
#'
#' If the input is a character vector it will be treated as a single transcript.
#' If a list of character vectors are provided, they they are handled as
#' separate transcripts. Co-occurrences are not tracked across transcripts.
#'
#' @param tokens A character vector or list of character vectors
#' @param window_size The size of the forward-looking window within which co-occurrence should be tabulated.
#' @param types An optional argument that defines the rows and columns of the returned coocurrence matrix.
#'
#' @details
#' In a forward-looking window of size \code{k}, the first word in the window is
#' associated with the remaining \code{k - 1} words in the window. If the window
#' is of size 2 and consists of \code{cow, duck}, then the counter tracking the
#' number of times \code{cow} is following by \code{duck} will be incremented by
#' one. In the returned co-occurrence matrix, this means incrementing the value
#' in the row for "cow" and the column for "duck".
#'
#' If \code{types} are provided, then only co-occurrences between the provided
#' types are counted.
#'
#' If the \code{tokens} input is a list of character vectors, forward-looking windows do NOT span list elements. Thus, if the input were:
#'
#'  \code{list(c('cow', 'duck'), c('pig', 'chicken'))}
#'
#' Trying to construct a forward-looking window of size 2 beginning on the
#' second token in the first character vector ("duck") would yield
#' \code{c('duck', NA)}. Co-occurrences are not tracked across list
#' elements---they are not considered to be adjacent to each other in
#' speech/text.
#'
#' @export
create_cooccurrence_matrix <- function(tokens, window_size, types = NULL) {
    transcripts <- if (is.list(tokens)) tokens else list(tokens)
    if (is.null(types)) {
        types <- unique(sort(unlist(transcripts)))
    }
    M <- matrix(0, nrow = length(types), ncol = length(types), dimnames = list(types, types))
    for (transcript in transcripts) {
        M <- M + tabulate_cooccurrence_among_types(transcript, types, window_size)
    }
    return(M)
}

#' @describeIn create_cooccurrence_matrix Tabulate directed co-occurrences
tabulate_cooccurrence_among_types <- function(tokens, types, window_size) {
    m <- matrix(0, nrow = length(types), ncol = length(types), dimnames = list(types, types))
    local_types <- types[types %in% tokens]
    for (type in local_types) {
        windows <- get_forward_windows(tokens, type, window_size)
        ix <- as.vector(windows[, -1]) # drop first window element, which is the type
        x <- factor(tokens[ix], types)
        m[types == type, ] <- tabulate(x, nbins = nlevels(x)) # ignores NA
    }
    return(m)
}

#' @describeIn create_cooccurrence_matrix Construct forward-looking windows
get_forward_windows <- function(tokens, type, window_size) {
    ix <- which(tokens == type)
    windows <- matrix(
        data = rep(ix, window_size) + rep(seq(0, window_size - 1), each = length(ix)),
        nrow = length(ix),
        ncol = window_size)
    windows[windows > length(tokens)] <- NA
    return(windows)
}
