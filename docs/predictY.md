# `predictY(X, model, yHat, indices)`

### Overview

The `predictY` function predicts the dependent variable \( Y \) based on the independent variable \( X \) and the given model. Optionally, it allows for specific fitted values \( \hat{y} \) and predictor indices to be specified.

### Parameters

| Parameter  | Type  | Description                                                           | Default  |
|------------|-------|-----------------------------------------------------------------------|----------|
| `X`        | Table | The input vector containing independent variable values.               | -        |
| `model`    | Table | The regression model from `multipleLinearRegression()` | -       |
| `yHat`     | Table | Optional. The fitted values for the intercept and coefficients.        | nil      |
| `indices`  | Table | Optional. The indices in the model to be used for prediction.          | nil      |

### Returns

| Return     | Type    | Description                                                        |
|------------|---------|--------------------------------------------------------------------|
| `YPred`    | Number  | The predicted value of the dependent variable \( Y \).             |

### Example

```lua
local X = {{1, 4, 7}, {2, 3, 5}, {3, 2, 1}, {4, 2, 2}, {5, 8, 3}, {3, 6, 2}}
local Y = {3, 3, 2, 2, 4, 5}

local model = StatBook.multipleLinearRegression(X, Y)

local Xtest = {1, 5, 6}
local YPred = module.predictY(Xtest, model)
print(YPred) 
```



