# `goodnessOfFit(observed, expectedProportions, CL)`

### Overview

The `goodnessOfFit` function performs a Pearson's Chi-Squared Goodness of Fit Test. This test is used to determine if the observed frequency distribution of a variable matches the expected frequency distribution.

### Parameters

| Parameter           | Type   | Description                                                                 | Default  |
|---------------------|--------|-----------------------------------------------------------------------------|----------|
| `observed`          | Table  | Array of observed frequencies for each category.                             | -        |
| `expectedProportions`| Table | Array of expected proportions for each category.                             | -        |
| `CL`                | Number | Confidence level for the test.                                              | 0.95     |

### Returns

| Return      | Type      | Description                                                 |
|-------------|-----------|-------------------------------------------------------------|
| `pValue`    | Number    | The p-value of the Chi-Squared Test.                         |
| `rejectH0`  | Boolean   | Whether to reject the null hypothesis at the given alpha.    |
| `stat`      | Number    | The Chi-Squared statistic.                                  |
| `df`        | Number    | The degrees of freedom.                                     |
| `parametric`| Boolean   | Whether the test is parametric (always true for this test).  |
| `testType`  | String    | Specifies the type of test, "Pearson's Goodness of Fit Test".|
| `statType`  | String    | Specifies the type of statistic used, "Chi-Square".          |
| `warning`   | Boolean   | Whether the sample size is too small for a reliable test.    |

### Example

```lua
local observed = {50, 40, 30, 25}
local expectedProportions = {0.3, 0.3, 0.2, 0.2}
local CL = 0.95
local result = goodnessOfFit(observed, expectedProportions, CL)
print(result.pValue, result.rejectH0, result.stat, result.df, result.warning)  -- Output will vary based on the input
```

### Mathematical Background

The Chi-Squared statistic \( \chi^2 \) is calculated using:

\[
\chi^2 = \sum \frac{(O_i - E_i)^2}{E_i}
\]

Where \( O_i \) and \( E_i \) are the observed and expected frequencies for each category, respectively. 

The expected frequency \( E_i \) for each category is given by:

\[
E_i = n \times \text{expectedProportions}_i
\]

The degrees of freedom \( df \) is:

\[
df = \text{Number of categories} - 1
\]

A p-value is calculated based on the Chi-Squared statistic and degrees of freedom. A warning is issued if more than 20% of the expected frequencies are less than 5.


