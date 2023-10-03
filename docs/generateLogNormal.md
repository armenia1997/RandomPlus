# `generateLogNormal(mu, sigma)`

### Overview

The `generateLogNormal(mu, sigma)` function generates a random number that follows a log-normal distribution.

### Parameters

| Parameter  | Type   | Description                                                |
|------------|--------|------------------------------------------------------------|
| `mu`       | Number | The mean parameter of the underlying normal distribution.  |
| `sigma`    | Number | The standard deviation parameter of the underlying normal distribution. |

### Returns

| Return     | Type   | Description                                          |
|------------|--------|------------------------------------------------------|
| `result`   | Number | A random number from a log-normal distribution.      |

### Example

```lua
local result = StatBook.generateLogNormal(0, 1)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a log-normal distribution with parameters \( \mu \) and \( \sigma \). A log-normal distribution is useful in various applications, including finance and ecology, where the values must be positive.

To generate \( result \), the function uses the Box-Muller method to generate a standard normally distributed random variable \( Z \). The function then calculates \( result \) using:

\[
result = \exp(\mu + \sigma \times Z)
\]




