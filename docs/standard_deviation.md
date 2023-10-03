# `standardDeviation(list)`

### Overview

The `standardDeviation` function calculates the sample standard deviation (SD) of a given list of numbers. The standard deviation is a measure of the amount of variation or dispersion of a set of values.

### Parameters

| Parameter Name | Type  | Description                                                  | Required | Default Value |
|----------------|-------|--------------------------------------------------------------|----------|---------------|
| `list`         | table | A list of numerical values for which the standard deviation will be calculated. The list must contain at least two numerical values. | Yes      | N/A           |

### Returns

| Type   | Description                                         | Possible Values           |
|--------|-----------------------------------------------------|---------------------------|
| number | The sample standard deviation of the elements in the list. The return value will be a floating-point number. | Any numerical value |

### Constraints

- The `list` parameter must be a table containing numerical values only.
- The table must have at least two elements; otherwise, the function will return `0` as there's not enough data to calculate the standard deviation.
- It finds the sample SD, not population SD.

### Example Use

```lua
local myList = {1, 2, 3, 4, 5}

-- The standard deviation of the list {1, 2, 3, 4, 5} will be calculated
local result = StatBook.standardDeviation(myList)

-- Output will be the calculated standard deviation
print(result)
```

