import Foundation

import Slipstream

/// A single-screen reference for buying a machine, installing GitLab on it, and
/// moving GitHub repositories and Actions runners over to it.
struct SelfHostedGitLab: View {
  var body: some View {
    CheatSheetPage(
      "Looking for something to do while GitHub is down?",
      path: "/cheatsheets/self-hosted-gitlab",
      description: "GitHub was degraded 523 hours this year. Here is what it costs to run GitLab on your own hardware instead, with today's parts prices, the install commands, the migration steps for repositories and Actions runners, and a break-even calculator.",
      keywords: [
        "self-hosted GitLab",
        "GitLab migration",
        "GitHub Actions migration",
        "GitLab runner",
        "home server",
        "GitHub downtime",
        "CI/CD",
      ],
      topBarNote: "Prices and uptime data read on August 6, 2026",
      scripts: [URL(string: "/scripts/gitlab-breakeven.js")],
      lede: {
        numbers
      },
      rail: {
        Div {
          RawHTML("""
<p class="cs-summary-machine">Pricing <b id="rig-note">nothing yet</b></p>
<div class="cs-summary-figures">
  <div><b id="s-capex">$1,092</b><span>Hardware</span></div>
  <div><b id="s-payoff">&hellip;</b><span>Time to pay off</span></div>
</div>
""")
        }
        .className("cs-tile cs-panel-facts cs-s1")

        Div {
          Div {
            H3 { DOMString("When does it pay off?") }
            Div {
              Span { RawHTML("<i style=\"background:var(--series-2)\"></i>GitHub, cumulative") }
              Span { RawHTML("<i style=\"background:var(--series-1)\"></i>Self-hosted, cumulative") }
            }
            .className("cs-legend")
          }
          .className("cs-chart-head")

          Div {
            RawHTML("<svg id=\"breakeven-plot\" class=\"cs-plot\" role=\"img\" aria-label=\"Cumulative cost of GitHub versus a self-hosted GitLab instance over 36 months\"></svg>")
            RawHTML("<div id=\"breakeven-tip\" class=\"cs-tip\"></div>")
          }
          .className("cs-plot-wrap")

          Div { RawHTML("<span id=\"verdict\">…</span>") }
            .className("cs-verdict")

          Div {
            Div {
              RawHTML("""
  <div class="cs-presets" role="group" aria-label="Starting profiles">
    <button type="button" class="cs-preset" data-preset="ios" aria-pressed="false">Solo iOS</button>
    <button type="button" class="cs-preset" data-preset="web" aria-pressed="false">Solo web</button>
    <button type="button" class="cs-preset" data-preset="startup" aria-pressed="true">Startup</button>
    <button type="button" class="cs-preset" data-preset="scaleup" aria-pressed="false">Scaling</button>
  </div>
  <p class="cs-preset-note" id="preset-note"></p>
  """)
              RawHTML("""
  <div class="cs-fieldset-title">Your team</div>
  <div class="cs-field"><label for="f-devs">Developers<b><span id="v-devs">8</span></b></label><input id="f-devs" type="range" min="1" max="200" step="1" value="8"></div>
  <div class="cs-field"><label for="f-rate">Dev cost / hour<b>$<span id="v-rate">110</span></b></label><input id="f-rate" type="range" min="5" max="300" step="1" value="110"></div>
  <div class="cs-field"><label for="f-admin">Upkeep / month<b><span id="v-admin">3</span> hrs</b></label><input id="f-admin" type="range" min="0" max="40" step="0.5" value="3"></div>
  <p class="cs-readout-hint">Patching GitLab and the runner hosts, checking backups restore. Priced at the hourly rate above.</p>
  <div class="cs-field cs-field-wide">
    <label for="f-plan-1">GitHub plan</label>
    <div class="cs-segmented" role="radiogroup" aria-label="GitHub plan">
      <input type="radio" name="plan" id="f-plan-0" value="0"><label for="f-plan-0">Free<em>$0</em></label>
      <input type="radio" name="plan" id="f-plan-1" value="1" checked><label for="f-plan-1">Team<em>$4</em></label>
      <input type="radio" name="plan" id="f-plan-2" value="2"><label for="f-plan-2">Enterprise<em>$21+</em></label>
    </div>
  </div>

  <div class="cs-fieldset-title">CI minutes / month</div>
  <div class="cs-field"><label for="f-linux">Linux minutes<b><span id="v-linux">20,000</span></b></label><input id="f-linux" type="range" min="0" max="1000" step="1" value="750"></div>
  <div class="cs-field"><label for="f-macos">macOS minutes<b><span id="v-macos">2,000</span></b></label><input id="f-macos" type="range" min="0" max="1000" step="1" value="580"></div>
  <div class="cs-field cs-picker">
    <label for="f-linux-tier">Linux runner</label>
    <select id="f-linux-tier">
      <option value="0" selected>2-core &middot; $0.006</option>
      <option value="1">4-core &middot; $0.012</option>
      <option value="2">8-core &middot; $0.022</option>
      <option value="3">16-core &middot; $0.042</option>
    </select>
  </div>
  <div class="cs-field cs-picker">
    <label for="f-mac-tier">macOS runner</label>
    <select id="f-mac-tier">
      <option value="0" selected>4-core &middot; $0.062</option>
      <option value="2">12-core &middot; $0.077</option>
      <option value="1">M2 Pro &middot; $0.102</option>
    </select>
  </div>
  <p class="cs-readout-hint" id="minutes-hint"></p>
  <p class="cs-readout-hint" id="speed-hint"></p>

  <details class="cs-group">
    <summary>Outages</summary>
    <div class="cs-group-body">
      <div class="cs-field"><label for="f-ghup">GitHub uptime<b><span id="v-ghup">89.9</span>%</b></label><input id="f-ghup" type="range" min="85" max="100" step="0.1" value="89.9"></div>
      <div class="cs-field"><label for="f-selfup">Self-hosted uptime<b><span id="v-selfup">99.5</span>%</b></label><input id="f-selfup" type="range" min="90" max="100" step="0.1" value="99.5"></div>
      <div class="cs-field"><label for="f-block">Blocks you<b><span id="v-block">15</span>%</b></label><input id="f-block" type="range" min="0" max="100" step="1" value="15"></div>
    </div>
  </details>

  <details class="cs-group">
    <summary>Running the box</summary>
    <div class="cs-group-body">
      <div class="cs-field cs-field-wide cs-readout">
        <span>Hardware<b id="r-capex">$0</b></span>
        <span>Power draw<b id="r-watts">0 W</b></span>
      </div>
      <p class="cs-readout-hint">Set by the machine counts on the cards.</p>
      <div class="cs-field"><label for="f-kwh">Electricity<b>$<span id="v-kwh">0.16</span>/kWh</b></label><input id="f-kwh" type="range" min="0.05" max="0.60" step="0.01" value="0.16"></div>
    </div>
  </details>
  """)
            }
            .className("cs-fields")

            Div {
              Div {
                RawHTML("""
  <details class="cs-group cs-group-flush">
    <summary>Where the money goes</summary>
    <table class="cs-compare">
      <thead>
        <tr><th>Every month</th><th>On GitHub</th><th>On your own</th></tr>
      </thead>
      <tbody id="cost-rows"></tbody>
    </table>
  </details>
  """)
              }
              .className("cs-compare-wrap")
            }
          }
          .className("cs-calc")

          RawHTML("""
<details class="cs-method">
  <summary>How this is calculated</summary>
  <dl>
    <dt>GitHub seats</dt>
    <dd>Free $0, Team $4, Enterprise from $21 per user per month, off <a href=\"https://github.com/pricing\" rel=\"noreferrer\">github.com/pricing</a>. Both paid tiers quote first-year rates, so treat them as floors. Self-managed GitLab is free at any seat count.</dd>
    <dt>Actions minutes</dt>
    <dd>Rates come from <a href="https://docs.github.com/en/billing/reference/actions-minute-multipliers" rel="noreferrer">GitHub's published per-minute table</a>. The free allowance of 2,000, 3,000 or 50,000 only applies to standard runners, and macOS spends it 10× faster. Larger runners are billed from the first minute.</dd>
    <dt>Turnaround</dt>
    <dd>A hosted 2-core runner and a 14-core tower do not take the same time over the same job. Speed-up is capped at 4× because build steps do not all parallelise.</dd>
    <dt>Apple silicon costs more</dt>
    <dd>GitHub charges $0.102 a minute for the 5-core M2 Pro against $0.077 for the 12-core Intel. Fewer cores, higher price, because Apple silicon capacity is scarcer. Owning the Mac sidesteps the choice.</dd>
    <dt>What an hour costs</dt>
    <dd>Three numbers, depending on how you earn.</dd>
    <dd><b>Salaried:</b> pay plus overhead. The <a href="https://www.bls.gov/ooh/computer-and-information-technology/software-developers.htm" rel="noreferrer">US Bureau of Labor Statistics</a> put the median developer at $133,080 in May 2024, about $85 an hour with 30% overhead.</dd>
    <dd><b>Contracting:</b> what they bill, since an idle hour is unbilled. Senior freelance web runs about $115 an hour.</dd>
    <dd><b>App Store:</b> no hourly rate exists, so use what you forgo. An hour you cannot work is an hour you could have sold to somebody else, which puts a solo indie near the salaried figure, around $95. Pricing the hour against app revenue instead gives a much smaller number: <a href="https://www.revenuecat.com/state-of-subscription-apps/" rel="noreferrer">RevenueCat</a> puts the top 10% of subscription apps at $2,500 a month, roughly $16 an hour, and the median at $72 a month. That measures how big the business is, not what an idle hour costs, since subscriptions keep renewing while you wait for GitHub.</dd>
    <dt>Downtime</dt>
    <dd>Developers × hours down × the share that stops you × their hourly cost. Hours down comes off 160 working hours, not 730, because a 3am outage costs nothing.</dd>
    <dt>Downtime that blocks you</dt>
    <dd>The share of GitHub's downtime that actually stops your work. Most incidents degrade one service rather than take everything out, so the default is 15%: of 16 hours down, about 2 hours cost you something.</dd>
    <dt>Your box</dt>
    <dd>Power around the clock, its own downtime on the same terms, and the upkeep hours above. GitLab ships security releases roughly monthly, so the upkeep number is the one that decides whether this is worth doing at all: at 8 hours a month it costs more than most teams' GitHub bill.</dd>
    <dt>Not counted</dt>
    <dd>Your network, and the Saturday you spend fixing your own outage.</dd>
  </dl>
</details>
""")
        }
        .className("cs-tile cs-panel-calc cs-s2")
      }
    ) {
      jumpNav
      hardware
      install
      backups
      migrate
      runners
      footer
    }
  }

