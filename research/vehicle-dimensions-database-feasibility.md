# Vehicle Dimensions Database Feasibility Research

**Date:** 2025-11-17
**Purpose:** Research feasibility of implementing a crawler for building a database of vehicle dimensions, organized by make, model, and year

## Executive Summary

Building a comprehensive vehicle dimensions database is **highly feasible** through multiple approaches:

1. **Commercial APIs** - Several vendors offer ready-to-use APIs with comprehensive dimension data
2. **Downloadable Databases** - Complete datasets available for purchase (CSV/MySQL/Excel)
3. **Free/Open Data Sources** - Limited but available free options
4. **Web Crawling** - Possible but legally complex and time-intensive

**Recommendation:** Use a combination of commercial API/database purchase for initial data, supplemented by selective crawling of public sources where legally permitted.

---

## Option 1: Commercial APIs (BEST OPTION)

### Top Recommended APIs

#### 1. VehicleDatabases.com - Vehicle Specifications API
**Coverage:** North American vehicles, 1999-present
**Pricing:** Contact for quote
**Dimension Fields:**
- Width
- Height
- Length
- Wheelbase
- Ground clearance
- Trunk volume
- Overall size
- Number of doors

**Access Method:** REST API (JSON)
**Query Options:** VIN or Year/Make/Model/Trim
**Website:** https://vehicledatabases.com/vehicle-specifications-api

**Pros:**
- Comprehensive coverage
- Well-documented API
- Regular updates
- Commercial-friendly licensing

**Cons:**
- Paid service (pricing not public)
- North American focus (EU coming soon)
- Only covers 1999+

---

#### 2. Auto-Data.net API
**Coverage:** 55,000+ specifications, 3,500+ models, 10,000+ generations
**Pricing:** Custom quotes based on needs
**Parameters:** 120+ different parameters in 7 groups
**Dimension Fields:** Included in technical specifications

**Access Method:** XML/JSON API
**Website:** https://api.auto-data.net/

**Pros:**
- Very comprehensive (55,000+ specs)
- Flexible pricing - buy only categories you need
- Daily updates from multiple sources
- Well-structured data

**Cons:**
- Pricing not transparent (requires quote)
- May be expensive for full access

---

#### 3. CarQuery API
**Coverage:** Historical car and truck data
**Pricing:** Free (with downloadable database option)
**Dimension Fields:**
- model_length_mm
- model_width_mm
- model_height_mm
- model_wheelbase_mm
- model_weight_kg
- model_doors
- model_seats

**Access Method:** JSON API
**Website:** https://www.carqueryapi.com/
**Downloads:** http://www.carqueryapi.com/downloads/

**Pros:**
- FREE API access
- Good dimension coverage
- JSON format
- Downloadable database available

**Cons:**
- Data completeness/recency unclear
- Coverage of 2024-2025 models uncertain
- May lack recent updates

---

#### 4. CarsXE Vehicle Specifications API
**Coverage:** General vehicle specifications
**Pricing:** Contact for pricing
**Fields:** Make, model, year, engine, tire size, equipment, warranties

**Website:** https://api.carsxe.com/vehicle-specifications

**Pros:**
- Comprehensive vehicle data
- Commercial API

**Cons:**
- Pricing not public
- Specific dimension fields not confirmed

---

#### 5. ~~Edmunds API~~ (NO LONGER AVAILABLE)
**Status:** DISCONTINUED for public use
**Note:** Edmunds closed their public Developer API. Access now limited to strategic partners only.

**Historical Fields Included:**
- EXTERIOR_DIMENSIONS
- INTERIOR_DIMENSIONS
- CARGO_DIMENSIONS

---

### Government API

#### NHTSA vPIC API
**Coverage:** 1981-present (Model Years)
**Pricing:** FREE
**Access Method:** XML/CSV/JSON
**Website:** https://vpic.nhtsa.dot.gov/api/

**Important Limitation:**
⚠️ **Physical dimensions (length, width, height) are NOT available** through vPIC API. The API focuses on VIN-decodable information and regulatory compliance data, not detailed physical specifications.

**Available Data:**
- Make, model, year
- Body type and class
- Engine specifications
- Drive type
- Doors
- Safety features
- Brake system details

