# `inference(list, independent, CL, mu0)`

### Overview

Performs statistical inference tests based on the given data. The function will decide which test to use based on the number of samples, whether they are independent or not, and their distribution.

> **NOTE 1: ALL TESTS IN THIS MODULE ARE TWO-TAILED** (besides F and Chi-Square tests). A future update with one-tailed options may come in a future update.

> **NOTE 2**: There aren't any two or more sample tests able to do a hypothesis test for a certain amount of difference between the means/medians of the samples. By default, all two or more sample tests check for a difference in distribution, that is, \( H_0: D_\mu\) or \( D_\eta = 0 \) 

> **NOTE 3:** If `dependent = true` then all samples must have the same amount of entries. This is a result of the logic of a dependent test, which states that samples must have the same subjects treated at different points. StatBook v1.1 will likely have an algorithm that will weed out entries with nil or missing values.

> **NOTE 4:** It is highly recommended to return the warning value, as a `warning = true` value means the results may have a significant degree of inaccuracy due to computational limits.

### Parameters

| Parameter      | Type      | Description                                                                                                 |
|----------------|-----------|-------------------------------------------------------------------------------------------------------------|
| `list`         | Table     | A table of lists containing the data to be tested.                                                           |
| `independent`  | Boolean, Nil   | Whether the samples are independent or not (Nil for 1-sample).                                                                  |
| `CL`           | Number, (Nil = 0.95)    | Confidence level for the statistical tests (Nil = 0.95).                                                                  |
| `mu0`          | Number, (Nil = 0)    | The hypothetical mean tested against in 1-sample test. Defaults to 0 if Nil.                                     |

### Returns

A table possibly containing the following:

| Key             | Type       | Description                                                                                                  |
|-----------------|------------|--------------------------------------------------------------------------------------------------------------|
| `pValue`        | Number     | The p-value of the test.                                                                                     |
| `rejectH0`      | Boolean    | Whether to reject the null hypothesis.                                                                        |
| `stat`          | Number     | The value of the test statistic.                                                                     |
| `df`            | Number, Table, Nil  | Degrees of freedom (some tests have two (F), some not applicable).                                              |
| `center`        | Table -> Number(s)     | Contains the mean(s) or median(s) of the dataset(s).                                                                           |
| `centerComp`    | Number, Nil        | Comparison value for the center (not applicable for some tests).                                     |
| `lowerCI`       | Number, Nil   | The lower bound of the confidence interval for mean/median (NA for 3+ sample tests).                                                   |
| `upperCI`       | Number, Nil     | The upper bound of the confidence interval for the mean/median (NA for 3+ sample tests)                                                  |
| `dependent`     | Boolean, Nil        | Whether the test is for dependent samples (Nil for one-sample tests).                           |
| `parametric`    | Boolean    | Indicates if the test is parametric.                                              |
| `nSamples`      | Number     | Number of samples in the test.                                       |
| `testType`      | String     | Specifies the type of the test.                              |
| `statType`      | String     | Specifies the type of the test statistic.                                       |
| `centerType`    | String     | Specifies what measure of central tendency is being tested.                |
| `postHoc`       | Table -> Tables, Nil        | Post-hoc tests with individual test data within each nested table (only for 3+ sample tests).                                                     |
| `postHocSig`    | Table -> Tables, Nil        | Only contains Post-hoc tests with significant p-values (only for 3+ sample tests)                                      |
| `warning`       | Nil , True        | Warnings if applicable (Nil if false or NA).     

### `postHoc` and `postHocSig` subfields (only for 3+ sample tests)

A table possibly containing the following:

| Key             | Type       | Description                                                                                                  |
|-----------------|------------|--------------------------------------------------------------------------------------------------------------|
| `group1`        | Number     | The index of the first sample selected in the Post Hoc.                                                                                     |
| `group2`        | Number     | The index of the second sample selected in the Post Hoc.                                                                                     |
| `pValue`        | Number     | The p-value of the Post Hoc test.                                                                                     |
| `alpha`        | Number     | The alpha needed for significance entailed by the Bonferonni correction.                                                                                     |
| `rejectH0`      | Boolean    | Whether to reject the null hypothesis.                                                                        |
| `stat`          | Number     | The value of the test statistic.                                                                     |
| `df`            | Number, Nil  | Degrees of freedom (some not applicable).                                              |
| `center`        | Table -> Numbers     | Contains the means or medians of the datasets.                                                                           |
| `centerComp`    | Number       | Comparison value for the center.                                     |
| `lowerCI`       | Number   | The lower bound of the confidence interval for mean/median.                                                   |
| `upperCI`       | Number   | The upper bound of the confidence interval for the mean/median                                                 |
| `testType`      | String     | Specifies the type of the test.                              |
| `statType`      | String     | Specifies the type of the test statistic.                                       |
| `centerType`    | String     | Specifies what measure of central tendency is being tested.                |
| `warning`       | Nil , True        | Warnings if applicable (Nil if false or NA).     

