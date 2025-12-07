# Support Ticket Extractor for LM Knowledge Bases

This script is designed to extract support tickets from a specified support
pool within the Solutions app. Its primary goal is to transform these tickets
into a structured, readable format (HTML or Markdown) suitable for ingestion
into a language model (LM) knowledge base, specifically for support training
purposes. By providing the LM with real-world support interactions,
descriptions, and resolutions, it can improve its ability to understand,
categorize, and respond to future support queries.

## Prerequisites

Before running this script, ensure you have the following installed and configured:

1. **Bash Shell:** The script is written in Bash.
2.  **`slingr` CLI (renamed/symlinked as `solutions`):** This is the primary tool used to interact with the Slingr app API.

**Clone the `slingr-bash` repository:**

```bash
git clone https://github.com/espinosajuanma/slingr-bash.git
```

**Make `slingr` accessible as `solutions`:**
* **Copy `slingr` and rename it:**

This makes a standalone `solutions` command.

```bash
# Navigate into the cloned directory
cd slingr-bash
# Copy the slingr executable and rename it to 'solutions'
# Choose a directory in your $PATH, e.g., /usr/local/bin or ~/bin
cp slingr /usr/local/bin/solutions
```

*Ensure `/usr/local/bin` (or your chosen path) is in your shell's `$PATH` environment variable.*

**Authentication:** Ensure you are configured and authenticated with the `slingr` CLI (now accessible as `solutions`) to access your organization's data. This typically involves running commands like `solutions app solutions`, `solutions env prod`, and `solutions email [your_email]`.

3. **`jq`:** A lightweight and flexible command-line JSON processor.
  * **Installation (macOS via Homebrew):** `brew install jq`
  * **Installation (Ubuntu/Debian via apt):** `sudo apt-get update && sudo apt-get install jq`
4. **`pandoc`:** A universal document converter. Required for converting the HTML output to Markdown.
  * **Installation (macOS via Homebrew):** `brew install pandoc`
  * **Installation (Ubuntu/Debian via apt):** `sudo apt-get update && sudo apt-get install pandoc`

## Installation

1. **Save the script:**
Save the provided script content into a file, for example, `extract_tickets.sh`.

2. **Make it executable:**
```bash
chmod +x extract_tickets.sh
```

## Configuration

The most important configuration step is to specify the `POOL_NAME` you want to extract tickets from.

1. **Identify your Support Pool:**
    Log into the solutions app and navigate to your support pools. Find the exact name of the pool you wish to extract tickets from. Common examples might be "LIMS", "Non-LIMS", etc.

2. **Edit the script:**
    Open `extract_tickets.sh` in a text editor and modify the `POOL_NAME` variable on **line 3**:

```bash
POOL_NAME="Your Exact Pool Name Here" # <--- Change this!
```

For example, if your pool is named "Tier 1 Support":
```bash
POOL_NAME="Tier 1 Support"
```

## Usage

Run the script from your terminal.

### Default Output (GitHub Flavored Markdown)

By default, the script outputs tickets formatted as GitHub Flavored Markdown (GFM). This is generally the preferred format for LM ingestion as it's plain text with rich formatting.

```bash
./extract_tickets.sh > support_tickets.md
```

This command will:
1. Fetch tickets from the configured `POOL_NAME`.
2. Convert them into Markdown (GFM).
3. Save the entire output to `support_tickets.md`.

### HTML Output

If you prefer the raw HTML output, pass `html` as an argument:

```bash
./extract_tickets.sh html > support_tickets.html
```

This command will:
1.  Fetch tickets from the configured `POOL_NAME`.
2.  Output them as raw HTML.
3.  Save the entire output to `support_tickets.html`.

### Printing to Console

You can also just print the output directly to your terminal:

```bash
./extract_tickets.sh          # For Markdown
./extract_tickets.sh html     # For HTML
```

