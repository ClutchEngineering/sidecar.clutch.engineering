# Articles Directory

This directory contains markdown content that is dynamically injected into vehicle make and model pages on the Sidecar website.

## Directory Structure

```
articles/
├── {make}/
│   ├── about.md           # About the make (shown at bottom of make pages and model pages)
│   └── {model}/
│       └── about.md       # About the specific model (shown on model pages)
```

## Naming Conventions

- Make names should use the same format as in the URL structure (e.g., `saab`, `toyota`, `bmw`)
- Model names should use underscores instead of spaces and match the URL format (e.g., `9_5` for "9-5", `model_3` for "Model 3")

## File Formats

### Make About (`{make}/about.md`)

This file should contain:
- Brief history of the automotive manufacturer
- Notable achievements or innovations
- Brand philosophy and characteristics
- Current status of the company

This content will appear:
- At the bottom of the make page (e.g., `/supported-cars/saab/`)
- At the bottom of all model pages for that make (e.g., `/supported-cars/saab/9-5/`)

### Model About (`{make}/{model}/about.md`)

This file should contain:
- Introduction to the specific model
- Design philosophy and key features
- Engine options and variants
- Historical significance or legacy
- Generation-specific information

This content will appear:
- On the model page, between the legend and FAQ sections

## Markdown Support

All markdown files are rendered using the `Article` view component, which supports:
- Headings (H1-H6)
- Paragraphs
- Bold and italic text
- Links
- Lists (ordered and unordered)
- Code blocks
- Tables
- Images
- Blockquotes

## Example

See the Saab 9-5 example files in this directory:
- `saab/about.md` - Information about Saab as a manufacturer
- `saab/9_5/about.md` - Information about the Saab 9-5 model

## Generations Data

In addition to markdown content, generation information is automatically pulled from the OBDb workspace's `generations.yaml` files. If a `generations.yaml` file exists for a given make/model in the workspace, it will be displayed in a "Generations" section on the model page.

### Example `generations.yaml` structure:

```yaml
generations:
  - name: "First Generation"
    start_year: 1997
    end_year: 2009
    description: "The first-generation Saab 9-5..."

  - name: "Second Generation"
    start_year: 2010
    end_year: 2012
    description: "The second-generation Saab 9-5..."
```

## Optional Content

All markdown files are optional. If a file doesn't exist for a given make or model, that section simply won't appear on the page. This allows for gradual content addition without breaking the site.
