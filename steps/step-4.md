# Step 4: Networking

## Overview
In this step, you'll add the ability to crack a remote lock. The app should function the exact same way after implementing this step, but now the user will be able to choose between remote and local locks.

## Steps

1. Add a networking class that allows you to crack a single remote lock using an API.

    We'll call this class `RequestManager`. `RequestManager` should:
    - Be a [singleton](http://krakendev.io/blog/the-right-way-to-write-a-singleton) and live in a folder called `Networking`
    - Return all data asynchronously to its callers via a callback closure.
    - Use the interface below (you can write as many private helper functions as you need)

        ```swift
        static let shared = RequestManager()

        func post(guess: String,
                  username: String,
                  completion: @escaping ((Result<PickPocketResult>) -> Void)) {}

        ```
    > You will need to use Intrepid's [Swift Wisdom](https://github.com/IntrepidPursuits/swift-wisdom) library using Cocoapods in order to access the `Result` enum that is used in the `post` function.

1. Implement the body of the `post` function
    Take a look at the [API request documentation](https://github.com/IntrepidPursuits/pick-pocket-server/wiki/Pick-Lock) to determine what the backend is expecting. You should probably test out this web request in an app like [Postman](https://www.getpostman.com/) before adding it to your app. You can use the username, guess and token shown in the example request on the API reference page for your testing.

    1. Create a `URLRequest` and populate it with the required data.
        - To create the request body, you'll have to convert the guess and the user token into JSON, and then into `Data`. Consider using [Codable](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) for this
        - Note that when you send the guess to the API, it needs it to be in the form `"[2,3,2]"` rather than `"232"`. You should think about where the appropriate place to do that transformation might be.
    1. Send the `URLRequest` using `URLSession`'s `dataTask` function
        - Don't forget that you'll have to handle server errors somewhere. Think about where that handling should occur.
    1. Parse the server response and pass it into the completion

        - You may need to create a helper object or write a custom init to handle the response JSON format

1. Update the `Lock` model to handle both local and remote locks. You'll need to modify the submit function to return a callback containing a `PickPocketResult` rather than returning it directly.
    - Hint: this is a good opportunity to use protocol-oriented programming.

1. Update the view model and UI to allow the user to switch between picking a remote lock and a local lock.
