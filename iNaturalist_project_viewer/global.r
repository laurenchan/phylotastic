library(shiny)
library(rinat)
library(rphylotastic)
library(deeptime)
library(datelife)
library(ggplot2)
library(ggtree)
library(ape)
library(shinycustomloader)

# the following gets height in pixels, developed in datelifeweb
tree_plot_height <- function(tree){
  tipnum <- ape::Ntip(tree)
  if(tipnum > 10){
    hei <- 10 + (20 * tipnum)
  } else {
    hei <- 200
  }
  hei
}