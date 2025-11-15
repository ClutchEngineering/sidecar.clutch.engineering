# PR Preview Setup Guide

This repository uses **GitHub Actions** to automatically deploy PR previews to GitHub Pages - fully GitHub-native with no external services needed!

## How It Works

This setup uses GitHub's modern Actions-based deployment model for BOTH production and PR previews:

- **Production (main branch):** Uses `deploy.yml` → deploys to your main site (https://sidecar.clutch.engineering/)
- **PR Previews:** Uses `pr-preview.yml` → deploys to unique preview URLs

When a PR is opened or updated:
1. GitHub Actions builds your site using the same process as production
2. The built site is deployed as a separate GitHub Pages deployment
3. A comment is automatically posted to the PR with the unique preview URL
4. Each new commit updates the preview automatically

**Preview URL format:** GitHub provides unique deployment URLs like:
- `https://clutchengineering.github.io/<repo>/deployments/<deployment-id>/`

## Setup Status

✅ **Workflows configured** - Both `deploy.yml` (production) and `pr-preview.yml` (PR previews) are ready

✅ **No configuration changes needed** - Since you're already using Actions-based deployment for production, PR previews work out of the box!

## How the Two Workflows Coexist

Both workflows use the same `actions/upload-pages-artifact` and `actions/deploy-pages` actions, but they create **different deployments**:

| Workflow | Trigger | Environment | Deployment Type | URL |
|----------|---------|-------------|-----------------|-----|
| `deploy.yml` | `push: main` | `github-pages` | Production | https://sidecar.clutch.engineering/ |
| `pr-preview.yml` | `pull_request` | `github-pages` | Preview | Unique per PR |

### Key Design Points

1. **Separate concurrency groups:**
   - Production: `group: "pages"`
   - PR previews: `group: "pages-pr-${{ github.event.number }}"`
   - This prevents conflicts and allows parallel deployments

2. **Same environment, different deployments:**
   - Both share the `github-pages` environment
   - GitHub automatically creates separate deployment records
   - Production deployment remains stable
   - Preview deployments are ephemeral (exist only while PR is open)

3. **No source changes needed:**
   - Your Pages source setting (Settings → Pages) stays as "GitHub Actions"
   - No branch-based deployment required

## Testing PR Previews

1. Create a test pull request against `main`
2. The **PR Preview** workflow will automatically run
3. Once complete, a comment will appear on the PR with the preview URL
4. Make additional commits to the PR - the preview will auto-update
5. The preview URL remains accessible until the deployment is removed

## Troubleshooting

### Preview workflow fails with "Resource not accessible by integration"

**Cause:** Workflow doesn't have required permissions

**Fix:** The workflow already requests `pull-requests: write` permission. Verify that your repository allows Actions to create comments:
1. Go to **Settings** → **Actions** → **General**
2. Check **"Allow GitHub Actions to create and approve pull requests"**

### Build fails with Airtable errors

**Cause:** Repository secrets not configured

**Fix:** Ensure these secrets are set in **Settings** → **Secrets and variables** → **Actions**:
- `AIRTABLE_API_KEY`
- `AIRTABLE_BASE_ID`
- `AIRTABLE_MODELS_TABLE_ID`

These are already configured for production, so PR previews should work automatically.

### Preview URL returns 404

**Possible causes:**
1. **Deployment hasn't completed** - Check the Actions tab for the workflow status
2. **Deployment was cleaned up** - Preview deployments may be removed when:
   - The PR is closed/merged
   - A new deployment replaces it
   - GitHub Pages deployment limits are reached

### Comment not posted to PR

**Cause:** Missing permissions or API error

**Fix:**
1. Verify `pull-requests: write` permission in the workflow
2. Check the workflow logs for any GitHub Script errors
3. Ensure the PR is from the same repository (not a fork) - fork PRs have restricted permissions

## Benefits of This Approach

✅ **Fully GitHub-native** - Uses official GitHub Actions for both prod and previews
✅ **No configuration changes** - Works with your existing Actions-based deployment
✅ **Automatic PR comments** - Preview links posted directly to PRs
✅ **Parallel deployments** - PR previews don't block production deployments
✅ **Consistent build process** - Previews use the exact same build as production
✅ **Free** - GitHub Pages is free for public repositories

## Technical Details

- **Main deployment action:** `actions/deploy-pages@v4`
- **PR preview action:** `actions/deploy-pages@v4` (same action, different trigger)
- **Comment integration:** `actions/github-script@v7`
- **Platform:** macOS-15 (required for Swift + Xcode builds)
- **Deployment model:** GitHub Actions (both prod and previews)
- **No branch-based deployment needed** - Everything via Actions

## How Preview Cleanup Works

Unlike branch-based preview systems (like `rossjrw/pr-preview-action`), this Actions-based approach:
- Creates deployments in GitHub's deployment API
- GitHub automatically manages deployment lifecycle
- Preview deployments are separate from production
- Old deployments may be cleaned up by GitHub after a period of time

If you need manual cleanup, you can use the GitHub API or gh CLI:
```bash
# List deployments
gh api repos/{owner}/{repo}/deployments

# Delete a specific deployment (requires deactivation first)
gh api -X POST repos/{owner}/{repo}/deployments/{deployment_id}/statuses \
  -f state=inactive
gh api -X DELETE repos/{owner}/{repo}/deployments/{deployment_id}
```

## Comparison with Other Approaches

This implementation uses the **modern Actions-based model** which is different from:

1. **Branch-based previews** (`rossjrw/pr-preview-action`):
   - ❌ Requires switching from Actions to branch-based deployment
   - ❌ Would disrupt your existing production workflow
   - ✅ Auto-cleanup on PR close

2. **External services** (Netlify, Vercel, Cloudflare):
   - ❌ Requires external account and API tokens
   - ❌ Data leaves GitHub
   - ✅ Better preview management UI
   - ✅ More features (redirects, edge functions, etc.)

3. **This Actions-based approach**:
   - ✅ Works with your existing GitHub Actions deployment
   - ✅ Fully GitHub-native
   - ✅ No external dependencies
   - ✅ Zero configuration changes to production
   - ⚠️ Preview URLs are less pretty (deployment IDs instead of PR numbers)
   - ⚠️ No automatic cleanup on PR close (managed by GitHub)
