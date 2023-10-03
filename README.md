# StatBook: A Statistics Module for Roblox

## Overview

This is a comprehensive Statistics module designed specifically for Roblox games. It provides a wide range of statistical functions, from basic descriptive statistics to advanced hypothesis testing and random variate generation.

> For a more comprehensive overview of the module, go to [this link]()

## Features

- **Hypothesis Testing**
  - Inference (One-Sample, Two-Sample, Three-Plus Sample tests)
  - Multiple Linear Regression (with Mallow's C(p) forward selection)
  - Predict Y (for use with Multiple Linear Regression)
  - Categorical Testing (Odds Ratio, One Sample Proportion CI, etc.)
  
- **Random Variate Generation**
  - Non-Scaled (Standard Normal, Normal, Gamma, etc.)
  - Scaled (Standard Normal Scaled, Normal Scaled, etc.)
  - Continuous Random Values from Dataset (via Kernel Density Estimation)
  - Customized Distributions 
  - 
  
- **Other Basic Statistics**
  - Sum of Squares
  - Mean, Median, Mode
  - Range, Standard Deviation, Variance
  - Interquartile Range
  - and more...
  
- **Complex Functions**
  - Erf, Inverf
  - Gamma
  - Hypergeometric 2F1
  - and more...

## Installation

To install, go to [this link](https://www.roblox.com/library/14945241287/StatBook-v1-Statistics-Module) and download. Then, simply place the `StatBook_v1` module script inside your Roblox game's `ServerScriptService` directory.

## Usage

Detailed usage instructions can be found in the `How_To_Use.md` file.

```lua
-- Example usage in Roblox Lua
local stats = require("game.ServerScriptService.StatBook_v1")

local mean = stats.mean({1, 2, 3, 4, 5})
print("Mean:", mean)
```
