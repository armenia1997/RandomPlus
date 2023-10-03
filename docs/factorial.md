# `factorial(x)`

### Overview

The `factorial` function computes the factorial of a given non-negative integer \( n \). The factorial, denoted \( n! \), is the product of all positive integers less than or equal to \( n \). For example, \( 5! = 5 * 4 * 3 * 2 * 1 = 120 \).

### Parameters

| Parameter Name | Type   | Description                                                                         | Required | Default Value |
|----------------|--------|-------------------------------------------------------------------------------------|----------|---------------|
| `x`            | number | The non-negative integer for which the factorial will be calculated.                 | Yes      | N/A           |

### Returns

| Type   | Description                                                       | Possible Values           |
|--------|-------------------------------------------------------------------|---------------------------|
| number | The factorial of the input number \( x \).                        | Any non-negative integer  |

### Constraints

- The `x` parameter must be a non-negative integer.
- Factorial of negative integers is undefined, so such input should be avoided.

### Example Use

```lua
local number = 5

-- The factorial of 5 is 5 * 4 * 3 * 2 * 1 = 120
local result = StatBook.factorial(number)

print(result)
```
