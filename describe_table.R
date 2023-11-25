# contingency tables and show them in a pretty way
# definition of helper function: describe_table()


# read data

here("data", "crabs.txt")

df_raw <- read.fwf(
  here("data", "crabs.txt"), 
  widths = c(1, -2, 1,-2, 4, -2, 1, -2, 4, -1, 1)
)

col_names <- here("data", "crabs.txt") %>% 
  read_lines(n_max = 1) %>% 
  str_split(" ") %>% 
  unlist() %>% 
  head(-1)

# then we read in the data starting from the second line
df_raw <- here("data", "crabs.txt") %>% 
  read.fwf(
    widths = c(1, 3, 6, 5, 5, 1),
    skip = 1,
    col.names = col_names)

str(df_raw)

df_raw

df <- df_raw %>% 
  mutate(
    color = factor(color, labels = c("light", "medium", "dark", "darker")),
    spine = factor(spine, labels =c("both good", "one worn or broken", "both worn or broken")),
    y = factor(y, labels = c("No Satellite", "At least 1 Sattelite"))
  )

str(df)
df

# contigency tables

tab <- tab_2way
vars <- dimnames(tab)
vars
tab
idx = c(3, 4)
tab[idx[1], idx[2]]
tab[array_reshape(1:length(tab), dim=dim(tab), order = "F")[idx[1], idx[2]]]

tab <- tab_3way
dims <- dim(tab) %>% print()
vars <- dimnames(tab) %>% print()
idx <-  c(3, 1, 3)
tab[idx[1], idx[2], idx[3]]
idx_1d <- array_reshape(1:length(tab), dim=dim(tab), order = "F")[idx[1], idx[2], idx[3]] %>% print()
tab[idx_1d]

tab <- tab_3way
idx <-  c(3, 1, 3)
#idx <-  c(2, 4, 4)
dims <- dim(tab) %>% print()
d <- length(dims) %>% print()
position <- 1 + sum((idx-1)*lag(cumprod(dims), default = 1)) %>% print()
tab[position]
tab[idx[1], idx[2], idx[3]]

vars <- sapply(1:3, function(x) {dimnames(tab)[[x]][idx[x]]}) %>% print()
vars[3]


# define the helper function to show tables in a pretty way

describe_table <- function(tab, idx){
  # get dimensions of the table
  dims <- dim(tab)
  d <- length(dims)
  
  # get levels of each dimension (variable) based on indices
  vars <- sapply(1:d, function(x) {dimnames(tab)[[x]][idx[x]]})
  
  # calculate the position of the table element based on indices 
  position <- 1 + sum((idx-1)*lag(cumprod(dims), default = 1))
  
  # get the value based on the position in the table
  value <- tab[position]
  
  str <- case_when(
    d == 1 ~ glue(
      "The count of the females",
      " with {tolower(vars[1])} spine[s]",
      " is {value}."),
    d == 2 ~ glue(
      "The count of the females",
      " with {tolower(vars[1])} spine[s]",
      " having {vars[2]} satellite males",
      " is {value}."),    
    d == 3 ~ glue(
      "The count of the {vars[3]}-colored females",
      " with {tolower(vars[1])} spine[s]",
      " having {vars[2]} satellite males",
      " is {value}."),
    TRUE ~ "Not supported!"
  )
  
  print(str)
}

# tests

describe_table(tab_2way, c(2, 10))
describe_table(tab_3way, c(2, 10, 3))



