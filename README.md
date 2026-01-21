# Enjaz Pro - Project Management System

A comprehensive Flutter-based project management application with role-based authentication and real-time collaboration features.

## 🚀 Features

### Authentication & User Management
- **Role-based Authentication**: Super Admin, Admin, and User roles
- **Secure Login/Registration**: Email and password authentication
- **Profile Management**: Update user information and preferences
- **Password Recovery**: Forgot password functionality

### Project Management
- **Project Creation & Management**: Create, edit, and manage projects
- **Task Assignment**: Assign tasks to team members
- **Progress Tracking**: Real-time project and task progress monitoring
- **Status Management**: Track project status (Active, Completed, Paused, Cancelled)
- **PERT Chart Visualization**: Project timeline and dependency visualization

### Dashboard & Analytics
- **Role-specific Dashboards**: Customized views for each user role
- **Statistics Cards**: Project counts, completion rates, and performance metrics
- **Real-time Updates**: Live data synchronization across all users
- **Notification System**: In-app notifications for project updates

### Multi-platform Support
- **Web Application**: Responsive web interface
- **Mobile Ready**: Android and iOS support
- **Cross-platform**: Windows, macOS, and Linux desktop support

## 🏗️ Architecture

### Clean Architecture Pattern
```
lib/
├── core/                   # Core functionality
│   ├── constants/         # App constants
│   ├── services/          # Core services (Database, API, Storage)
│   └── utils/             # Utility functions
├── data/                  # Data layer
│   ├── models/            # Data models
│   └── repositories/      # Data repositories
├── presentation/          # Presentation layer
│   ├── controllers/       # GetX controllers
│   └── widgets/           # Reusable widgets
└── view/                  # UI screens
    ├── admin_pages/       # Admin dashboard
    ├── login_pages/       # Authentication screens
    ├── super_admin/       # Super admin dashboard
    └── user/              # User dashboard
```

### State Management
- **GetX**: Reactive state management with dependency injection
- **Reactive Programming**: Observable data streams for real-time updates

### Data Storage
- **Local Database**: SharedPreferences for web compatibility
- **Offline Support**: Full offline functionality with data synchronization
- **Sample Data**: Pre-populated test data for demonstration

## 🛠️ Technologies Used

- **Flutter 3.x**: Cross-platform UI framework
- **Dart**: Programming language
- **GetX**: State management and dependency injection
- **SharedPreferences**: Local data storage
- **JSON Annotation**: Model serialization
- **UUID**: Unique identifier generation

## 📱 User Roles & Permissions

### Super Admin
- Full system access and control
- User management (create, edit, delete users)
- System-wide project oversight
- Database management and reset functionality
- Analytics and reporting

### Admin
- Project management within assigned scope
- Team member management
- Task assignment and tracking
- Project approval/rejection
- Performance monitoring

### User
- Personal dashboard with assigned projects
- Task management and progress updates
- Project creation requests
- Profile management
- Notifications and updates

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Web browser (for web development)
- Android Studio / VS Code (recommended IDEs)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ismailbasha1/project-management.git
   cd project-management
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   # For web
   flutter run -d web-server --web-port=8080
   
   # For mobile
   flutter run
   
   # For desktop
   flutter run -d windows  # or macos/linux
   ```

## 🔐 Default Login Credentials

The application comes with pre-configured test accounts:

| Role | Email | Password | Name |
|------|-------|----------|------|
| Super Admin | superadmin@enjaz.com | 123456 | مدير النظام الرئيسي |
| Admin | admin@enjaz.com | 123456 | أحمد محمد الإداري |
| User | user1@enjaz.com | 123456 | سارة أحمد |
| User | user2@enjaz.com | 123456 | محمد علي |

## 🌐 Web Access

Once running, access the application at:
- **Local Development**: http://localhost:8080
- **Production**: [Your deployed URL]

## 📊 Key Features Walkthrough

### 1. Authentication Flow
- Login with role-based redirection
- Registration with role assignment
- Password recovery system
- Automatic session management

### 2. Dashboard Experience
- **Super Admin**: System overview, user management, global statistics
- **Admin**: Project management, team oversight, approval workflows
- **User**: Personal projects, task management, progress tracking

### 3. Project Management
- Create new projects with detailed information
- Assign team members and set deadlines
- Track progress with visual indicators
- Manage project status and milestones

### 4. Real-time Updates
- Live notifications for project changes
- Automatic data synchronization
- Responsive UI updates across all connected users

## 🔧 Configuration

### Database Reset
Super Admins can reset the database to restore default sample data:
1. Login as Super Admin
2. Click the refresh icon in the app bar
3. Confirm the database reset operation

### Environment Setup
The application automatically initializes with sample data for testing purposes. In production, you may want to:
- Disable automatic sample data creation
- Configure external API endpoints
- Set up proper authentication backends

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Known Issues

- Web platform uses SharedPreferences instead of SQLite for compatibility
- Some UI elements may need RTL (Right-to-Left) adjustments for Arabic text
- Mobile responsiveness may need fine-tuning on smaller screens

## 🔮 Future Enhancements

- [ ] Real-time chat and collaboration
- [ ] File upload and document management
- [ ] Advanced reporting and analytics
- [ ] Integration with external calendar systems
- [ ] Mobile push notifications
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Export functionality (PDF, Excel)

## 📞 Support

For support and questions:
- Create an issue in this repository
- Contact: [Your contact information]

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX community for state management solutions
- Contributors and testers who helped improve the application

---

**Built with ❤️ using Flutter**