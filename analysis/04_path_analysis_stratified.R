# ============================================================
# Script 4: Stratified Path Analysis by Cancer History
# HINTS Dataset - HBM Physical Activity Path Analysis
# Author: Poojitha Garlapati
# ============================================================

library(lavaan)
library(dplyr)

# Load analytic dataset
hints_analytic <- read.csv("data/hints_analytic.csv")

cat("Loaded analytic dataset: N =", nrow(hints_analytic), "\n")

# ── Step 1: Split by Cancer History ────────────────────────
no_cancer <- hints_analytic %>%
  filter(CancerHistory_Binary == 0)

cancer <- hints_analytic %>%
  filter(CancerHistory_Binary == 1)

cat("No cancer history: N =", nrow(no_cancer), "\n")
cat("Cancer history:    N =", nrow(cancer), "\n")

# ── Step 2: Define Path Model ───────────────────────────────
hbm_model <- '
  PhysicalActivity_z ~ Susceptibility_z
                     + Severity_z
                     + Benefits_z
                     + Barriers_z
                     + SelfEfficacy_z
                     + CuesToAction_z
                     + MentalHealth_z
'

# ── Step 3: Fit Models for Each Group ──────────────────────
fit_no_cancer <- sem(
  hbm_model,
  data = no_cancer,
  estimator = "MLR",
  missing = "listwise"
)

fit_cancer <- sem(
  hbm_model,
  data = cancer,
  estimator = "MLR",
  missing = "listwise"
)

# ── Step 4: Extract Results for Both Groups ─────────────────
extract_results <- function(fit, group_name, n) {
  std_params <- standardizedSolution(fit) %>%
    filter(op == "~") %>%
    select(
      Predictor = rhs,
      Beta      = est.std,
      SE        = se,
      p_value   = pvalue
    ) %>%
    mutate(
      Group       = group_name,
      N           = n,
      Beta        = round(Beta, 3),
      SE          = round(SE, 3),
      p_value     = round(p_value, 3),
      Significant = ifelse(p_value < 0.05, "Yes", "No")
    )

  r2 <- round(inspect(fit, "r2"), 4)

  cat("\n──", group_name, "── N =", n, "── R² =", r2, "──\n")
  print(std_params)
  cat("Variance explained:", round(r2 * 100, 2), "%\n")

  return(std_params)
}

results_no_cancer <- extract_results(
  fit_no_cancer,
  "No Cancer History",
  nrow(no_cancer)
)

results_cancer <- extract_results(
  fit_cancer,
  "Cancer History",
  nrow(cancer)
)

# ── Step 5: Compare Key Coefficients ───────────────────────
cat("\n── Key Coefficient Comparison ─────────────────────\n")
cat("Construct          | No Cancer | Cancer History\n")
cat("---------------------------------------------------\n")

constructs <- c(
  "Severity_z", "Barriers_z",
  "SelfEfficacy_z", "Susceptibility_z"
)

for (construct in constructs) {
  beta_no <- results_no_cancer %>%
    filter(Predictor == construct) %>%
    pull(Beta)
  beta_yes <- results_cancer %>%
    filter(Predictor == construct) %>%
    pull(Beta)
  cat(
    sprintf("%-20s | %9.3f | %9.3f\n",
            construct, beta_no, beta_yes)
  )
}

# ── Step 6: Save Combined Results ──────────────────────────
combined_results <- bind_rows(results_no_cancer, results_cancer)
write.csv(
  combined_results,
  "outputs/path_coefficients_stratified.csv",
  row.names = FALSE
)
cat("\nStratified results saved to outputs/path_coefficients_stratified.csv\n")
