# Step 3: Create View Model

## Overview
In this step you'll hook everything up and create a functioning MVP (minimum viable product) of PickPocket. You'll also expand the app to include a list of previous guesses to make guessing a code easier.

![pick-pocket-ios](../images/pick-pocket-wireframe.png)

## Steps
1. Connect the UI elements to the view controller

1. Create a view model
    - The view model should:
        - Contain a `private` instance of a `Lock`
        - Expose the length of the lock in the correct format for the indicator (will you need to change your `Lock` implementation to make this possible?)
        - Expose the correct and misplaced counts of the most recent guess as a feedback String in emoji format
        - Expose an emoji to indicate whether the user has cracked the code.
        - Have a function to receive user input from the digit buttons
        - Keep track of the digits the user has guessed and expose them in the appropriate format
        - Submit the guess when it is long enough and process the resulting `PickPocketResult`

1. Connect the view controller to the view model
    - The view controller should have an instance of the view model
    - User action (`IBAction`) methods should call view model methods with the appropriate input
    - The view should update with output from the view model

1. Write unit tests that verify that your view model is handling user input correctly and is outputting the correct feedback. One of the major benefits of using MVVM that you can test what the user will see without having to worry about a view controller, so make sure your tests cover all user interactions.

___
At this point, you should be able to use the app to pick exactly one lock. You've built the MVP of PickPocket, now let's expand it!

5. Add the ability to reset the lock, both after the code has been guessed, and at any point while guessing

1. Create a model to keep track of previous guesses

1. Add a list to the UI to display the previous guesses from top to bottom (see #5 in the wireframes above)

1. Add the previous guess model to the view model and expose the appropriate information to the view
    - The view model should update the guess history when it submits a guess
    - The guess history should be cleared out when the lock code changes

## Acceptance Criteria

When this step is done:

- The lock code length indicator should display the length of the code being guessed.
- When a user presses a button, a digit should be added to a readout.
- When a guess has reached the length of the lock code, the guess should automatically submit and the readout should clear.
- When a guess response is received:
    - The guess readout should clear
    - The lock indicator should update
        - If a guess is incorrect, the indicator should display a locked emoji 🔒.
        - If a guess is correct, the indicator should display an unlocked emoji 🔓.
    - A row containing feedback should be added to the bottom of the previous guesses list
        - The guess itself should be shown on the right
        - The guess feedback on the left should show the `correct` number of black dots ⚫ and the `misplaced` number of white dots ⚪. e.g. if the guess result contains 2 `correct` and 1 `misplaced`, the feedback should be ⚫⚫⚪, no matter the order of the `correct` and `misplaced` digits
    - If a guess was correct, a dialog to reset the lock should be presented
- When a user resets the lock, the previous guess list, guess readout and lock indicator clear out
