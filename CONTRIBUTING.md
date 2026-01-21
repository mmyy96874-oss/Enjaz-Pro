# Contributing to Enjaz Pro

Thank you for your interest in contributing to Enjaz Pro! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Issues
1. Check existing issues to avoid duplicates
2. Use the issue template when creating new issues
3. Provide detailed information including:
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Screenshots (if applicable)
   - Device/browser information

### Suggesting Features
1. Check if the feature has already been requested
2. Create a detailed feature request with:
   - Clear description of the feature
   - Use cases and benefits
   - Possible implementation approach
   - Mockups or examples (if applicable)

### Code Contributions

#### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Git knowledge
- Understanding of Flutter/Dart best practices

#### Development Setup
1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/project-management.git
   cd project-management
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Generate model files:
   ```bash
   flutter packages pub run build_runner build
   ```
5. Run the app:
   ```bash
   flutter run -d web-server --web-port=8080
   ```

#### Coding Standards

##### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use proper indentation (2 spaces)

##### Architecture Guidelines
- Follow Clean Architecture principles
- Use GetX for state management
- Implement proper error handling
- Write reusable widgets
- Separate business logic from UI

##### File Organization
```
lib/
├── core/                   # Core functionality
│   ├── constants/         # App constants
│   ├── services/          # Core services
│   └── utils/             # Utility functions
├── data/                  # Data layer
│   ├── models/            # Data models
│   └── repositories/      # Data repositories
├── presentation/          # Presentation layer
│   ├── controllers/       # GetX controllers
│   └── widgets/           # Reusable widgets
└── view/                  # UI screens
```

##### Naming Conventions
- **Files**: snake_case (e.g., `user_profile_page.dart`)
- **Classes**: PascalCase (e.g., `UserProfilePage`)
- **Variables/Functions**: camelCase (e.g., `userName`, `getUserData()`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `API_BASE_URL`)

#### Pull Request Process

1. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**
   - Write clean, well-documented code
   - Follow the coding standards
   - Add tests if applicable
   - Update documentation if needed

3. **Test Your Changes**
   ```bash
   # Run tests
   flutter test
   
   # Check for analysis issues
   flutter analyze
   
   # Format code
   flutter format .
   ```

4. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: add user profile editing functionality"
   ```

5. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Use the PR template
   - Provide clear description of changes
   - Link related issues
   - Add screenshots for UI changes

#### Commit Message Format
Use conventional commits format:
```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat(auth): add password reset functionality
fix(dashboard): resolve statistics calculation error
docs(readme): update installation instructions
```

## 🧪 Testing Guidelines

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests
- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for user flows
- Aim for good test coverage
- Use descriptive test names

### Test Structure
```dart
group('AuthController', () {
  late AuthController authController;
  
  setUp(() {
    authController = AuthController();
  });
  
  test('should login user with valid credentials', () {
    // Arrange
    const email = 'test@example.com';
    const password = 'password123';
    
    // Act
    final result = authController.login(email, password);
    
    // Assert
    expect(result, isA<UserModel>());
  });
});
```

## 📝 Documentation

### Code Documentation
- Add dartdoc comments for public APIs
- Document complex algorithms
- Include usage examples
- Keep documentation up to date

### README Updates
- Update README for new features
- Add screenshots for UI changes
- Update installation instructions if needed
- Keep feature list current

## 🐛 Bug Reports

### Before Reporting
1. Search existing issues
2. Try to reproduce the bug
3. Check if it's already fixed in latest version

### Bug Report Template
```markdown
**Bug Description**
A clear description of the bug.

**Steps to Reproduce**
1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior**
What you expected to happen.

**Actual Behavior**
What actually happened.

**Screenshots**
If applicable, add screenshots.

**Environment**
- OS: [e.g. Windows 10]
- Browser: [e.g. Chrome 96]
- Flutter version: [e.g. 3.0.0]
- App version: [e.g. 1.0.0]
```

## 🎯 Feature Requests

### Feature Request Template
```markdown
**Feature Description**
A clear description of the feature.

**Problem Statement**
What problem does this solve?

**Proposed Solution**
How should this feature work?

**Alternatives Considered**
Other solutions you've considered.

**Additional Context**
Any other context or screenshots.
```

## 📋 Code Review Guidelines

### For Contributors
- Keep PRs focused and small
- Write clear commit messages
- Add tests for new functionality
- Update documentation
- Respond to feedback promptly

### For Reviewers
- Be constructive and respectful
- Focus on code quality and standards
- Check for security issues
- Verify tests pass
- Test functionality manually

## 🏷️ Release Process

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create release branch
4. Test thoroughly
5. Create release PR
6. Tag release after merge
7. Deploy to production

## 📞 Getting Help

- Create an issue for bugs or questions
- Join discussions in existing issues
- Check documentation first
- Be patient and respectful

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow
- Follow community guidelines

Thank you for contributing to Enjaz Pro! 🚀