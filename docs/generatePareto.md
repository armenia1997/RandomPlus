# `generatePareto(alpha, xm)`

### Overview

The `generatePareto(alpha, xm)` function generates a random number that follows a Pareto distribution with shape parameter `alpha` and scale parameter `xm`.

### Parameters

| Parameter  | Type   | Description                                          |
|------------|--------|------------------------------------------------------|
| `alpha`    | Number | The shape parameter for the Pareto distribution.     |
| `xm`       | Number | The scale parameter for the Pareto distribution.     |

### Returns

| Return     | Type   | Description                                         |
|------------|--------|-----------------------------------------------------|
| `result`   | Number | A random number from a Pareto distribution.         |

### Example

```lua
local result = StatBook.generatePareto(2, 1)
print(result)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( result \) that follows a Pareto distribution with shape parameter \( \alpha \) and scale parameter \( xm \).

The probability density function (pdf) for the Pareto distribution is:

\[
f(x; \alpha, xm) = \alpha xm^\alpha x^{-(\alpha + 1)} \quad \text{for } x \geq xm, \alpha > 0
\]

In this implementation, the Pareto distribution is generated using the formula:

\[
\text{result} = xm \times (1 - \text{random})^{-\frac{1}{\alpha}}
\]








