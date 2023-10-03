# `median(list)`

### Overview

The `median` function calculates the median value from a given list of numbers. The median is the middle value in a data set sorted in ascending order. For a list with an odd number of elements, the median is the exact middle value. For a list with an even number of elements, the median is the average of the two middle values.

### Parameters

| Parameter Name | Type  | Description                                  | Required | Default Value |
|----------------|-------|----------------------------------------------|----------|---------------|
| `list`         | table | A list of numerical values to find the median from. The list must contain at least one numerical value. | Yes      | N/A           |

### Returns

| Type           | Description                                  | Possible Values                          |
|----------------|----------------------------------------------|------------------------------------------|
| number or nil  | The median value of the elements in the list. If the list is empty or nil values are encountered, returns `nil`. | Any numerical value or `nil` |

### Constraints

- The `list` parameter must be a table containing numerical values only.
- The table must have at least one element; otherwise, the function will return `nil`.

### Example Use

```lua
local myList = {7, 2, 3, 6, 5}
local result = StatBook.median(myList)

print(result)  -- Output will be 5
```
