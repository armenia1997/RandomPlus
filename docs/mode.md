# `mode(list)`

### Overview

The `mode` function calculates the mode(s) of a given list of numbers. The mode is the number(s) that appear most frequently in the data set. If multiple numbers have the same highest frequency, all of them are returned as modes in a table.

### Parameters

| Parameter Name | Type  | Description                                 | Required | Default Value |
|----------------|-------|---------------------------------------------|----------|---------------|
| `list`         | table | A list of numerical values to find the mode from. The list must contain at least one numerical value. | Yes      | N/A           |

### Returns

| Type  | Description                                     | Possible Values                         |
|-------|-------------------------------------------------|-----------------------------------------|
| table | A table containing the mode(s) of the list. If there are multiple modes, all will be included in the returned table. | A table containing numerical values |

### Constraints

- The `list` parameter must be a table containing numerical values only.
- The table must have at least one element; otherwise, the function will return an empty table.

### Example Use

```lua
local myList = {1, 2, 3, 2, 2, 4}

local result = StatBook.mode(myList)

-- The modes of the list is 2 as it appears most frequently
for _, v in ipairs(result) do
    print(v)
end
```
