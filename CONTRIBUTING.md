# Contributing to MindNest

Thank you for your interest in contributing to MindNest! This guide will help you get started.

## 🌟 Ways to Contribute

- **Bug Reports**: Found a bug? Open an issue with details
- **Feature Requests**: Have an idea? Share it with us
- **Code Contributions**: Submit pull requests
- **Documentation**: Improve READMEs, add examples
- **Design**: Suggest UI/UX improvements
- **Testing**: Help test on different devices

## 🚀 Getting Started

### 1. Fork and Clone

```bash
git clone https://github.com/YOUR_USERNAME/mindnest.git
cd mindnest
```

### 2. Set Up Development Environment

**Backend:**
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Frontend:**
```bash
cd frontend
flutter pub get
```

### 3. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

## 📝 Code Style Guidelines

### Python (Backend)

- Follow [PEP 8](https://pep8.org/)
- Use type hints
- Write docstrings for functions
- Keep functions under 50 lines
- Use meaningful variable names

**Example:**
```python
async def detect_emotion(text: str) -> Emotion:
    """
    Detect emotion from text input.

    Args:
        text: User's input text

    Returns:
        Detected emotion enum
    """
    # Implementation
```

### Dart/Flutter (Frontend)

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `const` constructors where possible
- Keep widgets under 300 lines (extract to separate files)
- Use meaningful widget names
- Add comments for complex logic

**Example:**
```dart
/// Displays emotion selection buttons
class EmotionSelector extends StatelessWidget {
  final Function(Emotion) onEmotionSelected;

  const EmotionSelector({
    Key? key,
    required this.onEmotionSelected,
  }) : super(key: key);

  // Implementation
}
```

## 🎨 Design Principles

1. **Calm & Minimal**: Avoid cluttered UI, use whitespace
2. **Soft Colors**: Stick to the gradient palette
3. **Smooth Animations**: 300-400ms transitions, ease curves
4. **Accessibility**: High contrast, readable fonts
5. **Short Sentences**: Under 10 words for meditation text

### Color Palette

```dart
// Primary
primaryGradient: [#667EEA, #764BA2]

// Emotions
anxious: #FF6B6B
sad: #4ECDC4
tired: #95A5F5
calm: #6BCF7F
```

## 🧪 Testing

### Backend Tests

```bash
cd backend
pytest
```

### Frontend Tests

```bash
cd frontend
flutter test
```

### Manual Testing

1. Test on both iOS and Android
2. Test with slow network
3. Test offline mode
4. Test with different text inputs
5. Verify animations are smooth

## 📦 Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] Tested on iOS/Android (for frontend)
- [ ] Updated documentation if needed
- [ ] No console warnings/errors
- [ ] Commits are clean and descriptive

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring

## Testing
How did you test this?

## Screenshots (if UI change)
Before: [image]
After: [image]

## Checklist
- [ ] Code follows style guide
- [ ] Tests added/updated
- [ ] Documentation updated
```

### Review Process

1. Submit PR with clear description
2. Wait for automated tests
3. Address reviewer feedback
4. Get approval from maintainer
5. PR will be merged!

## 🐛 Bug Reports

### Good Bug Report Template

```markdown
**Describe the bug**
Clear description of what's wrong

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What should happen

**Screenshots**
If applicable

**Device Info**
- Device: [e.g. iPhone 12]
- OS: [e.g. iOS 15.0]
- App Version: [e.g. 1.0.0]

**Additional context**
Any other relevant info
```

## 💡 Feature Requests

### Good Feature Request Template

```markdown
**Problem Statement**
What problem does this solve?

**Proposed Solution**
How would you solve it?

**Alternatives Considered**
Other approaches you thought about

**Additional Context**
Mockups, examples, etc.
```

## 🏗️ Architecture Guidelines

### Backend

- Keep routes in `main.py` simple (delegate to services)
- Business logic goes in `services/`
- Data models in `models/schemas.py`
- Keep functions pure when possible

### Frontend

- Screens in `screens/`
- Reusable widgets in `widgets/`
- Services (API, DB) in `services/`
- Models in `models/`
- Use Provider for state management

## 📚 Resources

- [Flutter Docs](https://flutter.dev/docs)
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [Material Design](https://material.io/design)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

## 🤝 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Give constructive feedback
- Focus on what's best for the community

## 📞 Questions?

- Open a GitHub Discussion
- Email: developers@mindnest.ai
- Check existing issues/PRs first

## 🙏 Recognition

Contributors will be added to:
- README.md contributors section
- Release notes
- Special thanks in the app (for major contributions)

---

**Thank you for contributing to MindNest! Together we can help people find their calm.** 💜