**Pros:**
- FREE government data
- Official source
- Well-documented
- 130+ attributes

**Cons:**
- NO dimension data
- Regulatory focus only
- Limited to VIN-based information

---

## Option 2: Downloadable Databases

### Recommended Sources

#### 1. Teoalida Car Database
**Coverage:** 60,000+ rows, 1945-2020 (with 1980-present being most complete)
**Formats:** Excel (XLS), CSV, MySQL
**Pricing:** Paid (samples available free)

**Dimension Completeness:**
- **1980-present:** 99% completion
- **1945-1980:** 75% completion

**Dimension Fields:**
- Length
- Width
- Height
- Wheelbase
- Cube (volume)

**Data Quality:**
- "99% data completion and accuracy guaranteed"
- "99.99% accurate" for engine and dimensions
- Source: AutoKatalog (professional source)
- Manually written in Excel
- European market guarantee (other markets available)

**Customer Reviews:**
- Positive feedback on accuracy and customer support
- "carefully written with hand and always up to date"
- "complete and accurate"

**Website:** https://www.teoalida.com/cardatabase/

**Pros:**
- High accuracy (99.99% for dimensions)
- Extensive historical coverage
- Multiple format options
- Good customer reviews
- One-time purchase

**Cons:**
- Paid service
- Primarily European market focus
- Manual updates (not real-time)
- Older data (pre-1980) less accurate

---

#### 2. Car2DB
**Coverage:** Cars since 1908 (most data from 1972+)
**Formats:** CSV, MySQL dump, Excel (xlsx)
**Pricing:** ~$72 for motorcycle DB (car pricing not listed)
**Updates:** Monthly

**Features:**
- API access available (api.car2db.com)
- Specifications of body, engine, transmission
- Demo database available (2 makes)

**Website:** https://car2db.com/

**Pros:**
- Monthly updates
- Multiple formats
- API included
- Historical coverage
- Demo available

**Cons:**
- Pricing not transparent
- Data completeness unclear
- Dimension fields not explicitly listed

---

#### 3. Database-Downloads.com
**Coverage:** 60,000+ rows, 1945-2020
**Formats:** Excel, CSV, MySQL
**Pricing:** FREE
**Fields:** 20+ fields

**Website:** https://database-downloads.com/

**Pros:**
- Completely FREE
- Large dataset
- Multiple formats
- Historical coverage

**Cons:**
- Dimension fields not confirmed
- Data quality unknown
- Update frequency unclear
- Limited documentation

---

#### 4. CarAPI.app
**Coverage:** US vehicles, 2015-2020 (free sample)
**Formats:** CSV download
**Pricing:** Free sample available

**Website:** https://carapi.app/features/vehicle-csv-download

**Pros:**
- Free sample available
- Recent data (2015-2020)
- US market focus

**Cons:**
- Limited year range in free version
- Full version pricing unknown
- Dimension fields not confirmed

---

## Option 3: Web Crawling Sources

### Crawlable Websites with Dimension Data

#### 1. AutomobileDimension.com
**URL Pattern:** `/model/make/model-name`
**Example:** https://www.automobiledimension.com/model/ford/mustang

**Data Available:**
- Length, width, height
- Boot/trunk capacity
- Weight
- Wheelbase
- Ground clearance

**Site Structure:**
- Make overview: `/make-car-dimensions.html`
- Previous models: `/previous/make`
- Comparison tools: `car-comparison.php`
- Search engine: `car-search-engine.php`

**Year Handling:** Multiple years on same page (not in URL)

**Crawlability:**
- ⚠️ robots.txt check returned 403 (possible bot protection)
- Site structure is consistent and scrapable
- No explicit ToS regarding scraping found

**Coverage:** Extensive modern and historical coverage

**Pros:**
- Well-structured URLs
- Comprehensive dimension data
- Multiple years per model
- Comparison features

**Cons:**
- Possible bot protection (403 on robots.txt)
- Years not in URL (requires page parsing)
- Legal status of scraping unclear
- May violate browsewrap ToS

---

