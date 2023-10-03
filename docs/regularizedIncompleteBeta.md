# `regularizedIncompleteBeta(a, b, x)`

### Overview

The `regularizedIncompleteBeta` function calculates the regularized incomplete Beta function \( I_x(a, b) \) for given parameters \( a \), \( b \), and \( x \).

### Parameters

| Parameter | Type  | Description                                               |
|-----------|-------|-----------------------------------------------------------|
| `a`       | Number| First parameter of the regularized incomplete Beta function.|
| `b`       | Number| Second parameter of the regularized incomplete Beta function.|
| `x`       | Number| Value at which the regularized incomplete Beta function is evaluated.|

### Returns

| Return       | Type  | Description                                              |
|--------------|-------|----------------------------------------------------------|
| `regincbeta` | Number| The calculated value of the regularized incomplete Beta function.|

### Example

```lua
local a = 2.5
local b = 1.5
local x = 0.4
local result = StatBook.regularizedIncompleteBeta(a, b, x)
print(result)  -- Output will vary depending on input parameters
```

### Mathematical Background

The regularized incomplete Beta function \( I_x(a, b) \) is calculated using the formula:

\[
I_x(a, b) = \frac{{\text{incompleteBeta}(a, b, x)}}{\frac{\Gamma(a) \times \Gamma(b)}{\Gamma(a + b)}}
\]

Here, \( \text{incompleteBeta}(a, b, x) \) is the incomplete Beta function and \( \Gamma \) is the Gamma function.

The function is a wrapper for the `incompleteBeta` and `Gamma` functions, which provide the necessary calculations for the incomplete Beta and Gamma terms in the regularized incomplete Beta function formula.
