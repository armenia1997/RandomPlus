# `matMult(A, B)`

The `matMult` function performs matrix multiplication between two matrices `A` and `B`. The function assumes that the matrices are in correct dimensions for multiplication to proceed. It returns a new matrix `C` which is the result of the multiplication.

## Parameters

| Parameter | Type  | Description                                         | Default  |
|-----------|-------|-----------------------------------------------------|----------|
| `A`       | table | The first matrix, represented as a 2D table.        | Required |
| `B`       | table | The second matrix, represented as a 2D table.       | Required |

## Returns

| Variable      | Type  | Description                                                             |
|---------------|-------|-------------------------------------------------------------------------|
| `resultMatrix`| table | A new matrix represented as a 2D table, resulting from `A` multiplied by `B`. |

## Example

```lua
local A = {
  {1, 2},
  {3, 4}
}

local B = {
  {2, 0},
  {1, 2}
}

local C = StatsBook.matMult(A, B) 
```

##Notes

- The function does not handle cases where the matrices are not of compatible dimensions for multiplication. Make sure the number of columns in `A` matches the number of rows in `B`.





