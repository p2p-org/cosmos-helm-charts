const chartName = 'cosmos-operator-rpc-node';
const chartPath = __dirname;

module.exports = {
    extends: '../.github/chart-release.config.js',
    tagFormat: 'cosmos-operator-rpc-node-v${version}',
    plugins: [
        '@semantic-release/commit-analyzer',
        '@semantic-release/release-notes-generator',
        '@semantic-release/changelog',
        '@semantic-release/git',
        '@semantic-release/github',
        ['@semantic-release/exec', {
            prepareCmd: 'sed -i "s/^version:.*$/version: ${nextRelease.version}/" Chart.yaml && helm package . --version ${nextRelease.version} --app-version ${nextRelease.version} && mv *.tgz ../'
        }]
    ]
};
