# Privacy Policy

**Claude Blog** is a Claude Code plugin that runs entirely on your local machine. It does not collect, store, transmit, or share any personal data or usage information.

## What This Plugin Does NOT Do

- Does not collect analytics or telemetry
- Does not send data to any external server (except when you explicitly use web search, API calls to CMS platforms, or MCP servers you configure)
- Does not create accounts or require authentication
- Does not store cookies or tracking identifiers
- Does not access any data outside of the files and URLs you provide to it

## Third-Party Services

When you explicitly invoke certain commands, the plugin may interact with external services **on your behalf and under your control**:

| Feature | Service | When |
|---------|---------|------|
| AI image generation | Google Gemini API (via nanobanana-mcp) | Only when you run `/blog image` and have configured your own API key |
| Audio narration | Google Gemini TTS API | Only when you run `/blog audio` and have configured your own API key |
| Web research | Search engines | Only when you run `/blog write`, `/blog rewrite`, or `/blog factcheck` |
| CMS taxonomy sync | WordPress, Shopify, Ghost, Strapi, Sanity APIs | Only when you run `/blog taxonomy` with your own CMS credentials |
| NotebookLM research | Google NotebookLM | Only when you run `/blog notebooklm` with your own configuration |

All API keys and credentials are stored locally in your environment variables or `.env` files. This plugin never transmits your credentials to any party other than the service you are explicitly calling.

## Data Residency

All generated content (blog posts, images, audio files, analysis reports) is saved to your local filesystem only.

## Contact

For privacy questions, open an issue at: https://github.com/AgriciDaniel/claude-blog/issues

## Last Updated

2026-03-27
