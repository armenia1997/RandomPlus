# `inverf(x)`

### Overview

The `inverf` function calculates the inverse of the error function \( \text{erf}^{-1}(x) \) using the Newton-Raphson method for numerical approximation.

### Parameters

| Parameter | Type  | Description               |
|-----------|-------|---------------------------|
| `x`       | Number| The value to find the inverse error function of. Must be in the range \([-1, 1]\). |

### Returns

| Return  | Type  | Description          |
|---------|-------|----------------------|
| `inv`   | Number| The calculated inverse error function value \( \text{erf}^{-1}(x) \). |

### Example

```lua
local x = 0.5
local result = StatBook.inverf(x)
print(result)  -- Output will be approximately 0.4769
```

### Mathematical Background

The function calculates \( \text{erf}^{-1}(x) \) using the Newton-Raphson method for solving equations. The Newton-Raphson formula for iteration is:

\[x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}\]

In this context, \( f(x) = \text{erf}(x) - a \) and \( f'(x) = \frac{2}{\sqrt{\pi}} \exp(-x^2) \), where \( a \) is the argument passed to `module.inverf`.
