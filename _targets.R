library(targets)
library(tarchetypes)
source("R/functions.R")
source("R/authorize_bq.R")
project = "streamline-resources"
dataset = "google_analytics_raw"
table = "google_analytics_users"
bq_tbl = bigrquery::bq_table(project, dataset, table)
bq_tbl2 = bigrquery::bq_table(project, "covid_jhu", "covid_jhu_cases")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("dplyr", "ggplot2",
                            "bigrquery"))



list(
  tar_target(
    database_update_time,
    bq_table_mtime(bq_tbl)
  ),
  tar_target(
    raw_data,
    connect_bq(database_update_time, bq_tbl)
  ),
  tar_target(
    covid_update_time,
    bq_table_mtime(bq_tbl2)
  ),
  tar_target(
    covid_data,
    connect_bq(covid_update_time, bq_tbl2)
  ),
  tar_target(
    data,
    raw_data %>%
      arrange(date, latitude)
  ),
  ##### I need *STORED* data (aka a data.frame)
  # tar_target(
  #   dataframe,
  #   data %>%
  #     dplyr::collect()
  # ),
  # tar_target(
  #   covid_dataframe,
  #   covid_data %>%
  #     dplyr::collect()
  # ),
  tar_target(
    sum_covid,
    covid_data %>%
      group_by(date) %>%
      summarise(cases = sum(cases, na.rm = TRUE))
  ),
  tar_target(
    both_data,
    left_join(data, sum_covid)
  ),
  tar_target(scatter, create_plot(data)),
  tar_target(data2, print(data)),
  tar_render(report, "index.Rmd")
)
