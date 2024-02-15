# Engineering Standards and Rules

## Core Rules

1. Absolute Zero-Emoji Policy:
   - No emojis are permitted anywhere in the source code, comments, commit messages, or user documentation.
   - Text and logs must remain clean, professional, and strictly technical.

2. Tone and Style:
   - Avoid marketing hype, promotional buzzwords, and AI boilerplate.
   - Keep comments concise, accurate, and directly related to implementation mechanics.

3. Architecture and Privacy:
   - Offline-First: Never make network requests or add telemetry services.
   - Local Ownership: All user records and imported files must be kept in app-managed local storage.
   - SQLite as Single Source of Truth: All screens derive state from canonical database queries.
