# `generateT(df)`

### Overview

The `generateT(df)` function generates a random number that follows a Student's t-distribution with `df` degrees of freedom.

### Parameters

| Parameter  | Type   | Description                                          |
|------------|--------|------------------------------------------------------|
| `df`       | Number | The degrees of freedom for the t-distribution.       |

### Returns

| Return     | Type   | Description                                           |
|------------|--------|-------------------------------------------------------|
| `result`   | Number | A random number from a Student's t-distribution.      |

### Example

```lua
local result = StatBook.generateT(10)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a Student's t-distribution with \( df \) degrees of freedom.

The probability density function (pdf) for the Student's t-distribution is:

\[
f(t; df) = \frac{\Gamma(\frac{df+1}{2})}{\sqrt{df \pi} \Gamma(\frac{df}{2})} \left(1 + \frac{t^2}{df} \right)^{-\frac{df + 1}{2}}
\]

In this implementation, the Student's t-distribution is generated using the formula:

\[
\text{result} = \frac{x}{\sqrt{y / df}}
\]

Where \( x \) is a random number from a standard normal distribution and \( y \) is a random number from a chi-square distribution with \( df \) degrees of freedom.







