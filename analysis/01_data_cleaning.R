# ============================================================
# Script 1: Data Cleaning and Preparation
# HINTS Dataset - HBM Physical Activity Path Analysis
# Author: Poojitha Garlapati
# ============================================================

library(dplyr)
library(tidyr)

# Load HINTS dataset
# Download from: https://hints.cancer.gov/data-literature/hints-data.aspx
hints_raw <- read.csv("data/hints_raw.csv", stringsAsFactors = FALSE)

cat("Raw dataset dimensions:", dim(hints_raw), "\n")
cat("Total variables:", ncol(hints_raw), "\n")
cat("Total respondents:", nrow(hints_raw), "\n")

# ── Step 1: Select relevant variables ──────────────────────
# 61 variables mapped to 7 HBM constructs + outcome

selected_vars <- hints_raw %>%
  select(
    # Outcome
    ModerateExercise,

    # Perceived Susceptibility
    ChanceCancer, SeriousnessRoutine,

    # Perceived Severity
    CancerDeadly, CancerSerious,

    # Perceived Benefits
    DoctorTrust, HealthInfoTrust,

    # Perceived Barriers
    CostBarrier, TransportBarrier, AccessBarrier,

    # Self-Efficacy
    ConfidenceManage, ConfidenceChange,

    # Cues to Action
    FamilyInfluence, MediaInfluence,

    # Mental Health
    DepressionScore, AnxietyScore,

    # Demographics
    Age, Gender, RaceEthnicity,
    EducationLevel, IncomeLevel,

    # Cancer History
    CancerHistory
  )

cat("\nSelected variables:", ncol(selected_vars), "\n")

# ── Step 2: Handle missing values ──────────────────────────
# Recode negative values (-9, -5, -1) as NA (HINTS convention)

hints_clean <- selected_vars %>%
  mutate(across(everything(), ~ifelse(. < 0, NA, .)))

cat("Missing values before removal:\n")
print(colSums(is.na(hints_clean)))

# Remove rows with missing outcome variable
hints_clean <- hints_clean %>%
  filter(!is.na(ModerateExercise))

cat("\nRows after removing missing outcome:", nrow(hints_clean), "\n")

# ── Step 3: Recode variables ────────────────────────────────
hints_clean <- hints_clean %>%
  mutate(
    # Cancer history: binary (1 = personal or family, 0 = none)
    CancerHistory_Binary = ifelse(CancerHistory %in% c(1, 2), 1, 0),

    # Gender: binary
    Gender_Binary = ifelse(Gender == 1, 1, 0),

    # Education: ordinal retained as numeric
    Education = as.numeric(EducationLevel),

    # Income: ordinal retained as numeric
    Income = as.numeric(IncomeLevel)
  )

# ── Step 4: Final dataset ───────────────────────────────────
hints_final <- hints_clean %>%
  filter(complete.cases(.))

cat("\nFinal dataset dimensions:", dim(hints_final), "\n")
cat("Final N =", nrow(hints_final), "\n")

# Save cleaned dataset
write.csv(hints_final, "data/hints_clean.csv", row.names = FALSE)
cat("\nCleaned dataset saved to data/hints_clean.csv\n")
