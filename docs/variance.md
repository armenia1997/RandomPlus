# `variance(list)`

### Overview

The `variance` function calculates the sample variance of a given list of numbers. Variance is a statistical measurement of the spread between numbers in a dataset.

### Parameters

| Parameter Name | Type  | Description                                                      | Required | Default Value |
|----------------|-------|------------------------------------------------------------------|----------|---------------|
| `list`         | table | A list of numerical values for which the variance will be calculated. The list must contain at least two numerical values. | Yes      | N/A           |

### Returns

| Type   | Description                                          | Possible Values           |
|--------|------------------------------------------------------|---------------------------|
| number | The sample variance of the elements in the list. The return value will be a floating-point number. | Any numerical value |

### Constraints

- The `list` parameter must be a table containing numerical values only.
- The table must have at least two elements; otherwise, the function will return `0` as there's not enough data to calculate the variance.
- It finds the sample variance, not population variance.

### Example Use

```lua
local myList = {1, 2, 3, 4, 5}

-- The sample variance will be 2.5
local result = StatBook.variance(myList)
print(result)
```