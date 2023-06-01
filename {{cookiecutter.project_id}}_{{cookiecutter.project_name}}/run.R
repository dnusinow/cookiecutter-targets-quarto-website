#!/usr/bin/env Rscript

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

# This is a helper script to run the pipeline.
# Choose how to execute the pipeline below.
# See https://books.ropensci.org/targets/hpc.html
# to learn about your options.

targets::tar_make()
# targets::tar_make_clustermq(workers = 2) # nolint
# targets::tar_make_future(workers = 2) # nolint
