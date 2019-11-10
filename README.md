# Can I take a day off?

[![CircleCI](https://circleci.com/gh/anwinged/dayoff/tree/master.svg?style=svg)](https://circleci.com/gh/anwinged/dayoff/tree/master)

Simple app for time traking. Pet project created with Crystal, Vue.js and Circle CI.

## Installation

With docker you can run

    $ make install
    $ make run-server

Next open <http://localhost:3000/?profile=profile-xyz> in browser,
where `profile-xyz` is profile name stored in `var/data` directory.

## Tests

    $ make spec
    $ make ameba
