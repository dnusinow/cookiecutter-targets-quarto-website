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

push_data <- function(script_fpath, ..., msg = NULL) {
    if (!is.null(message)) {
        system2(script_fpath, args = msg)
    } else {
        system2(script_fpath)
    }
}

push_targets <- list(
    tar_file(
        push_data_script,
        "./bin/push_data"
    ),
    tar_target(
        pushed,
        push_data(push_data_script,
                  ## Add any targets to this list as a way to tie the push_data
                  ## target downstream of the outputs of the workflow. They are
                  ## ignored by the push_data() function
                  list(
                  ),
                  message = quilt_message)
    )
)
