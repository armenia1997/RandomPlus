# `generateWeibull(alpha, beta)`

### Overview

The `generateWeibull(alpha, beta)` function generates a random number that follows a Weibull distribution.

### Parameters

| Parameter  | Type   | Description                                           |
|------------|--------|-------------------------------------------------------|
| `alpha`    | Number | The scale parameter of the Weibull distribution.      |
| `beta`     | Number | The shape parameter of the Weibull distribution.      |

### Returns

| Return     | Type   | Description                                              |
|------------|--------|----------------------------------------------------------|
| `result`   | Number | A random number from a Weibull distribution.             |

### Example

```lua
local result = StatBook.generateWeibull(1, 2)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a Weibull distribution with scale parameter \( \alpha \) and shape parameter \( \beta \).

The probability density function (pdf) of the Weibull distribution is defined as:

\[
f(x; \alpha, \beta) = \beta \alpha x^{\beta - 1} e^{-\alpha x^\beta} \quad \text{for } x \geq 0, \alpha > 0, \beta > 0
\]

In this implementation, the random variable from the Weibull distribution is generated using the formula:

\[
\text{result} = \alpha (-\ln(1 - U))^{1/\beta}
\]

where \( U \) is a uniformly distributed random number between 0 and 1, excluding 0 and 1.






