# `gamma(x)`

### Overview

The `gamma` function calculates the Gamma function \( \Gamma(x) \) using the Lanczos approximation method.

### Parameters

| Parameter | Type  | Description                    |
|-----------|-------|--------------------------------|
| `x`       | Number| The value to find the Gamma function of. |

### Returns

| Return  | Type  | Description                    |
|---------|-------|--------------------------------|
| `gam`   | Number| The calculated Gamma function value \( \Gamma(x) \). |

### Example

```lua
local x = 5
local result = StatBook.gamma(x)
print(result)
```

### Mathematical Background

The function calculates \( \Gamma(x) \) using the Lanczos approximation, which is an efficient method to compute the Gamma function for complex numbers. The method approximates \( \Gamma(z) \) by:

\[
\Gamma(z) \approx \sqrt{2\pi} \left( z + \frac{5}{6} \right)^{z+\frac{1}{2}} e^{-(z+\frac{5}{6})} \left( c_0 + \frac{c_1}{z+1} + \frac{c_2}{z+2} + \cdots + \frac{c_n}{z+n} \right)
\]

Here \( c_0, c_1, \cdots, c_n \) are precomputed coefficients used in the approximation.
