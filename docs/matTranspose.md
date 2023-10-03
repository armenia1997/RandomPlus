# `matTranspose(matrix)`

The `matTranspose` function takes a given matrix `matrix` and returns its transpose. The transpose of a matrix is obtained by flipping the matrix over its diagonal.

## Parameters

| Parameter  | Type  | Description                                          | Default  |
|------------|-------|------------------------------------------------------|----------|
| `matrix`   | table | The matrix to be transposed, represented as a 2D table. | Required |

## Returns

| Variable       | Type  | Description                                                          |
|----------------|-------|----------------------------------------------------------------------|
| `resultMatrix` | table | A new matrix represented as a 2D table, which is the transpose of the input matrix `matrix`. |

## Example

```lua
local matrix = {
  {1, 2},
  {3, 4},
  {5, 6}
}

local result = StatsBook.matTranspose(matrix) 
```

