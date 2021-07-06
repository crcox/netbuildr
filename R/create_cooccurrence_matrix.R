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

get_forward_windows <- function(tokens, type, window_size) {
    ix <- which(tokens == type)
    windows <- matrix(
        data = rep(ix, window_size) + rep(seq(0, window_size - 1), each = length(ix)),
        nrow = length(ix),
        ncol = window_size)
    windows[windows > length(tokens)] <- NA
    return(windows)
}
