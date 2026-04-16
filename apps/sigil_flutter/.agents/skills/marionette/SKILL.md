---
name: marionette
description: Visual verification of Flutter UI using the Marionette MCP server. Use when launching the app, taking screenshots, or interacting with the running app for visual testing.
---

You use the **Marionette MCP** server to visually verify Flutter UI in a running debug app.

## Connection Workflow

**CRITICAL**: Marionette needs the **VM service URI**, NOT the DTD URI.

1. Launch the app:
   ```
   mcp__dart__launch_app(root: "apps/sigil_flutter/", device: "macos")
   ```
   This returns a `dtdUri` — **do NOT use it for marionette**.

2. Get the VM service URI from app logs:
   ```
   mcp__dart__get_app_logs(pid: <pid>, maxLines: -1)
   ```
   Find the `app.debugPort` event and extract `wsUri` (format: `ws://127.0.0.1:PORT/TOKEN=/ws`).

3. Connect marionette with the VM service URI:
   ```
   mcp__marionette__connect(uri: <wsUri>)
   ```

4. If connection fails, marionette MCP **will crash**. The user must resume it via `/mcp` before retrying.

## Taking Screenshots

```
mcp__marionette__take_screenshots()
```

Returns a visual screenshot of the current app state. Use after navigating to the target screen.

## Navigation

Use `scroll_to` to bring elements into view:
```
mcp__marionette__scroll_to(text: "Widget Text")
mcp__marionette__scroll_to(key: "widget_key")
```

Keys (`ValueKey<String>`) are more reliable than text matching.

## Interaction

- `mcp__marionette__tap(text: "Button Text")` — tap a button or element
- `mcp__marionette__enter_text(text: "input", key: "field_key")` — type into a text field
- `mcp__marionette__hot_reload()` — reload after code changes without losing state

## After Code Changes

1. Make code edits
2. Call `mcp__marionette__hot_reload()` (preserves app state)
3. Take a screenshot to verify

## Troubleshooting

- **"Connection closed" on connect**: The app isn't ready yet or the URI is wrong. Check logs for the correct `wsUri`.
- **Marionette tools disappear**: The MCP server crashed. User must resume it via `/mcp`.
- **Can't find element**: Add a `ValueKey<String>` to the widget in source code, hot reload, then retry.
