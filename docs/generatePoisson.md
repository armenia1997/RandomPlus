# `generatePoisson(lambda)`

### Overview

The `generatePoisson(lambda)` function generates a random number that follows a Poisson distribution.

### Parameters

| Parameter  | Type   | Description                                                                                     |
|------------|--------|-------------------------------------------------------------------------------------------------|
| `lambda`   | Number | The average rate of events per interval for the Poisson distribution. Must be greater than 0.    |

### Returns

| Return     | Type   | Description                                                        |
|------------|--------|--------------------------------------------------------------------|
| `result`   | Number | A random number from a Poisson distribution.                        |

### Example

```lua
local result = StatBook.generatePoisson(5)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a Poisson distribution with parameter \( \lambda \).

The probability mass function (pmf) of the Poisson distribution is defined as:

\[
P(X=k) = \frac{\lambda^k e^{-\lambda}}{k!}
\]

In this implementation, the algorithm uses a method based on direct simulation. It initializes a loop with \( p = 1 \) and multiplies \( p \) by a random number between 0 and 1 until \( p \) is less than or equal to \( e^{-\lambda} \). The number of iterations minus 1 gives the random variable from the Poisson distribution.

\[
\text{result} = k - 1
\]





