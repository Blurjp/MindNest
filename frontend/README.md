# MindNest - Flutter Frontend

Beautiful, calming meditation app built with Flutter for iOS and Android.

## Features

- **Emotion Detection**: Select your mood or type how you feel
- **AI Meditation**: Get personalized meditation sessions
- **Animated Sessions**: Calming breathing animations during meditation
- **Mood Journaling**: Track your emotional progress over time
- **Progress Charts**: Visualize your weekly improvement
- **Sleep Routines**: Pre-defined guided meditation programs
- **Local Storage**: All your data saved locally with SQLite

## Screenshots

### Home Screen
- Gradient background (soft blue to purple)
- 4 emotion buttons with emojis
- Text input for natural language emotion detection
- Quick access to journal and routines

### Session Screen
- Breathing circle animation (inhale/exhale)
- Real-time subtitle display
- Progress indicator
- Completion survey for mood tracking

### Journal Screen
- Weekly improvement percentage card
- 7-day mood trend chart
- List of recent sessions with emotion changes

## Setup

### Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Install dependencies**:
   ```bash
   cd frontend
   flutter pub get
   ```

2. **Configure API URL**:

   Open `lib/services/api_service.dart` and update the backend URL:
   ```dart
   static const String baseUrl = 'http://YOUR_BACKEND_URL:8000';
   ```

   For local development:
   - iOS Simulator: `http://localhost:8000`
   - Android Emulator: `http://10.0.2.2:8000`
   - Physical Device: `http://YOUR_COMPUTER_IP:8000`

3. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                # App entry point
├── models/                  # Data models
│   ├── emotion.dart         # Emotion enum
│   ├── meditation_session.dart
│   ├── journal_entry.dart
│   └── sleep_routine.dart
├── screens/                 # UI screens
│   ├── home_screen.dart     # Emotion selection
│   ├── session_screen.dart  # Meditation playback
│   ├── journal_screen.dart  # Mood tracking
│   ├── settings_screen.dart # User preferences
│   └── routines_screen.dart # Sleep programs
└── services/                # Business logic
    ├── api_service.dart     # Backend API calls
    └── database_service.dart # Local SQLite storage
```

## Key Dependencies

```yaml
dependencies:
  # State Management
  provider: ^6.1.1

  # Networking
  http: ^1.1.2
  dio: ^5.4.0

  # Local Storage
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2

  # Audio
  audioplayers: ^5.2.1
  just_audio: ^0.9.36

  # Charts
  fl_chart: ^0.65.0

  # Voice Recording
  record: ^5.0.4
  permission_handler: ^11.1.0
```

## Building for Release

### iOS

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and archive.

### Android

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

## Design System

### Colors

- **Primary Gradient**: `#667EEA` → `#764BA2` (blue to purple)
- **Session Background**: `#4A5B8C` → `#2D3561` (dark blue)
- **Emotion Colors**:
  - Anxious: `#FF6B6B` (soft red)
  - Sad: `#4ECDC4` (soft teal)
  - Tired: `#95A5F5` (soft purple)
  - Calm: `#6BCF7F` (soft green)
  - Neutral: `#B8C5D6` (soft gray)

### Typography

- **Font**: Poppins (install custom font or use system default)
- **Sizes**:
  - Title: 36px bold
  - Heading: 24px bold
  - Body: 16-18px regular
  - Caption: 12-14px

### Spacing

- Large: 40-48px
- Medium: 24-32px
- Small: 12-16px

## Animations

1. **Breathing Circle** (Session Screen):
   - 4-second cycle (inhale/exhale)
   - Scale: 1.0 → 1.3
   - Opacity: 0.6 → 0.1

2. **Loading State** (Home Screen):
   - Pulsing circle while generating meditation
   - Infinite repeat with reverse

3. **Subtitle Animation** (Session Screen):
   - Show 5 words at a time
   - Auto-scroll based on speech duration

## Local Data Storage

### Database Schema

**journal_entries**:
- `id` INTEGER PRIMARY KEY
- `emotion_before` TEXT
- `emotion_after` TEXT
- `session_type` TEXT
- `timestamp` TEXT

**user_settings**:
- `key` TEXT PRIMARY KEY
- `value` TEXT

## API Integration

The app communicates with the FastAPI backend at `/api` endpoints:

- `POST /api/emotion` - Detect emotion from text
- `POST /api/meditate` - Generate meditation session
- `POST /api/journal` - Log mood entry
- `GET /api/journal` - Retrieve entries
- `GET /api/routines` - Get sleep routines

See `lib/services/api_service.dart` for implementation.

## MVP Limitations

- No real audio playback (mock URLs)
- No voice recording (text input only)
- Local-only data storage (no cloud sync)
- Single user (no authentication)
- Limited to 3 sessions per day (not enforced yet)

## Future Enhancements

- [ ] Real TTS audio playback
- [ ] Voice recording with emotion detection
- [ ] User authentication and cloud sync
- [ ] Push notifications for daily reminders
- [ ] Social sharing of progress
- [ ] Premium features (unlimited sessions, custom voices)
- [ ] Background audio playback
- [ ] Offline mode with pre-downloaded meditations
- [ ] Apple Health / Google Fit integration

## Troubleshooting

### "Unable to connect to backend"
- Ensure backend is running on correct URL
- Check firewall settings
- Use correct IP for physical device testing

### "Database locked" error
- Close and restart the app
- Clear app data if persists

### Fonts not loading
- Ensure font files are in `assets/fonts/`
- Run `flutter clean && flutter pub get`

## Contributing

1. Follow Flutter style guide
2. Keep UI minimal and calming
3. Test on both iOS and Android
4. Maintain consistent color scheme

## License

MIT
