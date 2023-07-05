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

renv::activate(.top_level)

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

# Replace the target list below with your own:
list(
    ## fetch_targets, # uncomment to fetch
    tar_quarto(report_site,
               "report_src",
             quiet = TRUE),
    ## Replace this message with whatever you want the quilt commit message to
    ## be
    tar_target(
        quilt_message,
        "Data analysis for {{cookiecutter.program}}/{{cookiecutter.project_id}}"
    )
    ## push_targets # uncomment to push
)
