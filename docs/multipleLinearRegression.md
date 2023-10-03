# `multipleLinearRegression(X, Y, forwardReg, diagnostics, CL)`

## Overview

The `multipleLinearRegression` function performs multiple linear regression analysis on given data sets. This advanced function includes several features, such as forward regression based on Mallows's Cp, diagnostic statistics, and calculation of Variance Inflation Factors (VIFs).

> **NOTE 1**: ALL T-TESTS IN THIS MODULE ARE TWO-TAILED.

> **NOTE 2:** All data point subtables within the \( X \) table must have the same amount of entries. Currently, the table does not have an algorithm to deal with nil values (this will come very soon in 1.1). Therefore, it is the developer's responsibility to input a proper \( X \) table and format the table beforehand.

> **NOTE 3:** Before invoking the function, ensure that the \( X \) table is formatted correctly as a 2D table, where each inner table represents a row of the matrix. If \( X \) is not in this format, you may use the `module.matTranspose(matrix)` function to transpose \( X \) into a compatible layout. This is crucial for the proper functioning of the function.

> **NOTE 4:** The `VIFs` table is only there as a warning. VIF values do not impact the regression model and do not automatically remove multi-collinear predictors. You will have to manually account for this if you choose to remove a predictor yourself and thus rerun `multipleLinearRegression` again. StatBook v1.1 will seek to give the developer an option to automatically eliminate multi-collinear predictors based on high VIF values.


## Parameters

| Parameter         | Type    | Description                                            | Default  |
|-------------------|---------|--------------------------------------------------------|----------|
| `X`                 | table   | The independent variables matrix (2D table).           | Required |
| `Y`                 | table   | The dependent variable vector (1D table).              | Required |
| `forwardReg`        | boolean | Enables or disables the forward regression process.     | true     |
| `diagnostics`       | boolean | Enables or disables diagnostic statistics.              | true     |
| `CL`                | number  | Confidence level for t-tests and F-test.                | 0.95      |

## Returns (if `diagnostics` ~= `true`)

| Variable   | Type  | Description                                                             | 
|------------|-------|-------------------------------------------------------------------------|
| `yHat`       | table -> number(s) | Fitted values for the dependent variable.             | 
| `indices`      | table -> number(s) | Indices of betas retained in model from lmOrig to lmNew     | 


## Returns (if `diagnostics` = `true`)

| Variable   | Type  | Description                                                             | Subfields                           |
|------------|-------|-------------------------------------------------------------------------|-------------------------------------|
| `lmNew`       | table -> tables | Model after forward selection with Mallow's C(p)            |      yes    |
| `lmOrig`     | table -> tables | Model before forward selection with Mallow's C(p)            |            yes     |
| `indices`      | table -> number(s) | Indices of betas retained in model from lmOrig to lmNew     |           |

## `lmNew` and `lmOrig` Subfields*

| Variable   | Type  | Description                                                             | Sub-subfields                           |
|------------|-------|-------------------------------------------------------------------------|-------------------------------------|
| `yHat`       | table -> number(s) | Fitted values for the dependent variable.             |                                     |
| `r2`         | number| \( R^2 \) value indicating the goodness of fit.                          |                                     |
| `r2adj`      | number| Adjusted \( R^2 \) accounting for # of predictors.         |                                     |
| `F`          | number| F-statistic used for hypothesis testing.                                 |                                     |
| `pValueF`     | number| p-value of the F-statistic.            |                                     |
| `BetaInfo`   | table -> table | Information about predictor coefficients.                                 |  yes |
| `VIFs`*       | table -> table | Indicates multicollinearity status.                                      |  yes          |

\* There isn't a `VIFs` subfield in lmOrig.

## `BetaInfo` Sub-subfields

| Variable   | Type  | Description                                                             | 
|------------|-------|--------------------------------------------------------------------------|
| `predictorIndex`       | table -> number | The original index of the beta in question.             |     
| `rejectH0` | table -> boolean | Hypotheses test results for individual betas.                          |   
| `t`       | table -> number | The t-statistic of the beta in question.             |     
| `pValue` | table -> boolean | The p-value of the beta in question.                          |   

## `VIFs` Sub-subfields

| Variable   | Type  | Description                                                             | 
|------------|-------|--------------------------------------------------------------------------|
| `VIF`       | table -> number | Variance Inflation Factors of each beta.             |     
| `summaryVIF` | table -> string| A description of potential multicollinearity                   |          

## Example Usage

```lua
-- regression with 6 datapoints and 3 predictors
local X = {{1, 4, 7}, {2, 3, 5}, {3, 2, 1}, {4, 2, 2}, {5, 8, 3}, {3, 6, 2}}
local Y = {3, 3, 2, 2, 4, 5}

local model = StatBook.multipleLinearRegression(X, Y)

print(model.lmNew.pValueF, model.lmOrig.pValueF, model.lmNew.BetaInfo.t, model.lmNew.BetaInfo.pValue) -- can return a lot more than that

-- rest is optional
local Xtest = {1, 5, 6}
local prediction = predictY(Xtest, model)
```

## Subsequent Usage

After acquiring the model from `module.multipleLinearRegression`, you can employ the `module.predictY(X, model, yHat, indices)` function directly with the returned `model` to predict new \( Y \) values based on new \( X \) values. The `model` object contains all necessary coefficients and information for the prediction.

## Mathematical Background

Multiple Linear Regression aims to model the relationship between multiple independent variables and a dependent variable by fitting a linear equation to the observed data. Here we dive into the mathematical details of how it works.

### Matrices

A multiple linear regression model can be represented in matrix form as:

\[
\mathbf{Y} = \mathbf{X}\beta + \epsilon
\]

- \( \mathbf{Y} \) is a \( n \times 1 \) matrix (column vector) of the dependent variable.
- \( \mathbf{X} \) is a \( n \times p \) matrix of the independent variables, including the intercept.
- \( \beta \) is a \( p \times 1 \) matrix (column vector) of the coefficients.
- \( \epsilon \) is a \( n \times 1 \) matrix (column vector) of the error terms.

### Inverses and Coefficients

The coefficients \( \beta \) can be estimated using the formula:

\[
\hat{\beta} = (\mathbf{X}^T\mathbf{X})^{-1}\mathbf{X}^T\mathbf{Y}
\]

- \( \mathbf{X}^T \) is the transpose of \( \mathbf{X} \).
- \( (\mathbf{X}^T\mathbf{X})^{-1} \) is the inverse of \( \mathbf{X}^T\mathbf{X} \).

### Variance-Covariance Matrix

The variance-covariance matrix \( \Sigma \) of the estimated coefficients is given by:

\[
s^2\{b\} = MSE(\mathbf{X}^T\mathbf{X})^{-1}
\]

- \( MSE \) is the mean squared error.

From the variance-covariance matrix, one can find the variances of the individual betas, and thus conduct individual t-tests.

### Forward Selection Using Mallows' Cp

Mallows' Cp criterion is used for feature selection in multiple linear regression. The Cp statistic is calculated as follows:

\[
C_p = \frac{SSE_p}{MSE} - N + 2(p + 1)
\]

- \( SSE_p \) is the sum of squared errors for the model with \( p \) predictors.
- \( MSE \) is the mean squared error from the full model.
- \( N \) is the total number of observations.
- \( p \) is the number of predictors in the smaller model.

Lower \( C_p \) values indicate a model with a better fit.



