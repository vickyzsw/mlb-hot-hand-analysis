# Does Michael Harris II Have a Hot Hand?

An ongoing statistical study of short-term batting-performance variation using MLB Statcast data from the 2022–2025 seasons.

## Research Overview

Apparent hot and cold streaks can arise even when batting outcomes are independent. This project asks whether Michael Harris II's observed short-term performance variation exceeded what would ordinarily occur under explicit no-streakiness benchmarks—and, when it did, whether pitcher behavior or Harris's own approach changed alongside it.

The project reconstructs official at-bats from pitch-level Statcast records, measures recent performance with rolling batting averages, compares observed variation with Monte Carlo null distributions, and evaluates the sensitivity of the findings to alternative window lengths, statistics, and null models.

> **Current conclusion:** Harris's 2025 season exhibited unusually large variation in 25-at-bat rolling batting average. This finding is robust across multiple rolling windows and null models. However, it does not establish that prior success caused later success or identify a single causal hot-hand mechanism.

## Start Here

| Resource | Purpose |
|---|---|
| **[Main analysis](https://vickyzsw.github.io/mlb-hot-hand-analysis/main-analysis.html)** | Concise presentation of the central research design and results |
| **[Robustness analysis](https://vickyzsw.github.io/mlb-hot-hand-analysis/robustness-analysis.html)** | Window sensitivity, alternative statistics, permutation inference, and context-aware simulations |
| **[Detailed research workflow](analysis/mlb-analysis.Rmd)** | Full code and exploratory analyses, including pitch-location density and mechanism analyses |
| **[Archived formal report](https://vickyzsw.github.io/mlb-hot-hand-analysis/)** | Earlier integrated report documenting the first complete stage of the project |
| **[Presentation](presentation/final-presentation.pdf)** | Project presentation from the initial study stage |

## Research Questions

1. Did Harris's rolling batting average fluctuate more than expected under a season-specific independent-outcome model?
2. Are the conclusions sensitive to the rolling-window length or the statistic used to define streakiness?
3. Do the results persist when the null benchmark preserves the observed hit total or allows baseline hit probability to vary with observed context?
4. Were Hot, Neutral, and Cold periods associated with changes in pitch velocity, pitch mix, pitch location, swing decisions, or batted-ball direction?

## Data and Unit of Analysis

The dataset contains MLB Statcast observations for Michael Harris II from 2022 through 2025. Because Statcast is recorded at the pitch level, the analysis reconstructs chronologically ordered plate appearances and official at-bats before calculating batting outcomes.

Different questions use different units of analysis:

| Question | Unit |
|---|---|
| Rolling performance and Monte Carlo inference | Official at-bat |
| Pitch velocity, pitch mix, and swing decisions | Pitch |
| Terminal-pitch location | Official at-bat |
| Spray direction and contact-related summaries | Ball in play |

The analysis uses more than 4,000 pitch-level records and 1,970 reconstructed official at-bats across the four seasons.

## Statistical Design

### Primary analysis

1. Reconstruct official at-bats and encode each as a hit or non-hit.
2. Calculate a 25-at-bat rolling batting average separately within each season.
3. Use the variance of the rolling series as the primary measure of season-level temporal variation.
4. Generate 5,000 simulated seasons under a season-specific i.i.d. Bernoulli null model.
5. Compare the observed variance with its Monte Carlo null distribution using a finite-simulation correction.

### Robustness analysis

The primary conclusion is evaluated using:

- rolling windows of 10, 15, 25, and 30 official at-bats;
- lag-1 autocorrelation and longest consecutive hit run as alternative statistics;
- a within-season permutation null that preserves the exact number of hits;
- a context-aware Bernoulli null with at-bat-specific predicted hit probabilities; and
- Holm adjustment across the four season-specific primary tests.

The alternative benchmarks are sensitivity analyses, not causal assignment mechanisms.

## Current Findings

### Primary rolling-variance results

| Season | Interpretation | Monte Carlo p-value |
|---|---|---:|
| 2022 | Consistent with the season-specific null | 0.634 |
| 2023 | Consistent with the season-specific null | 0.138 |
| 2024 | Suggestive, but not conventionally significant, variation | 0.089 |
| 2025 | Unusually large rolling-performance variation | 0.0002 |

The observed 2025 rolling-BA variance was approximately 2.03 times the mean variance under the primary null model.

### Robustness of the 2025 result

- The 2025 rolling-variance result remains in the extreme upper tail across 10-, 15-, 25-, and 30-at-bat windows.
- At the primary 25-at-bat window, the result persists under the season-specific Bernoulli null (`p ≈ 0.0002`), within-season permutation null (`p ≈ 0.0014`), and context-aware Bernoulli null (`p ≈ 0.0008`).
- The primary result also remains significant after Holm adjustment across the four season-level tests (`p_Holm ≈ 0.0008`).

Alternative statistics qualify the interpretation. In 2025, lag-1 autocorrelation (`r = 0.045`, `p ≈ 0.124`) and the longest-hit-run statistic (`p ≈ 0.100`) were not individually unusual. The evidence is therefore more consistent with broad, sustained movement between stronger and weaker periods than with unusually strong one-at-bat carryover or a single exceptional run of consecutive hits.

### Exploratory mechanism findings

- Pitchers did not consistently throw harder during Hot periods.
- The estimated odds of receiving a four-seam fastball were approximately 17.5% lower during Hot periods than during Neutral periods, but the pitcher-clustered result was suggestive rather than conclusive.
- Swing-decision differences varied across seasons and were not directionally consistent.
- Batted-ball direction was not meaningfully associated with prior performance state (`χ²(4) = 2.15`, `p = 0.708`, Cramér's `V = 0.027`).
- Pitch-location density and terminal-pitch location analyses are retained as exploratory mechanism evidence in the detailed workflow.

These comparisons describe associations with prior performance state; they should not be interpreted as causal effects.

## Repository Guide

```text
mlb-hot-hand-analysis/
├── analysis/
│   ├── main-analysis.Rmd          # concise primary analysis
│   ├── mlb-analysis.Rmd           # detailed workflow and mechanisms
│   └── robustness-analysis.Rmd    # sensitivity and alternative nulls
├── data/
│   ├── README.md
│   ├── prepare_analysis_data.R
│   └── savant_data.csv
├── docs/
│   ├── index.html                 # archived integrated report
│   ├── main-analysis.html
│   └── robustness-analysis.html
├── output/
│   ├── figures/
│   └── mlb-analysis_files/
├── presentation/
│   └── final-presentation.pdf
├── references/
│   ├── mlb-data-codebook.Rmd
│   └── mlb-data-codebook.html
├── report/
│   ├── mlb-hot-hand-report.Rmd
│   └── mlb-hot-hand-report.html
└── README.md
```

## Reproducibility

The analysis is written in R and uses packages including `dplyr`, `tidyr`, `readr`, `ggplot2`, and `zoo`, with additional packages used for clustered inference and effect-size estimation.

The reusable data-preparation script is [`data/prepare_analysis_data.R`](data/prepare_analysis_data.R). It reconstructs the official-at-bat dataset used by the robustness analysis from the repository's Statcast data.

To reproduce an analysis, open the project file in RStudio and render the relevant `.Rmd` file from within its directory. The simulation code uses fixed random seeds where specified.

## Interpretation and Limitations

The results establish that the observed 2025 rolling-performance variation is difficult to explain under the evaluated null benchmarks. They do not establish a causal hot-hand effect.

Important limitations include:

- rolling windows overlap and therefore produce mechanically dependent neighboring summaries;
- the primary Bernoulli model assumes constant hit probability within a season;
- the context-aware model includes only selected observed pre-outcome variables;
- injuries, opponent quality, ballparks, fatigue, lineup position, and other time-varying factors may remain unmeasured;
- Hot, Neutral, and Cold states are constructed summaries rather than randomized treatments; and
- mechanism analyses are exploratory and may have limited sample sizes within states.

## Research Status and Next Steps

Completed:

- [x] Pitch-level data cleaning and official-at-bat reconstruction
- [x] Rolling-performance and season-specific Monte Carlo analysis
- [x] Window-length sensitivity analysis
- [x] Alternative-statistic checks
- [x] Permutation and context-aware null-model checks
- [x] Multiple-testing adjustment for the primary season-level comparisons
- [x] Pitcher, swing-decision, pitch-location, and batted-ball mechanism analyses

Planned extensions:

- [ ] Expand contact-quality analysis using exit velocity, launch angle, hard-hit rate, and expected batting average
- [ ] Refine sequential prediction and calibration evaluation
- [ ] Evaluate generalizability across additional players
- [ ] Develop a hierarchical or state-space model for time-varying batting ability
- [ ] Separate predictive, associational, and causal claims more explicitly in future work

## Author

**Shenwei Zhang (Vicky)**

M.A. Statistics and Data Science, University of California, Berkeley

B.S. Statistics, The Ohio State University
