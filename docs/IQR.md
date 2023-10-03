# `interquartileRange(values)`

### Overview

The `interquartileRange` function calculates the Interquartile Range (IQR) of a given list of numbers. The IQR is the range between the first quartile (Q1) and the third quartile (Q3) of a data set, providing a measure of statistical dispersion.

### Parameters

| Parameter Name | Type  | Description                                                           | Required | Default Value |
|----------------|-------|-----------------------------------------------------------------------|----------|---------------|
| `values`       | table | A list of numerical values for which the IQR will be calculated. The list must contain at least two numerical values. | Yes      | N/A           |

### Returns

| Type   | Description                                       | Possible Values           |
|--------|---------------------------------------------------|---------------------------|
| number | The Interquartile Range (IQR) of the elements in the list. The return value will be a floating-point number. | Any numerical value       |

### Constraints

- The `values` parameter must be a table containing numerical values only.
- The table must have at least two elements; otherwise, an error will be thrown.

### Example Use

```lua
local myValues = {1, 2, 3, 4, 5}

-- The IQR of the list {1, 2, 3, 4, 5} will be calculated
local result = StatBook.interquartileRange(myValues)

-- Output will be the calculated IQR
print(result)
```
