build_rmds <- function (files, config, local, raw = FALSE)
{
    if (length(files) == 0)
        return(hugo_build(local, config))
    lib1 = by_products(files, c("_files", "_cache", if (!raw) ".html"))
    lib2 = gsub("^content", "blogdown", lib1)
    if (raw) {
        i = grep("_files$", lib2)
        lib2[i] = gsub("^blogdown", "static", lib2[i])
    }
    for (i in seq_along(lib2)) if (dir_exists(lib2[i])) {
        file.copy(lib2[i], dirname(lib1[i]), recursive = TRUE)
    }
    else if (file.exists(lib2[i])) {
        file.rename(lib2[i], lib1[i])
    }
    for (f in files) in_dir(d <- dirname(f), {
        f = basename(f)
        html = with_ext(f, "html")
        if (local && file_test("-nt", html, f))
            next
        render_page(f)
        x = readUTF8(html)
        x = encode_paths(x, by_products(f, "_files"), d, raw)
        writeUTF8(c(fetch_yaml2(f), "", x), html)
    })
    for (i in seq_along(lib1)) if (dir_exists(lib1[i])) {
        dir_create(dirname(lib2[i]))
        file.copy(lib1[i], dirname(lib2[i]), recursive = TRUE)
    }
    hugo_build(local, config)
    if (!raw) {
        root = getwd()
        in_dir(publish_dir(config), process_pages(local, root))
        i = file_test("-f", lib1)
        lapply(unique(dirname(lib2[i])), dir_create)
        file.rename(lib1[i], lib2[i])
    }
    unlink(lib1, recursive = TRUE)
}

## https://stackoverflow.com/a/8743858/3756632
assignInNamespace("build_rmds", build_rmds, "blogdown")
