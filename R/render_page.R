## Get path to Rmd file
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 1)
rmd <- args[1]
html <- sub("\\.[Rr]md$", ".html", rmd)

## Suppress version numbers in subdirectory names
## Copied from blogdown
options(htmltools.dir.version = FALSE)

html_exists <- file.exists(html)
html_newer <- file_test("-nt", html, rmd)

if (html_exists & html_newer) {
    seconds <- 0
    note <- paste0(rmd, ": skipped\n")
} else {
    time <- system.time(rmarkdown::render(
        rmd,
        'blogdown::html_page',
        envir = globalenv(),
        quiet = TRUE,
        encoding = 'UTF-8'
    ))
    note <- paste0(rmd, ": ", time[['elapsed']], " seconds\n")
}

cat(note)
