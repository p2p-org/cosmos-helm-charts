const path = require('path');

module.exports = {
    branches: ['main'],
    tagFormat: '${CHART_NAME}-v${version}',
    plugins: [
        ['@semantic-release/commit-analyzer', {
            preset: 'conventionalcommits',
            releaseRules: [
                { type: 'feat', release: 'minor' },
                { type: 'fix', release: 'patch' },
            ],
        }],
        '@semantic-release/release-notes-generator',
        ['@semantic-release/changelog', {
            changelogFile: 'CHANGELOG.md',
        }],
        ['@semantic-release/git', {
            assets: ['CHANGELOG.md', 'Chart.yaml'],
            message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}',
        }],
        ['@semantic-release/github', {
            assets: [
                { path: '${CHART_NAME}-${nextRelease.version}.tgz', label: '${CHART_NAME} Chart' },
            ],
        }],
    ],
    prepare: [
        {
            path: '@semantic-release/exec',
            cmd: 'sed -i "s/^version:.*$/version: ${nextRelease.version}/" Chart.yaml',
        },
        {
            path: '@semantic-release/exec',
            cmd: 'helm package . --version ${nextRelease.version} --app-version ${nextRelease.version}',
        },
    ],
};
