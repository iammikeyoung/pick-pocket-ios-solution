# Step 1: Create Models

## Overview
In this step, you'll implement the business logic for the `Lock` and `GuessResult` models.

A completed `Lock` should be initialized with a code (you'll have to write this part). When you submit a guess `String`, you will get back a `GuessResult`. The `GuessResult` should contain the number of `correct` and `misplaced` digits in the guess as per the rules.

The starter project contains an incomplete implementation of the models, shown below. You may adjust them as needed. Don't stress out too much about getting the logic exactly correct. If you're still working on this at the end of the second day, your mentor will help you through it or provide the solution.

```Swift
struct Lock {
    func submit(guess: String) -> GuessResult {
        return PickPocketResult(correct: 0, misplaced: 0)
    }
}
```

```Swift
struct GuessResult {
    let correct: Int
    let misplaced: Int
}
```

## Steps
1. Implement the logic of the `submit` function. It should function as described [here](https://docs.google.com/a/intrepid.io/document/d/1Wywului461Y45yPI0grVbXJd6oj6FukvSLCbRmFJaLw/edit?usp=sharing).

2. Write unit tests that verify that the game logic is working correctly.
