# Saving $4000+/month with self-hosted runners

For the longest time, [Sidecar](https://sidecar.clutch.engineering) didn't have any continuous integration 😭.

Sidecar does have tests, but given the scale of the codebase I was looking at a potential bill in the **thousands of dollars per month** just to run continuous integration on GitHub. The more tests I wanted to write, the bigger a cost I was looking at for CI. This was like having to pay $1 every time I wanted to do a push-up; the incentive structure is backwards.

## The cost of testing Sidecar

Sidecar takes about 10 minutes to build on a decently fast machine, and with almost 1,100 Swift packages in the dependency graph that also have their own tests, the CI minutes add up quick.

| Package | Avg runtime | Runs (17 days) |
|:--------|------------:|---------------:|
| Sidecar build | ~9.6 min | 324 |
| VehicleKit tests | ~7.7 min | 14 |
| PIDDetectorKit tests | ~6.5 min | 196 |
| ...many more packages | ~3.2 min | 2000+ |

### The cost of GitHub macOS runners

[GitHub's free tier](https://docs.github.com/billing/managing-billing-for-github-actions/about-billing-for-github-actions) gives you 3000 minutes per month, but macOS minutes have a 10x multiplier.

*That's 300 actual macOS minutes, or about **5 hours per month**.*

Doing some simple math: building Sidecar alone, plus a handful of key test suites uses about 30-35 minutes, would eat up the free tier after just 10 pull requests 😭. Being a cost-conscious bootsrapped founder, I ended up just running tests manually and hoped I didn't miss anything (narrator: *he did*).

But then I learned about [self-hosted runners](https://docs.github.com/en/actions/concepts/runners/self-hosted-runners).

It's now been about a month with my own build cluster, and the numbers are wild: **I'm saving about **$4000 per month** (~$45,000 annually).**

Let me walk you through the math, compare against the alternatives, and show you how to set this up yourself.

---

## Sidecar in build metrics

From October 1-17, 2025, the Clutch Engineering macOS runners processed **28,723 minutes** of build time across two main workloads:

- **Valhalla builds: 11,393 minutes** (40% of total)
- **Sidecar CI: 17,330 minutes** (60% of total)

If I were running these on GitHub's hosted macOS runners, here's what it would cost:

## Provider costs

GitHub charges **$0.08 per minute** for standard macOS runners (or $4.80/hour). The free tier gives you 300 actual macOS minutes per month (3,000 minutes with the 10x multiplier). Some quick math:

```
28,723 minutes - 300 free minutes = 28,423 billable minutes
28,423 minutes x $0.08 = $2,273.84
```

For just 17 days. Extrapolate that to a full 31-day month:

```
((28,723 x 31/17) - 300) x $0.08 ≈ $4,167 per month
```

It's also important to note that the base machines are just [3-core M1s](https://docs.github.com/en/actions/reference/runners/github-hosted-runners#standard-github-hosted-runners-for--private-repositories), so the build times I quote above (and below) are likely much longer.

I looked at other macOS CI providers to see if there was a better option. Here's how they compare for Clutch Engineering's monthly usage (~52,377 minutes/month):

| Service | Cost/Minute | Free Minutes/Month | Est. Monthly Cost |
|:--------|------------:|-------------------:|------------------:|
| [GitHub Actions](https://github.com/pricing) | $0.08 | 300 | $4,167 |
| [Xcode Cloud](https://developer.apple.com/xcode-cloud/) | $0.08† | 1,500 | $400‡ |
| [CircleCI](https://circleci.com/pricing/) (4 CPU) | $0.012 | 0§ | $628 |
| [Codemagic](https://codemagic.io/pricing/) | $0.095 | 500 | $4,938 |
| [Depot](https://depot.dev/pricing) | $0.08 | 0 | $4,191 |
| [Bitrise](https://bitrise.io/pricing) Teams (3 concurrent) | Flat rate | Unlimited¶ | $89 |
| [Bitrise](https://bitrise.io/pricing) Pro (10 concurrent) | Flat rate | Unlimited¶ | $192 |
| [MacStadium](https://www.macstadium.com/pricing) (2x M4.M) | Machine rental | Unlimited♱ | $398 |
| **Self-hosted (owned)** | **N/A** | **∞** | **~$64**★ |

> † Xcode Cloud pricing is per-hour, not per-minute; equivalent to ~$0.08/min for comparison.
>
> ‡ Xcode Cloud offers tiered pricing; 1,000 hours/month at $399.99 is the best option for this usage. The problem is that Xcode Cloud is **unreasonably slow** (30+ minutes to build Sidecar).
>
> § CircleCI offers 30,000 free credits/month, but macOS runners use these credits super fast.
>
> ¶ Bitrise offers unlimited build minutes but limits concurrent builds; Teams allows 3 concurrent, Pro allows 10. With 2,774 workflow runs in 17 days, queue times become significant.
>
> ♱ MacStadium rents individual Mac machines; pricing shown for 2x M4.M Mac mini (10 Core, 24GB) at $199/month each to match current setup.
>
> ★ Hardware amortization + power costs only; machines are owned, not rented.

### Renting Macs

The closest equivalent to self-hosting is renting Mac hardware from [MacStadium](https://www.macstadium.com/pricing). At $398/month for two M4 Mac minis (matching the setup), it's significantly cheaper than most CI services. But here's the math on ownership:

**MacStadium rental:**
```
$398/month × 12 months = $4,776/year
```

**Purchase equivalent hardware:**
```
Mac mini M4 16GB: $599
Mac mini M4 Pro 24GB: $1,399
Total: $1,998
```

MacStadium's rental cost exceeds the purchase price in just **5 months**. After that, you're paying $398/month for hardware you could have owned.

Over 3 years:
- **MacStadium**: $14,328
- **Self-hosted**: $1,998 (hardware) + $252 (power) = $2,250

That's **$12,078 in savings** just by owning the hardware instead of renting it. And you still own the machines at the end.

The only real advantages of MacStadium are:
1. No upfront capital expenditure
2. Someone else handles hardware failures
3. Easier to scale up/down on demand

But for a stable workload like mine, those advantages don't justify paying 6× more over three years.

## The solution: self-hosted runners

Here's my current setup:

- 1x MacBook Pro M1 Max 32GB (2021, repurposed laptop)
- 1x Mac mini M4 Pro 24GB (2024, purchased for Clutch Engineering)
- 1x Mac mini M4 16GB (2024, purchased for Clutch Engineering)

### The Real Costs

**Hardware:**
- Mac mini M4 16GB: $599 (base model)
- Mac mini M4 Pro 24GB: ~$1,399
- MacBook Pro M1 Max: Already owned, sunk cost

**Power:** At ~10W idle and ~40W under load per Mac mini, averaging 25W each over a month:
```
25W x 2 minis x 24h x 31 days = 37.2 kWh
37.2 kWh x $0.26/kWh ≈ ~$10 per month
```

The MacBook Pro adds maybe another $3/month.

**Internet:** I already have business internet for other services, so this is effectively $0 marginal cost.

**Amortization:** Spread the Mac mini costs over 3 years:
```
($599 + $1,399) / 36 months ≈ $55.50 per month
```

**Total recurring cost:** ~$64/month (Mac mini amortization + power for all three machines)

Compare that to the $4,191/month for GitHub, or even the $628/month for CircleCI's 4 CPU runners.

### Multiple runners per machine

One optimization worth mentioning: you can run multiple GitHub Actions runner instances on a single machine. The Clutch Engineering build cluster runs 3-5 runners per machine, which means those three physical machines provide 12+ concurrent build slots. This is super useful for shorter test suites that don't max out the CPU; you can run multiple tests in parallel on the same hardware.

![Clutch Engineering build cluster](/gfx/2025/10/build-cluster.png)

### Maintenance cost

Setup took me about an hour for the new Mac Mini. Maintenance has been essentially zero; these machines just work. The GitHub Actions runner software auto-updates, macOS is stable, and builds are reliable.

Even if you value your time at $200/hour, that's a one-time $400 cost that pays for itself in the first month.

---

## How to set it up

Setup is hella easy. Like, shockingly easy.

### Step 1: Prepare your Mac

1. Install the latest macOS
2. Enable automatic login (Settings > Users & Groups)
3. Configure energy settings to prevent sleep
4. Install Xcode and any other build dependencies you need

### Step 2: Register the runner

1. Go to your organization's settings: `https://github.com/organizations/<YourOrganization>/settings/actions/runners/new`
2. Select macOS as the runner type
3. Follow the download and configuration instructions

The commands look something like this:

```bash
# Create a folder for the runner
mkdir actions-runner && cd actions-runner

# Download and install the latest runner
# (see the GitHub instructions for the latest commands)

# Configure the runner
./config.sh --url https://github.com/<YourOrg> --token <YourToken>

# Install and start the service
./svc.sh install
./svc.sh start
```

### Step 3: Configure Your workflows

Update your workflow files to use your self-hosted runner:

```yaml
jobs:
  build:
    runs-on: self-hosted
    # or be more specific:
    runs-on: [self-hosted, macOS]
```

### Step 4: Monitor and maintain

GitHub provides a dashboard showing runner status, job queue, and utilization. You can access this at:

```
https://github.com/organizations/<YourOrganization>/settings/actions/runners
```

The runners auto-update themselves, so maintenance is minimal.

## Security considerations

A few important notes on security:

1. **Network isolation:** Keep your runners on a separate VLAN if possible.
2. **No public repos:** Only use self-hosted runners for private repositories.

GitHub's documentation has more details: [About self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners)

## Verdict

For the Clutch Engineering use case (lots of iOS builds across multiple projects) self-hosted runners are a no-brainer:

- **Savings:** $2,000-$4,000+ per month
- **Setup time:** ~2 hours one-time
- **Maintenance:** Effectively zero
- **Performance:** Faster than GitHub's hosted runners (no boot time, cached dependencies)
- **Flexibility:** Full control over environment, installed tools, and configurations

But the most important result of this: costs are no longer directly associated with the scale of testing and deploying Sidecar. This is a **huge** psychological win.

If you need any amount of non-trivial macOS CI workload, the math is clear: **buying even one Mac Mini can save you tens of thousands of dollars.** 🥳
