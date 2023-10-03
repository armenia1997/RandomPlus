# `generateChiSquare(df)`

### Overview

The `generateChiSquare(df)` function generates a random number that follows a Chi-Square distribution with degrees of freedom `df`.

### Parameters

| Parameter  | Type   | Description                                                     |
|------------|--------|-----------------------------------------------------------------|
| `df`       | Number | Degrees of freedom for the Chi-Square distribution.              |

### Returns

| Return     | Type   | Description                                                    |
|------------|--------|----------------------------------------------------------------|
| `result`   | Number | A random number from a Chi-Square distribution.                 |

### Example

```lua
local result = StatBook.generateChiSquare(5)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a Chi-Square distribution with \( df \) degrees of freedom.

The probability density function (pdf) for the Chi-Square distribution is:

\[
f(x; df) = \frac{x^{(df/2 - 1)} e^{-x/2}}{2^{df/2} \Gamma(df/2)} \quad \text{for } x \geq 0, df > 0
\]

In this implementation, the Chi-Square distribution is generated using the gamma distribution:

\[
\text{result} = \text{GenerateGamma}(df / 2, 0.5)
\]