#### 2. VehicleSizes.com
**Coverage:** 10,300+ models, dating back to 1928
**Data Fields:**
- Length, width, height
- Trunk capacity
- Curb weight
- Max weight
- Ground clearance
- Roof load
- Rim size
- Tire size

**Website:** https://www.vehiclesizes.com/

**Crawlability:**
- ⚠️ robots.txt check returned 403
- Extensive historical coverage
- 130,000+ images

**Pros:**
- Exceptional coverage (back to 1928)
- Comprehensive data fields
- Large image library

**Cons:**
- Bot protection detected
- Scraping legality unclear

---

#### 3. CarSized.com
**Coverage:** Models since 1908
**Features:** Side-by-side comparisons, true-to-scale visualizations
**Data:** 2.6M+ comparison combinations

**Website:** https://www.carsized.com/en/

**Pros:**
- Historical coverage
- Visual comparison data
- Large dataset

**Cons:**
- Designed for interactive use
- Complex scraping
- Legal concerns

---

### Legal Considerations for Web Crawling

#### Terms of Service Types

**1. Clickwrap ToS**
- Requires explicit agreement (button/checkbox)
- Creates binding contract
- MUST comply with all terms
- Scraping likely prohibited

**2. Browsewrap ToS**
- Passive, no explicit consent required
- Link typically at bottom of page
- Weaker enforceability
- May allow scraping of public data if compliant with legal/ethical principles

#### Best Practices

✅ **DO:**
- Check robots.txt file
- Review Terms of Service
- Respect rate limits
- Only scrape public data
- Consult legal experts
- Consider contacting site owners for permission

❌ **DON'T:**
- Ignore robots.txt
- Bypass access controls
- Overwhelm servers
- Scrape private/gated content
- Violate clickwrap agreements

#### Key Legal Points

- Web scraping is **legal** for publicly available data
- Legality depends on **how, what, and why** you scrape
- Different jurisdictions have different rules
- Terms of Service violations can lead to legal issues
- Some sites explicitly prohibit scraping

---

## Data Quality Comparison

| Source | Coverage | Accuracy | Completeness | Updates | Cost |
|--------|----------|----------|--------------|---------|------|
| VehicleDatabases.com API | 1999+ | High | High | Real-time | $$$ |
| Auto-Data.net API | 55,000+ specs | High | Very High | Daily | $$$ |
| CarQuery API | Historical | Medium | Medium | Uncertain | FREE |
| Teoalida Database | 1945-2020 | 99.99%* | 99%* | Manual | $$ |
| Car2DB | 1972+ | Unknown | Unknown | Monthly | $$ |
| Database-Downloads | 1945-2020 | Unknown | Unknown | Unknown | FREE |
| AutomobileDimension (crawl) | Extensive | Unknown | High | Unknown | FREE** |
| VehicleSizes.com (crawl) | 1928+ | Unknown | High | Unknown | FREE** |
| NHTSA vPIC | 1981+ | Official | N/A | Real-time | FREE |

\* For 1980-present
\** Legal/ToS compliance required

---

## Recommended Implementation Strategy

### Phase 1: Initial Data Acquisition (FASTEST)

**Option A: Commercial API** (Recommended for speed/quality)
1. Subscribe to **VehicleDatabases.com** or **Auto-Data.net**
2. Covers 1999-present comprehensively
3. Real-time updates
4. Commercial licensing clear

**Option B: Database Purchase** (Recommended for budget)
1. Purchase **Teoalida Database** (99.99% accuracy for dimensions)
2. One-time cost
3. Covers 1945-2020
4. Supplement with CarQuery API for free updates

**Option C: Free Sources** (Recommended for MVP/testing)
1. Use **CarQuery API** (free)
2. Download **Database-Downloads.com** dataset (free)
3. Test with limited data before investing

### Phase 2: Data Enrichment (OPTIONAL)

