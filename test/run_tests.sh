#!/usr/bin/env bash
flutter test --coverage
genhtml coverage/lcov.info -o /Users/zianderthalapps/coverage/html