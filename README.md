Techo Lab
An app built for Techo Lab to perform basic authentication and CRUD operations using live mock APIs
from Reqres.in. The app is developed using Flutter and follows clean architecture, Provider for
state management, and Flutter Secure Storage for secure token handling.

✨ Features
✅ Authentication
Login and Register functionality using email and password.

Secure token storage using flutter_secure_storage.

Auth state persistence with auto-login support on app launch.

Logout functionality to clear session/token.

👥 User Management (CRUD)
Create user with mock job title.

Read paginated list of users fetched from API.

Update existing user’s name and job title.

Delete a user (simulated locally, see note below).

🛡️ State Management
Provider package is used for managing:

Authentication state (AuthProvider)

User operations and list (UserProvider)

📦 Secure Storage
Tokens are securely saved using flutter_secure_storage.

All API calls rely on this stored token for authenticated access (simulated).

🖥️ UI Highlights
Responsive and clean UI built using Flutter's Material 3.

Modular reusable components like CardLayout.

Interactive SplashScreen checks authentication status before navigating.

Intuitive user interface with ListTiles and Cards.

📱 Project Structure

lib/
├── models/             # Data models (e.g., UserModel)
├── providers/          # State management (AuthProvider, UserProvider)
├── screens/            # All UI screens (Login, Register, Home, Splash)
├── services/           # API calls (ApiService)
├── widgets/            # Reusable widgets (CardLayout, etc.)
└── main.dart           # App entry point and MultiProvider setup

❗ Note on User Data Handling
This app uses the mock API provided by Reqres, which does not persist changes on the server. To
handle this, several local strategies are used to simulate realistic behavior:

Delete Operation:
Deleted user IDs are tracked locally in a Set. When fetching users, the list is filtered to exclude
these IDs, giving the impression that the user has been deleted.

Create Operation:
When a new user is created, it is added locally to the top of the list with mock data (random ID,
avatar, generated email, etc.). This user is visible only during that session and is not stored on
the server.

Update Operation:
When a user is updated (e.g., name or job title), the job is updated locally in the user object
within the app’s state. Since the API does not return updated data, this local update ensures the
UI reflects the change instantly.

These mechanisms ensure the app behaves as expected while using a mock API that does not actually
modify data server-side.

