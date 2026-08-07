import Foundation

/// Prompts shown in place of the manual instructions when the page is switched
/// to agent mode.
///
/// Each one carries the context an agent cannot infer: the constraints, the
/// facts that are easy to get wrong, and what counts as done. The hostname is
/// written as `gitlab.example.com` throughout so the page can substitute
/// whatever the reader types into the domain field.
enum AgentPrompts {
  static let hardware = """
Help me buy hardware to self-host GitLab so my team stops depending on GitHub Actions.

My situation:
- Developers: {{devs}}
- We build for: {{platforms}}
- CI usage today: {{linux}} Linux minutes and {{macos}} macOS minutes a month
- Currently on the GitHub {{plan}} plan
- Shortlist I am already looking at: {{machines}}, about {{budget}}

Constraints you must respect:
- GitLab's own baseline for a single node is 8 vCPU, 16 GB RAM, and 40 GB of
  disk plus the size of every repository, on SSD. Gitaly is I/O bound, so no
  NFS and no network shares.
- Concurrent CI jobs = monthly minutes / 60 / 160 working hours. Budget about
  2 threads and 4 GB per concurrent job. Past one box, put GitLab on its own
  machine so a runaway build cannot make the web UI unresponsive.
- DDR4 on LGA 1700 currently gives far more cores per dollar than DDR5. A
  32 GB DDR4 kit runs about half what the same capacity costs in DDR5.
- Apple platforms need real Apple hardware. Hosted macOS minutes bill at ten
  times the Linux rate, which is usually what justifies the purchase.

Pricing, and read this twice:
- Every price you remember is wrong. Datacenter demand has roughly doubled
  memory and NAND over the last year. A 64 GB DDR5 kit that a model would
  guess at $175 is closer to $950 today, and a 2 TB NVMe drive that used to be
  $160 is closer to $375.
- So: open a real listing for every single part before you quote it. Read the
  price off the page. If you cannot open the listing, say so and leave the
  price blank rather than filling in a number you believe.
- Check it is actually in stock and actually shipping from the retailer, not
  a marketplace reseller at three times the price. Plenty of mainstream parts
  currently have no buybox at all.
- Tell me the date you checked, and link every listing you used.

Deliver:
1. One recommended build, with a table of part, model, live price, listing
   link, and the date you checked it.
2. The total, and the expected idle and full-load wattage.
3. A UPS with a USB data port, sized to that load, so the machine can shut
   down cleanly. Not a bigger one than the load needs.
4. Anything out of stock, called out explicitly with an alternative. Do not
   substitute parts silently.
"""

  static let install = """
Install GitLab on a fresh Ubuntu 24.04 LTS machine I control.

Access: I have sudo over SSH at {{ssh}}.
External URL: https://gitlab.example.com
TLS: {{tls}}.
The machine has {{cores}} cores and {{ram}} GB of RAM.

Facts you need:
- Install the `gitlab-ee` package, not `gitlab-ce`. With no licence applied it
  behaves exactly as Free, and moving to a paid tier later is a licence upload
  rather than a reinstall.
- The initial root password is in /etc/gitlab/initial_root_password and is
  deleted automatically after 24 hours.
- Omnibus bundles PostgreSQL and Redis. Do not install either separately.
- Omnibus defaults assume a much larger machine. Scale puma workers, sidekiq
  concurrency and postgresql shared_buffers to the cores and RAM above.

Do this, showing me each command before you run it:
1. Install dependencies, add the repository, and install with EXTERNAL_URL set.
2. Retrieve the initial root password and tell me to change it immediately.
3. Turn off open sign-ups and set default project visibility to Private.
4. Write the tuning values into /etc/gitlab/gitlab.rb and reconfigure.
5. Verify with `gitlab-ctl status` and `gitlab-rake gitlab:check SANITIZE=true`,
   and show me the output.

Do not expose this instance to the public internet. If it needs remote access,
propose Tailscale or a Cloudflare Tunnel rather than port forwarding.
"""

