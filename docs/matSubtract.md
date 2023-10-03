# `matSubtract(A, B)`

The `matSubtract` function performs element-wise subtraction between two matrices `A` and `B`. Both matrices must have the same dimensions for the operation to be valid.

## Parameters

| Parameter  | Type  | Description                                                     | Default  |
|------------|-------|-----------------------------------------------------------------|----------|
| `A`        | table | The first matrix, represented as a 2D table.                    | Required |
| `B`        | table | The second matrix, also represented as a 2D table.               | Required |

## Returns

| Variable   | Type  | Description                                                      |
|------------|-------|------------------------------------------------------------------|
| `C`        | table | A new matrix, represented as a 2D table, that is the result of `A` minus `B`. |

## Example

```lua
local A = {
  {1, 2},
  {3, 4}
}

local B = {
  {2, 1},
  {4, 3}
}

local result = StatsBook.matSubtract(A, B) 
```

## Notes

- Both matrices `A` and `B` must have the same dimensions. Otherwise, the function may throw an error or return incorrect results.

