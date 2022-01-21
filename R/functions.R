#' @title Plot ozone from the preprocessed air quality data.
#' @description Plot a histogram of ozone concentration.
#' @return A ggplot histogram showing ozone content.
#' @param data Data frame, preprocessed air quality dataset.
#' @examples
#' library(ggplot2)
#' library(tidyverse)
#' data <- airquality %>%
#'   mutate(Ozone = replace_na(Ozone, mean(Ozone, na.rm = TRUE)))
#' create_plot(data)
create_plot <- function(data) {
  ggplot(data) +
    geom_line(aes(x = date, y = users)) +
    theme_gray(24)
}

bq_table_mtime =
  if ("bq_table_mtime" %in% names(asNamespace("bigrquery"))) {
    bigrquery::bq_table_mtime
  } else {
    function(x) {
      meta = bigrquery::bq_table_meta(x = x, fields = "lastModifiedTime")
      as.POSIXct(as.double(meta$lastModifiedTime)/1000,
                 origin = "1970-01-01", tz = "UTC")
    }
  }


read_db <- function(database_update_time, bq_tbl) {
  bigrquery::bq_table_download(bq_tbl)
}

connect_bq <- function(database_update_time, bq_tbl) {
  require("streamliner")
  bq_tbl = bigrquery::as_bq_table(bq_tbl)
  dplyr::tbl(bq_tbl)
}
