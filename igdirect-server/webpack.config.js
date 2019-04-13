var path = require('path');

module.exports = {
    target: "node",
    entry: './app.js',
    output: {
        path: path.resolve(__dirname, 'bin'),
        filename: 'app.bundle.js',
    },
    module: {
        rules: [{
            test: /\.js?$/,
            exclude: /node_modules/,
            loader: 'babel-loader',
            options: {
                presets: [
                    [
                        "@babel/preset-env",
                        {
                            targets: {
                                node: "8.10"
                            }
                        }
                    ]
                ]
            }
        }]
    },
    resolveLoader: {
        modules: [
            __dirname + '/node_modules'
        ]
    }
};