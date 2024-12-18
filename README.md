<p align="center">
    <img width="400px" height=auto src="https://github.com/p2p-org/cosmos-helm-charts/blob/main/docs/images/logo.png?raw=true" />
</p>

<p align="center">
    <a href="https://x.com/P2Pvalidator"><img src="https://badgen.net/badge/twitter/@P2Pvalidator/1DA1F2?icon&label" /></a>
    <a href="https://github.com/p2p-org/cosmos-helm-charts"><img src="https://badgen.net/github/stars/p2p-org/cosmos-helm-charts?icon=github" /></a>
    <a href="https://github.com/p2p-org/cosmos-helm-charts"><img src="https://badgen.net/github/forks/p2p-org/cosmos-helm-charts?icon=github" /></a>
</p>

# P2P Cosmos Helm Charts

This repository contains Helm charts for P2P Cosmos projects. These charts are used for deploying and managing various components of the Cosmos ecosystem.

## Adding a New Chart

To add a new chart to this repository, follow these steps:

1. Create a new directory for your chart:

   ```
   mkdir -p charts/my-new-chart
   ```

2. Initialize a new Helm chart in this directory:

   ```
   helm create charts/my-new-chart
   ```

3. Customize the chart according to your needs. Make sure to update the following files:
   - `Chart.yaml`: Update metadata, especially the `name`, `description`, and `version` fields.
   - `values.yaml`: Define default values for your chart.
   - Templates in the `templates/` directory.

4. Create a `.releaserc.js` file in your chart directory using an existing one as an example - you simply need to change these lines

```js
module.exports = {
    extends: '../../.github/chart-release.config.js',
    tagFormat: 'your-chart-name-v${version}',
};
```

## Contributing

We welcome contributions to our Helm charts! Here's how you can contribute:

1. Create a new branch for your feature or bug fix
2. Make your changes
3. Submit a pull request

### Conventional Commits

We use Conventional Commits to standardize our commit messages. This helps us automatically determine version bumps and generate changelogs. Please format your commit messages as follows:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Types:

- `feat`: A new feature (minor version bump)
- `fix`: A bug fix (patch version bump)
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools and libraries

Examples:

- `feat(allora-worker): add new configuration option for worker threads`
- `fix(cosmos-operator-rpc-node): resolve issue with persistent volume claims`
- `docs: update installation instructions in README`

When to use each type:

- Use `feat` when you add a new feature or significant enhancement to a chart
- Use `fix` when you fix a bug or resolve an issue in a chart
- Use `docs` for changes to documentation files (README, CONTRIBUTING, etc.)
- Use `style` for formatting changes, missing semicolons, etc.
- Use `refactor` when you restructure code without changing its behavior
- Use `perf` for performance improvements
- Use `test` when adding or modifying tests
- Use `chore` for updates to build scripts, CI configurations, etc.

By following these conventions, you help maintain a clear and useful git history, which aids in the automatic versioning and changelog generation for our charts.

### Testing Your Changes

Tests are ran on PR.
