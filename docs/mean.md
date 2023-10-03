# `mean(list)`

### Overview

The `mean` function calculates the arithmetic mean, commonly known as the average, of a given list of numbers. The function sums up all the elements in the list and divides it by the total number of elements to determine the mean value.

### Parameters

| Parameter Name | Type  | Description                       | Required | Default Value |
|----------------|-------|-----------------------------------|----------|---------------|
| `list`         | table | A list of numerical values for which the mean will be calculated. The list must contain at least one numerical value. | Yes      | N/A           |

### Returns

| Type   | Description                 | Possible Values           |
|--------|-----------------------------|---------------------------|
| number | The mean (average) of the elements in the list. The return value will be a floating-point number if the mean is not an integer. | Any numerical value |

### Constraints

- The `list` parameter must be a table containing numerical values only.
- The table must have at least one element; otherwise, the function will return an undefined result due to division by zero.

### Example Use

```lua
local myList = {1, 2, 3, 4, 5}
local result = StatBook.mean(myList)

print(result)  -- Output will be 3
```