# `chiSquareIndependence(matrix, CL)`

### Overview

The `chiSquareIndependence` function performs Pearson's Chi-Squared Test for Independence. This test checks whether two categorical variables are independent of each other.

### Parameters

| Parameter           | Type    | Description                                                       | Default  |
|---------------------|---------|-------------------------------------------------------------------|----------|
| `matrix`            | Table   | The contingency table as a 2D array.                               | -        |
| `CL`                | Number  | Confidence level for the test.                                    | 0.95     |

### Returns

| Return      | Type    | Description                                                      |
|-------------|---------|------------------------------------------------------------------|
| `pValue`    | Number  | The p-value of the Chi-Squared Test.                             |
| `rejectH0`  | Boolean | Whether to reject the null hypothesis at the given alpha.        |
| `stat`      | Number  | The Chi-Squared statistic.                                       |
| `df`        | Number  | The degrees of freedom.                                          |
| `parametric`| Boolean | Whether the test is parametric (always true for this test).      |
| `testType`  | String  | Specifies the type of test, "Pearson's Test for Independence/Homogeneity".|
| `statType`  | String  | Specifies the type of statistic used, "Chi-Square".              |
| `warning`   | Boolean | Whether the sample size is too small for a reliable test.        |

### Example

```lua
local matrix = {{19, 24}, {43, 32}}
local CL = 0.95
local result = chiSquareIndependence(matrix, CL)
print(result.pValue, result.rejectH0, result.stat, result.df, result.warning)  -- Output will vary based on the input
```

### Mathematical Background

The Chi-Squared statistic \( \chi^2 \) is calculated as:

\[
\chi^2 = \sum \frac{(O_{ij} - E_{ij})^2}{E_{ij}}
\]

Where \( O_{ij} \) and \( E_{ij} \) are the observed and expected frequencies, respectively. \( i \) and \( j \) are the row and column indices of the contingency table.

The expected frequency \( E_{ij} \) is calculated as:

\[
E_{ij} = \frac{(R_i \times C_j)}{n}
\]

Where \( R_i \) and \( C_j \) are the total frequencies of the \( i^{th} \) row and \( j^{th} \) column, respectively, and \( n \) is the total sample size.

The degrees of freedom \( df \) are:

\[
df = (r - 1) \times (c - 1)
\]

Where \( r \) and \( c \) are the number of rows and columns in the contingency table, respectively.

A p-value is calculated based on the Chi-Squared statistic and degrees of freedom. A warning is issued if more than 20% of the expected frequencies are less than 5.



