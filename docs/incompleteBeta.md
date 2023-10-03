# `incompleteBeta(a, b, x)`

### Overview

The `incompleteBeta` function calculates the incomplete Beta function \( I_x(a, b) \) for given parameters \( a \), \( b \), and \( x \).

### Parameters

| Parameter | Type  | Description                                               |
|-----------|-------|-----------------------------------------------------------|
| `a`       | Number| First parameter of the incomplete Beta function.          |
| `b`       | Number| Second parameter of the incomplete Beta function.         |
| `x`       | Number| Value at which the incomplete Beta function is evaluated. |

### Returns

| Return    | Type  | Description                                 |
|-----------|-------|---------------------------------------------|
| `incbeta` | Number| The calculated value of the incomplete Beta function. |

### Example

```lua
local a = 2.5
local b = 1.5
local x = 0.4
local result = StatBook.incompleteBeta(a, b, x)
print(result)  -- Output will vary depending on input parameters
```

### Mathematical Background

The incomplete Beta function \( I_x(a, b) \) is calculated using the formula:

\[
I_x(a, b) = \frac{x^a}{a} \times {}_2F_1(a, 1 - b; a + 1; x)
\]

Here, \( {}_2F_1(a, 1 - b; a + 1; x) \) is the hypergeometric function computed by the function `hypergeometric2f1(a, b, c, z)`.

The function is a wrapper for the `hypergeometric2f1` function, which provides the necessary calculation for the hypergeometric term in the incomplete Beta function formula.
