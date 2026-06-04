# Barter Flutter API integration

The app connects to the Django backend at `barter-backend` by default.

## Run against the API

1. Start the backend: `python manage.py runserver` (from `barter-backend`).
2. Run the app with live API (mock disabled):

```bash
flutter run --dart-define=USE_MOCK_DATA=false --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

For Android emulator use `http://10.0.2.2:8000` instead of `127.0.0.1`.

## Mock UI mode

```bash
flutter run --dart-define=USE_MOCK_DATA=true
```

Sign in → **Continue as Creator/Brand (mock)** loads `assets/mock/*.json` without HTTP.

## Auth

- Register / sign in on `/sign-in` when `USE_MOCK_DATA=false`.
- JWT tokens are stored with `flutter_secure_storage` and attached as `Authorization: Bearer …`.

## Architecture

- `lib/core/` — Dio client, token storage, config
- `lib/data/dto/` — snake_case API shapes
- `lib/data/mappers/` — DTO → UI view models
- `lib/data/repositories/` — API + mock fallback
- `lib/providers/` — Riverpod wiring

OpenAPI docs: `http://127.0.0.1:8000/api/docs/`
