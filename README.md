# StoryTechTest

StoryTechTest is a SwiftUI-based iOS application that demonstrates a social media-like stories feature, similar to Instagram. The app is modular, using a clean architecture with separation of concerns for networking, services, models, and UI components. It uses mock data for development purpose.

## Features

- **Stories Feed:** Browse user stories with avatars, images, and interaction (like, seen).
- **Mock Data:** Uses local JSON (`mock_users.json`) for user and story data.
- **Networking Layer:** Abstracted networking with support for local and remote data sources.
- **Service Layer:** Business logic for fetching and updating stories.
- **Design System:** Centralized spacing and design tokens for consistent UI.

## Project Structure

```
StoryTechTest/
├── Assets.xcassets/         # App assets (images, icons)
├── Components/             # Reusable UI components
├── Core/
│   ├── Models/             # Data models (e.g., StoryUser)
│   ├── HomeView.swift      # Main home screen
│   └── RootTabView.swift   # Tab navigation
├── DesignSystem/           # Design tokens (e.g., spacing)
├── Networking/             # Networking logic
├── Services/               # Business logic/services
├── mock_users.json         # Mock data for stories/users
├── StoryTechTestApp.swift  # App entry point
StoryTechTestTests/         # Unit tests
StoryTechTestUITests/       # UI tests
```

### Dependencies
- [Factory](https://github.com/hmlongco/Factory): Dependency injection for fast easy and managed DI
- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI): Image loading, handle caches

### Missed Features
- Likes / isSeen are only implemented in the scope of the story itself ( when dismissing the StoryView we lose the data ) since it's not persisted through StoriesService.
- routing between different users stories ( for now when user has no more stories it dismisses the StoryView )

### Technical Debts 
- Decouple Routing from UI should be handled by viewModels that takes a module routing in init.
- StoryBubbleViewModel should use the StoriesService that holds the centralized data and not get the story from its parent.
- Decouple Networking layer that handles only DTOs that should be mapped to domain entities before reaching viewModels .
- Make Networking and DesignSystem as a separate SPM modules that exposes only protocols.
- Handle displaying Errors.
- Unit/UI tests.

## Mock Data
- The app uses `mock_users.json` for local development. You can modify this file to change the stories and users displayed in the app.
