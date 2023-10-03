# `generateExponential(lambda)`

### Overview

The `generateExponential(lambda)` function generates a random number that follows an Exponential distribution.

### Parameters

| Parameter  | Type   | Description                                       |
|------------|--------|---------------------------------------------------|
| `lambda`   | Number | The rate parameter of the Exponential distribution.|

### Returns

| Return     | Type   | Description                                       |
|------------|--------|---------------------------------------------------|
| `x`        | Number | A random number from an Exponential distribution.|

### Example

```lua
local x = StatBook.generateExponential(0.5)
print(x)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( x \) that follows an Exponential distribution with rate parameter \( \lambda \). The Exponential distribution is often used to model the time between events in a Poisson process.

To generate \( x \), the function uses the following formula:

\[
x = -\frac{\ln(1 - U)}{\lambda}
\]

where \( U \) is a uniformly distributed random number between 0 and 1.

The \( \ln \) function represents the natural logarithm, and \( \lambda \) is the rate parameter, which should be greater than zero.

x = \frac{d \times v}{\beta}
\]

where \( d = \alpha - \frac{1}{3} \), \( v = (1 + c \times Z)^{3} \), and \( c = \frac{1}{\sqrt{9 \times d}} \).

The reciprocal of \( x \) from the Gamma distribution is then taken to generate the Inverse Gamma distributed number.



