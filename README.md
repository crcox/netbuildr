# netbuildr

Build associative networks from multiple data modalities, including:
 * word association norms
 * natural language corpora
 
The networks produced are represented as square adjacency matrices.

## How to install
`netbuildr` is not on CRAN, but can be installed directly from github using the [devtools](https://github.com/r-lib/devtools) package:

```
devtools::install_github("crcox/netbuildr")
```

## How to use
### Build network from text split across multiple documents
In the following, single letters are substituted for words.
Each vector contained in the list `tokens` represents a document.

The window is forward looking, and directed connections are drawn from the first word in a window to the other words in the window.
If a list of types are provided, only cooccurrences among the provided types are counted.
The resulting matrix can be interpretted as a directed weighted graph, and can be made unweighted by applying a threshold.

```
tokens <- list(
    c("a", "g", "f", "b", "a", "e", "c", "d", "b", "a"),
    c("a", "h", "i", "b", "a", "j", "c", "k", "b", "a")
)
types <- c("a", "b", "c")
window_size <- 3
create_cooccurrence_matrix(tokens, window_size)
#   a b c d e f g h i j k
# a 0 0 2 0 1 1 1 1 1 1 0
# b 4 0 0 0 1 0 0 0 0 1 0
# c 0 2 0 1 0 0 0 0 0 0 1
# d 1 1 0 0 0 0 0 0 0 0 0
# e 0 0 1 1 0 0 0 0 0 0 0
# f 1 1 0 0 0 0 0 0 0 0 0
# g 0 1 0 0 0 1 0 0 0 0 0
# h 0 1 0 0 0 0 0 0 1 0 0
# i 1 1 0 0 0 0 0 0 0 0 0
# j 0 0 1 0 0 0 0 0 0 0 1
# k 1 1 0 0 0 0 0 0 0 0 0


create_cooccurrence_matrix(tokens, window_size, types)
#   a b c
# a 0 0 2
# b 4 0 0
# c 0 2 0
```

## Build network from association data
In an association task, participants are asked to respond with the first words that come to mind when presented with a cue.
When building a network, the cue words represent the nodes.
A connection is drawn between two nodes when one is produced as a response when cued by the other.

In the example, there are three unique cues, so the network will have three nodes.
The function returns a logical matrix.

```
cues    <- c(1,1,1,1,2,2,2,2,3,3,3,3)
responses <- c(2,4,5,6,3,4,5,6,1,4,5,6)
create_unweighted_network(cues, responses)
#       1     2     3
# 1 FALSE  TRUE FALSE
# 2 FALSE FALSE  TRUE
# 3  TRUE FALSE FALSE


```
