const path = require('path');
const webpack = require('webpack');

const ManifestPlugin = require('webpack-manifest-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CompressionPlugin = require('compression-webpack-plugin');
const zopfli = require('@gfx/zopfli');

const config = {
    context: path.resolve(__dirname, 'app/javascript/packs'),
    entry: {
        application: './application.js',
        'images/ccpts': './images/ccpts.png',
        'images/favicon': './images/favicon.ico'
    },
    output: {
        path: path.resolve(__dirname, 'public/packs'),
        filename: '[name]-[hash].js'
    },
    resolve: {
        extensions: ['.ts', '.tsx', '.js', '.scss', '.css'],
        alias: {
            'jquery': 'jquery/src/jquery',
            'jquery-ui': 'jquery-ui-dist/jquery-ui.js'

        }
    },
    module: {
        rules: [
            {
                test: /\.(css|scss)$/, use: [
                    {
                        loader: MiniCssExtractPlugin.loader,
                        options: {
                            hmr: true
                        },
                    },
                    'css-loader',
                    'sass-loader'
                ]
            },
            {
                test: /\.(png|jpg|gif|ico|eot|ttf|woff|woff2|svg)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            outputPath: 'images/',
                            name: '[name]-[hash].[ext]',
                        },
                    },
                ],
            },
            { test: /\.tsx?$/, loader: "ts-loader" }
        ],
    },
    plugins: [
        new ManifestPlugin({
            fileName: 'manifest.json',
            publicPath: 'packs/',
            writeToFileEmit: true
        }),
        new MiniCssExtractPlugin({ filename: '[name]-[contentHash].css' }),
        new webpack.ProvidePlugin({
            $: 'jquery/src/jquery',
            jQuery: 'jquery/src/jquery',
            FastClick: 'fastclick'
        })
    ]
};

module.exports = (env, argv) => {
    if (argv.mode === 'development') {
        config.devtool = "source-map";

        config.devServer = {
            publicPath: '/packs/',
            contentBase: './public',
            host: '0.0.0.0',
            port: 3035,
            disableHostCheck: true,
            headers: {
                'Access-Control-Allow-Origin': '*'
            }
        };
    } else if (argv.mode === 'production') {
        config.output.filename = '[name]-[contentHash].js';

        config.plugins.push(
            new CompressionPlugin({
                test: /\.(css|js|png|jpg|gif|ico|eot|ttf|woff|woff2|svg)$/,
                algorithm(input, compressionOptions, callback) {
                    return zopfli.gzip(input, compressionOptions, callback);
                }
            })
        );
    }

    return config;
};
