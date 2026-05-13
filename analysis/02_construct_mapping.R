# ============================================================
# Script 2: HBM Construct Mapping and Standardization
# HINTS Dataset - HBM Physical Activity Path Analysis
# Author: Poojitha Garlapati
# ============================================================

library(dplyr)

# Load cleaned dataset
hints_clean <- read.csv("data/hints_clean.csv")

cat("Loaded cleaned dataset:", dim(hints_clean), "\n")

# ── Step 1: Compute HBM Construct Scores ───────────────────
# Each construct score = mean of constituent items

hints_constructs <- hints_clean %>%
  mutate(

    # 1. Perceived Susceptibility
    # Cancer awareness and personal risk perception
    Susceptibility = rowMeans(
      select(., ChanceCancer, SeriousnessRoutine),
      na.rm = TRUE
    ),

    # 2. Perceived Severity
    # Beliefs about seriousness of health consequences
    Severity = rowMeans(
      select(., CancerDeadly, CancerSerious),
      na.rm = TRUE
    ),

    # 3. Perceived Benefits
    # Trust in health system and perceived value of action
    Benefits = rowMeans(
      select(., DoctorTrust, HealthInfoTrust),
      na.rm = TRUE
    ),

    # 4. Perceived Barriers
    # Financial, transportation, and access barriers
    Barriers = rowMeans(
      select(., CostBarrier, TransportBarrier, AccessBarrier),
      na.rm = TRUE
    ),

    # 5. Self-Efficacy
    # Confidence in ability to manage and change health behavior
    SelfEfficacy = rowMeans(
      select(., ConfidenceManage, ConfidenceChange),
      na.rm = TRUE
    ),

    # 6. Cues to Action
    # Social influence and health information exposure
    CuesToAction = rowMeans(
      select(., FamilyInfluence, MediaInfluence),
      na.rm = TRUE
    ),

    # 7. Mental Health
    # Depression and anxiety status
    MentalHealth = rowMeans(
      select(., DepressionScore, AnxietyScore),
      na.rm = TRUE
    )
  )

cat("\nHBM constructs computed successfully.\n")

# ── Step 2: Z-Score Standardization ────────────────────────
# Standardize all constructs and outcome for path analysis

hints_standardized <- hints_constructs %>%
  mutate(
    Susceptibility_z  = scale(Susceptibility)[,1],
    Severity_z        = scale(Severity)[,1],
    Benefits_z        = scale(Benefits)[,1],
    Barriers_z        = scale(Barriers)[,1],
    SelfEfficacy_z    = scale(SelfEfficacy)[,1],
    CuesToAction_z    = scale(CuesToAction)[,1],
    MentalHealth_z    = scale(MentalHealth)[,1],
    PhysicalActivity_z = scale(ModerateExercise)[,1]
  )

cat("Variables standardized (z-scores).\n")

# ── Step 3: Descriptive Statistics ─────────────────────────
construct_vars <- c(
  "Susceptibility", "Severity", "Benefits",
  "Barriers", "SelfEfficacy", "CuesToAction",
  "MentalHealth", "ModerateExercise"
)

desc_stats <- hints_standardized %>%
  select(all_of(construct_vars)) %>%
  summarise(across(everything(), list(
    mean = ~round(mean(., na.rm = TRUE), 3),
    sd   = ~round(sd(., na.rm = TRUE), 3),
    min  = ~round(min(., na.rm = TRUE), 3),
    max  = ~round(max(., na.rm = TRUE), 3)
  )))

cat("\nDescriptive Statistics:\n")
print(t(desc_stats))

# ── Step 4: Save Analytic Dataset ──────────────────────────
write.csv(hints_standardized, "data/hints_analytic.csv", row.names = FALSE)
cat("\nAnalytic dataset saved to data/hints_analytic.csv\n")
cat("Final analytic N =", nrow(hints_standardized), "\n")
