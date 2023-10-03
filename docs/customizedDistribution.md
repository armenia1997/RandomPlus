# `customizedDistribution(piecewiseFunctions, desiredMin, desiredMax)`

### Overview

The function generates a random number based on custom piecewise functions within the desired range.

### Parameters

| Parameter           | Type      | Description                                                                              |
|---------------------|-----------|------------------------------------------------------------------------------------------|
| `piecewiseFunctions`| Table     | A table containing subtables, each with a function string, \( x_{\text{min}} \), and \( x_{\text{max}} \) for each piecewise function.  |
| `desiredMin`        | Number    | The minimum desired value of the scaled random number.                                    |
| `desiredMax`        | Number    | The maximum desired value of the scaled random number.                                    |

### Returns

| Return         | Type    | Description                                                         |
|----------------|---------|---------------------------------------------------------------------|
| `randomX`      | Number  | A scaled random number in the range `[desiredMin, desiredMax]`.     |

### Example

```lua
local functions = {{"x^2", 0, 2}, {"2*x", 2, 4}}
local randomX = StatBook.customizedDistribution(functions, 0, 10)
print(randomX)  -- Output will vary
```

### Mathematical Background

The function employs a Monte Carlo method using the custom piecewise functions provided. It randomly selects one of the piecewise functions and generates a random coordinate \((\text{randomX}, \text{randomY})\) within its range and below its absolute maximum value. The function value at this \(\text{randomX}\) is calculated using the user-provided function, and the coordinate is accepted if \(\text{randomY} \leq \text{number}\). The accepted \(\text{randomX}\) value is then scaled to fall within `[desiredMin, desiredMax]`.

\[
\text{randomX} = \text{desiredMin} + \left( \text{randomX} - x_{\text{min}} \right) \times \frac{\text{desiredMax} - \text{desiredMin}}{x_{\text{max}} - x_{\text{min}}}
\]