### Examples

One-Sample Test:

```lua
local data = {
    {12, 15, 14, 10, 13, 8, 13, 16, 8, 15, 22, 4, 7, 8}
}
-- in this case, either one-sample t-test or sign test (depends on normality of sample)
local CL = 0.95
local mu0 = 12
-- if we did not specify mu0, it would default to 0,
local result = StatBook.inference(data, nil, CL, mu0)
print(result.pValue, result.stat)
```

Two-Sample Test:

```lua
local data = {
    {12, 15, 14, 10, 13, 6, 18},
    {20, 24, 30, 27, 28, 19, 19}
}
local independent = false
-- in this case, either two-sample dep. t-test or signed-rank test (depends on normality of samples + Folded-F test)
local CL = 0.95
local result = StatBook.inference(data, independent, CL)
print(result.pValue, result.centerComp, result.lowerCI, result.upperCI)
```

Three-Plus Sample Test:

```lua
local data = {
    {12, 15, 14, 10, 13, 14},
    {20, 24, 30, 27, 28, 20},
    {16, 25, 19, 20, 22, 18},
    {23, 14, 10, 37, 8, 19}
}
local independent = true
-- in this case, either ANOVA test or Kruskal Wallis test (depends on normality of samples + Levene Test)
local CL = 0.95
local result = StatBook.inference(data, independent, CL)
print(result.pValue, result.postHocSig.group1, result.postHocSig.group2, result.postHocSig.pValue)
```

###Algorithmic Background

One Sample Test: If the data has only one list, the function performs either a t-test or a sign test based on the Shapiro-Wilk test result for normality.

Two Sample Test (Dependent): If there are two dependent lists, it performs either a paired t-test or a Wilcoxon signed-rank test based on the Shapiro-Wilk test result.

Two Sample Test (Independent): If there are two independent lists, it performs either a two-sample t-test or a Wilcoxon rank-sum test.

Three or More Samples (Dependent): For three or more dependent lists, a Friedman test is performed.

Three or More Samples (Independent): For three or more independent lists, the function performs either an ANOVA or a Kruskal-Wallis test based on Shapiro-Wilk and Levene tests.

Internal functions oneSample, twoSampleDep, twoSampleInd, and threePlusSampleInd decide which specific test to use.

## Understanding Independent and Dependent Samples
### Independent Samples
- **Definition**: Samples are considered independent when the sample sets are not related in any way. 
- **Example**: Suppose we have two different classes of students, and we measure their heights. The heights of students in the first class do not influence the heights of students in the second class.
- **Statistical Tests**: Typical tests for independent samples include the Two-Sample t-Test and ANOVA.

### Dependent Samples
- **Definition**: Samples are considered dependent (or paired) when the sample sets are related or matched in some way.
- **Example**: Before-and-after measurements on the same subjects (e.g., the heights of students at the beginning and end of a school year).
- **Statistical Tests**: Typical tests for dependent samples include the Paired t-Test and the Wilcoxon Signed-Rank Test.

---

## Understanding Parametric and Nonparametric Tests
### Parametric Tests
- **Definition**: Parametric tests make certain assumptions about the parameters of the population distribution from which the samples are drawn.
- **Assumptions**: These tests usually assume that the data is normally distributed. They may also assume homogeneity of variances among groups.
- **Examples**: t-Tests, ANOVA, and Pearson correlation are examples of parametric tests.
- **Advantages**: Generally more powerful and yield more information about specific parameters than nonparametric tests.

