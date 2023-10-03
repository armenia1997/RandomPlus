# `generateBeta(alpha, beta)`

### Overview

The `generateBeta(alpha, beta)` function generates a random number that follows a Beta distribution.

### Parameters

| Parameter  | Type   | Description                                         |
|------------|--------|-----------------------------------------------------|
| `alpha`    | Number | The first shape parameter of the Beta distribution. |
| `beta`     | Number | The second shape parameter of the Beta distribution.|

### Returns

| Return     | Type   | Description                                         |
|------------|--------|-----------------------------------------------------|
| `result`   | Number | A random number from a Beta distribution.           |

### Example

```lua
local result = StatBook.generateBeta(2, 5)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a Beta distribution with shape parameters \( \alpha \) and \( \beta \). The Beta distribution is often used in statistics to describe probabilities and proportions.

To generate \( result \), the function first generates two gamma-distributed random variables \( x \) and \( y \) using the Marsaglia and Tsang method for gamma distribution. The \( x \) value is generated with \( \alpha \) and \( \beta \) set to 1, and \( y \) value is generated with \( \alpha \) set to `beta` and \( \beta \) set to 1. The function then calculates \( result \) using:

\[
result = \frac{x}{x + y}
\]



