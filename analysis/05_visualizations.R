# ============================================================
# Script 5: Visualizations
# HINTS Dataset - HBM Physical Activity Path Analysis
# Author: Poojitha Garlapati
# ============================================================

library(ggplot2)
library(dplyr)

# Create outputs directory
dir.create("outputs", showWarnings = FALSE)

# Load results
full_results <- read.csv("outputs/path_coefficients_full.csv")
stratified_results <- read.csv("outputs/path_coefficients_stratified.csv")

# ── Plot 1: Full Sample Path Coefficients ───────────────────
full_results <- full_results %>%
  mutate(
    Predictor = gsub("_z", "", Predictor),
    Color = ifelse(Beta < 0, "Negative", "Positive"),
    Significant = ifelse(p_value < 0.05, "Significant", "Not Significant")
  )

p1 <- ggplot(full_results, aes(
    x = reorder(Predictor, Beta),
    y = Beta,
    fill = Color,
    alpha = Significant
  )) +
  geom_bar(stat = "identity", width = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40") +
  geom_text(
    aes(
      label = ifelse(p_value < 0.05,
                     paste0("β = ", Beta, "*"),
                     paste0("β = ", Beta)),
      hjust = ifelse(Beta < 0, 1.1, -0.1)
    ),
    size = 3.5
  ) +
  scale_fill_manual(values = c("Negative" = "#E87C7C", "Positive" = "#4A90D9")) +
  scale_alpha_manual(values = c("Significant" = 1, "Not Significant" = 0.4)) +
  coord_flip() +
  labs(
    title = "HBM Constructs Predicting Physical Activity",
    subtitle = "Full Sample (N = 6,590) | Standardized Path Coefficients (β)",
    x = "HBM Construct",
    y = "Standardized β Coefficient",
    fill = "Direction",
    alpha = "Significance",
    caption = "* p < .05  ** p < .01  *** p < .001"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "bottom"
  )

ggsave("outputs/plot1_full_sample_coefficients.png",
       p1, width = 9, height = 6, dpi = 150)
cat("Plot 1 saved.\n")

# ── Plot 2: Stratified Comparison ──────────────────────────
key_constructs <- c("Severity", "SelfEfficacy", "Barriers")

stratified_plot <- stratified_results %>%
  mutate(Predictor = gsub("_z", "", Predictor)) %>%
  filter(Predictor %in% key_constructs)

p2 <- ggplot(stratified_plot, aes(
    x = Predictor,
    y = Beta,
    fill = Group
  )) +
  geom_bar(stat = "identity", position = "dodge", width = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40") +
  geom_text(
    aes(label = Beta),
    position = position_dodge(width = 0.6),
    vjust = ifelse(stratified_plot$Beta < 0, 1.5, -0.5),
    size = 3.5
  ) +
  scale_fill_manual(values = c(
    "No Cancer History" = "#4A90D9",
    "Cancer History"    = "#E87C7C"
  )) +
  labs(
    title = "HBM Predictors by Cancer History",
    subtitle = "Stratified Comparison | Standardized β Coefficients",
    x = "HBM Construct",
    y = "Standardized β Coefficient",
    fill = "Group"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "gray40"),
    legend.position = "bottom"
  )

ggsave("outputs/plot2_stratified_comparison.png",
       p2, width = 9, height = 6, dpi = 150)
cat("Plot 2 saved.\n")

cat("\nAll visualizations saved to outputs/\n")
