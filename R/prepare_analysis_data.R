library(dplyr)
library(readr)

raw_data <- readr::read_csv(
  "../data/savant_data.csv",
  show_col_types = FALSE
)

pitch_data <- raw_data %>%
  mutate(
    game_date = as.Date(
      game_date,
      format = "%m/%d/%Y"
    )
  ) %>%
  arrange(
    game_date,
    game_pk,
    at_bat_number,
    pitch_number
  ) %>%
  mutate(
    pa_id = paste(
      game_pk,
      at_bat_number,
      sep = "_"
    )
  ) %>%
  group_by(
    game_pk,
    at_bat_number
  ) %>%
  mutate(
    final_pitch =
      pitch_number ==
      max(pitch_number, na.rm = TRUE)
  ) %>%
  ungroup()

pa_data <- pitch_data %>%
  filter(final_pitch) %>%
  arrange(
    game_date,
    game_pk,
    at_bat_number
  )

official_ab_events <- c(
  "single",
  "double",
  "triple",
  "home_run",
  "field_out",
  "force_out",
  "strikeout",
  "strikeout_double_play",
  "grounded_into_double_play",
  "double_play",
  "triple_play",
  "field_error",
  "fielders_choice",
  "fielders_choice_out"
)

pa_data <- pa_data %>%
  mutate(
    official_at_bat = if_else(
      events %in% official_ab_events,
      1L,
      0L
    ),
    hit = if_else(
      events %in% c(
        "single",
        "double",
        "triple",
        "home_run"
      ),
      1L,
      0L
    )
  )

ab_data <- pa_data %>%
  filter(official_at_bat == 1L) %>%
  arrange(
    game_date,
    game_pk,
    at_bat_number
  )

stopifnot(
  all(ab_data$hit %in% c(0L, 1L))
)
