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


read_db <- function(database_update_time, bq_tbl) {
  bigrquery::bq_table_download(bq_tbl)
}
