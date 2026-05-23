# CI Application Pipeline

### How to Get SHA for Any GitHub Action

```bash
git ls-remote <https://github.com/actions/checkout.git> refs/tags/<v6.0.2> | cut -f1
```

| Repository      | Links                                           |
| --------------- | ----------------------------------------------- |
| Checkout        | https://github.com/actions/checkout.git         |
| gitleaks-action | https://github.com/gitleaks/gitleaks-action.git |
| codeql-action   | https://github.com/github/codeql-action.git     |
| upload-artifact | https://github.com/actions/upload-artifact.git  |

## [Reusable Static Analysis](.github/workflows/reusable-static-analysis.yaml)

## [Reusable Testing](.github/workflows/reusable-testing.yaml)

### When to use matrix

- < 3 minutes → no matrix, single job
- 3-8 minutes → consider matrix [unit, integration]
- 8-20 minutes → matrix [unit, integration, e2e]
- .> 20 minutes → matrix + also optimize test suite itself

The contract between DevOps and Dev team is simple:

```
DevOps says:  "Put unit tests in src/**/*.test.js"
DevOps says:  "Put integration tests in tests/integration/**/*.test.js"
Dev does:     Writes tests in those folders
Pipeline:     Automatically picks up based on folder path
```

What DevOps engineer sets up in `package.json`:

```json
{
  "scripts": {
    "test": "jest",
    "test:unit": "jest src/unit --coverage",
    "test:integration": "jest src/integration --coverage",
    "test:e2e": "jest tests/e2e"
  }
}
```

What developers do:

```
They just write tests and put them in the right folder.
They never touch the pipeline.

src/
├── user/
│   ├── user.service.js
│   └── user.service.test.js    ← developer puts unit test here
tests/
└── integration/
    └── user-api.test.js         ← developer puts integration test here
```

## [Reusable Docker](.github/workflows/reusable-docker.yaml)

You can search for cosign : https://search.sigstore.dev
