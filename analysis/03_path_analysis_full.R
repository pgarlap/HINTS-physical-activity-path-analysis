# ============================================================
# Script 3: Full Sample Path Analysis
# HINTS Dataset - HBM Physical Activity Path Analysis
# Author: Poojitha Garlapati
# ============================================================

library(lavaan)
library(dplyr)

# Load analytic dataset
hints_analytic <- read.csv("data/hints_analytic.csv")

cat("Loaded analytic dataset: N =", nrow(hints_analytic), "\n")

# ── Step 1: Define Path Model ───────────────────────────────
# Direct effects of 7 HBM constructs on physical activity

hbm_model <- '
  # Direct effects on Physical Activity
  PhysicalActivity_z ~ Susceptibility_z
                     + Severity_z
                     + Benefits_z
                     + Barriers_z
                     + SelfEfficacy_z
                     + CuesToAction_z
                     + MentalHealth_z
'

# ── Step 2: Fit Path Model ──────────────────────────────────
fit_full <- sem(
  hbm_model,
  data = hints_analytic,
  estimator = "MLR",
  missing = "listwise"
)

cat("\n── Full Sample Model Results ──────────────────────\n")
summary(fit_full, fit.measures = TRUE, standardized = TRUE)

# ── Step 3: Extract Model Fit Indices ──────────────────────
fit_indices <- fitMeasures(fit_full, c("cfi", "rmsea", "srmr", "chisq", "df", "pvalue"))

cat("\n── Model Fit Indices ──────────────────────────────\n")
cat("CFI:  ", round(fit_indices["cfi"], 3), "\n")
cat("RMSEA:", round(fit_indices["rmsea"], 3), "\n")
cat("SRMR: ", round(fit_indices["srmr"], 3), "\n")

# ── Step 4: Extract Standardized Path Coefficients ─────────
std_params <- standardizedSolution(fit_full) %>%
  filter(op == "~") %>%
  select(
    Predictor = rhs,
    Outcome   = lhs,
    Beta      = est.std,
    SE        = se,
    Z         = z,
    p_value   = pvalue
  ) %>%
  mutate(
    Beta    = round(Beta, 3),
    SE      = round(SE, 3),
    Z       = round(Z, 3),
    p_value = round(p_value, 3),
    Significant = ifelse(p_value < 0.05, "Yes", "No")
  )

cat("\n── Standardized Path Coefficients ────────────────\n")
print(std_params)

# ── Step 5: R-squared ───────────────────────────────────────
r2 <- inspect(fit_full, "r2")
cat("\nR² (Physical Activity):", round(r2, 4), "\n")
cat("Variance explained:     ", round(r2 * 100, 2), "%\n")

# ── Step 6: Save Results ────────────────────────────────────
write.csv(std_params, "outputs/path_coefficients_full.csv", row.names = FALSE)
cat("\nFull sample results saved to outputs/path_coefficients_full.csv\n")
