# `generateCauchyScaled(x0, gamma, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)`

### Overview

The function generates a scaled random number based on a Cauchy distribution with a specified location parameter (\( x_0 \)) and scale parameter (\( \gamma \)) within the desired range.

### Parameters

| Parameter      | Type   | Description                                                                  |
|----------------|--------|------------------------------------------------------------------------------|
| `x0`           | Number | The location parameter of the Cauchy distribution.                            |
| `gamma`        | Number | The scale parameter of the Cauchy distribution.                              |
| `desiredMin`   | Number | The minimum desired value of the scaled random number.                        |
| `desiredMax`   | Number | The maximum desired value of the scaled random number.                        |
| `LQpercent`    | Number | Lower quantile percentage. Default is 0.001.                                 |
| `UQpercent`    | Number | Upper quantile percentage. Default is 0.999.                                 |
| `lowerQuantile`| Number | Lower quantile value. Calculated by default if not provided.                  |
| `upperQuantile`| Number | Upper quantile value. Calculated by default if not provided.                  |

### Returns

| Return         | Type   | Description                                                         |
|----------------|--------|---------------------------------------------------------------------|
| `random`       | Number | A scaled random number in the range `[desiredMin, desiredMax]`.     |

### Example

```lua
local random = StatBook.generateCauchyScaled(0, 1, -10, 10)
print(random)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( x \) that follows a Cauchy distribution and then scales it to the desired range. The formula used for scaling is:

\[
\text{random} = \text{scaleToDesiredRange}(x, \text{lowerQuantile}, \text{upperQuantile}, \text{desiredMin}, \text{desiredMax})
\]

Where `scaleToDesiredRange` is a function that takes the random number \( x \), lower and upper quantile values, and desired minimum and maximum values as arguments, and returns a scaled value that falls within `[desiredMin, desiredMax]`.









