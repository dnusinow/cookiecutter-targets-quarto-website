fetch_data <- function(script_fpath) {
    system2(script_fpath, stdout = TRUE) %>%
        jsonlite::fromJSON(simplifyVector = TRUE)
}

fetch_targets <- list(
    tar_file(
        fetch_script_fpath,
        "./bin/fetch_data"
    ),
    tar_target(
        fetched,
        fetch_data(fetch_script_fpath)
    )
)

## Any targets you want to add at the end of a build before pushing
push_targets <- list(
)
