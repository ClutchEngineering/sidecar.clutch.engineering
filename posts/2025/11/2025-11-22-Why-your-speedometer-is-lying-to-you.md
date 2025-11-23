---
thumbnail: /gfx/news/2025/11/speedometer-regulation.png
---

# Why your speedometer is lying to you (in a good way)

If you've ever connected an OBD scanner to your car and watched its speed readout, you may have noticed something odd: your dashboard doesn't match the scanner's speed. Your speedometer might say 70 mph while the OBD data shows 67. Which one's the truth?

Well, turns out the answer's a bit more complicated than you might expect, and I lost myself down a rabbit hole of worldwide automotive regulations tonight to get to the bottom of it.

## The legal framework

In most of the world, vehicle speedometers are legally required to *never* display a speed that is *lower* than your actual speed.

The reasoning boils down to this: if your speedometer shows a number that *is* too low, you might break the speed limit while believing you're driving legally.

And nobody wants a ticket for going 72 in a 70 zone when their dashboard clearly showed 70.

From the European standard, [UNECE Regulation 39](https://unece.org/fileadmin/DAM/trans/main/wp29/wp29regs/2018/R039r2e.pdf), Section 5.4:

> The speed indicated shall not be less than the true speed of the vehicle. At the
> test speeds specified in paragraph 5.3.5. above, there shall be the following
> relationship between the speed displayed (V<sub>1</sub>) and the true speed (V<sub>2</sub>).
>
> 0 &le; (V<sub>1</sub> - V<sub>2</sub>) &le; 0.1 V<sub>2</sub> + 4 km/h

If we rewrite the standard's formula in terms of the displayed speed:

> V<sub>actual</sub> ≤ V<sub>displayed</sub> ≤ 1.1 × V<sub>actual</sub> + 4 km/h

This creates two rules:

1. The displayed speed can never be **below** your actual speed.
2. The displayed speed can be up to 110% **above** your true speed, plus 4 km/h.

**A concrete example:** if you're actually traveling at 100 km/h (about 62 mph), your speedometer could legally display anywhere from 100 to 114 km/h (62 to 71 mph), but never 99 km/h. That's a potential 14 km/h (9 mph) buffer at highway speeds.

### Who follows this regulation?

![Countries participating in the World Forum for Harmonization of Vehicle Regulations](/gfx/news/2025/11/World_Forum_for_Harmonization_of_Vehicle_Regulations.png)

> Image from Wikipedia's ["World Forum for Harmonization of Vehicle Regulations"](https://en.wikipedia.org/wiki/World_Forum_for_Harmonization_of_Vehicle_Regulations#Participating_countries)

UNECE Regulation 39 is part of the [1958 Agreement](https://en.wikipedia.org/wiki/World_Forum_for_Harmonization_of_Vehicle_Regulations#Participating_countries) on vehicle technical harmonization. As of 2023, there are 68 contracting parties, including:

- The European Union and all its member states
- United Kingdom, Norway, Switzerland, Andorra, San Marino
- Russia, Ukraine, Belarus, Turkey, Azerbaijan, Georgia, Armenia, Kazakhstan, Kyrgyzstan
- Japan, South Korea, Thailand, Malaysia, Vietnam, Philippines, Pakistan
- Australia, New Zealand
- South Africa, Egypt, Tunisia, Nigeria, Uganda

Australia explicitly adopts UNECE R39 through [ADR 18/03](https://www.legislation.gov.au/Details/F2006L01392) for vehicles manufactured after July 2007.

**Notable exceptions:** The United States and Canada are not signatories to the 1958 Agreement. The US has its own [Federal Motor Vehicle Safety Standards](https://www.nhtsa.gov/laws-regulations) (FMVSS), and Canada's Transport Canada does not regulate speedometer accuracy at the federal level.

## Why this is good for you

When you glance at your speedometer and see a higher number, you instinctively ease off the gas. That's the point. The inflated reading encourages you to drive a bit slower than you otherwise might, creating a real-world safety margin without you having to think about it.

It also protects you from the small, unconscious speed creep that happens on long drives. A momentary lapse in attention won't push you over the limit because there's already a buffer built in. Yes, the speedometer is lying to you, but it's a lie that complements driver tendencies to reduce tickets and improve road safety.

## How tire wear impacts your speedometer

Tire wear actually reinforces this buffer over time. As your tires wear down, their diameter shrinks, which means the wheels have to rotate more times to cover the same distance. Since your car's speed sensors count wheel rotations, worn tires cause both the dashboard and OBD to read *higher* than your true ground speed. GPS, which measures your actual position via satellite, isn't affected by tire size.

Manufacturers account for this by calibrating toward the edge of the legal tolerance when the car is new, knowing the safety margin will grow as the tires wear.

## The takeaway

When you use OBD or GPS to determine your car's speed, you'll often get a value that doesn't match what's shown on your car's speedometer. This is working as intended, and **you should prefer your car's speedometer over an OBD or GPS speedometer while driving**. After the drive, you can use direct OBD readings from an app like [Sidecar](https://sidecar.clutch.engineering) to better understand your "true" trip details.

![100%](/gfx/news/2025/11/speedometer-regulation.png)

Drive safe,

-- Jeff
