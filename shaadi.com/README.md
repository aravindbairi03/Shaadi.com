# Shaadi.com

A SwiftUI-based application for managing and interacting with match profiles. It supports offline functionality for accepting/rejecting matches and syncs data with the server when the network is available.

# Features

- Fetch and display match profiles using `randomuser` API.
- Accept or reject matches and store actions locally when offline.
- Automatically sync offline actions when the internet is available.
- Persistent data storage using SwiftData.
- Responsive UI built with SwiftUI and image caching using SDWebImageSwiftUI.

# Technologies & Libraries Used

- **Swift** – Main programming language.
- **SwiftUI** – For building modern, declarative user interfaces.
- **Combine** – To manage asynchronous events and API calls.
- **SDWebImageSwiftUI** – For asynchronous image loading and caching.
