################################################################################
# Title: Data Structures in R -- based on AR2: Data Structures

# Name of file: dat_structures_functions.R
# A script about basics of data structures in the R statistical programming
# language and basics of functional programming
# Author: Ruben Bach
# Note: Mostly based on Advanced R, first edition, by H. Wickham
# Date: Mon Sep 13, 2021
################################################################################

# Basic data structures in R are vectors
## Vectors come in two flavors: atomic vectors and lists

## All elements of atomic vectors must be of the same type, while lists allow different types

## Data types are (types Raw and Complex barely used)
### logical
Log.vector <- c(TRUE, FALSE, FALSE, TRUE)
typeof(Log.vector)

### Integer (1,2,3,4,5...)
Int.vector <- c(1L, 5L, 3L)
typeof(Int.vector)

### Double
dbl.vector <- c(2.3, 5.6, 5.5424365)
typeof(dbl.vector)

### Character
Chr.vector <- c("Ruben", "Amy", "George", "Harry")
typeof(Chr.vector)

# Test whether vector is atomic vector
is.atomic(dbl.vector)

# Test whether vector is of certain type
is.double(dbl.vector)
is.character(dbl.vector)
is.logical(dbl.vector)
is.integer(dbl.vector)


#### We can coerce some types into others
# E.g. logical to integer

as.integer(Log.vector) # TRUE becomes 1, FALSE 0
as.character(dbl.vector) # Obviously, we can represent numbers as text



##### Lists: Second basic data structure in R
# Lists are combinations of (different) types of atomic vectors, but also other lists
my.list <- list(1:4, c("Ruben", "Amy", "Rebecca"), c(TRUE, FALSE, FALSE, TRUE))
str(my.list)

my.list.2 <- list(1:4, c("Ruben", "Amy", "Rebecca"), c(TRUE, FALSE, FALSE, TRUE), 
                  list(1:4, c("Ruben", "Amy", "Rebecca")))
str(my.list.2)

# Combine lists into one list with c()
str(c(my.list.2, my.list))


# In general, lists are very powerful because they can contain a lot of different information!


#### Attributes
# We can add additional attributes to objects in R (such as names or other meta data)
y <- 1:10
attr(y, "my_attribute") <- "This is a vector"
attr(y, "my_attribute")
str(attributes(y))

### Naming
# Add names as you create a vector (note that not all elements of a vector need to have names)
y <- c(a = 1, 2, 3)
names(y)

# Or using the names() function
v <- c(1, 2, 3)
names(v) <- c('a')
names(v)

# By default, vectors have no names
z <- c(1, 2, 3)
names(z)

# Use unname() to remove names

#### Factors
# With social science data, we often have factors (e.g., low middle high education)
# A factor is a vector that can contain only predefined values
# Factors are built on top of integer vectors using two attributes: "factor class (makes them behave
# differently from regular integer vectors, and "levels", which defines the set of allowed values.

x <- factor(c("a", "b", "b", "a"))
x
class(x)
levels(x)


# Common mistake: Using values that are not in the levels
x[2] <- "c"
x

# We need to add the level first
levels(x) <- c("a", "b", "c") # Side note: Can have factor levels that have no observations in the data!
x[2] <- "c"
x



####### Matrices and Arrays
## When we add a "dim" attribute to a vector, we can turn the vector into a multi-dimensional array
## Most interesting (and popular) are matrices (think of everything related to Statistics and Math!)
## A matrix is a 2-dimensional array (rows and columns)
## Arrays with more than 2 dimensions are hardly used, but we should know what they are!

# Two scalar arguments to specify rows and columns
a <- matrix(1:6, ncol = 3, nrow = 2)

# You can also modify an object in place by setting dim()
c <- 1:6 ## 6 element vector
dim(c) <- c(3, 2) # turned into matrix with 3 rows and 2 columns
c

dim(c) <- c(2, 3) # Change to 2 rows and 3 columns
c # Notice how rows and columns are filled with values (columns before rows!)

# Can also assign row and column names to a matrix
rownames(a) <- c("A", "B")
colnames(a) <- c("a", "b", "c")
a

# To combine matrices, use cbind() and rbind() instead of c()
cbind(a, c)
# Note that matrices need to have same row (cbind) or column (rbind) length!
dim(c) <- c(3, 2)
cbind(a, c)



##### Dataframes
## Dataframes (df) are the most common way of storing data in R
# Technically, a df is list of equal length vectors with a 2-dimensional structure
# I.e., we can also work with colnames() or, equivelant, names() (we could also say, variable names
# in a dataset) and rownames() (less commmon)
# length() is the length of the underlying list, ncol() and nrow() count columns and rows

# Create a dataframe for example by
df <- data.frame(x = 1:3, y = c("a", "b", "c"))
str(df)

# Combination of different df just like combining matrices (aka cbind() and rbind())

# Final note: Because df's are list of vectors, we a column can also contain a list!
dfl <- data.frame(x = 1:3, y = I(list(1:2, 1:3, 1:4)))
str(dfl)

# However, note that the list must have the right number of "rows"!
dfl <- data.frame(x = 1:3, y = I(list(1:2, 1:3, 1:4, 1:3)))
str(dfl)


################################################################################
### Functional Programming in R -- based on AR10: Functional Programming########
################################################################################
### I mostly copied code from the chapter and I comment on it with additional
### explanations!

