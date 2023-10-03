# `generateLogNormalScaled(mu, sigma, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)`

### Overview

The `generateLogNormalScaled()` function generates a scaled random number based on a log-normal distribution with a specified mean (\( \mu \)) and standard deviation (\( \sigma \)) within the desired range.

### Parameters

| Parameter      | Type   | Description                                                                  |
|----------------|--------|------------------------------------------------------------------------------|
| `mu`           | Number | The mean of the log-normal distribution.                                      |
| `sigma`        | Number | The standard deviation of the log-normal distribution.                        |
| `desiredMin`   | Number | The minimum desired value of the scaled random number.                        |
| `desiredMax`   | Number | The maximum desired value of the scaled random number.                        |
| `LQpercent`    | Number | Lower quantile percentage. Default is 0.                                      |
| `UQpercent`    | Number | Upper quantile percentage. Default is 0.999.                                  |
| `lowerQuantile`| Number | Lower quantile value. Calculated by default if not provided.                  |
| `upperQuantile`| Number | Upper quantile value. Calculated by default if not provided.                  |

### Returns

| Return         | Type   | Description                                                         |
|----------------|--------|---------------------------------------------------------------------|
| `random`       | Number | A scaled random number in the range `[desiredMin, desiredMax]`.     |

### Example

```lua
local random = StatBook.generateLogNormalScaled(0, 1, 1, 100)
print(random)  -- Output will vary
```

### Mathematical Background

The function generates a random number \( x \) that follows a log-normal distribution and then scales it to the desired range. The formula used for scaling is:

\[
\text{random} = \text{scaleToDesiredRange}(x, \text{lowerQuantile}, \text{upperQuantile}, \text{desiredMin}, \text{desiredMax})
\]

Where `scaleToDesiredRange` is a function that takes the random number \( x \), lower and upper quantile values, and desired minimum and maximum values as arguments, and returns a scaled value that falls within `[desiredMin, desiredMax]`.








