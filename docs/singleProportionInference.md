# `singleProportionInference(k, n, p, CL)`

## Description

The `singleProportionInference(k, n, p, CL)` function performs hypothesis testing for a single proportion. It chooses between using a Large Sample Proportion Test or an Exact Binomial Test based on the sample size and the probability.

## Parameters

| Parameter | Type   | Description                                      | Default |
|-----------|--------|--------------------------------------------------|---------|
| `k`       | number | The number of successes in the sample.           | Required|
| `n`       | number | The sample size.                                 | Required|
| `p`       | number | The hypothesized population proportion.          | Required|
| `CL`      | number | The Confidence Level for the test.               | 0.95    |

## Returns

| Variable   | Type   | Description                                                      |
|------------|--------|------------------------------------------------------------------|
| `pValue`   | number | The p-value of the test.                                          |
| `rejectH0` | boolean| Indicates whether to reject the null hypothesis.                  |
| `stat`     | number | The test statistic (Z for Large Sample, None for Exact).          |
| `df`       | number | Degrees of freedom (1 for Large Sample, None for Exact).          |
| `pTest`    | number | The hypothesized population proportion.                           |
| `pHat`     | number | The sample proportion.                                            |
| `lowerCI`  | number | Lower bound of the confidence interval.                           |
| `upperCI`  | number | Upper bound of the confidence interval.                           |
| `parametric`|boolean| Indicates if the test is parametric (true for Large Sample, false for Exact).|
| `testType` | string | Type of the test conducted ("Large Sample Proportion Test" or "Exact Binomial Test").|
| `statType` | string | Type of the statistic used ("Z" for Large Sample, None for Exact).|

## Examples

```lua
-- Example 1: Large sample size
local result = StatBook.singleProportionInference(40, 100, 0.35, 0.95)
-- Output will show Large Sample Proportion Test results

-- Example 2: Small sample size
local result = StatBook.singleProportionInference(4, 10, 0.35, 0.95)
-- Output will show Exact Binomial Test results
```

##Notes

- If (n * p) >= 5 and (n * (1 - p)) >= 5, a Large Sample Proportion Test is conducted.
- Otherwise, an Exact Binomial Test is conducted.