  // MARK: - Hero

  @ViewBuilder
  private var jumpNav: some View {
    Navigation {
      Link("Why", destination: URL(string: "#numbers"))
      Link("1 · Buy the box", destination: URL(string: "#hardware"))
      Link("2 · Install GitLab", destination: URL(string: "#install"))
      Link("3 · Back it up", destination: URL(string: "#backups"))
      Link("4 · Migrate from GitHub", destination: URL(string: "#migrate"))
      Link("5 · Runners & CI", destination: URL(string: "#runners"))

      RawHTML("""
<div class="cs-jump-tools">
  <label class="cs-host"><span>Your domain</span><input id="f-host" type="text" value="gitlab.example.com" spellcheck="false" autocomplete="off"></label>
  <div class="cs-mode" role="group" aria-label="Instruction style">
    <button type="button" class="cs-mode-btn" data-mode="human" aria-pressed="true">Human</button>
    <button type="button" class="cs-mode-btn" data-mode="agent" aria-pressed="false">Agent</button>
  </div>
</div>
""")
    }
    .className("cs-jump")
  }

  // MARK: - 1. Hardware

  @ViewBuilder
  private var hardware: some View {
    CheatSheetSection(
      number: 1,
      title: "Buy the box",
      summary: "GitLab wants 8 vCPU and 16 GB for one node. All three clear it.",
      accentClass: "cs-s1",
      anchor: "hardware",
      agentPrompt: AgentPrompts.hardware
    ) {
      for rig in gitLabRigs {
        RigTile(rig: rig)
      }

      Tile("Power protection", subtitle: "So an outage does not corrupt the database") {
        for accessory in gitLabAccessories {
          AccessoryRow(accessory: accessory)
        }
        Note("Amazon links are affiliate links. Every price was read off its listing on \(priceVerifiedOn), not estimated, and will have moved since.")
      }

      Tile("Why the parts cost this much", subtitle: "Every price on this page was pulled live on \(priceVerifiedOn)", width: .wide, identifier: "tile-row-start") {
        Text {
          RawHTML("Datacenter demand has roughly doubled memory and NAND prices this year. Memory and storage are now most of what you pay, so buying last generation is what keeps the bill down.")
        }
        RefTable(
          headers: ["Instead of", "Buy", "Saves"],
          rows: [
            ["32 GB DDR5-5600 · $529.94", "32 GB DDR4-3200 · $249.99", "$279.95"],
            ["64 GB DDR5-6000 · $949.99", "32 GB, and add later", "$700.00"],
            ["2 TB NVMe · $374.95", "1 TB NVMe · $249.99", "$124.96"],
            ["8-core Zen 5 · $279.99", "14-core i5-13500 · $279.99", "6 more cores"],
          ],
          numericColumns: [2]
        )
        Bullets([
          "<b>DDR4 on LGA 1700 is where the value is.</b> A 13th-gen i5 gives you 14 cores on cheap memory. The DDR5 equivalent costs $280 more for six fewer cores.",
          "<b>1 TB is plenty.</b> GitLab wants 40 GB plus your repos, and most teams' whole history is a few gigabytes. Buy more when you run out.",
          "Buy the <b>least memory that clears 16 GB</b>. Add more when prices fall.",
          "Stock moves weekly. Several parts here had no buybox the day this was written.",
        ])
      }

      Tile("Sizing rules", subtitle: "Straight from GitLab's requirements page") {
        RefTable(
          headers: ["Resource", "Baseline", "Notes"],
          rows: [
            ["CPU", "8 vCPU", "4 is fine for a few users. GitLab advises against burstable cloud instances such as AWS t-series, which throttle under sustained load"],
            ["Memory", "16 GB", "8 GB is the documented floor, with swap"],
            ["App disk", "40 GB", "Plus every repository you import"],
            ["Postgres", "5–12 GB", "12 GB if you enable Ultimate features"],
            ["Storage", "SSD", "Gitaly is I/O bound, so keep repos off NFS and network shares"],
          ]
        )
        Note("Omnibus bundles Redis and Postgres. You install neither.")
      }

      Tile("Network setup", subtitle: "Do this before you install anything") {
        Bullets([
          "Give the box a <b>DHCP reservation</b> so its address never moves.",
          "Pick a real hostname you control, like <code>gitlab.example.com</code>, even on a LAN. Certificates and clone URLs bake it in.",
          "Point it at the LAN IP with split-horizon DNS, or add it to every <code>/etc/hosts</code>.",
          "Open <b>22</b>, <b>80</b> and <b>443</b>. Keep it off the public internet unless you want to run a reverse proxy and fail2ban.",
          "Remote access without port-forwarding: Tailscale or a Cloudflare Tunnel.",
        ])
      }
    }
  }

