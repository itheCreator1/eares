# EARES WordPress

[![CI](https://github.com/itheCreator1/eares/actions/workflows/ci.yml/badge.svg)](https://github.com/itheCreator1/eares/actions/workflows/ci.yml)

**The new home on the web for EARES, the Rizarios Ecclesiastical School Alumni Association** (ΕΑΡΕΣ, Ένωση Αποφοίτων Ριζαρείου Εκκλησιαστικής Σχολής).

The school has been sending graduates out into the world since 1844. The association keeps them in touch with news, events, elections and its own newspaper, *The Rizareitis* (Ο Ριζαρείτης). This repository is the site that does that job: a WordPress install you can rebuild from scratch with one script, locked down so the browser can edit content but never code, and dressed in a theme that looks like it belongs to a 180-year-old institution without looking 180 years old.

> **The one rule of this project:** everything that isn't content lives in git. WordPress core, plugins, roles, the theme, the settings: all of it is code, all of it is reviewed, all of it can be rebuilt. The browser is for writing posts, not for installing things.

---

## At a glance

| | |
|---|---|
| **Stack** | WordPress 7.1 on PHP 8.3 + Apache, MariaDB 11.4, wp-cli and Mailpit, all under Docker Compose with pinned image versions |
| **People** | Six roles, including a custom **User Manager** who runs the membership desk without ever touching an Administrator |
| **Security** | Optional two-factor login, login throttling, no XML-RPC, no application passwords, no leaking of login names, no file edits from the browser |
| **Public site** | A custom block theme with self-hosted Greek fonts, the association's own photos, and a front page built like a bulletin board |
| **Operations** | A production override with automatic HTTPS and security headers; exact core and plugin versions in `versions.env`; nightly backups with retention and an encrypted off-site copy; a restore script that CI proves on every push; setup that you can run as often as you like |
| **Quality** | CI runs coding standards, shellcheck, a full end-to-end smoke test on a fresh stack, and a wipe-and-restore of the backup for every push |

---

## Quick start

You need Docker with Compose. That's it.

```sh
cp .env.example .env        # then change the passwords
docker compose up -d        # WordPress, MariaDB, Mailpit
scripts/setup.sh            # install and configure everything (safe to re-run)
scripts/seed-users.sh       # optional: one fake test user per role
scripts/seed-content.sh     # optional: fake sample posts, to see the theme in action
scripts/smoke-test.sh       # optional: prove it all works
```

A few minutes later:

| URL | What you'll find |
|---|---|
| http://localhost:8080 | The public site |
| http://localhost:8080/wp-admin | The dashboard (admin credentials from `.env`) |
| http://localhost:8025 | Mailpit, which catches every email the site sends: invites, password resets, 2FA codes. Nothing escapes to a real inbox. |
| http://localhost:8081 | Adminer, if you want to look at the database: `docker compose --profile tools up -d adminer` |

Want a clean slate? `docker compose down -v`, then run the quick start again. `setup.sh` checks before it changes anything, so running it twice changes nothing the second time.

---

## The public site

The old eares.gr did its job for years: a portrait of the founder, the school, the church, burgundy everywhere, a login box in the sidebar. The new site keeps its character and loses the clutter.

**The look.** The colours come straight from the photos of the school church: crimson from the brick arches, limestone from the walls, cypress green from the trees in the courtyard and the old site's widgets. Headings are set in GFS Didot, a typeface from the Greek Font Society, with Noto Serif for reading and Commissioner for menus and labels. All three cover full Greek, polytonic included, so a feast-day text in the old accents renders as beautifully as the news. The fonts are served by the site itself: visitors' browsers never call Google, a CDN or the WordPress emoji service.

**The front page reads like a parish bulletin board, only tidier:**

1. The church dome at sunset, with the association's name set in the dark sky beside it.
2. Pinned announcements, such as a call to a general assembly, directly under the photo where nobody can miss them.
3. The latest news on the left. On the right, the front page of the newest issue of *The Rizareitis* and the upcoming events.
4. The welcome text from the old site, next to a photo of the church porch. It says how old the school is, and the number now updates itself every year instead of being stuck at "178".
5. A green band inviting members to renew their subscription.

**The menu** keeps the old sections under clearer names: Home, The Association (Η Ένωση), News (Νέα), The Rizareitis (Ο Ριζαρείτης), The School (Η Σχολή), Subscriptions (Συνδρομές), Contact (Επικοινωνία). The old sidebar login box became a quiet "Members' login" (Είσοδος μελών) link in the header.

**For editors,** everyday tasks need no training beyond "write a post":

| To... | Do this |
|---|---|
| Put an announcement at the top of the front page | Tick *Stick to the top of the blog* on the post; untick it when it's over |
| Publish a new issue of the newspaper | A post in the *The Rizareitis* category (Ο Ριζαρείτης), with the front page as its featured image and the PDF in a File block |
| Announce an event | A post in *Events* (Εκδηλώσεις), with the date and time in the text |

[`docs/site-map.md`](docs/site-map.md) maps every section of the old site onto the new one.

**Under the hood,** the theme lives in [`wp-content/themes/eares/`](wp-content/themes/eares/):

- Colours, fonts and spacing are in `theme.json`.
- Templates and the header and footer are in `templates/` and `parts/`.
- Front-page sections and ready-made blocks for editors are in `patterns/`: a board-members grid, a cross ornament divider, the membership band.
- What `theme.json` can't express (ornaments, the photo overlay, the news list) is in `assets/theme.css`.

**Photos.** The original photos sit in `assets/pictures/` at 10–12 MB each. `scripts/optimize-photo.sh` turns them into WebP copies of 150–290 KB for the theme, so a visitor on a phone doesn't download a poster to read the news.

`setup.sh` builds the site's skeleton:
- the categories;
- the menu pages, with clearly marked "to be completed" placeholders (Προς συμπλήρωση) instead of invented facts;
- the static front page;
- header photos for The Association and The School pages.

It only ever fills gaps, so it never overwrites what editors have written.

---

## Who can do what

WordPress's standard roles, plus two of our own:

| Role | Who | Can |
|---|---|---|
| Administrator | The site admin, plus one backup | Everything |
| **User Manager** (Διαχειριστής Χρηστών, `eares_user_manager`) | The office or secretary | Everything an Editor can, plus create, edit and delete users, change their roles, and reset their 2FA. **Cannot** see, edit or assign Administrators or other User Managers. |
| Editor | Board members (ΔΣ) and the newspaper's editorial team (Ριζαρείτης) | Publish and edit all content, moderate comments |
| Author | Trusted alumni | Publish their own posts |
| Contributor | Other alumni | Write drafts and attach photos; an Editor publishes them |
| **Inactive** (Ανενεργός, `eares_inactive`) | Former board members and the like, case by case | Nothing. Login is refused and open sessions end at once, but their posts and name stay on the site. |

The User Manager is the interesting one. They run the membership desk, but the Administrators are invisible to them: those accounts don't appear in their user list or its counts, the API doesn't return them, and the promote option isn't in their role menu. A forged request is refused too, because the checks happen on the server, not just in the menus.

Two more rules close the obvious loopholes:
- **Self-registration is off.** Only Administrators and User Managers create accounts.
- **Only Administrators may post raw HTML.** Otherwise an Editor's `<script>` could run in an Administrator's browser and walk around every protection above.

The roles are defined in code, in `wp-content/mu-plugins/eares-roles.php`. Change a capability, bump `EARES_ROLES_VERSION`, and the roles are rebuilt on the next request.

---

## Keeping accounts safe

### Two-factor login

Two-factor authentication uses the [Two-Factor](https://wordpress.org/plugins/two-factor/) plugin. It's **optional for everyone**, and each member turns it on from their own profile, choosing from:

- an authenticator app, such as Google Authenticator;
- backup (recovery) codes;
- a code sent by email.

Members have a friendly step-by-step guide in Greek, [`docs/2fa-odigos.md`](docs/2fa-odigos.md), ready to export to PDF or publish as a help page.

**Lost your phone?** An Administrator or User Manager opens **Users**, hovers over the person and clicks **Reset 2FA** (Επαναφορά 2FA). The reset goes into the activity log, and the member gets an email about it, so a reset they didn't ask for never goes unnoticed.

> **Before resetting, confirm who is asking.** Hang up and call back the phone number on their profile, never a number given during the call. A reset leaves the account protected by its password alone.

There's also a guard against the classic takeover: "change the email, reset the 2FA, reset the password". If anyone other than the member changes an account's email address, User Managers can't reset its 2FA for the next 7 days; only an Administrator can.

### Logins

- **Guessing gets expensive.** Five failed logins for one username from one IP, or twenty from one IP in total, lock that IP out for 15 minutes, even with the right password. Lockouts show up in the activity log.
- **Login names stay private.** Author pages use a `member-…` address (`/author/member-5a5385c0b6/`) instead of the login name. Anonymous visitors can't list users through the API, the `?author=N` trick or the sitemap.
- **The side doors are closed.** XML-RPC is off, and so are application passwords, which would otherwise let someone log in without 2FA.

Behind a reverse proxy, WordPress must trust it (`TRUST_PROXY=1`); the production override sets this for you. Otherwise every visitor seems to come from the proxy's IP, and one attacker could lock everybody out.

### The browser can look, but it can't touch

`wp-config` forbids editing and installing code from the dashboard (`DISALLOW_FILE_EDIT`, `DISALLOW_FILE_MODS`). Only wp-cli, run by the scripts, can change WordPress core, plugins or the theme. A stolen admin password can do damage to content, which backups fix, but it can't plant code on the server.

The database sits on a Docker network with no internet access. Locally every port listens on `127.0.0.1` only; in production the only open ports are Caddy's 80 and 443.

---

## The Users screen

Two extra columns you can sort by:

- **2FA**: on or off, at a glance.
- **Last login** (Τελευταία σύνδεση): accounts silent for 12 months or more get a red flag.

The **No login for 12+ months** view (Χωρίς σύνδεση 12+ μήνες) lists just the flagged accounts. Nothing happens to them automatically; a person decides.

The activity log (Simple History) is visible to Administrators and User Managers only, and User Managers don't see events by or about Administrators and other User Managers.

---

## Deploying to production

Production is the same stack with one override file on top, [`docker-compose.prod.yml`](docker-compose.prod.yml). It changes three things:

- **HTTPS in front.** [Caddy](https://caddyserver.com/) listens on ports 80 and 443, gets and renews a Let's Encrypt certificate for your domain by itself, and redirects plain HTTP to HTTPS. Its configuration is [`deploy/Caddyfile`](deploy/Caddyfile).
- **WordPress is only reachable through Caddy.** It publishes no port at all, and it's told to trust the proxy (`TRUST_PROXY`) and require HTTPS for logins (`FORCE_SSL_ADMIN`).
- **No Mailpit.** Mail goes to the real SMTP provider set in `.env`. `setup.sh` refuses to run in production while `SMTP_HOST` still says `mailpit`.

### What you need

- A Linux server with Docker and Compose, with ports 80 and 443 open to the internet (and nothing else listening on them).
- A DNS `A` (and `AAAA`, if the server has IPv6) record pointing the domain at the server. Caddy can't get a certificate until it does.
- An SMTP account with a mail provider.

### First deployment

```sh
git clone https://github.com/itheCreator1/eares.git && cd eares
cp .env.example .env
```

Edit `.env`:

| Setting | Value |
|---|---|
| `COMPOSE_FILE` | Uncomment it: `docker-compose.yml:docker-compose.prod.yml`. Every `docker compose` command and every script now uses the production override, so you never type `-f`. |
| `SITE_DOMAIN`, `ACME_EMAIL` | The domain (e.g. `eares.gr`) and an address Let's Encrypt can warn about expiring certificates |
| `WP_URL` | `https://` plus the domain, exactly. WordPress stores it on first install. |
| `WP_ENVIRONMENT_TYPE` | `production` |
| Every `change-me` password | Long random values: `openssl rand -base64 24` |
| `SMTP_*`, `MAIL_FROM` | Your mail provider's settings, and a sender address on your own domain |
| `BACKUP_REMOTE`, `BACKUP_PING_URL` | The encrypted off-site remote and a monitoring URL ([Backup and restore](#backup-and-restore)) |

Then:

```sh
docker compose up -d --wait   # Caddy, WordPress, MariaDB
scripts/setup.sh
```

Open `https://<your domain>/wp-admin`, log in, and check that a password-reset email actually arrives. Then work through [Before going live](#before-going-live).

### Day to day on the server

Everything under [Running it](#running-it) works the same way, because `COMPOSE_FILE` in `.env` applies the override everywhere. To deploy a new version of the code:

```sh
git pull
docker compose up -d --wait   # recreates only the containers whose config changed
scripts/setup.sh              # applies any new settings, roles or content structure
```

The theme and the mu-plugins are mounted straight from the checkout, so `git pull` alone puts new code live; `setup.sh` catches up the database side.

### What the proxy adds

Every response carries:

| Header | Why |
|---|---|
| `Strict-Transport-Security: max-age=31536000` | Browsers refuse plain HTTP for a year. Deliberately without `includeSubDomains` and `preload`, which would force HTTPS on every other subdomain too and are hard to undo. |
| `X-Content-Type-Options: nosniff` | No guessing of file types, so an upload can't be run as a script |
| `X-Frame-Options: SAMEORIGIN` and CSP `frame-ancestors 'self'` | Other sites can't frame the login page (clickjacking) |
| CSP `object-src 'none'; base-uri 'self'` | No plugins, no hijacked base URL. A full script policy would break the block editor, so there isn't one. |
| `Referrer-Policy: strict-origin-when-cross-origin` | Other sites see only the domain, never the full address |
| `Permissions-Policy` | No camera, microphone, location, payment or USB access for any page |

The `Server` and `X-Powered-By` headers are removed, and responses are compressed.

### Limits and logs

- **Uploads** go up to 64 MB per file, enough for a full issue of *The Rizareitis* as a PDF or a photo straight off a phone. The PHP side is [`deploy/php/eares.ini`](deploy/php/eares.ini), the proxy side is `request_body` in the Caddyfile; raise both together.
- **Container logs** rotate at 10 MB, keeping five files per container, so they can't quietly fill the disk. `docker compose logs caddy` shows the access log.
- **Certificates** live in the `caddy_data` volume. Keep it: `docker compose down -v` deletes it along with the database, and Let's Encrypt limits how often you can ask for a new certificate.

---

## Running it

### Updating

Every server runs exactly the WordPress core and plugin versions in [`versions.env`](versions.env), and so does CI, so what was tested is what runs. Neither the dashboard nor a newer Docker image changes them: core lives in the `wp_data` volume, and `DISALLOW_FILE_MODS` keeps the browser out. At least once a month, and whenever a security release comes out:

1. `scripts/update.sh --check` lists releases newer than the pins. It changes nothing.
2. Bump the numbers in `versions.env` in a pull request. CI builds the site with exactly those versions and runs every check. When core changes, bump the `wordpress` image tag in `docker-compose.yml` to the same version, so a fresh volume starts on it.
3. Merge, then on the server: `git pull && scripts/update.sh`. Outside `local` it takes a backup first.

`update.sh` and `setup.sh` never downgrade. If the server is somehow ahead of `versions.env`, they say so and leave it, because older code can't be trusted with a database that newer code already migrated. Translations aren't pinned; they follow the installed versions.

The PHP coding-standard tools are pinned too, by `composer.lock`.

### Backup and restore

`scripts/backup.sh` writes one set per run into `backups/`: `db-<time>.sql.gz`, `uploads-<time>.tar.gz` and `checksums-<time>.sha256`. Each file is checked before it counts (`gzip -t`, `tar -t`), and the folder is readable by its owner only, because the dump holds members' emails, phones and password hashes. Core and plugins aren't included, because `setup.sh` reinstalls them at the versions in `versions.env`.

Then it:
- **copies the set off-site** when `BACKUP_REMOTE` is set in `.env`. A backup that lives next to the thing it backs up is a comforting story, not a backup;
- **prunes** sets older than `BACKUP_KEEP_DAYS` (14) locally and `BACKUP_REMOTE_KEEP_DAYS` (90) off-site, only ever touching its own files;
- **pings** `BACKUP_PING_URL`, if set, so a monitor such as healthchecks.io tells you when backups stop.

**Off-site, encrypted.** The copy goes through [rclone](https://rclone.org), which speaks to almost every storage provider (S3, Backblaze B2, SFTP, Google Drive...). It runs in its own container, so nothing needs installing on the server. Configure a storage remote and, on top of it, a `crypt` remote, so the provider only ever sees encrypted files:

```sh
mkdir -p rclone
docker compose run --rm --user "$(id -u):$(id -g)" rclone config   # 1. your storage, e.g. "b2"   2. a "crypt" remote over b2:eares-backups, e.g. "eares-offsite"
```

Then set `BACKUP_REMOTE=eares-offsite:` in `.env` and run `scripts/backup.sh` once by hand. **Keep a copy of `rclone/rclone.conf` (or at least the crypt passwords) somewhere other than the server**: without them the off-site backups can't be decrypted. `rclone/` is not in git.

**Every night.** On the server, with the checkout in `/srv/eares` and a user `eares` that may run docker (edit the two unit files if yours differ):

```sh
sudo cp deploy/systemd/eares-backup.* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now eares-backup.timer
systemctl list-timers eares-backup.timer        # next run
journalctl -u eares-backup.service              # past runs
```

No systemd? A cron line does the same: `30 3 * * * cd /srv/eares && scripts/backup.sh >> backups/backup.log 2>&1`.

**Restore.** `scripts/restore.sh` checks the checksums, asks you to type the backup time, then replaces the database and the uploads entirely. Run `scripts/setup.sh` straight after: on a fresh stack it reinstalls core and plugins, and it re-applies the settings.

```sh
scripts/restore.sh                      # newest set in backups/
scripts/restore.sh 20261030-033000      # a specific set
scripts/restore.sh --remote             # newest set off-site (e.g. the server is gone)
scripts/setup.sh
```

To rebuild on a new server: clone the repo, put back `.env` and `rclone/rclone.conf`, `docker compose up -d`, then `scripts/restore.sh --remote` and `scripts/setup.sh`.

CI does exactly that on every push: it backs up the test site to an off-site remote, wipes every container and volume, comes back as `production` with new passwords, restores from the remote, runs `setup.sh`, and checks that posts, users, settings and every uploaded file match, before running the smoke test again.

### Email

The site sends mail over SMTP using the `SMTP_*` settings in `.env`, with STARTTLS whenever the server offers it. Locally that's Mailpit; in production it's whichever provider you choose.

---

## Quality checks

```sh
composer install && vendor/bin/phpcs   # WordPress coding standards
shellcheck scripts/*.sh                # shell scripts
scripts/smoke-test.sh                  # needs the stack + seed-users.sh + seed-content.sh
```

The smoke test drives a real running site and checks:
- the roles and the anti-escalation rules;
- the hardening: XML-RPC, the users API, author URLs;
- the theme and its pages;
- the login lockout.

[CI](.github/workflows/ci.yml) runs all of it on every push, on a stack built from nothing, and finishes with the backup-wipe-restore test described under [Backup and restore](#backup-and-restore).

---

## Project map

| Path | What it does |
|---|---|
| `docker-compose.yml` | The services, with pinned images. The database is on an internal network, and ports bind to 127.0.0.1. The `wp-config` hardening is set here: file edits off, code installs only from wp-cli, `FORCE_SSL_ADMIN`, and HTTPS detection behind a proxy. Container logs rotate. |
| `docker-compose.prod.yml` | The production override: Caddy with HTTPS, WordPress reachable only through it, no Mailpit |
| `deploy/Caddyfile` | The reverse proxy: TLS, HTTP→HTTPS redirect, security headers, upload size limit |
| `deploy/php/eares.ini` | PHP upload limits (64 MB) and no PHP version in headers |
| `wp-content/mu-plugins/eares-roles.php` | The custom roles and the rules that stop anyone climbing above their role |
| `wp-content/mu-plugins/eares-users-admin.php` | Last login, the 2FA and last-login columns, the Reset 2FA action and its 7-day guard, the Inactive login block, the allowed 2FA methods, and who sees what in the activity log |
| `wp-content/mu-plugins/eares-login-limit.php` | Login throttling |
| `wp-content/mu-plugins/eares-hardening.php` | Registration off; XML-RPC and application passwords off; no user listing for anonymous visitors; `member-…` author addresses |
| `wp-content/mu-plugins/eares-profile.php` | A private phone field (not in the API; included in personal-data export and erasure) and a simpler profile screen |
| `wp-content/mu-plugins/eares-mail.php` | SMTP from the `.env` settings |
| `wp-content/themes/eares/` | The public site's block theme |
| `scripts/setup.sh` | Installs and configures everything: core and plugins at the `versions.env` versions, the Greek language pack, settings, the theme and the site structure. Refuses the `change-me` passwords outside `local`, and never hides a live production site from search engines on a re-run. |
| `scripts/setup-content.php` | Categories, menu pages, the static front page and page header photos (run by `setup.sh`) |
| `versions.env` | The exact WordPress core and plugin versions every install runs |
| `scripts/update.sh` | Brings core and plugins to `versions.env` (after a backup), refreshes translations; `--check` lists newer releases |
| `scripts/backup.sh` | Backs up the database and uploads into `backups/`, copies them off-site, prunes old sets |
| `scripts/restore.sh` | Puts a backup back, from `backups/` or from off-site |
| `deploy/systemd/` | The nightly backup timer |
| `scripts/optimize-photo.sh` | Resizes a photo to WebP for the theme |
| `scripts/seed-users.sh`, `scripts/seed-content.sh` | Fake test users and sample posts; both refuse to run in production |
| `scripts/smoke-test.sh` | End-to-end checks against a running stack |
| `docs/site-map.md` | The old site mapped onto the new one, and how editors handle announcements, issues and events |
| `docs/2fa-odigos.md` | The members' 2FA guide, in Greek |
| `.github/workflows/ci.yml` | CI: PHP syntax, PHPCS, shellcheck, then the full stack with the smoke test, a backup, a wipe and a restore |

---

## Language

Greek is the site's language. Anyone can switch their own admin screens to English from their profile. The EARES additions follow that choice for the role names; their other labels (columns, the phone field, messages) are in Greek only.

---

## Before going live

- [ ] Check that the Two-Factor plugin's Greek translation is complete. If it isn't, ship a Greek `.po`/`.mo` file.
- [ ] Choose a production SMTP provider and set `SMTP_*` in `.env`. The email 2FA option depends on reliable delivery.
- [ ] Set `WP_ENVIRONMENT_TYPE=production` and change every `change-me` password (`setup.sh` refuses them outside `local` anyway). A new production site starts hidden from search engines; on launch day tick it visible in Settings > Reading (or set `BLOG_PUBLIC=1` in `.env`). Re-running `setup.sh` won't undo that.
- [ ] Deploy with the production override ([Deploying to production](#deploying-to-production)). It serves the site over HTTPS only and sets `FORCE_SSL_ADMIN` and `TRUST_PROXY` for you. If you use your own proxy instead, set both in `.env` and make sure WordPress can only be reached through it.
- [ ] Check the headers once the site is live, for example at [securityheaders.com](https://securityheaders.com/) and [SSL Labs](https://www.ssllabs.com/ssltest/).
- [ ] Set up the encrypted off-site remote and `BACKUP_REMOTE`, enable `eares-backup.timer`, set `BACKUP_PING_URL`, and keep a copy of `rclone/rclone.conf` off the server ([Backup and restore](#backup-and-restore)). Then do one real `scripts/restore.sh --remote` on a spare machine.
- [ ] Put `scripts/update.sh --check` on a monthly calendar ([Updating](#updating)).
- [ ] Replace the "to be completed" placeholders (Προς συμπλήρωση) on the pages: the history, the board members, the subscription amount and IBAN, the contact details.
