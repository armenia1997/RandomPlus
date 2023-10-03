# How to Use StatBook_v1 Module
Follow these steps to integrate the StatBook_v1 module into your project:

## Step 1: Download the Module
Download the `StatBook_v1` module from [this link](https://www.roblox.com/library/14945241287/StatBook-v1-Statistics-Module).

## Step 2: Place the Module
Place the downloaded `StatBook_v1` module into `ServerScriptService` within your Roblox Studio project.

## Step 3: Import the Module in Your Script
When using the module in your script, add the following line to import it:

```lua
local StatBook = require(game.ServerScriptService.StatBook_v1)
```

##  Step 4: Use Functions from the Module
When you need to use a function from this library, always prepend the function call with "StatBook.". For example:

```lua
local StatBook = require(game.ServerScriptService.StatBook_v1)
local result = StatBook.Median(list)
```

### And you are all set!

By following these steps, you'll be able to use all the statistical functions provided by the StatBook_v1 module in your Roblox game.