  // MARK: - 2. Install

  @ViewBuilder
  private var install: some View {
    CheatSheetSection(
      number: 2,
      title: "Install GitLab",
      summary: "Ubuntu 24.04 LTS and the Omnibus package, in about four commands.",
      accentClass: "cs-s2",
      anchor: "install",
      agentPrompt: AgentPrompts.install,
      agentFields: """
<div class="cs-prompt-fields">
  <label class="cs-prompt-field">
    <span>How you log into the new machine</span>
    <input id="f-ssh" type="text" spellcheck="false" autocomplete="off" placeholder="ubuntu@192.168.1.20">
  </label>
  <label class="cs-prompt-field">
    <span>TLS</span>
    <select id="f-tls">
      <option value="Let&#39;s Encrypt, the machine is reachable on port 80">Let&#39;s Encrypt</option>
      <option value="my own certificate, already at /etc/gitlab/ssl">My own certificate</option>
    </select>
  </label>
</div>
"""
    ) {
      Tile("Prepare the OS", subtitle: "Ubuntu 24.04 LTS server") {
        CodeBlock("""
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl openssh-server ca-certificates tzdata perl

# Outbound notification mail. Choose "Internet Site" and
# enter the hostname you picked above.
sudo apt install -y postfix

sudo timedatectl set-timezone America/New_York
sudo systemctl enable --now ssh
""")
        Note("Skip Postfix if you send mail through SMTP. That goes in <code>gitlab.rb</code>.")
      }

      Tile("Install the package", subtitle: "One package, and it is the Enterprise one") {
        CodeBlock("""
curl --location \\
  "https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh" \\
  | sudo bash

sudo EXTERNAL_URL="https://gitlab.example.com" apt install gitlab-ee
""")
        Note("GitLab ships two builds. <b>CE</b> is the community edition, <b>EE</b> is the enterprise one, and they are the same binary: with no licence applied, EE runs the Free feature set exactly as CE does. Install <code>gitlab-ee</code> anyway, because moving to a paid tier later is then a licence upload rather than a reinstall and migration. GitLab explains the split in <a href=\"https://docs.gitlab.com/administration/install/\" rel=\"noreferrer\">its installation docs</a>.")
      }

      Tile("First login", subtitle: "The root password self-destructs in 24 hours") {
        CodeBlock("""
sudo cat /etc/gitlab/initial_root_password

# Sign in at https://gitlab.example.com as "root",
# then immediately:
#   Admin > Settings > General > Sign-up restrictions
#     - untick "Sign-up enabled"
#   Admin > Settings > General > Visibility
#     - default project visibility: Private
#   User > Preferences > SSH Keys - add your key
""")
        Note("If the file is already gone, reset the password instead.")
        CodeBlock("""
sudo gitlab-rake "gitlab:password:reset[root]"
""")
      }

      Tile("TLS", subtitle: "Two paths, pick one") {
        Text { RawHTML("<b>Public DNS.</b> Omnibus requests a Let's Encrypt certificate automatically when <code>EXTERNAL_URL</code> is <code>https://</code> and port 80 is reachable.") }
        CodeBlock("""
# /etc/gitlab/gitlab.rb
letsencrypt['enable'] = true
letsencrypt['contact_emails'] = ['ops@example.com']
letsencrypt['auto_renew'] = true
""")
        Text { RawHTML("<b>LAN only.</b> Issue your own and drop the pair in place:") }
        CodeBlock("""
sudo mkdir -p /etc/gitlab/ssl && sudo chmod 755 /etc/gitlab/ssl
# copy gitlab.example.com.crt and .key into /etc/gitlab/ssl/

# /etc/gitlab/gitlab.rb
letsencrypt['enable'] = false
nginx['redirect_http_to_https'] = true
""")
      }

      Tile("Tune gitlab.rb", subtitle: "Omnibus defaults assume a server rack") {
        Text { RawHTML("<span id=\"tuning-for\">Pick a machine in step 1 and these values follow its cores and memory.</span>") }
        RawHTML("<div id=\"tuning-code\"></div>")
        CodeBlock("""
sudo gitlab-ctl reconfigure
""")
        Note("<span id=\"tuning-note\">Omnibus bundles Prometheus for GitLab's built-in performance dashboards. Whether to keep it depends on the memory you have.</span>")
      }

      Tile("Health check", subtitle: "Everything green before you migrate") {
        CodeBlock("""
sudo gitlab-ctl status
sudo gitlab-rake gitlab:check SANITIZE=true
sudo gitlab-rake gitlab:env:info

# Watch a reconfigure or a slow first boot
sudo gitlab-ctl tail
""")
      }
    }
  }

