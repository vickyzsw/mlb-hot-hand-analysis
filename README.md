# Does Michael Harris II Have a Hot Hand?

A statistical analysis of short-term batting-performance streakiness using MLB Statcast data.

## Project Overview

Sports fans often interpret consecutive successes and failures as evidence that a player is “hot” or “cold.” However, visible streaks can also occur naturally in random sequences.

This project investigates whether Michael Harris II’s batting performance during the 2022–2025 MLB seasons exhibited more short-term variation than would be expected under models with no temporal streakiness. It is a reproducible research system: analysis notebooks are paired with reusable statistical functions and automated tests.

The analysis first compares Harris’s observed rolling batting-average patterns with simulated random seasons. It then explores whether unusually strong or weak periods were associated with changes in pitcher behavior, Harris’s swing decisions, or his batted-ball patterns.

## Research Questions

1. Did Harris’s rolling batting average fluctuate more than random variation would predict?
2. Were any individual seasons unusually streaky relative to a season-specific null model?
3. Did pitchers change their velocity, pitch mix, or location following Harris’s Hot periods?
4. Did Harris change his swing decisions or batted-ball direction across Hot, Neutral, and Cold periods?

## Analytical Framework

1. Convert pitch-level Statcast records into chronologically ordered plate appearances and official at-bats.
2. Calculate a 25-at-bat rolling batting average separately within each season.
3. Construct a season-specific null model in which each official at-bat is an independent Bernoulli outcome with the observed season batting average.
4. Simulate 5,000 random seasons for each year.
5. Apply the same 25-at-bat rolling window to every simulated season.
6. Compare the observed rolling-BA variance with the Monte Carlo null distribution.
7. Define prior Hot, Neutral, and Cold performance states for exploratory mechanism analysis.
8. Compare pitcher behavior, swing decisions, terminal-pitch location, and batted-ball direction across performance states.
9. Stress-test conclusions with alternate window sizes, lag-1 correlation, longest-run statistics, within-season permutation, and a context-aware Bernoulli benchmark.

## Data

The project uses MLB Statcast pitch-level data for Michael Harris II from the 2022 through 2025 seasons.

The data include:

* Game and plate-appearance identifiers
* Pitch type and release velocity
* Pitch location and strike-zone measurements
* Pitch descriptions and plate-appearance outcomes
* Batted-ball coordinates

Pitch-level records were transformed into the appropriate unit of analysis depending on the research question:

* Official at-bat level for rolling batting average
* Plate-appearance level for outcome analysis
* Pitch level for pitcher and swing-decision analysis
* Batted-ball level for spray-direction analysis

## Methods

* Data cleaning and chronological ordering
* Research-variable construction
* 25-at-bat rolling batting averages
* Season-specific Bernoulli null models
* Monte Carlo simulation with 5,000 repetitions per season
* Monte Carlo p-values
* Logistic regression
* Pitcher-clustered standard errors
* Pearson chi-square tests
* Cramér’s V effect size
* Exploratory data visualization

## Key Findings

* **2022:** Observed streakiness was consistent with the random null model (`p = .634`).
* **2023:** Observed streakiness was also consistent with the null model (`p = .138`).
* **2024:** The season showed suggestive, but not conventionally significant, evidence of unusual variation (`p = .089`).
* **2025:** Rolling batting-average variance was substantially greater than the null model predicted (`p ≈ .0002`).

The mechanism analyses did not identify one definitive explanation for the unusual performance variation:

* Pitchers did not consistently throw harder during Hot periods.
* The estimated odds of receiving a four-seam fastball were approximately 17.5% lower during Hot periods than during Neutral periods, but the pitcher-clustered result was suggestive rather than conclusive.
* Harris’s swing decisions changed across seasons, but Hot-state differences were not directionally consistent.
* Batted-ball direction was not meaningfully associated with prior performance state (`χ²(4) = 2.15`, `p = .708`, Cramér’s `V = .027`).

Overall, the results provide evidence of unusually high streakiness in Harris’s 2025 season, but they do not establish a single causal hot-hand mechanism.

### Robustness interpretation

The 2025 rolling-variance result remains extreme under the Bernoulli (`p ≈ .0002`), permutation (`p ≈ .0014`), and context-aware (`p ≈ .0008`) benchmarks. That result does **not** imply unusually strong adjacent dependence: the 2025 lag-1 result is `r = .045`, `p ≈ .124`, and a six-hit longest run has `p ≈ .100`. The evidence therefore concerns broader local performance variation, not a causal hot-hand effect or a single extraordinary run.

## Repository Structure

```text
mlb-hot-hand-analysis/
├── analysis/
│   ├── main-analysis.Rmd
│   ├── mlb-analysis.Rmd
│   └── robustness-analysis.Rmd
├── R/
│   ├── prepare_analysis_data.R
│   └── streak_statistics.R
├── data/
│   ├── README.md
│   ├── savant_data.csv
│   └── raw/
├── docs/
│   └── index.html
├── presentation/
│   └── final-presentation.pdf
├── references/
│   ├── mlb-data-codebook.Rmd
│   └── mlb-data-codebook.html
├── tests/testthat/
├── .github/workflows/r-tests.yml
├── .gitignore
├── mlb-hot-hand-analysis.Rproj
└── README.md
```

## Project Files

* [R Markdown analysis](analysis/mlb-analysis.Rmd)
* [Primary analysis](analysis/main-analysis.Rmd)
* [Robustness analysis](analysis/robustness-analysis.Rmd)
* [View the full interactive HTML report](https://vickyzsw.github.io/mlb-hot-hand-analysis/)
* [Project presentation](presentation/final-presentation.pdf)
* [Data codebook](references/mlb-data-codebook.html)
**[View the published interactive report →](https://vickyzsw.github.io/mlb-hot-hand-analysis/)**

The report presents the rolling batting-average analysis, Monte Carlo simulation, year-by-year results, and exploratory analyses of pitcher and batter behavior.

- [View the R Markdown source](report/mlb-hot-hand-report.Rmd)
- [View the detailed research workflow](analysis/mlb-analysis.Rmd)

## Tools and Packages

* R and RStudio
* `dplyr` and `tidyr`
* `ggplot2`
* `zoo`
* `sandwich` and `lmtest`
* `effectsize`

## Limitations

The Bernoulli null model assumes that official at-bats are independent and that the underlying hit probability remains constant within each season. The overlapping rolling windows also create dependence among adjacent rolling averages.

The context-aware benchmark is conditional on a model fitted to the same observed seasons. It is a useful sensitivity check, but model estimation uncertainty is not fully propagated; its p-value should not be read as a confirmatory causal test. The analysis is a single-player study, and specification checks are reported as complementary estimands rather than interchangeable proofs.

The pitcher- and batter-mechanism analyses are exploratory. Differences across performance states should not be interpreted as causal effects because pitch selection, pitcher identity, game context, and other factors may also influence the observed patterns.

## Project Status

* [x] Data collection
* [x] Data cleaning and restructuring
* [x] Rolling-performance analysis
* [x] Monte Carlo simulation
* [x] Year-by-year statistical comparison
* [x] Pitcher-behavior analysis
* [x] Batter-behavior analysis
* [x] Batted-ball direction analysis
* [x] Final R Markdown report
* [ ] Additional contact-quality analysis
* [ ] Expanded analysis of additional players

## Author

**Shenwei Zhang (Vicky)**
M.A. Statistics and Data Science student, University of California, Berkeley
B.S. Statistics, The Ohio State University
