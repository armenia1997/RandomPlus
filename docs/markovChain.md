# `markovChain(states, transitionProbs, startState, length, returnFullSequence)`

### Overview

Generates a sequence of states based on a Markov Chain model.

### Parameters

| Parameter              | Type      | Description                                                                              |
|------------------------|-----------|------------------------------------------------------------------------------------------|
| `states`               | Table     | List of possible states in the Markov Chain.                                             |
| `transitionProbs`      | Table     | Transition probability matrix between states.                                            |
| `startState`           | Any       | The state to start the sequence from.                                                    |
| `length`               | Number    | The length of the sequence to be generated.                                              |
| `returnFullSequence`   | Boolean   | Whether to return the full sequence or just the final state. Default is `false`.         |

### Returns

| Return                 | Type      | Description                                                                               |
|------------------------|-----------|-------------------------------------------------------------------------------------------|
| `sequence` or `sequence[length]` | Table or Any  | Returns the entire sequence if `returnFullSequence` is true; otherwise, returns the last state.|

### Example

```lua
local states = {"Sunny", "Cloudy", "Rainy"}
local transitionProbs = {
	Sunny = {Sunny = 0.8, Cloudy = 0.15, Rainy = 0.05},
	Cloudy = {Sunny = 0.2, Cloudy = 0.6, Rainy = 0.2},
	Rainy = {Sunny = 0.1, Cloudy = 0.3, Rainy = 0.6}
}
local startState = "Sunny"
local length = 10
local sequence = StatBook.markovChain(states, transitionProbs, startState, length, true)
print(sequence)  -- Output will be a table representing the sequence
```

### Mathematical Background

The function generates a sequence based on a Markov Chain, which models the transitions between various states with certain probabilities. A Markov Chain is defined by its states and the transition probabilities between these states. The function takes a `startState` and moves to the next state based on the given `transitionProbs`, repeating this process for `length` times. The `chooseNextState` function is used internally to select the next state based on the current state and the transition probabilities.