  // MARK: - 3. Backups

  @ViewBuilder
  private var backups: some View {
    CheatSheetSection(
      number: 3,
      title: "Back it up",
      summary: "Do this before you migrate anything, while there is nothing to lose.",
      accentClass: "cs-s1",
      anchor: "backups",
      agentPrompt: AgentPrompts.backups,
      agentFields: """
<div class="cs-prompt-fields">
  <label class="cs-prompt-field">
    <span>Backup bucket</span>
    <input id="f-bucket" type="text" spellcheck="false" autocomplete="off" placeholder="b2://acme-gitlab-backups">
  </label>
  <label class="cs-prompt-field">
    <span>Where gitlab-secrets.json goes</span>
    <input id="f-vault" type="text" spellcheck="false" autocomplete="off" placeholder="1Password, Ops vault">
  </label>
</div>
"""
    ) {
      Tile("What a backup actually contains", subtitle: "Two artifacts, and the second one is the one people forget") {
        CodeBlock("""
# Repos, database, uploads, CI artifacts
sudo gitlab-backup create STRATEGY=copy

# Secrets and config - NOT in the backup above.
# Without these the backup will not restore.
sudo tar -czf /secure/gitlab-config.tgz \\
  /etc/gitlab/gitlab.rb /etc/gitlab/gitlab-secrets.json

# Nightly at 02:00
echo '0 2 * * * root /usr/bin/gitlab-backup create CRON=1' \\
  | sudo tee /etc/cron.d/gitlab-backup
""")
        Note("Archives land in <code>/var/opt/gitlab/backups</code> as <code>&lt;timestamp&gt;_gitlab_backup.tar</code>. Set <code>gitlab_rails['backup_keep_time'] = 604800</code> or that directory grows until the disk fills.")
      }

      Tile("Get the backups off the box", subtitle: "A backup sitting on the machine that died is not a backup", width: .wide) {
        Text {
          RawHTML("Omnibus pushes each backup straight to any S3-compatible bucket. Backblaze B2 and Cloudflare R2 cost a few dollars a month here, and neither charges egress.")
        }
        CodeBlock("""
# /etc/gitlab/gitlab.rb
gitlab_rails['backup_upload_connection'] = {
  'provider' => 'AWS',
  'region' => 'us-west-000',
  'aws_access_key_id' => 'KEY',
  'aws_secret_access_key' => 'SECRET',
  # Drop this line if you really are on AWS
  'endpoint' => 'https://s3.us-west-000.backblazeb2.com'
}
gitlab_rails['backup_upload_remote_directory'] = 'acme-gitlab-backups'
gitlab_rails['backup_multipart_chunk_size'] = 104857600
gitlab_rails['backup_encryption'] = 'AES256'
gitlab_rails['backup_keep_time'] = 604800

sudo gitlab-ctl reconfigure
sudo gitlab-backup create CRON=1
""")
        Bullets([
          "Give the bucket key <b>write and list only</b>. A compromised runner should not be able to delete your history.",
          "Turn on <b>object lock</b>, which makes an uploaded file impossible to change or delete until a date you set. Anything that gets hold of your credentials can then write new objects but cannot touch last week's.",
          "<code>gitlab-secrets.json</code> is excluded from the archive on purpose. Put it in a password manager, not the bucket.",
          "<code>backup_keep_time</code> prunes local copies only. Set a bucket lifecycle rule for the rest.",
        ])
        Note("Restore into a throwaway VM every quarter. An untested backup is a guess.")
        CodeBlock("""
sudo gitlab-backup restore BACKUP=1754400000_2026_08_05_18.2.1
""")
      }

    }
  }

