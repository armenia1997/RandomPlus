# `generateBetaScaled(alpha, beta, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)`

### Overview

The function generates a scaled random number based on a Beta distribution with specified shape parameters (\( \alpha \) and \( \beta \)) within the desired range.

### Parameters

| Parameter      | Type   | Description                                                                  |
|----------------|--------|------------------------------------------------------------------------------|
| `alpha`        | Number | The first shape parameter of the Beta distribution.                           |
| `beta`         | Number | The second shape parameter of the Beta distribution.                          |
| `desiredMin`   | Number | The minimum desired value of the scaled random number.                        |
| `desiredMax`   | Number | The maximum desired value of the scaled random number.                        |
| `LQpercent`    | Number | Lower quantile percentage. Default is 0.                                      |
| `UQpercent`    | Number | Upper quantile percentage. Default is 1.                                      |
| `lowerQuantile`| Number | Lower quantile value. Calculated by default if not provided.                  |
| `upperQuantile`| Number | Upper quantile value. Calculated by default if not provided.                  |

### Returns

| Return         | Type   | Description                                                         |
|----------------|--------|---------------------------------------------------------------------|
| `scaledX`      | Number | A scaled random number in the range `[desiredMin, desiredMax]`.     |

### Example

```lua
local scaledX = StatBook.generateBetaScaled(2, 5, 0, 1)
print(scaledX)  -- Output will vary
```

### Mathematical Background

The function generates random numbers \( x \) and \( y \) that follow Gamma distributions with parameters \( \alpha \) and \( \beta \) respectively, and then derives a Beta-distributed random number \( \text{result} = \frac{x}{x+y} \). This result is then scaled to the desired range using the formula:

\[
\text{scaledX} = \text{scaleToDesiredRange}(\text{result}, \text{lowerQuantile}, \text{upperQuantile}, \text{desiredMin}, \text{desiredMax})
\]

Where `scaleToDesiredRange` is a function that takes the Beta-distributed random number \( \text{result} \), lower and upper quantile values, and desired minimum and maximum values as arguments, and returns a scaled value that falls within `[desiredMin, desiredMax]`.










