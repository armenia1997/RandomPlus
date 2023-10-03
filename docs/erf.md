# `erf(x)`

### Overview

The `erf` function computes the error function of a given real number \( x \). The error function is defined as:

\[\text{erf}(x) = \frac{2}{\sqrt{\pi}} \int_{0}^{x} e^{-t^2} dt\]

In this implementation, the error function is approximated by a series expansion up to 100 terms.

### Parameters

| Parameter Name | Type   | Description                                                   | Required | Default Value |
|----------------|--------|---------------------------------------------------------------|----------|---------------|
| `x`            | number | The real number for which the error function will be computed.| Yes      | N/A           |

### Returns

| Type   | Description                            | Possible Values           |
|--------|----------------------------------------|---------------------------|
| number | The error function value of the input \( x \).| Any real number         |

### Constraints

- The `x` parameter must be a real number.

### Example Use

```lua
local number = 1.0

-- The error function of 1.0 will be calculated
local result = StatBook.erf(number)

-- Output will be the error function value for 1.0
print(result)
```