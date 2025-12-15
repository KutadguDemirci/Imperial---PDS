create_person_s3 <- function(name, age) {
  structure(list(name = name, age = age), class = "person_s3")
}

greet.person_s3 <- function(obj) {
  paste0("Hello, my name is ", obj$name, " and I am ", obj$age, " years old.")
}


####################################

setClass("PersonS4",
  slots = list(
    name = "character",
    age = "numeric"
  )
)

setMethod("initialize", "PersonS4", function(.Object, name, age) {
  .Object@name <- name
  .Object@age <- age
  .Object
})


setGeneric("greet", function(object) standardGeneric("greet"))
setMethod("greet", "PersonS4", function(object) {
  paste0("Hello, my name is ", object@name, " and I am ", object@age, " years old.")
})

#####################################

library(R6)

PersonR6 <- R6Class("PersonR6",
  private = list(
    name = NULL,
    age = NULL
  ),
  public = list(
    initialize = function(name, age) {
      private$name <- name
      private$age <- age
    },
    greet = function() {
      paste0("Hello, my name is ", private$name, " and I am ", private$age, " years old.")
    },
    get_name = function() {
      private$name
    },
    get_age = function() {
      private$age
    }
  )
)

