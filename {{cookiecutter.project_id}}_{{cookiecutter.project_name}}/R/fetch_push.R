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
        cmdval <- system2(script_fpath, args = shQuote(msg))
        if (cmdval != 0L) {
            stop("Error pushing with return value: ", cmdval)
        }
    } else {
        cmdval <- system2(script_fpath)
        if (cmdval != 0L) {
            stop("Error pushing with return value: ", cmdval)
        }
    }
}

push_targets <- list(
    tar_file(
        push_data_script,
        "./bin/push_data"
    ),
    tar_target(
        quilt_message,
        "Data analysis"
    ),
    tar_target(
        pushed,
        push_data(push_data_script,
                  ## Add any targets to this list as a way to tie the push_data
                  ## target downstream of the outputs of the workflow. They are
                  ## ignored by the push_data() function
                  list(
                  ),
                  msg = quilt_message)
    )
)
