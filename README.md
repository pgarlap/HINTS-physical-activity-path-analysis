# Health Belief Model Determinants of Physical Activity
## A Path Analysis Using the HINTS Dataset

Standardized path analysis examining how Health Belief Model (HBM) 
constructs predict weekly moderate-intensity physical activity using 
the Health Information National Trends Survey (HINTS, N = 6,590).

**Conducted under the mentorship of Dr. Navin Kaushal, PhD**  
Population Health Research Laboratory  
Indiana University Indianapolis, School of Health and Human Sciences

---

## Background

Physical inactivity is a leading risk factor for chronic disease in 
the United States. The Health Belief Model (HBM) provides a framework 
for understanding how psychological beliefs influence preventive health 
behaviors such as exercise.

This study applied the HBM to the HINTS dataset to identify which 
belief constructs most strongly predict physical activity - with 
findings contributing to evidence-based intervention design for 
at-risk populations.

---

## Research Question

Which Health Belief Model constructs most strongly predict weekly 
moderate-intensity physical activity, and do these effects differ 
between cancer survivors and non-cancer populations?

---

## HBM Constructs Analyzed

| Construct | Description |
|---|---|
| Perceived Susceptibility | Cancer awareness and risk perception |
| Perceived Severity | Beliefs about health consequences |
| Perceived Benefits | Trust in health system |
| Perceived Barriers | Financial, transportation, access barriers |
| Self-Efficacy | Confidence in managing health |
| Cues to Action | Social influence and health information exposure |
| Mental Health | Depression and mental health status |

**Outcome:** Weekly minutes of moderate-intensity exercise (M = 182, SD = 325)

---

## Methodology

- Cleaned and recoded 61 HINTS survey variables
- Mapped variables to 7 HBM constructs
- Created comprehensive variable codebook
- Computed HBM construct scores as item means
- Z-score standardized all variables
- Conducted standardized path analysis in R using lavaan
- Estimated full sample and cancer-stratified models
- Evaluated model fit using CFI, RMSEA, and SRMR

---

## Key Findings

### Full Sample (N = 6,590 | R² = 0.021)

| HBM Construct | β | p-value | Direction |
|---|---|---|---|
| Perceived Severity | -0.127 | <.001 | Negative |
| Perceived Barriers | +0.050 | <.001 | Positive |
| Self-Efficacy | +0.039 | <.01 | Positive |
| Perceived Susceptibility | +0.023 | .063 | Not significant |
| Perceived Benefits | — | ns | Not significant |
| Cues to Action | — | ns | Not significant |
| Mental Health | — | ns | Not significant |

### Cancer History Stratification

| Group | N | R² | Perceived Severity β |
|---|---|---|---|
| Full Sample | 6,590 | 2.1% | -0.127 |
| No Cancer History | 5,541 | 2.0% | -0.123 |
| Cancer History | 1,049 | 3.9% | -0.144 |

**Key insight:** Cancer survivors showed stronger effects of Perceived 
Severity and Self-Efficacy on physical activity - suggesting health 
beliefs operate differently in this subgroup and interventions should 
be tailored accordingly.

---

## Clinical Interpretation

**Perceived Severity** was the strongest predictor across all models. 
Individuals perceiving greater health threat engaged in *less* exercise 
— likely reflecting actual health limitations rather than beliefs alone.

**Self-Efficacy** showed consistent positive association - confidence 
in managing one's health promotes physical activity, consistent with 
HBM theory.

**Cancer survivors** showed stronger Perceived Severity effects 
(β = −0.144 vs −0.123) - health concerns and personal efficacy play 
more prominent roles in this group.

My PharmD background informed interpretation of these findings - 
particularly the clinical nuance between perceived health threat and 
actual physical limitations in older and cancer-affected populations.

---

## Tools

- **R / RStudio** - primary analysis environment
- **lavaan** - structural equation modeling and path analysis
- **ggplot2** - data visualization
- **Microsoft Excel** - data preparation and codebook
- **Dataset:** HINTS (Health Information National Trends Survey)
- **Source:** hints.cancer.gov

---

## Repository Structure

hints-physical-activity-path-analysis/
├── analysis/
│   ├── 01_data_cleaning.R
│   ├── 02_construct_mapping.R
│   ├── 03_path_analysis_full.R
│   └── 04_path_analysis_stratified.R
├── visualization/
│   └── 05_visualizations.R
├── outputs/
│   └── path_coefficients_summary.csv
└── README.md

---

## Poster Presentation

This project was presented as a practicum poster at Indiana University 
Indianapolis, Luddy School of Informatics, Computing, and Engineering 
(May 2026).

---

## Author

**Poojitha Garlapati**  
PharmD + M.S. Health Informatics  
Indiana University Indianapolis

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://linkedin.com/in/garlapati-poojitha)
[![Email](https://img.shields.io/badge/Email-D14836?style=flat-square&logo=gmail&logoColor=white)](mailto:poojithagarlapati55@gmail.com)