  // MARK: - 4. Migration

  @ViewBuilder
  private var migrate: some View {
    CheatSheetSection(
      number: 4,
      title: "Migrate from GitHub",
      summary: "GitLab's importer pulls repos, issues, pull requests and comments over the GitHub API.",
      accentClass: "cs-s3",
      anchor: "migrate",
      agentPrompt: AgentPrompts.migrate,
      agentFields: """
<label class="cs-prompt-field">
  <span>GitHub repository URLs, one per line</span>
  <textarea id="f-repos" rows="4" spellcheck="false" autocomplete="off" placeholder="https://github.com/acme/billing
https://github.com/acme/web"></textarea>
</label>
"""
    ) {
      Tile("Token", subtitle: "Classic PAT only, since fine-grained tokens do not work") {
        Bullets([
          "<code>repo</code>, required.",
          "<code>read:org</code>, needed for collaborators and Git LFS objects.",
          "The source organization must not enforce third-party application restrictions, or the token silently sees nothing.",
          "You need <b>Maintainer</b> or <b>Owner</b> on the destination GitLab group.",
        ])
        Note("Generate one at <a href=\"https://github.com/settings/tokens/new?scopes=repo,read:org&amp;description=GitLab%20import\" rel=\"noreferrer\">github.com/settings/tokens</a>, which opens the classic form with both scopes already ticked. Delete it when the migration is done.")
      }

      Tile("Run the import", subtitle: "UI for a handful, API for a fleet", width: .medium) {
        Text { RawHTML("<b>UI:</b> <code>+ → New project → Import project → GitHub</code>, paste the token, tick the repositories.") }
        CodeBlock("""
# API - one repo
curl --request POST "https://gitlab.example.com/api/v4/import/github" \\
  --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \\
  --header "Content-Type: application/json" \\
  --data '{
    "personal_access_token": "'"$GITHUB_TOKEN"'",
    "repo_id": 123456789,
    "target_namespace": "acme/backend",
    "new_name": "billing",
    "optional_stages": {
      "single_endpoint_issue_events_import": true,
      "attachments_import": true,
      "collaborators_import": true
    }
  }'
""")
        Note("The API path also works for public repositories you do not own, and for GitHub Enterprise Server sources. The UI flow handles neither.")
      }

      Tile("Run both at once for a while", subtitle: "Mirror first, switch when you are ready") {
        Text { RawHTML("Set the new GitLab project to <b>pull-mirror</b> from GitHub. Both remotes stay live while you rewrite CI; when you are ready, flip the mirror off and archive the GitHub repo.") }
        CodeBlock("""
# Settings > Repository > Mirroring repositories
#   Direction: Pull
#   URL: https://<user>@github.com/acme/billing.git
#   Password: GitHub PAT

# Then on every developer's laptop:
git remote set-url origin git@gitlab.example.com:acme/billing.git
git remote -v
""")
        Note("Push-mirroring in the other direction (GitLab → GitHub) keeps a public read-only copy alive if your users expect one.")
      }

      Tile("What actually comes across", subtitle: "Everything the importer moves, and everything it does not", width: .medium, identifier: "tile-import-scope") {
        RefTable(
          headers: ["Item", "Imported"],
          rows: [
            ["Repository, all branches and tags", "Yes"],
            ["Issues, PRs (as merge requests), comments", "Yes"],
            ["Labels, milestones, release notes", "Yes"],
            ["Wiki, branch protection rules", "Yes"],
            ["Git LFS objects", "Yes, with <code>read:org</code>"],
            ["Collaborators and their roles", "Opt-in stage"],
            ["Markdown attachments", "Opt-in stage"],
            ["<b>Actions workflows</b>", "<b>No, rewrite by hand</b>"],
            ["<b>Secrets and variables</b>", "<b>No, GitHub never exposes them</b>"],
            ["<b>Webhooks, deploy keys, Pages</b>", "<b>No</b>"],
            ["<b>Discussions, Projects boards</b>", "<b>No</b>"],
          ]
        )
        Note("Comment threads above roughly 30,000 items are skipped unless you enable the single-endpoint stage. GitLab tested the importer against Kubernetes, which has 80k PRs and 1.5M comments, and it took about 76 hours. Both figures come from the <a href=\"https://docs.gitlab.com/user/project/import/github/\" rel=\"noreferrer\">GitHub importer documentation</a>.")
      }

      Tile("Post-import checklist", subtitle: "Per repository, once the import finishes") {
        Checklist(id: "postimport", [
          "Confirm the <b>default branch</b>, which the importer does not always carry over.",
          "Re-create <b>protected branch</b> and <b>protected tag</b> rules. GitHub rulesets do not map cleanly.",
          "Re-add every <b>webhook</b>.",
          "Re-add every <b>deploy key</b>.",
          "Re-enter each secret as a <b>masked, protected CI/CD variable</b>.",
          "Re-point external services such as Slack, Sentry and Jira at the GitLab project.",
          "Update badge URLs and any <code>raw.githubusercontent.com</code> links in READMEs.",
          "Check Git LFS objects arrived, if the repository uses them.",
          "Archive the GitHub repo rather than deleting it, so old links keep resolving.",
        ])
      }
    }
  }

