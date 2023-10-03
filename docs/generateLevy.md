# `generateLevy(c, mu)`

### Overview

The `generateLevy(c, mu)` function generates a random number that follows a Lévy distribution.

### Parameters

| Parameter  | Type   | Description                                                                                     |
|------------|--------|-------------------------------------------------------------------------------------------------|
| `c`        | Number | The scale parameter for the Lévy distribution. Must be greater than 0.                           |
| `mu`       | Number | The location parameter for the Lévy distribution.                                                |

### Returns

| Return     | Type   | Description                                                    |
|------------|--------|----------------------------------------------------------------|
| `result`   | Number | A random number from a Lévy distribution.                       |

### Example

```lua
local result = StatBook.generateLevy(1, 0)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a Lévy distribution with scale parameter \( c \) and location parameter \( \mu \).

The probability density function (pdf) of the Lévy distribution is defined as:

\[
f(x; c, \mu) = \sqrt{\frac{c}{2\pi}} \frac{e^{-\frac{c}{2(x - \mu)}}}{(x - \mu)^{3/2}}
\]

The function uses the Inverse Error Function to generate a random variable that follows the Lévy distribution:

\[
result = \frac{c}{(\sqrt{2} \times \text{InverseErrorFunction}(2 \times (1 - \text{math.random}/2) - 1))^2} + \mu
\]




