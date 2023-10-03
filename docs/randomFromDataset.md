# `randomFromDataset(values, kernel, percentageOfFrameTime, bandwidth)`

### Overview

Generates a random number based on a given dataset using Kernel Density Estimation (KDE).

### Parameters

| Parameter              | Type      | Description                                                                               |
|------------------------|-----------|-------------------------------------------------------------------------------------------|
| `values`               | Table     | The dataset from which to generate the random number.                                      |
| `kernel`\*               | String    | The type of kernel to use for the KDE. Default is Gaussian.                                |
| `percentageOfFrameTime`| Number    | The percentage of frame time allowed for the function to run. Default is 0.1.              |
| `bandwidth`            | Number    | The bandwidth to use in the KDE. Calculated by default if not provided.                    |

\* Options for `kernel` are: "Gaussian", "Epanechnikov", "Uniform", "Triangular", "Biweight", "Cosine", "Logistic", and "Sigmoid".

### Returns

| Return                 | Type      | Description                                                                               |
|------------------------|-----------|-------------------------------------------------------------------------------------------|
| `xRandom`              | Number    | A random number generated based on the KDE of the dataset.                                 |

### Example

```lua
local dataset = {1, 2, 3, 3, 4, 4, 5, 6, 7}
local kernelType = "Gaussian"
local percentageOfFrameTime = 0.1
local randomValue = StatBook.randomFromDataset(dataset, kernelType, percentageOfFrameTime)
print(randomValue)  -- Output will vary
```

### Mathematical Background

The function uses Kernel Density Estimation (KDE) to approximate the probability density function of the given dataset. The KDE is computed for multiple points within the data range, and the maximum density \( \text{maxY} \) is determined. Random coordinates \((x, y)\) are generated within this computed density. The \( y \)-value of the coordinate is compared to the KDE value at \( x \), and if \( y \leq \text{KDE}(x) \), then \( x \) is returned as the generated random number.

The kernel density estimation is given by:

\[
\text{KDE}(x) = \frac{1}{n \times \text{bandwidth}} \sum_{i=1}^{n} K\left(\frac{x - x_i}{\text{bandwidth}}\right)
\]

where \( K(u) \) is the kernel function and \( n \) is the number of data points. Different types of kernel functions like Gaussian, Epanechnikov, etc., can be used.









