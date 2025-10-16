# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**Pulse** is a Flutter-based mobile application currently in early development (POC stage). It is designed primarily for seniors (65+), helping users reflect on their emotional state, receive gentle AI summaries, and optionally share weekly updates with family.

## Product Goals (POC Stage)

- Daily emotional check-ins via push notifications
- Large-text, senior-friendly UI for input
- AI-generated nightly summaries
- Optional weekly email sent to family members
- Simple onboarding with age input and family share toggle

## Tech Stack

| Component     | Technology     | Notes |
|---------------|----------------|-------|
| Frontend      | Flutter (Dart) | Cross-platform |
| Backend       | Supabase       | Auth, DB, cron |
| AI Summaries  | OpenAI GPT-4o-mini | Start with prompt template |
| Email         | SendGrid       | For summary delivery |
| Hosting       | Supabase       | Simple and scalable |
| Versioning    | Git + GitHub   | Feature branch model |

## Development Commands

### Flutter
- `flutter pub get` - Install dependencies
- `flutter run` - Launch the app
- `flutter test` - Run all tests
- `flutter test <path/to/test_file.dart>` - Run a specific test file
- `flutter analyze` - Static analysis
- `flutter build <platform>` - Build for specific platform (e.g., android, ios)

### Code Quality
- `dart format .` - Format all Dart code
- `dart fix --apply` - Apply automated fixes

## Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── onboarding_screen.dart
│   ├── reflection_screen.dart
│   ├── summary_screen.dart
│   └── settings_screen.dart
├── services/
│   ├── supabase_service.dart
│   ├── ai_service.dart
│   └── email_service.dart
├── models/
│   └── reflection_model.dart
├── utils/
│   └── constants.dart
└── widgets/
    └── large_button.dart

test/
.env (gitignored)
pubspec.yaml
```

## Environment Setup

- Create a `.env` file in the project root with the following keys:
  - `SUPABASE_URL` - Your Supabase project URL
  - `SUPABASE_ANON_KEY` - Your Supabase anonymous key
  - `OPENAI_API_KEY` - OpenAI API key for AI summaries
  - `SENDGRID_API_KEY` - SendGrid API key for email delivery
- All secrets are gitignored and must never be committed

## Architecture Notes

### Backend (Supabase)
- Database tables for user profiles, daily reflections, and summaries
- Edge Functions for scheduled tasks (nightly summary generation, weekly emails)
- Authentication for user management
- Row-level security policies to protect user data

### AI Integration
- Use OpenAI GPT-4o-mini for generating summaries
- Prompt templates should be simple and focused on emotional well-being
- Summary generation runs as a Supabase Edge Function triggered by cron

### Email Delivery
- SendGrid integration for weekly family emails
- Email templates should be simple, readable, and accessible

## Development Guidelines

- Prioritize clarity and accessibility in all UI elements
- Use async/await pattern consistently with Supabase and OpenAI API calls
- Default to large fonts (18pt+) and high-contrast colors for senior-friendly UI
- Keep POC scope focused - log feature ideas for v2 in `v2_ideas.md`
- No HIPAA compliance required, but handle personal data responsibly

## POC Success Criteria

- End-to-end testable: user check-in → AI summary → family email
- At least 5 real users use it for 2 weeks
- At least 3 say they'd miss it if removed
