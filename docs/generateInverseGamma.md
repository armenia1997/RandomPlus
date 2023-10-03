# `generateInverseGamma(alpha, beta)`

### Overview

The `generateInverseGamma(alpha, beta)` function generates a random number that follows an Inverse Gamma distribution using the Marsaglia and Tsang method for Gamma distribution and then taking the reciprocal.

### Parameters

| Parameter   | Type    | Description                     |
|-------------|---------|---------------------------------|
| `alpha`     | Number  | The shape parameter of the Inverse Gamma distribution. |
| `beta`      | Number  | The scale parameter of the Inverse Gamma distribution. |

### Returns

| Return      | Type    | Description                                       |
|-------------|---------|---------------------------------------------------|
| `x`         | Number  | A random number from an Inverse Gamma distribution.|

### Example

```lua
local x = StatBook.generateInverseGamma(2, 1)
print(x)  -- Output will vary
```

### Mathematical Background

The function uses the Marsaglia and Tsang method to generate a random number \( x \) that follows a Gamma distribution with shape parameter \( \alpha \) and scale parameter \( \beta \). It then takes the reciprocal of this number to generate a value from an Inverse Gamma distribution.

For \( \alpha < 1 \), the function uses a recursive approach to find \( x \) for the Gamma distribution:

\[
x = \text{GenerateGamma}(\alpha + 1, \beta) \times u^{(1 / \alpha)}
\]

where \( u \) is a uniformly distributed random number between 0 and 1.

For \( \alpha \geq 1 \), \( x \) for the Gamma distribution is calculated using the formula:

\[
x = \frac{d \times v}{\beta}
\]

where \( d = \alpha - \frac{1}{3} \), \( v = (1 + c \times Z)^{3} \), and \( c = \frac{1}{\sqrt{9 \times d}} \).

The reciprocal of \( x \) from the Gamma distribution is then taken to generate the Inverse Gamma distributed number.



