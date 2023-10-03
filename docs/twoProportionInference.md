# `twoProportionInference(k1, n1, k2, n2, CL)`

### Overview

The `twoProportionInference` function performs statistical inference on two independent proportions. It calculates the confidence interval and p-value for the difference between two proportions \( p_1 \) and \( p_2 \).

### Parameters

| Parameter | Type   | Description                                                      | Default  |
|-----------|--------|------------------------------------------------------------------|----------|
| `k1`      | Number | Number of successful outcomes in the first sample.                | -        |
| `n1`      | Number | Total number of trials in the first sample.                       | -        |
| `k2`      | Number | Number of successful outcomes in the second sample.               | -        |
| `n2`      | Number | Total number of trials in the second sample.                      | -        |
| `CL`      | Number | Confidence level for the confidence interval.                     | 0.95     |

### Returns

| Return      | Type      | Description                                                 |
|-------------|-----------|-------------------------------------------------------------|
| `pValue`    | Number    | The p-value of the Z-test.                                  |
| `rejectH0`  | Boolean   | Whether to reject the null hypothesis at the given alpha.    |
| `stat`      | Number    | The Z-score of the test.                                    |
| `pHat`      | Table -> Number    | Estimated proportions for both samples and overall.          |
| `lowerCI`   | Number    | Lower bound of the confidence interval for \( p_1 - p_2 \). |
| `upperCI`   | Number    | Upper bound of the confidence interval for \( p_1 - p_2 \).  |
| `parametric`| Boolean   | Whether the test is parametric (always true for Z-test).     |
| `testType`  | String    | Specifies the type of test, "Two Proportion Test".           |
| `statType`  | String    | Specifies the type of statistic used, "Z".                   |
| `warning`   | Boolean   | Whether the sample size is too small for a reliable test.    |

### Example

```lua
local k1 = 50
local n1 = 100
local k2 = 40
local n2 = 90
local CL = 0.95
local result = twoProportionInference(k1, n1, k2, n2, CL)
print(result.pValue, result.rejectH0, result.stat, result.lowerCI, result.upperCI)  -- Output will vary based on the input
```

### Mathematical Background

The pooled proportion \( \hat{p} \) is calculated as:

\[
\hat{p} = \frac{k_1 + k_2}{n_1 + n_2}
\]

The standard error \( SE \) is calculated using:

\[
SE = \sqrt{\hat{p}(1 - \hat{p})\left(\frac{1}{n_1} + \frac{1}{n_2}\right)}
\]

The confidence interval is given by:

\[
\text{Lower CI} = \text{max}\left(\hat{p}_1 - \hat{p}_2 - Z_{\alpha/2} \times \sqrt{\frac{\hat{p}_1(1-\hat{p}_1)}{n_1} + \frac{\hat{p}_2(1-\hat{p}_2)}{n_2}}, -1\right)
\]

\[
\text{Upper CI} = \text{min}\left(\hat{p}_1 - \hat{p}_2 + Z_{\alpha/2} \times \sqrt{\frac{\hat{p}_1(1-\hat{p}_1)}{n_1} + \frac{\hat{p}_2(1-\hat{p}_2)}{n_2}}, 1\right)
\]

The Z-score \( Z \) and p-value are also calculated based on the above statistics.

