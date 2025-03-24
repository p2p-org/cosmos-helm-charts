module.exports = {
    branches: ['main'],
    plugins: [
        ['@semantic-release/commit-analyzer', {
            preset: 'conventionalcommits',
            releaseRules: [
                { type: 'feat', release: 'minor' },
                { type: 'fix', release: 'patch' },
            ],
        }],
        ['@semantic-release/git', {
            assets: ['CHANGELOG.md', 'Chart.yaml'],
            message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}',
        }],
        '@semantic-release/release-notes-generator',
        ['@semantic-release/changelog', {
            changelogFile: 'CHANGELOG.md',
        }],
        ['@semantic-release/exec', {
            prepareCmd: `
                sed -i "s/^version:.*$/version: \${nextRelease.version}/" Chart.yaml && \
                helm package . --version \${nextRelease.version} --app-version \${nextRelease.version} && \
                mv ${process.env.CHART_NAME}-\${nextRelease.version}.tgz ${process.env.GITHUB_WORKSPACE}/release/ && \
                ls -l ${process.env.GITHUB_WORKSPACE}/release/
            `
        }],
        ['@semantic-release/github', {
            assets: [
                `${process.env.GITHUB_WORKSPACE}/release/${process.env.CHART_NAME}-*.tgz`
            ]
        }]
    ]
};