**Supplement with selective crawling:**
1. Focus on missing years/models from Phase 1
2. Crawl **AutomobileDimension.com** for specific gaps
3. Implement respectful crawling:
   - Check robots.txt
   - Rate limiting (1-2 requests/second)
   - User-Agent identification
   - Store data locally (don't re-crawl)

**Legal safeguards:**
- Consult with legal counsel
- Only crawl sites with browsewrap ToS (not clickwrap)
- Only scrape public data
- Consider requesting permission from site owners
- Maintain audit trail

### Phase 3: Ongoing Maintenance

**For APIs:**
- Scheduled API calls for new model years
- Delta updates only
- Cache responses

**For databases:**
- Annual or quarterly re-purchase
- Compare with existing data
- Merge new records

**For crawled data:**
- Quarterly updates for new models
- Monitor for ToS changes
- Respect robots.txt updates

---

## Cost-Benefit Analysis

### Commercial API Approach

**Estimated Costs:**
- API subscription: $500-$5,000/month (estimated)
- Integration development: 40-80 hours
- Maintenance: 5-10 hours/month

**Benefits:**
- Immediate access
- High quality data
- Legal clarity
- Automatic updates
- Support available

**Best for:** Production applications, commercial use, need for current data

---

### Database Purchase Approach

**Estimated Costs:**
- Teoalida database: $100-$500 (estimated one-time)
- Car2DB: ~$72+ (estimated)
- Integration development: 20-40 hours
- Updates: $50-$200/year

**Benefits:**
- One-time cost
- Full dataset ownership
- Offline access
- Historical coverage

**Best for:** Historical analysis, budget constraints, offline applications

---

### Web Crawling Approach

**Estimated Costs:**
- Development: 80-160 hours
- Infrastructure: $50-$200/month
- Legal consultation: $500-$2,000
- Maintenance: 20-40 hours/month

**Risks:**
- Legal challenges
- ToS violations
- IP blocking
- Data quality issues
- Site structure changes

**Benefits:**
- "Free" data (high labor cost though)
- Full control
- Customizable

**Best for:** Research projects, non-commercial use, when other options unavailable

---

### Free Sources Approach

**Estimated Costs:**
- Integration development: 20-40 hours
- Maintenance: 5-10 hours/month

**Limitations:**
- Data quality uncertain
- Update frequency unknown
- Limited support
- Completeness varies

**Benefits:**
- Zero data cost
- Good for MVP/testing
- Quick start

**Best for:** Proof of concept, testing, non-critical applications

---

## Technical Implementation Recommendations

### Database Schema

```sql
CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    make VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    trim VARCHAR(100),

    -- Dimensions (in mm or inches, choose one standard)
    length_mm INT,
    width_mm INT,
    height_mm INT,
    wheelbase_mm INT,
    ground_clearance_mm INT,

    -- Volume/Capacity
    trunk_volume_liters INT,

    -- Weight
    curb_weight_kg INT,

    -- Other
    doors INT,
    seats INT,

    -- Metadata
    data_source VARCHAR(50),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(make, model, year, trim)
);

CREATE INDEX idx_make_model_year ON vehicles(make, model, year);
CREATE INDEX idx_year ON vehicles(year);
```

### API Integration Pattern

```python
# Example for VehicleDatabases.com or similar API

import requests
import json
from datetime import datetime

class VehicleDimensionsAPI:
    def __init__(self, api_key):
        self.api_key = api_key
        self.base_url = "https://api.vehicledatabases.com/v1"

    def get_vehicle_specs(self, year, make, model, trim=None):
        """Fetch vehicle specifications by year, make, model"""
        params = {
            'year': year,
            'make': make,
            'model': model,
            'api_key': self.api_key
        }
        if trim:
            params['trim'] = trim

        response = requests.get(
            f"{self.base_url}/specifications",
            params=params
        )
        response.raise_for_status()
        return response.json()

    def extract_dimensions(self, api_response):
        """Extract dimension fields from API response"""
        return {
            'length_mm': api_response.get('length'),
            'width_mm': api_response.get('width'),
            'height_mm': api_response.get('height'),
            'wheelbase_mm': api_response.get('wheelbase'),
            'ground_clearance_mm': api_response.get('ground_clearance'),
            'trunk_volume_liters': api_response.get('trunk_volume'),
            'doors': api_response.get('doors'),
            'curb_weight_kg': api_response.get('curb_weight'),
        }
```

### Web Scraping Pattern (if needed)

```python
import requests
from bs4 import BeautifulSoup
import time
from urllib.parse import urljoin

class RespectfulScraper:
    def __init__(self, base_url, delay=2.0):
        self.base_url = base_url
        self.delay = delay  # seconds between requests
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'VehicleDimensionsBot/1.0 (contact@example.com)'
        })

    def check_robots_txt(self):
        """Check robots.txt before scraping"""
        robots_url = urljoin(self.base_url, '/robots.txt')
        try:
            response = self.session.get(robots_url)
            return response.text
        except:
            return None

    def scrape_vehicle_page(self, make, model):
        """Scrape vehicle dimensions from a page"""
        url = f"{self.base_url}/model/{make}/{model}"

        # Rate limiting
        time.sleep(self.delay)

        try:
            response = self.session.get(url)
            response.raise_for_status()

            soup = BeautifulSoup(response.content, 'html.parser')

            # Parse dimensions (structure varies by site)
            # This is a generic example - adjust selectors for actual site
            dimensions = {
                'length': self._extract_dimension(soup, 'length'),
                'width': self._extract_dimension(soup, 'width'),
                'height': self._extract_dimension(soup, 'height'),
            }

            return dimensions
        except Exception as e:
            print(f"Error scraping {url}: {e}")
            return None

    def _extract_dimension(self, soup, dimension_type):
        """Extract specific dimension from parsed HTML"""
        # Implementation depends on site structure
        pass
```

---

## Risk Assessment

### Legal Risks

| Risk | Severity | Likelihood | Mitigation |
|------|----------|------------|------------|
| ToS violation lawsuit | High | Low-Medium | Use licensed APIs/databases |
| Cease & desist letter | Medium | Medium | Legal review, obtain permission |
| IP blocking | Low | High | Rate limiting, respectful crawling |
| Copyright claims | Medium | Low | Only scrape factual data (not copyrightable) |

### Technical Risks

| Risk | Severity | Likelihood | Mitigation |
|------|----------|------------|------------|
| Site structure changes | Medium | High | Monitoring, flexible parsing |
| Data quality issues | Medium | Medium | Validation, multiple sources |
| API deprecation | High | Low-Medium | Vendor lock-in avoidance |
| Rate limiting | Low | High | Caching, backoff strategies |

### Business Risks

| Risk | Severity | Likelihood | Mitigation |
|------|----------|------------|------------|
| High ongoing costs | Medium | Medium | Cost-benefit analysis, optimization |
| Outdated data | Medium | Medium | Regular updates, version tracking |
| Incomplete coverage | Low | Medium | Multiple data sources |
| Vendor dependency | Medium | Medium | Data export, backup sources |

---

## Conclusion

### Feasibility: ✅ HIGHLY FEASIBLE

Building a comprehensive vehicle dimensions database is achievable through multiple approaches, each with different trade-offs.

### Top Recommendations (in order):

1. **Best Overall:** VehicleDatabases.com or Auto-Data.net API
   - Highest quality, legally clear, well-maintained
   - Best for production applications
   - Cost: $$$ but worth it for reliability

2. **Best Value:** Teoalida Database Purchase + CarQuery API
   - One-time cost for historical data
   - Free API for updates
   - 99.99% accuracy for dimensions
   - Cost: $$ (one-time)

3. **Best for MVP:** CarQuery API + Database-Downloads.com
   - Both FREE
   - Good for testing concept
   - Upgrade later to commercial sources
   - Cost: $ (development only)

4. **Web Crawling:** Only as supplementary source
   - High legal risk
   - High maintenance
   - Use only for gaps in commercial data
   - Requires legal consultation

### Next Steps:

1. **Immediate:** Test CarQuery API to validate data structure fits needs
2. **Short-term:** Request quotes from VehicleDatabases.com and Auto-Data.net
3. **Evaluation:** Compare cost vs. quality vs. coverage for your specific use case
4. **Decision:** Choose primary source based on budget and requirements
5. **Implementation:** Build integration, establish update schedule
6. **Optional:** Supplement with selective crawling if gaps exist (with legal review)

### Success Factors:

- Clear legal boundaries
- Multiple data sources for validation
- Regular update schedule
- Data quality monitoring
- Scalable infrastructure
- Budget for data acquisition

**Overall Assessment: Proceed with confidence using recommended commercial sources or free APIs for initial implementation.**
