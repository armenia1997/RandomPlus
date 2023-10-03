# `range(list)`

### Overview

The `range` function calculates the range of a given list of numbers. The range is the difference between the maximum and minimum values in the list.

### Parameters

| Parameter Name | Type  | Description                                    | Required | Default Value |
|----------------|-------|------------------------------------------------|----------|---------------|
| `list`         | table | A list of numerical values to find the range from. The list must contain at least two numerical values. | Yes      | N/A           |

### Returns

| Type   | Description                                  | Possible Values           |
|--------|----------------------------------------------|---------------------------|
| number | The range of the list, calculated as the difference between the maximum and minimum values. | Any numerical value |

### Constraints

- The `list` parameter must be a table containing numerical values only.
- The table must have at least two elements; otherwise, the function will return an undefined result.

### Example Use

```lua
local myList = {1, 2, 3, 4, 5}

local result = StatBook.range(myList)

-- The range of the list {1, 2, 3, 4, 5} is (5 - 1) = 4
print(result)
```
