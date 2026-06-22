# Documentation Systems & Infrastructure

## Static Site Generators

### Docusaurus (Meta)

```bash
npx create-docusaurus@latest docs classic
```

Key config (`docusaurus.config.js`):

```javascript
module.exports = {
  title: "My API",
  url: "https://docs.example.com",
  baseUrl: "/",
  themeConfig: {
    algolia: { apiKey: "KEY", indexName: "idx", contextualSearch: true },
    prism: { additionalLanguages: ["python", "rust"] },
  },
};
```

### MkDocs (Python)

```yaml
# mkdocs.yml
site_name: My API Documentation
theme:
  name: material
  features: [navigation.tabs, toc.integrate, search.suggest, search.highlight]
plugins:
  - search
  - mkdocstrings:
      handlers:
        python:
          options: { show_source: true }
  - git-revision-date-localized
markdown_extensions: [pymdownx.highlight, pymdownx.superfences, admonition]
nav:
  - Home: index.md
  - API Reference: api/
```

### VitePress (Vue)

```typescript
// .vitepress/config.ts
export default defineConfig({
  title: "API Docs",
  themeConfig: {
    sidebar: {
      "/guide/": [
        {
          text: "Introduction",
          items: [{ text: "Getting Started", link: "/guide/getting-started" }],
        },
      ],
    },
    search: { provider: "local" },
    editLink: { pattern: "https://github.com/user/repo/edit/main/docs/:path" },
  },
});
```

## Multi-Version Documentation

### Version Switcher (Docusaurus)

```javascript
{
  versions: { current: { label: "2.0 (Next)", path: "next" } },
  onlyIncludeVersions: ["current", "1.5", "1.4"],
}
```

### Migration Guides

```markdown
# Migration Guide: v1 to v2

## Breaking Changes

**v1:** `client.authenticate(api_key)` **v2:** `client = Client(api_key=api_key)`

### Renamed Methods

| v1           | v2             | Notes     |
| ------------ | -------------- | --------- |
| `get_user()` | `fetch_user()` | Async now |
```

## Search Implementation

### Algolia DocSearch

```html
<script>
  docsearch({
    appId: "YOUR_APP_ID",
    apiKey: "YOUR_API_KEY",
    indexName: "your_index",
    container: "#docsearch",
  });
</script>
```

### Local Search (Lunr.js)

```javascript
const idx = lunr(function () {
  this.ref("id");
  this.field("title", { boost: 10 });
  this.field("content");
  documents.forEach((doc) => this.add(doc));
});
const results = idx.search("authentication");
```

## Documentation Testing

### Link Checking

```bash
# Python
linkchecker http://localhost:3000/docs
# Node
blc http://localhost:3000 -ro
```

### Code Example Testing

```python
# doctest
python -m doctest -v docs/*.md
```

```javascript
// Jest — extract code blocks and execute
test("API examples work", async () => {
  const examples = extractExamples("./docs/api.md");
  await expect(runExamples(examples)).resolves.toBeTruthy();
});
```

## Performance Optimization

### Build Optimization (Vite)

```javascript
export default {
  build: {
    rollupOptions: {
      output: { manualChunks: { vendor: ["react", "react-dom"] } },
    },
  },
};
```

### CDN & Caching (nginx)

```nginx
location /docs         { expires 1y;  add_header Cache-Control "public, immutable"; }
location ~* \.(html)$  { expires 1h;  add_header Cache-Control "public, must-revalidate"; }
```

## Analytics Integration

```javascript
// Docusaurus — Google Analytics
gtag: { trackingID: "G-XXXXXXXXXX", anonymizeIP: true }

// Custom — track search queries
analytics.track("docs_search", { query, resultCount: results.length });
```

## Quick Reference

| Tool       | Best For                      | Tech Stack     |
| ---------- | ----------------------------- | -------------- |
| Docusaurus | React projects, versioning    | React, MDX     |
| MkDocs     | Python projects, simple setup | Python, Jinja2 |
| VitePress  | Vue projects, fast builds     | Vue, Vite      |
| Nextra     | Next.js integration           | React, Next.js |
| Mintlify   | Modern UI, AI search          | React          |

| Search Solution   | Cost             | Features            |
| ----------------- | ---------------- | ------------------- |
| Algolia DocSearch | Free (OSS)       | Fast, typo-tolerant |
| Local (Lunr.js)   | Free             | Offline, no server  |
| Typesense         | Free (self-host) | Privacy-focused     |
| Meilisearch       | Free (self-host) | Fast, relevance     |
