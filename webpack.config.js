const path = require('path');
const autoprefixer = require('autoprefixer');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = (env = {}) => {
    const is_prod = !!env.production;

    const STYLE_LOADER = { loader: 'style-loader' };

    const CSS_LOADER = {
        loader: 'css-loader',
        options: {
            importLoaders: true,
        },
    };

    const POSTCSS_LOADER = {
        loader: 'postcss-loader',
        options: {
            plugins: [autoprefixer()],
        },
    };

    const SCSS_LOADER = { loader: 'sass-loader' };

    const MINI_CSS_LOADER = MiniCssExtractPlugin.loader;

    const BABEL_LOADER = {
        loader: 'babel-loader',
        options: {
            presets: ['@babel/preset-env'],
            plugins: [
                '@babel/plugin-transform-runtime',
                '@babel/plugin-proposal-class-properties',
            ],
        },
    };

    const VUE_LOADER = {
        loader: 'vue-loader',
        options: {
            loaders: {
                css: [
                    MINI_CSS_LOADER, //'vue-style-loader',
                    CSS_LOADER,
                    POSTCSS_LOADER,
                ],
                scss: [
                    MINI_CSS_LOADER, //'vue-style-loader',
                    CSS_LOADER,
                    POSTCSS_LOADER,
                    SCSS_LOADER,
                ],
            },
        },
    };

    return {
        mode: is_prod ? 'production' : 'development',
        entry: './assets/main.js',
        output: {
            filename: '[name].js',
            path: path.resolve(__dirname, './public/assets/'),
            publicPath: '/assets/'
        },
        module: {
            rules: [
                {
                    test: /\.js$/,
                    exclude: /node_modules/,
                    use: [BABEL_LOADER],
                },
                {
                    test: /\.css$/,
                    use: [MINI_CSS_LOADER, CSS_LOADER, POSTCSS_LOADER],
                },
                {
                    test: /\.scss$/,
                    use: [
                        MINI_CSS_LOADER,
                        CSS_LOADER,
                        POSTCSS_LOADER,
                        SCSS_LOADER,
                    ],
                },
                {
                    test: /\.vue$/,
                    use: [VUE_LOADER],
                },
            ],
        },
        plugins: [
            new VueLoaderPlugin(),
            new MiniCssExtractPlugin({
                // Options similar to the same options in webpackOptions.output
                // both options are optional
                filename: '[name].css',
                // chunkFilename: "[id].css"
            }),
        ],
    };
};
