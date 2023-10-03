# `generateCauchy(x0, gamma)`

### Overview

The `generateCauchy(x0, gamma)` function generates a random number that follows a Cauchy distribution.

### Parameters

| Parameter  | Type   | Description                                        |
|------------|--------|----------------------------------------------------|
| `x0`       | Number | The location parameter of the Cauchy distribution. |
| `gamma`    | Number | The scale parameter of the Cauchy distribution.    |

### Returns

| Return     | Type   | Description                                             |
|------------|--------|---------------------------------------------------------|
| `result`   | Number | A random number from a Cauchy distribution.             |

### Example

```lua
local result = StatBook.generateCauchy(0, 1)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a Cauchy distribution with location parameter \( x0 \) and scale parameter \( \gamma \).

The probability density function (pdf) of the Cauchy distribution is defined as:

\[
f(x; x0, \gamma) = \frac{1}{\pi \gamma [1 + (\frac{x - x0}{\gamma})^2]}
\]

In this implementation, the random variable from the Cauchy distribution is generated using the formula:

\[
\text{result} = x0 + \gamma \tan(\pi (U - 0.5))
\]

where \( U \) is a uniformly distributed random number between 0 and 1.



