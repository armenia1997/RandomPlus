# `generateBetaPrime(alpha, beta)`

### Overview

The `generateBetaPrime(alpha, beta)` function generates a random number that follows a beta prime distribution.

### Parameters

| Parameter  | Type   | Description                                                                                     |
|------------|--------|-------------------------------------------------------------------------------------------------|
| `alpha`    | Number | The shape parameter alpha for the beta prime distribution. Must be greater than 0.               |
| `beta`     | Number | The shape parameter beta for the beta prime distribution. Must be greater than 0.                |

### Returns

| Return     | Type   | Description                                                    |
|------------|--------|----------------------------------------------------------------|
| `result`   | Number | A random number from a beta prime distribution.                |

### Example

```lua
local result = StatBook.generateBetaPrime(1, 1)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a beta prime distribution with shape parameters \( \alpha \) and \( \beta \). 

The Beta Prime distribution is defined as:

\[
f(x;\alpha, \beta) = \frac{x^{\alpha-1}(1+x)^{-\alpha-\beta}}{B(\alpha, \beta)}
\]

where \( B(\alpha, \beta) \) is the beta function.

To generate \( result \), the function utilizes the Gamma distribution through two shape parameters \( \alpha \) and \( \beta \). It generates two Gamma-distributed random variables \( y_1 \) and \( y_2 \) with \( \alpha \) and \( \beta \) respectively. Then, \( result \) is computed as:

\[
result = \frac{y_1}{y_2}
\]




