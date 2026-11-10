# Moodle 4.0.12 (Build 20231211) — Coolify experimental branch

Branch: `moodle-4.0.12-coolify`. Original `moodle-4.0.12` is unchanged.

## Deploy
Create a **new** Git-backed Docker Compose resource in Coolify, branch
`moodle-4.0.12-coolify`, Compose path `/compose.yaml`.

Coolify generates `SERVICE_URL_MOODLE_80` (web service, port 80),
`SERVICE_PASSWORD_MOODLE` (database user),
`SERVICE_PASSWORD_MOODLEROOT` (database root), and
`SERVICE_PASSWORD_MOODLEADMIN` (Moodle admin). Verify their generated values
under Environment Variables. Set `MOODLE_ADMIN_EMAIL` to a real address.

Set the Moodle domain to HTTPS in Coolify. Check that
`SERVICE_URL_MOODLE_80` matches the intended public URL before deploying.
Do not expose the database service publicly.

The first run creates Moodle tables via CLI. Subsequent deployments preserve
database and moodledata volumes and **do not automatically upgrade** the database.
The cron service runs every minute after installation.

## Safety
- Moodle 4.0.12 and PHP 8.0 are end-of-life. This is for isolated staging only.
- **Do not attach an existing production database or moodledata volume** to this
  experimental stack. Back up and test restore procedures before migration.
- Generated passwords are stored in Coolify, not Git; avoid changing database
  credentials after initialization without a coordinated MariaDB update.
- Initial admin password is passed to the Moodle CLI installer; do not share
  deployment logs, process snapshots or environment variables.
- Do not merge into the default branch before testing the build and installation.
- Installation may fail on an interrupted first run, in which case inspect
  logs and recover manually; never delete populated volumes blindly.