### Nonparametric Tests
- **Definition**: Nonparametric tests do not make strong assumptions about the distribution of the variables.
- **Assumptions**: These tests do not assume that the data is normally distributed and are often used when the data is ordinal or nominal.
- **Examples**: Wilcoxon Signed-Rank Test, Wilcoxon Rank-Sum Test, and Kruskal-Wallis Test are examples of nonparametric tests.
- **Advantages**: Useful for analyzing non-normal distributions and ordinal or nominal data.


# Statistical Tests: Mathematical Background

## 1. One Sample Test
### t-Test
- **Hypothesis**: Tests whether the mean of a sample is equal to a specified value.
- **Formula**: \( t = \frac{\bar{x} - \mu_0}{s / \sqrt{n}} \)
- **Assumptions**: Assumes that the data is normally distributed. The Shapiro-Wilk test is used to verify this.

### Sign Test
- **Hypothesis**: Tests whether the median of the sample is equal to a specified value.
- **Formula**: The test uses the count of signs of the differences between each observation and the median.
- **Assumptions**: Does not assume normality.

---

## 2. Two Sample Test (Dependent)
### Paired t-Test
- **Hypothesis**: Tests whether the means of two paired samples are equal.
- **Formula**: \( t = \frac{\bar{d}}{s_d / \sqrt{n}} \)
- **Assumptions**: Assumes that the differences between pairs are normally distributed.

### Wilcoxon Signed-Rank Test
- **Hypothesis**: Tests whether the medians of two paired samples are equal.
- **Formula**: Uses ranks of the absolute differences between pairs.
- **Assumptions**: Does not assume normality.

---

## 3. Two Sample Test (Independent)
### Two-Sample t-Test
- **Hypothesis**: Tests whether the means of two independent samples are equal.
- **Formula**: \( t = \frac{\bar{x}_1 - \bar{x}_2}{\sqrt{s^2/n_1 + s^2/n_2}} \)
- **Assumptions**: Assumes both samples are normally distributed and have equal variances.

### Wilcoxon Rank-Sum Test
- **Hypothesis**: Tests whether the medians of two independent samples are equal.
- **Formula**: Uses ranks of all observations.
- **Assumptions**: Does not assume normality.

---

## 4. Three or More Samples (Dependent)
### Friedman Test
- **Hypothesis**: Tests whether more than two related samples have the same population mean ranks.
- **Formula**: Based on ranks of each set of samples.
- **Assumptions**: Assumes that the observations are related.

---

## 5. Three or More Samples (Independent)
### ANOVA
- **Hypothesis**: Tests whether three or more independent samples have the same mean.
- **Formula**: \( F = \frac{\text{Between-group variance}}{\text{Within-group variance}} \)
- **Assumptions**: Assumes each group is normally distributed and variances are equal. Shapiro-Wilk and Levene tests are used to verify this.

### Kruskal-Wallis Test
- **Hypothesis**: Tests whether three or more independent samples have the same median.
- **Formula**: Uses ranks of all observations.
- **Assumptions**: Does not assume normality or equal variances.

## Steps in Hypothesis Testing

1. **State the Null Hypothesis**
2. **State the Alternative Hypothesis**
3. **Determine the Level of Significance**
4. **Collect and Analyze Sample Data**
5. **Make a Decision**

---

## Null Hypothesis

The Null Hypothesis, denoted by \( H_0 \), is a statement of no effect or difference and serves as the basis for statistical testing. 

**Example**: \( H_0: \mu = 25 \)

---

## Alternative Hypothesis

The Alternative Hypothesis, denoted by \( H_a \), is what you aim to prove. It is a statement that contradicts the null hypothesis.

**Example**: \( H_a: \mu \neq 25 \)

---

## Types of Tests

- **One-tailed test**: Looks for an effect in only one direction.
  - Right-tailed
  - Left-tailed
  
- **Two-tailed test**: Looks for an effect in either direction.

---

## Test Statistics

Depending on the sample size and known parameters, different test statistics like Z, T are used.

- **Z-test**: Known variance, large sample size
- **T-test**: Unknown variance, small sample size

---

## P-value

The p-value is the probability of obtaining the observed results, or something more extreme, given that the null hypothesis is true.

- **Low p-value (\( < \alpha \))**: Reject the null hypothesis
- **High p-value (\( > \alpha \))**: Fail to reject the null hypothesis

---

## Decision Making

- **If \( p-value < \alpha \)**: Reject the null hypothesis
- **If \( p-value > \alpha \)**: Fail to reject the null hypothesis

---






