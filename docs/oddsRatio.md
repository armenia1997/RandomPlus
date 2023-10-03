# `oddsRatio(O11, O12, O21, O22, CL)`

### Overview

The `oddsRatio` function calculates the odds ratio for a 2x2 contingency table, along with the confidence intervals and hypothesis testing for independence. It can be particularly useful in epidemiological studies and statistical analysis of categorical data.

### Parameters

| Parameter | Type   | Description                                                | Default  |
|-----------|--------|------------------------------------------------------------|----------|
| `O11`     | Number | Count for group 1 with characteristic A.                    | -        |
| `O12`     | Number | Count for group 1 without characteristic A.                 | -        |
| `O21`     | Number | Count for group 2 with characteristic A.                    | -        |
| `O22`     | Number | Count for group 2 without characteristic A.                 | -        |
| `CL`      | Number | Confidence level for the confidence interval of the odds ratio.| 0.95    |

### Returns

| Return       | Type  | Description                                              |
|--------------|-------|----------------------------------------------------------|
| `OR`         | Number| The calculated odds ratio.                               |
| `rejectH0`   | Bool  | Whether to reject the null hypothesis of independence.   |
| `lowerCI`    | Number| Lower bound of the confidence interval for the odds ratio.|
| `upperCI`    | Number| Upper bound of the confidence interval for the odds ratio.|

### Example

```lua
local O11 = 13
local O12 = 9
local O21 = 8
local O22 = 6
local CL = 0.95
local result = oddsRatio(O11, O12, O21, O22, CL)
print(result.OR, result.rejectH0, result.lowerCI, result.upperCI)  -- Output will vary based on the input
```

### Mathematical Background

The odds ratio \( OR \) is calculated as:

\[
OR = \frac{(O11 / O12)}{(O21 / O22)}
\]

The confidence interval for the odds ratio is calculated using:

\[\text{Lower bound} = e^{\ln(OR) - Z \times \sigma}\]

\[\text{Upper bound} = e^{\ln(OR) + Z \times \sigma}\]

where \( \sigma = \sqrt{\frac{1}{O11} + \frac{1}{O12} + \frac{1}{O21} + \frac{1}{O22}} \) and \( Z \) is the value from the inverse of the standard normal distribution corresponding to a 1- \( \alpha/2 \) confidence level.

The null hypothesis \( H0 \) is rejected if the confidence interval does not include 1.
