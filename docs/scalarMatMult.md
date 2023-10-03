# `scalarMatMult(scalar, matrix)`

The `scalarMatMult` function multiplies a given scalar with every element of a provided matrix. The function returns a new matrix containing the results.

## Parameters

| Parameter  | Type  | Description                                         | Default  |
|------------|-------|-----------------------------------------------------|----------|
| `scalar`   | number| The scalar value to multiply with the matrix.       | Required |
| `matrix`   | table | The matrix, represented as a 2D table.              | Required |

## Returns

| Variable       | Type  | Description                                                            |
|----------------|-------|------------------------------------------------------------------------|
| `resultMatrix` | table | A new matrix represented as a 2D table, resulting from the scalar multiplication of the input matrix.|

## Example

```lua
local scalar = 2
local matrix = {
  {1, 2},
  {3, 4}
}

local result = StatsBook.scalarMatMult(scalar, matrix) 
```



