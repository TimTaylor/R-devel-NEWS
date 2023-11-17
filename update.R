library(xml2)
library(anytime)

url <- "https://developer.r-project.org/blosxom.cgi/R-devel/NEWS/index.rss"
xml <- read_xml(url) # TODO - handle failure
latest <- xml_find_first(xml, ".//item")
latest <- unlist(as_list(latest), recursive = FALSE)
latest$pubDate <- anytime(latest$pubDate) # TODO - handle failure
latest$description <- xml_text(read_html(latest$description))

previous <- readRDS("previous.rds")
if (latest$guid == previous$guid) {
    cat("Nothing to do. All up to date\n")
} else {
    filename <- paste0(format(latest$pubDate, "%Y%m%d"), ".txt")
    if (file.exists(filename))
        stop("Rethink the naming convention.")
    cat(latest$description, file = filename)
    saveRDS(latest, "previous.rds")
}
