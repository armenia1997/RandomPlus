# `generateStandardNormal()`

### Overview

The `generateStandardNormal()` function generates a random number that follows a standard normal distribution using the Box-Muller transform.

### Parameters

No parameters are required.

### Returns

| Return      | Type    | Description                                       |
|-------------|---------|---------------------------------------------------|
| `x`         | Number  | A random number from a standard normal distribution.|

### Example

```lua
local x = StatBook.generateStandardNormal()
print(x)  -- Output will vary
```

### Mathematical Background

The function internally utilizes the Box-Muller transform to generate a random number \( x \) that follows a standard normal distribution. This distribution has a mean of 0 and a standard deviation of 1.

The Box-Muller transform generates two independent standard normally distributed normal variables, \( Z_0 \) and \( Z_1 \), from two uniformly distributed random variables \( U_1 \) and \( U_2 \).

\[
Z_0 = \sqrt{-2 \ln(U_1)} \cos(2\pi U_2)
\]

\[
Z_1 = \sqrt{-2 \ln(U_1)} \sin(2\pi U_2)
\]

In this function, either \( Z_0 \) or \( Z_1 \) is returned as \( x \).