# Generate a sample dataset with negative values indicating some sort of missing data
# such as item nonresponse or don#t know in survey data
set.seed(1014)
df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep = TRUE)))
names(df) <- letters[1:6]
df

# Because missing values are represented in R by "NA", we need to convert
# -99 to NA
# Unfortunately, we have multiple columns with -99

# A copy-and-paste solution (error-prone!!) could look like this
df$a[df$a == -99] <- NA
df$b[df$b == -99] <- NA
df$c[df$c == -98] <- NA
df$d[df$d == -99] <- NA
df$e[df$e == -99] <- NA
df$f[df$g == -99] <- NA

# However, we made a few mistakes ("df$c == -98..." instead of "...-99..."
# and "df$f[df$g == -99]..." instead of "df$f[df$f...")

# To avoid such long and error prone copy pasting, we could write a function
# we start with function(), we then define parameters that the function can take (x)
# and we follow the function() by {}. Inside the {}, we tell the function what to do!
set.seed(1014)
df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep = TRUE)))
names(df) <- letters[1:6]
df

fix_missing <- function(x) {
  x[x == -99] <- NA # read: replace the subset of values in x where x equals -99 with NA!
  x
}
df$a <- fix_missing(df$a)
df$b <- fix_missing(df$b)
df$c <- fix_missing(df$c)
df$d <- fix_missing(df$d)
df$e <- fix_missing(df$e)
df$f <- fix_missing(df$e)

# We still need to apply it to every column!
# We could also apply it to a list of all columns! l(ist)apply --> lapply!
set.seed(1014)
df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep = TRUE)))
names(df) <- letters[1:6]
df

df[] <- lapply(df, fix_missing) # Why do we need df[]? Without [], the dataframe would be
# simplified to a list as a list is a simplified version of a dataframe and lapply is 
# a simplifying function!

# Can also subset to a few columns of the dataframe. Here, first five columns only
set.seed(1014)
df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep = TRUE)))
names(df) <- letters[1:6]
df
df[1:5] <- lapply(df[1:5], fix_missing)


# However, what should we do if we need to fix multiple values?
# Could again copy and paste, but there must be a more elegant solution!

# More elegant solution uses closures (i.e., functions that make and return functions,
# they enclose the environment of the parent function and can access all its variables!)
# Here, the inner function is the one from above, but instead of supplying the argument directly
# we have a second function which allows us to produce a function for each na_value

missing_fixer <- function(na_value) {
  function(x) {
    x[x == na_value] <- NA
    x
  }
}
fix_missing_99 <- missing_fixer(-99) ## Could choose any value
fix_missing_999 <- missing_fixer(-999)

# But still, two functions necessary!
fix_missing_99(c(-99, -999))
fix_missing_999(c(-99, -999))

# We could also add an extra argument to our function (na_value)
fix_missing <- function(x, na.value) {
  x[x == na.value] <- NA
  x
}

set.seed(1014)
df <- data.frame(replicate(6, sample(c(1:10, c(-99, -98)), 6, rep = TRUE)))
names(df) <- letters[1:6]
df

fix_missing(df, -99)
fix_missing(df, -98)

# What if we want to supply multiple NA values in one function call?
# We could add a for-loop.
fix_missing <- function(x, na.value) {
  for (y in na.value){ # for every value y in na.value
    x[x == y] <- NA    # replace x where x==y with NA
  }
  x
}
library(magrittr)
fix_missing(df, c(-98, -99)) %>% View()

### Now we go on to data exploration, some descriptive statistics
### Similar problem: Duplicate code

mean(df$a)
median(df$a)
sd(df$a)
mad(df$a)
IQR(df$a)

mean(df$b)
median(df$b)
sd(df$b)
mad(df$b)
IQR(df$b)

## One solution
summary <- function(x) {
  c(mean(x, na.rm = TRUE),
    median(x, na.rm = TRUE),
    sd(x, na.rm = TRUE),
    mad(x, na.rm = TRUE),
    IQR(x, na.rm = TRUE))
}

lapply(df, summary)

# We still have all the x and na.rm arguments many times
# Fix: Store functions in lists and call them from within another function!
summary <- function(x) {   # function 1
  funs <- c(mean, median, sd, mad, IQR) # stores functions in list
  lapply(funs, function(f) f(x, na.rm = TRUE)) # apply list of functions to list!
}

# To understand what's happening under the hood, we have a look at this step-by-step!

# First thing we need to know are anonymous functions:
# Examples: We define a function without giving it a name! I.e., we do not store it
# in an object. In other words, we just use the right hand side of, e.g.:
my.function <- function(x){length(unique(x))}

# i.e., we only use "function(x) length(unique(x))"
lapply(mtcars, function(x) length(unique(x)))

# Same logic: We only use "function(x) !is.numeric(x)
Filter(function(x) !is.numeric(x), mtcars)

# However, if you work with anonymous functions, be careful with parentheses!
function(x) 3() # doesn't work

# need to put parentheses around function, arguments and body!
(function(x) x + 3)(10)

# Equivalent (non anonymous)
f <- function(x) x + 3
f(10)
# or
f <- function(x){
  x + 3
} 
f(10)

# Example for closure functions: FUnctions that create functions (see also above)

power <- function(exponent) {
  function(x) {
    x ^ exponent
  }
}

square <- power(2) # make a function square with exponent 2
square(2)
square(4)

cube <- power(3) # make a function cube with exponent 3
cube(2)
cube(4)

