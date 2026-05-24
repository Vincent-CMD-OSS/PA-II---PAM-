# CHANGES

This file summarizes code changes and runtime actions applied during the recent work on the Informasi Umum CRUD and UI improvements.

## Backend
- Added local SQLite fallback when Postgres/Supabase is unreachable (pure-Go driver) so the API can run locally.
  - File: `backend/monolith/go-template-main/pkg/database/conn.go`
  - Dependency: added `github.com/glebarez/sqlite` to `go.mod`.
- Enabled auto-migrate at startup to create the `informasi_umum` table when DB is available or fallback is used.
  - File: `backend/monolith/go-template-main/app/app.go`
- Added model, repository, usecase, and controller for `InformasiUmum` (CRUD endpoints).
  - Files:
    - `backend/monolith/go-template-main/app/models/informasi_umum.go`
    - `backend/monolith/go-template-main/app/repositories/informasi_umum_repository.go`
    - `backend/monolith/go-template-main/app/usecases/informasi_umum_usecase.go`
    - `backend/monolith/go-template-main/app/controllers/informasi_umum_controller.go`
    - `backend/monolith/go-template-main/app/models/migration.go` (added to migrate list)
    - `backend/monolith/go-template-main/sql/informasi_umum.sql`
- Created root `.env` (copied from `cmd/.env`) so the app can start from repository root during development.

## Web (React admin)
- Implemented preview modal and added `Lihat` button in the admin CRUD list to preview detail layout.
  - File: `PA3/web/react-kia/src/pages/Admin/InformasiUmumManagement.jsx`
- The admin CRUD page already uses the service in `PA3/web/react-kia/src/services/informasiUmum.js` for API calls.

## Mobile (Flutter)
- Added `InformasiUmumModel` and API service to fetch list/detail from backend.
  - Files:
    - `TA-PA2/mobile/kia_app/lib/features/tumbuh_kembang/data/models/informasi_umum_model.dart`
    - `TA-PA2/mobile/kia_app/lib/features/tumbuh_kembang/data/datasources/informasi_umum_api_service.dart`
- Rewrote the Informasi Umum list screen to use backend data.
  - File: `TA-PA2/mobile/kia_app/lib/features/tumbuh_kembang/presentation/screens/informasi_umum/informasi_umum_screen.dart`
- Rebuilt the detail screen to render:
  - Hero image with fallback, badges, title, Ringkasan
  - Parsed “Tutorial Edukasi” steps (numbered cards)
  - `Materi Inti` accordion
  - `Yang Perlu Diingat` info box
  - File: `TA-PA2/mobile/kia_app/lib/features/tumbuh_kembang/presentation/screens/informasi_umum/informasi_umum_detail_screen.dart`
  - Added helper widgets `_AccordionSections` and parsing helpers (`_parseNumberedSteps`, `_parseSections`, `_parseReminders`).
- Added missing asset used by the Edukasi card: `TA-PA2/mobile/kia_app/assets/images/hero_edukasi.png`.

## Runtime actions performed
- Ran `go mod tidy` and `go get` to add dependencies.
- Started backend locally; when Supabase was unreachable the app used the SQLite fallback and auto-migrated tables.
- Created a sample Informasi Umum entry via API (`POST /informasi-umum`) and verified via `GET /informasi-umum`.

## How to run / verify locally
1. Start backend (from repository root):
```powershell
Push-Location backend/monolith/go-template-main
go run cmd/main.go
```
2. Run web dev server (in `PA3/web/react-kia`):
```bash
npm install
npm run dev
```
Open admin page and use the CRUD form / `Lihat` preview.
3. Run Flutter app (in `TA-PA2/mobile/kia_app`):
```bash
flutter pub get
flutter run
```
Open Informasi Umum list and the detail view to see the new layout.

## Notes & recommendations
- The SQLite fallback is intended for local development only. Consider gating it behind an environment flag (DEV_ONLY) or revert it before deploying to production.
- Parsing of `konten` is heuristic. For robust rendering across platforms, consider storing structured content (JSON with `sections`, `steps`, `reminders`) and updating admin editor & backend accordingly.

If you want, I can:
- Create a `CHANGES.md` commit and push it to the current branch.
- Make the SQLite fallback conditional on an env var, or revert it.
- Implement a structured content editor in the web admin and corresponding backend change.
