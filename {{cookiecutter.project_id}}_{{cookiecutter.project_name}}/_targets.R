.top_level <- (function() {
    cur_dir <- path.expand(getwd())
    while (TRUE) {
        if (".git" %in% dir(cur_dir, all.files = TRUE)) {
            return(cur_dir)
        }
        next_up <- dirname(cur_dir)
        if (next_up == cur_dir) {
            stop("Couldn't find .git directory")
        }
        cur_dir <- next_up
    }
})()

options(renv.config.synchronized.check = FALSE)
renv::load(.top_level)

library(targets)
library(tarchetypes)
library(tidyverse)
suppressMessages(library(magrittr))

# Set target options:
tar_option_set(
  packages = c("tibble",
               "tidyverse",
               "glue",
               "jsonlite",
               "magrittr"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages 'future', 'future.callr', and 'future.batchtools' to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
source(file.path(.top_level, "analysis", "common", "theme_dpn_bw.R"))

save_csv <- function(x, fpath) {
    readr::write_csv(x, fpath)
    fpath
}

save_parquet <- function(x, fpath) {
    arrow::write_parquet(x, fpath)
    fpath
}

# Replace the target list below with your own:
list(
    ## fetch_targets, # uncomment to fetch
    tar_quarto(report_site,
               "report_src",
             quiet = TRUE),
    push_targets
)