  // MARK: - 5. Runners

  @ViewBuilder
  private var runners: some View {
    CheatSheetSection(
      number: 5,
      title: "Runners and CI",
      summary: "The runner takes five minutes. Rewriting the workflows takes days.",
      accentClass: "cs-s4",
      anchor: "runners",
      agentPrompt: AgentPrompts.runners,
      agentFields: """
<div class="cs-prompt-fields">
  <label class="cs-prompt-field">
    <span>Address of the machine running jobs</span>
    <input id="f-runnerip" type="text" spellcheck="false" autocomplete="off" placeholder="192.168.1.20">
  </label>
  <label class="cs-prompt-field">
    <span>Workflows to convert</span>
    <input id="f-workflows" type="text" spellcheck="false" autocomplete="off" placeholder=".github/workflows/ci.yml">
  </label>
</div>
"""
    ) {
      Tile("Linux runner", subtitle: "Docker executor, for everything that is not an Apple build", identifier: "tile-linux-runner") {
        CodeBlock("""
curl --location \\
  "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" \\
  | sudo bash
sudo apt install -y gitlab-runner docker.io
sudo usermod -aG docker gitlab-runner

# Create the runner in the UI first:
#   Group or project > Settings > CI/CD > Runners > New runner
# It hands you a token beginning with glrt-

sudo gitlab-runner register \\
  --non-interactive \\
  --url "https://gitlab.example.com" \\
  --token "$RUNNER_TOKEN" \\
  --executor "docker" \\
  --docker-image "alpine:latest" \\
  --docker-privileged=false \\
  --description "shelf-box-docker"
""")
        Note("<code>--registration-token</code> still works but is deprecated and scheduled for removal in GitLab 20.0. Use <code>glrt-</code> authentication tokens for anything new.")
      }

      Tile("What to tune afterwards", subtitle: "Registration writes config.toml for you", identifier: "tile-runner-config") {
        Text {
          RawHTML("You do not write <code>/etc/gitlab-runner/config.toml</code> by hand. Registration creates it and fills in the token. Three values in it are worth revisiting.")
        }
        RefTable(
          headers: ["Key", "Why"],
          rows: [
            ["<code>concurrent</code>", "Total jobs across every runner on the host. Roughly core count minus two, so GitLab keeps headroom"],
            ["<code>[runners.docker] memory</code>, <code>cpus</code>", "Caps one job so a runaway build cannot take the machine down with it"],
            ["<code>pull_policy</code>", "<code>if-not-present</code> stops every job re-pulling images over your connection"],
          ]
        )
        CodeBlock("""
sudo gitlab-runner restart
""")
        Note("Watch queue times under <i>Admin, CI/CD, Runners</i>. Jobs sitting in <code>pending</code> mean you need another host, not more concurrency on this one.")
      }

      Tile("macOS runner", subtitle: "Shell executor, because macOS cannot be containerised", identifier: "tile-macos-runner") {
        CodeBlock("""
brew install gitlab-runner
brew services start gitlab-runner

gitlab-runner register \\
  --non-interactive \\
  --url "https://gitlab.example.com" \\
  --token "$RUNNER_TOKEN" \\
  --executor "shell" \\
  --shell "bash" \\
  --tag-list "macos,xcode" \\
  --description "mac-mini-m4"

# Keep Xcode explicit so a Sonoma update cannot silently
# change the toolchain under your builds.
sudo xcode-select -s /Applications/Xcode.app
""")
        Note("The shell executor gives you no isolation, so jobs share one machine's state. Reset simulators and derived data between runs. Keep it away from untrusted forks.")
      }

      Tile("Actions → GitLab CI", subtitle: "The translation table", width: .wide) {
        RefTable(
          headers: ["GitHub Actions", "GitLab CI", "Notes"],
          rows: [
            ["<code>.github/workflows/*.yml</code>", "<code>.gitlab-ci.yml</code>", "One file at the repo root"],
            ["<code>jobs.&lt;id&gt;.runs-on</code>", "<code>tags:</code>", "Selects runners by tag"],
            ["<code>steps: - run:</code>", "<code>script:</code>", "A plain list of shell lines"],
            ["<code>uses: actions/checkout</code>", "Nothing", "GitLab always clones first"],
            ["<code>uses: actions/cache</code>", "<code>cache: {key, paths}</code>", "Built in"],
            ["<code>uses: actions/upload-artifact</code>", "<code>artifacts: paths:</code>", "Built in"],
            ["<code>container:</code>", "<code>image:</code>", "Same idea"],
            ["<code>services:</code>", "<code>services:</code>", "Same key, different syntax"],
            ["<code>env:</code>", "<code>variables:</code>", ""],
            ["<code>secrets.FOO</code>", "<code>$FOO</code>", "Masked + protected CI/CD variable"],
            ["<code>if:</code>", "<code>rules: - if:</code>", "Rules also gate <code>when</code> and <code>allow_failure</code>"],
            ["<code>needs:</code>", "<code>needs:</code>", "Same key"],
            ["<code>strategy.matrix</code>", "<code>parallel: matrix:</code>", ""],
            ["<code>concurrency</code>", "<code>resource_group:</code>", "Serializes deploys"],
            ["<code>workflow_dispatch</code>", "<code>when: manual</code>", "Or a pipeline schedule"],
            ["<code>workflow_call</code>", "<code>include: project:</code>", "Plus <code>extends:</code>"],
            ["Composite action", "CI/CD component", "Or a plain <code>include:</code>"],
            ["<code>${{ github.sha }}</code>", "<code>$CI_COMMIT_SHA</code>", ""],
            ["<code>${{ github.ref_name }}</code>", "<code>$CI_COMMIT_REF_NAME</code>", ""],
            ["<code>${{ github.repository }}</code>", "<code>$CI_PROJECT_PATH</code>", ""],
            ["<code>${{ runner.os }}</code>", "<code>$CI_RUNNER_EXECUTABLE_ARCH</code>", ""],
            ["<code>GITHUB_TOKEN</code>", "<code>$CI_JOB_TOKEN</code>", "Scoped to the job, expires with it"],
          ]
        )
        Note("There is no official one-shot converter in this direction. The Marketplace is the hard part: every <code>uses:</code> line is a dependency you now write yourself, or replace with a CI/CD component.")
      }

      Tile("The same pipeline, both ways", subtitle: "Build, test, deploy, which covers most workflows", width: .full) {
        CodeComparison(
          leftTitle: ".github/workflows/ci.yml",
          left: """
name: CI
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    container: node:22
    steps:
      - uses: actions/checkout@v4
      - uses: actions/cache@v4
        with:
          path: .npm
          key: cache-${{ hashFiles('package-lock.json') }}
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          path: dist/
          retention-days: 7

  test:
    needs: build
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: ["20", "22"]
    container: node:${{ matrix.node }}
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref_name == 'main'
    concurrency: production
    environment:
      name: production
      url: https://example.com
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh
""",
          rightTitle: ".gitlab-ci.yml",
          right: """
stages: [build, test, deploy]

default:
  image: node:22
  tags: [docker]

cache:
  key:
    files: [package-lock.json]
  paths: [.npm]

build:
  stage: build
  script:
    - npm ci
    - npm run build
  artifacts:
    paths: [dist/]
    expire_in: 1 week

test:
  stage: test
  needs: [build]
  parallel:
    matrix:
      - NODE: ["20", "22"]
  image: node:$NODE
  script: [npm ci, npm test]

deploy:
  stage: deploy
  needs: [test]
  resource_group: production
  environment:
    name: production
    url: https://example.com
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  script: [./deploy.sh]
"""
        )
        Note("The checkout steps have no counterpart because GitLab clones before every job. Caching and artifacts stop being Marketplace actions and become two keys in the file.")
      }

      Tile("How many boxes", subtitle: "Working out runner capacity from your minute count", width: .medium) {
        Text {
          RawHTML("CI minutes do not spread evenly across the month. They land in business hours, so size against that window rather than 730 hours.")
        }
        CodeBlock("""
concurrent jobs = monthly minutes / 60 / 160 working hours

  20,000 min  ->  2 jobs at once   ->  one box, easily
  80,000 min  ->  8 jobs at once   ->  two boxes
 200,000 min  -> 21 jobs at once   ->  four or more
""")
        Bullets([
          "Budget roughly <b>2 threads and 4 GB</b> per concurrent job. A 14-core i5-13500 comfortably runs six to eight.",
          "Once you pass one box, put <b>GitLab on its own machine</b>. A runaway build should not make the web UI unresponsive for everybody.",
          "Two runner hosts also means you can reboot one for kernel updates without stopping CI.",
          "Watch <i>Admin → CI/CD → Runners</i> for queue wait times. Jobs sitting in <code>pending</code> is the signal to add a box, not CPU percentage.",
        ])
        Note("These are the numbers behind the profiles in the calculator. The scaling team preset picks two towers for exactly this reason.")
      }

      Tile("Registry and packages", subtitle: "Stop paying for GHCR while you are here", width: .medium) {
        CodeBlock("""
docker login registry.example.com \\
  -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD"

# In .gitlab-ci.yml the credentials are already there:
publish:
  image: docker:27
  services: [docker:27-dind]
  script:
    - docker login -u "$CI_REGISTRY_USER" \\
        -p "$CI_REGISTRY_PASSWORD" "$CI_REGISTRY"
    - docker build -t "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA" .
    - docker push "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA"
""")
        Note("Set a cleanup policy under <i>Settings → Packages and registries</i>, or the registry will happily eat the whole disk.")
      }
    }
  }

