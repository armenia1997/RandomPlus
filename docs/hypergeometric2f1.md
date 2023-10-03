# `hypergeometric2f1(a, b, c, z)`

### Overview

The `hypergeometric2f1` function calculates the hypergeometric function \( \, _2F_1(a, b; c; z) \) using a series approximation.

### Parameters

| Parameter | Type  | Description                                                   |
|-----------|-------|---------------------------------------------------------------|
| `a`       | Number| First parameter of the hypergeometric function.               |
| `b`       | Number| Second parameter of the hypergeometric function.              |
| `c`       | Number| Third parameter of the hypergeometric function.               |
| `z`       | Number| Argument for which the hypergeometric function is calculated. |

### Returns

| Return        | Type  | Description                                           |
|---------------|-------|-------------------------------------------------------|
| `hypergeom`   | Number| The calculated hypergeometric function value.         |

### Example

```lua
local a = 1
local b = 2
local c = 3
local z = 0.5
local result = StatBook.hypergeometric2f1(a, b, c, z)
print(result)  -- Output will vary depending on input parameters
```

### Mathematical Background

The hypergeometric function \( \, _2F_1(a, b; c; z) \) is computed using the following series approximation:

\[
\, _2F_1(a, b; c; z) = 1 + \frac{a \cdot b}{c \cdot 1!} \cdot z + \frac{a(a+1) \cdot b(b+1)}{c(c+1) \cdot 2!} \cdot z^2 + \ldots
\]

The calculation continues until the change between the new sum and the previous sum is less than a tolerance value of \(1 \times 10^{-6}\) or up to 100,000,000 iterations.
