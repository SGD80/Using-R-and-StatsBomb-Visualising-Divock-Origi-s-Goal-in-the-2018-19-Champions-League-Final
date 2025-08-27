######### Libraries ######### 

library(tidyverse)
library(glue)
library(dplyr)
library(purrr)
library(StatsBombR)

######### Load Data  #########  

Comp <- FreeCompetitions() %>% 
  filter(competition_id==16 & season_id==4)
Matches <- FreeMatches(Comp)

Matches <- FreeMatches(Comp) #3
StatsBombData <- free_allevents(MatchesDF = Matches, Parallel = T) #4
StatsBombData = allclean(StatsBombData) #

########## Step 1: Select required columns and keep a shot identifier ######### 

shots <- StatsBombData %>%
  filter(type.name == "Shot")

shots_with_id <- shots %>%
  mutate(shot_id = row_number()) %>%
  select(shot_id, match_id, player.name, team.name, shot.freeze_frame,
         location.x, location.y, shot.end_location.x, shot.end_location.y, shot.outcome.name)

######### Unnest and process freeze frames ########

freeze_frame_long <- shots_with_id %>%
  unnest_longer(shot.freeze_frame) %>%
  rowwise() %>%
  mutate(
    location_x = if (is.list(shot.freeze_frame) && !is.null(shot.freeze_frame$location)) shot.freeze_frame$location[1] else NA_real_,
    location_y = if (is.list(shot.freeze_frame) && !is.null(shot.freeze_frame$location)) shot.freeze_frame$location[2] else NA_real_,
    teammate   = if (is.list(shot.freeze_frame) && !is.null(shot.freeze_frame$teammate)) shot.freeze_frame$teammate else NA,
    player_ff  = if (is.list(shot.freeze_frame) && !is.null(shot.freeze_frame$player.name)) shot.freeze_frame$player.name else NA_character_
  ) %>%
  ungroup() %>%
  select(shot_id, match_id, player.name, team.name, location_x, location_y, teammate, player_ff,
         location.x, location.y, shot.end_location.x, shot.end_location.y, shot.outcome.name)

######### ✅ Fix location_x and location_y using map_dbl   #######

freeze_frame_long <- freeze_frame_long %>%
  mutate(
    location_y = map_dbl(location_x, ~ .x[2]),
    location_x = map_dbl(location_x, ~ .x[1])
  )


#########  ######### 


ggplot() +
  annotate("rect", xmin = 0, xmax = 120, ymin = 0, ymax = 80, fill = NA, colour = "black", linewidth = 0.6) +
  annotate("rect", xmin = 0, xmax = 60, ymin = 0, ymax = 80, fill = NA, colour = "black", linewidth = 0.6) +
  annotate("rect", xmin = 18, xmax = 0, ymin = 18, ymax = 62, fill = NA, colour = "black", linewidth = 0.6) +
  annotate("rect", xmin = 102, xmax = 120, ymin = 18, ymax = 62, fill = NA, colour = "black", linewidth = 0.6) +
  annotate("rect", xmin = 0, xmax = 6, ymin = 30, ymax = 50, fill = NA, colour = "black", linewidth = 0.6) +
  annotate("rect", xmin = 120, xmax = 114, ymin = 30, ymax = 50, fill = NA, colour = "black", linewidth = 0.6) +
  annotate("rect", xmin = 120, xmax = 120.5, ymin = 36, ymax = 44, fill = NA, colour = "black", linewidth = 0.6) +
  annotate("rect", xmin = 0, xmax = -0.5, ymin = 36, ymax = 44, fill = NA, colour = "black", linewidth = 0.6) +
  annotate("segment", x = 60, xend = 60, y = -0.5, yend = 80.5, colour = "black", linewidth = 0.6) +
  annotate("segment", x = 0, xend = 0, y = 0, yend = 80, colour = "black", linewidth = 0.6) +
  annotate("segment", x = 120, xend = 120, y = 0, yend = 80, colour = "black", linewidth = 0.6) +
  annotate("point", x = 108 , y = 40, colour = "black", size = 1.05) +
  annotate("path", colour = "black", size = 0.6,
           x = 60 + 10 * cos(seq(0, 2*pi, length.out = 2000)),
           y = 40 + 10 * sin(seq(0, 2*pi, length.out = 2000))) +
  annotate("point", x = 60 , y = 40, colour = "black", size = 1.05) +
  annotate("path", x = 12 + 10 * cos(seq(-0.3*pi, 0.3*pi, length.out = 30)), size = 0.6,
           y = 40 + 10 * sin(seq(-0.3*pi, 0.3*pi, length.out = 30)), col = "black") +
  annotate("path", x = 107.84 - 10 * cos(seq(-0.3*pi, 0.3*pi, length.out = 30)), size = 0.6,
           y = 40 - 10 * sin(seq(-0.3*pi, 0.3*pi, length.out = 30)), col = "black") +
  
  # 🔽 Shot line with outcome-based color
  geom_segment(
    data = freeze_frame_long %>% filter(shot_id == 27),
    aes(
      x = location.x, y = location.y,
      xend = shot.end_location.x, yend = shot.end_location.y,
      color = shot.outcome.name
    ),
    linewidth = 1.2,
    arrow = arrow(length = unit(0.25, "cm"))
  ) +
  geom_point(
    data = freeze_frame_long %>% filter(shot_id == 27),
    aes(x = location.x, y = location.y, color = player.name),
    size = 4, alpha = 0.8
  ) +
  geom_text(
    data = freeze_frame_long %>% filter(shot_id == 27),
    aes(x = location.x - 3, y = location.y, label = player.name),  # move text 3 units left
    vjust = -1,
    size = 3
  ) +
  geom_point(
    data = freeze_frame_long %>% filter(shot_id == 27),
    aes(x = location_x, y = location_y, color = teammate),
    size = 4, alpha = 0.8
  ) +
  geom_text(
    data = freeze_frame_long %>% filter(shot_id == 27),
    aes(x = location_x, y = location_y, label = player_ff),
    vjust = -1, size = 3
  ) +
  scale_color_manual(
    values = c("TRUE" = "red", "FALSE" = "purple")  # Swap these to reverse the color roles
  ) +
  labs(
    title = glue("Match: 2018/19 Champions League Final"),
    subtitle = glue("Goal Scorer: Divock Okoth Origi"),
    x = "Touchline",
    y = "Final 3rd",
    color = "Team mate"
  ) +
  coord_flip(xlim = c(85, 125)) +
  theme_minimal()

######
