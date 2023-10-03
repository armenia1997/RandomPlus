# `oneSampleProportionCI(k, n, CL)`

### Overview

The `oneSampleProportionCI` function calculates a confidence interval for a proportion in a statistical population, based on the proportion observed in a sample. The function employs the Wald-Agresti-Coull (WAC) method, a modified version of the standard Wald method to calculate the confidence interval.

### Parameters

| Parameter | Type   | Description                                                         | Default  |
|-----------|--------|---------------------------------------------------------------------|----------|
| `k`       | Number | Number of successful outcomes in the sample.                        | -        |
| `n`       | Number | Total number of trials in the sample.                               | -        |
| `CL`      | Number | Confidence level for the confidence interval.                        | 0.95     |

### Returns

| Return      | Type  | Description                                                      |
|-------------|-------|------------------------------------------------------------------|
| `pHat`      | Number| The estimated proportion based on the sample.                     |
| `lowerCI`   | Number| Lower bound of the confidence interval for the proportion.        |
| `upperCI`   | Number| Upper bound of the confidence interval for the proportion.        |
| `testType`  | String| Specifies the type of test conducted, in this case, "One Sample Proportion CI".|

### Example

```lua
local k = 55
local n = 100
local CL = 0.95
local result = oneSampleProportionCI(k, n, CL)
print(result.pHat, result.lowerCI, result.upperCI, result.testType)  -- Output will vary based on the input
```

### Mathematical Background

The estimated proportion \( \hat{p} \) is calculated as:

\[
\hat{p} = \frac{k + 2}{n + 4}
\]

The standard error \( SE \) of the estimated proportion is calculated using:

\[
SE = \sqrt{\frac{\hat{p}(1-\hat{p})}{n + 4}}
\]

The confidence interval is given by:

\[\text{Lower CI} = \hat{p} - Z_{\alpha/2} \times SE\]

\[\text{Upper CI} = \hat{p} + Z_{\alpha/2} \times SE\]

where \( Z_{\alpha/2} \) is the value from the inverse of the standard normal distribution corresponding to a 1- \( \alpha/2 \) confidence level.

