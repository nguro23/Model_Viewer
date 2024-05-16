// Enum to represent different loading strategies for the model viewer.
enum Loading {
  auto, // Automatically determines the loading behavior.
  lazy, // Loads the model lazily, when it comes into view.
  eager // Loads the model eagerly, as soon as possible.
}

// Enum to represent different reveal strategies for the model viewer.
enum Reveal {
  auto, // Automatically determines the reveal behavior.
  interaction, // Reveals the model on user interaction.
  manual // Reveals the model manually through code.
}

// Enum to represent different AR scale modes for the model viewer.
enum ArScale {
  auto, // Automatically scales the model for AR.
  fixed // Keeps the model scale fixed for AR.
}

// Enum to represent different AR placement options for the model viewer.
enum ArPlacement {
  floor, // Places the model on the floor in AR.
  wall // Places the model on the wall in AR.
}

// Enum to represent different touch actions for the model viewer.
enum TouchAction {
  panY, // Allows vertical panning.
  panX, // Allows horizontal panning.
  none // Disables panning.
}

// Enum to represent different interaction prompts for the model viewer.
enum InteractionPrompt {
  auto, // Automatically shows the interaction prompt.
  whenFocused, // Shows the interaction prompt when the viewer is focused.
  none // Disables the interaction prompt.
}

// Enum to represent different styles for the interaction prompt.
enum InteractionPromptStyle {
  wiggle, // Uses a wiggle style for the interaction prompt.
  basic // Uses a basic style for the interaction prompt.
}
