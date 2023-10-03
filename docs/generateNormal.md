# `generateNormal(mu, sigma)`

### Overview

The `generateNormal` function generates a random number following a normal distribution characterized by a given mean (`mu`) and standard deviation (`sigma`).

### Parameters

| Parameter | Type   | Description                                                 | Default |
|-----------|--------|-------------------------------------------------------------|---------|
| `mu`      | Number | The mean of the normal distribution.                        | -       |
| `sigma`   | Number | The standard deviation of the normal distribution.          | -       |

### Returns

| Return | Type   | Description                                   |
|--------|--------|-----------------------------------------------|
| `x`    | Number | A random number following the specified normal distribution. |

### Example

```lua
local mu = 0
local sigma = 1
local randomNum = StatBook.generateNormal(mu, sigma)
print(randomNum)  -- Output will vary based on random generation
```

### Mathematical Background

The function uses the Box-Muller transform to generate a normally distributed random number \( x \), given a mean \( \mu \) and standard deviation \( \sigma \).

Given two independent and uniformly distributed random numbers \( U_1 \) and \( U_2 \), the Box-Muller transform generates a standard normally distributed random variable \( Z \):

\[
Z = \sqrt{-2 \ln(U_1)} \cos(2\pi U_2)
\]

To adapt this to a general normal distribution with mean \( \mu \) and standard deviation \( \sigma \), the function performs the following transformation:

\[
x = \mu + \sigma \times Z
\]



