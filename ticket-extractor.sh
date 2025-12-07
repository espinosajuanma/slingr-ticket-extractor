#!/bin/bash

SIZE="1000"
POOL_NAME="Non-LIMS"
OUTPUT_MODE="$1"

PROJECT_IDS="$(solutions q support.pools --name "$POOL_NAME" --_size 1 | \
              jq -r '.items[0].projects | map(.id) | join(",")')"

JQ_TICKET_TO_HTML='
.items[] |
[
  "<h1>#\(.number) \(.title)</h1>",
  "<table>",
  "<tr><td><strong>Project</strong></td><td>\(.project.label)</td></tr>",
  "<tr><td><strong>Status</strong></td><td>\(.status)</td></tr>",
  "<tr><td><strong>Priority</strong></td><td>\(.priority)</td></tr>",
  "<tr><td><strong>Assignee</strong></td><td>\(.assignee.label // "Unassigned")</td></tr>",
  "<tr><td><strong>Customer</strong></td><td>\(.customer.label)</td></tr>",
  "</table>",

  "<h2>Description</h2>",
  .description,

  (if (.attachments | length) > 0 then
    "<h3>Attachments</h3><ul>" +
    (.attachments | map("<li><a href=\"\(.link)\">\(.file.name)</a></li>") | join("")) +
    "</ul>"
  else "" end),

  (if (.notes | length) > 0 then
    "<h2>Public Notes</h2>" +
    (.notes | map("<blockquote><strong>\(.label)</strong><br>\(.note)</blockquote>") | join("\n"))
  else "" end),

  (if (.internalNotes | length) > 0 then
    "<h2>Internal Notes</h2>" +
    (.internalNotes | map("<blockquote><strong>\(.label)</strong><br>\(.note)</blockquote>") | join("\n"))
  else "" end),

  "<hr>"
]
| join("\n")
'

fetch_and_parse() {
    solutions q support.tickets \
      --project "$PROJECT_IDS" \
      --_size "$SIZE" \
      --_sortField "createdTimestamp" \
      --_sortType "desc" | \
    jq -r "$JQ_TICKET_TO_HTML"
}

if [[ "$OUTPUT_MODE" == "html" ]]; then
    fetch_and_parse
else
    fetch_and_parse | pandoc -f html -t gfm
fi