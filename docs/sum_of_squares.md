# `sumOfSquares(list)`

### Overview

The `sumOfSquares` function calculates the sum of squares of deviations from the mean for a given list of numbers. The function utilizes the mean of the list to calculate each deviation.

### Parameters

| Parameter | Type  | Description                        |
|-----------|-------|------------------------------------|
| `list`    | table | A list of numbers to calculate the sum of squares for. |

### Returns

| Type   | Description                                   |
|--------|-----------------------------------------------|
| number | The sum of squares of deviations from the mean. |

### Example Use

```lua
local StatBook = require("StatBook")
local myList = {1, 2, 3, 4, 5}
local result = StatBook.sumOfSquares(myList)
print(result)  -- Output will depend on the values in myList
```