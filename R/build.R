render_page <- function(input) {
    ## TODO: Don't hard code this path
    script <- normalizePath("/Users/amarder/Dropbox/hbs/rcs/hbs-rcs.github.io/R/render_page.R")
    args = c(script, input)
    return_code <- blogdown:::Rscript(shQuote(args))
    if (return_code != 0) stop("Failed to render '", input, "'")
}

## https://stackoverflow.com/a/8743858/3756632
assignInNamespace("render_page", render_page, "blogdown")