  // MARK: - 5. Numbers

  @ViewBuilder
  private var numbers: some View {
    Section {
      Div {
        Div {
          H1 { DOMString("Looking for something to do while GitHub is down?") }
          Text {
            RawHTML("GitHub Actions has been down 68.5 hours so far in 2026.")
          }
          .className("cs-intro-lead")

          Text {
            RawHTML("Standing up your own GitLab server takes an afternoon, and keeping it running takes a few hours a month, so in the time you spend watching that status page you could build the whole thing three times over.")
          }
          .className("cs-intro-lead")

          Text {
            RawHTML("Below: the parts at today's prices, the install commands, the migration steps, and a calculator for when it pays for itself.")
          }
        }
        .className("cs-intro")

        Div {
        Div {
          Div {
            H3 { DOMString("Rolling 90-day uptime") }
            Div {
              Span { RawHTML("<i style=\"background:var(--good)\"></i>Healthy") }
              Span { RawHTML("<i style=\"background:var(--critical)\"></i>Degraded") }
            }
            .className("cs-legend")
          }
          .className("cs-chart-head")

          Div {
            RawHTML("<svg id=\"uptime-plot\" class=\"cs-plot\" role=\"img\" aria-label=\"GitHub platform uptime measured over a rolling 90-day window, from June 2022 to August 2026, peaking at 98.9 percent in January 2025 and falling to 84.3 percent in May 2026\"></svg>")
            RawHTML("<div id=\"uptime-tip\" class=\"cs-tip\"></div>")
          }
          .className("cs-plot-wrap")

          Div {
            RawHTML("""
<div><b class="cs-bad">89.93%</b><span>2026 so far</span></div>
<div><b>91.06%</b><span>Trailing 12 mo</span></div>
<div><b>95.40%</b><span>All time</span></div>
<div><b class="cs-bad">78.33%</b><span>Worst month</span></div>
""")
          }
          .className("cs-figures")
        }
        .className("cs-tile cs-tile-wide cs-fail")

        Tile("Actions on its own", subtitle: "The part of GitHub this page replaces") {
          RefTable(
            headers: ["Year", "Incidents", "Hours", "Critical"],
            rows: [
              ["2024", "27", "46.0", "0"],
              ["2025", "36", "95.9", "0"],
              ["2026 so far", "30", "68.5", "6"],
            ],
            numericColumns: [1, 2, 3]
          )
          Note("Seven months of 2026 already beat all of 2024, and the critical rating went from unused to six. Half these incidents ran past two hours.")
        }

        Tile("The long ones", subtitle: "Single Actions outages, 2026") {
          RawHTML("""
<div class="cs-scroll"><table class="cs-table">
  <thead><tr><th>Date</th><th>Outage</th><th class="num">Length</th></tr></thead>
  <tbody>
    <tr data-day="2026-07-09"><td>Jul 9</td><td><a href="https://www.githubstatus.com/incidents/cstx3v63mklm" rel="noreferrer">Delays starting Actions runs</a></td><td class="num">10h 10m</td></tr>
    <tr data-day="2026-07-19"><td>Jul 19</td><td><a href="https://www.githubstatus.com/incidents/8vfyvq16hzh9" rel="noreferrer">Incident with GitHub Actions</a></td><td class="num">5h 10m</td></tr>
    <tr data-day="2026-04-24"><td>Apr 24</td><td><a href="https://www.githubstatus.com/incidents/3dqg0nhwnxs2" rel="noreferrer">Larger runners, VNet injection</a></td><td class="num">5h 34m</td></tr>
    <tr data-day="2026-05-05"><td>May 5</td><td><a href="https://www.githubstatus.com/incidents/1j40g94rn22j" rel="noreferrer">Incident with Actions</a></td><td class="num">3h 49m</td></tr>
    <tr data-day="2026-02-02"><td>Feb 2</td><td><a href="https://www.githubstatus.com/incidents/xwn6hjps36ty" rel="noreferrer">Incident with Actions</a></td><td class="num">3h 40m</td></tr>
  </tbody>
</table></div>
""")
        }

        Tile("Reading the numbers") {
          Bullets([
            "Each point is the share of the prior 90 days GitHub was healthy, from <a href=\"https://mrshu.github.io/github-statuses/\" rel=\"noreferrer\">The Missing GitHub Status Page</a>.",
            "Maintenance is excluded. Everything else counts in full, so this is time GitHub was <i>not fully healthy</i>, not time it was hard down.",
            "The mirror trails live status by about a day, so today's incident is not here yet. Figures run through <b>August 5, 2026</b>.",
            "August 2026 is a partial month.",
          ])
        }
        }
        .className("cs-lede-panels")
      }
      .className("cs-lede-grid")

    }
    .id("numbers")
    .className("cs-section cs-fail cs-section-why")
  }

