# `generateStandardNormalScaled(desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)`

### Overview

The `generateStandardNormalScaled()` function generates a scaled random number based on the standard normal distribution within the specified range.

### Parameters

| Parameter      | Type   | Description                                                                  |
|----------------|--------|------------------------------------------------------------------------------|
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
local random = StatBook.generateStandardNormalScaled(-10, 10)
print(random)  -- Value between -10 and 10
```

### Mathematical Background

The function generates a random number \( x \) that follows a standard normal distribution and then scales it to the desired range. The formula used for scaling is:

\[
\text{random} = \text{scaleToDesiredRange}(x, \text{lowerQuantile}, \text{upperQuantile}, \text{desiredMin}, \text{desiredMax})
\]

Where `scaleToDesiredRange` is a function that takes the random number \( x \), lower and upper quantile values, and desired minimum and maximum values as arguments, and returns a scaled value that falls within `[desiredMin, desiredMax]`.









