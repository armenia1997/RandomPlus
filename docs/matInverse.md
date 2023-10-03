# `matInverse(matrix)`

The `matInverse` function calculates the inverse of a square matrix, if it exists. The function will return `nil` if the matrix is not square or if the determinant is zero (indicating that the matrix is not invertible).

## Parameters

| Parameter  | Type  | Description                                                    | Default  |
|------------|-------|----------------------------------------------------------------|----------|
| `matrix`   | table | The square matrix to be inverted, represented as a 2D table.    | Required |

## Returns

| Variable        | Type  | Description                                                                        |
|-----------------|-------|------------------------------------------------------------------------------------|
| `inverseMatrix` | table | A new matrix represented as a 2D table, which is the inverse of the input matrix.  |
| `nil`           | nil   | If the matrix is not square or if the matrix is singular (determinant is zero).    |

## Example

```lua
local matrix = {
  {2, -1, 0},
  {-1, 2, -1},
  {0, -1, 2}
}

local result = StatsBook.matInverse(matrix)
```

## Notes

- If the matrix is not square or if the matrix is singular (determinant is zero), the result is nil. Ensure your matrix is square and the determinant is not 0.