  @ViewBuilder
  private var footer: some View {
    Footer {
      Text {
        RawHTML("Sources: <a href=\"https://docs.gitlab.com/install/package/ubuntu/\" rel=\"noreferrer\">GitLab installation docs</a>, <a href=\"https://docs.gitlab.com/install/requirements/\" rel=\"noreferrer\">GitLab requirements</a>, <a href=\"https://docs.gitlab.com/user/project/import/github/\" rel=\"noreferrer\">GitHub importer docs</a>, <a href=\"https://docs.gitlab.com/runner/register/\" rel=\"noreferrer\">runner registration docs</a>, <a href=\"https://docs.github.com/en/billing/reference/actions-minute-multipliers\" rel=\"noreferrer\">GitHub Actions per-minute rates</a>, <a href=\"https://github.com/pricing\" rel=\"noreferrer\">GitHub pricing</a>, and <a href=\"https://mrshu.github.io/github-statuses/\" rel=\"noreferrer\">The Missing GitHub Status Page</a>.")
      }
      Text {
        RawHTML("<b>Running this is a standing commitment, not a weekend project.</b> The moment your code lives on your hardware, patching it is your job. GitLab ships security releases roughly monthly and they are not optional: an unpatched instance holding every repository your team has is a serious target, and one reachable from the internet will be found. Budget time every month for <code>apt upgrade</code> and a GitLab version bump, subscribe to <a href=\"https://about.gitlab.com/releases/categories/releases/\" rel=\"noreferrer\">GitLab's release announcements</a>, keep the runner hosts patched too, and test the restore path before you need it. If nobody on the team owns that, GitHub's outages are the cheaper problem.")
      }

      Text {
        RawHTML("Amazon links are affiliate links. Prices observed August 2026 and not tracked afterwards. Verified against vendor documentation on August 6, 2026. Commands change, so read the release notes before pasting anything into production.")
      }
    }
    .className("cs-foot")
  }
}