  static let backups = """
Set up backups for my self-hosted GitLab, before I migrate anything onto it.
Instance: https://gitlab.example.com

Facts you need, because getting this wrong makes the backups useless:
- `gitlab-backup create` writes an archive to /var/opt/gitlab/backups. It
  contains repositories, the database, uploads and CI artifacts.
- It deliberately does NOT contain /etc/gitlab/gitlab.rb or
  /etc/gitlab/gitlab-secrets.json. Without the secrets file a restore cannot
  decrypt anything, so those two must be captured separately and stored
  somewhere other than the backup bucket.
- `backup_keep_time` only prunes local copies. Remote retention needs a
  lifecycle rule on the bucket.

Do this:
1. Schedule a nightly `gitlab-backup create CRON=1`.
2. Configure `gitlab_rails['backup_upload_connection']` to push each archive to
   {{bucket}}, with server-side encryption on.
3. Scope the bucket credential to write and list only, so a compromised runner
   cannot delete history. Turn on object lock or versioning.
4. Capture gitlab.rb and gitlab-secrets.json into {{vault}},
   and tell me exactly what you stored and where.
5. Prove it works: restore into a throwaway VM and show me the result. An
   untested backup is a guess.

Tell me the restore procedure in full when you are done, written so that
somebody who is not you can follow it during an outage.
"""

  static let migrate = """
Migrate my GitHub repositories to my self-hosted GitLab, where I am an Owner.
Instance: https://gitlab.example.com

Source: GitHub {{source}}
Repositories: {{repos}}
Team size, for seat planning: {{devs}}

Facts you need:
- The importer needs a CLASSIC personal access token with the `repo` scope,
  plus `read:org` for collaborators and Git LFS objects. Fine-grained tokens do
  not work. If the org enforces third-party application restrictions the token
  will silently see nothing.
- It brings across: repository, branches, tags, issues, pull requests as merge
  requests, comments, labels, milestones, release notes, wikis, and branch
  protection rules.
- It does NOT bring across: Actions workflows, secrets, webhooks, deploy keys,
  Pages, Discussions, or Projects boards. All of those are manual.
- Use POST /api/v4/import/github rather than the UI, so this is repeatable and
  so it works for public repositories I do not own.

Do this:
1. Import each repository, with the collaborators and attachments stages on.
2. After each one, verify the default branch is correct, protected branch and
   tag rules exist, and LFS objects arrived.
3. Give me a per-repository checklist of everything that did not transfer.
4. Set up pull mirroring from GitHub so both sides stay live during cutover,
   and tell me how to switch it off when we commit.
5. Give me the exact `git remote set-url` command for each repository.

Do not delete, archive, or change anything on GitHub without asking me first.
"""

  static let runners = """
Set up GitLab runners and convert my GitHub Actions workflows to GitLab CI.
Instance: https://gitlab.example.com

Runner hosts: {{runnerhosts}}
Workflows to convert: {{workflows}}

Facts you need:
- Register with a runner AUTHENTICATION token, which starts with `glrt-` and is
  created in the UI under Settings, CI/CD, Runners. `--registration-token` is
  deprecated and is removed in GitLab 20.0.
- Set `concurrent` in /etc/gitlab-runner/config.toml to roughly the core count
  minus two, so GitLab itself keeps headroom during a busy pipeline.
- On Linux use the Docker executor. On macOS use the shell executor, because
  macOS cannot be containerised. The shell executor has no isolation, so reset
  simulators and derived data between jobs, and never point it at forks.
- Pin the Xcode path explicitly with `xcode-select -s` so an OS update cannot
  change the toolchain underneath the builds.

Translation rules:
- `runs-on` becomes `tags`. `steps.run` becomes `script`.
- `actions/checkout` becomes nothing; GitLab clones automatically.
- `actions/cache` becomes `cache:`, `actions/upload-artifact` becomes
  `artifacts:`, `container:` becomes `image:`.
- `strategy.matrix` becomes `parallel: matrix:`, `concurrency` becomes
  `resource_group:`, `workflow_call` becomes `include: project:`.
- `${{ github.sha }}` becomes `$CI_COMMIT_SHA`, `github.ref_name` becomes
  `$CI_COMMIT_REF_NAME`, `github.repository` becomes `$CI_PROJECT_PATH`, and
  `GITHUB_TOKEN` becomes `$CI_JOB_TOKEN`.
- Every remaining `uses:` line is a Marketplace dependency I now own. Replace it
  with explicit script steps or a CI/CD component, and list the ones you could
  not replace so I can decide.

Do this:
1. Install and register the runners, tagged so Linux and macOS jobs land on the
   right machine.
2. Write .gitlab-ci.yml for each workflow.
3. List every secret the workflows reference, so I can add them as masked and
   protected CI/CD variables. Do not put secrets in the file.
4. Run the pipeline and iterate until it is green, showing me the failures.
"""
}
