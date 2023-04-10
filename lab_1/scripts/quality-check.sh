#!/bin/bash

echo "Checking linting..."
npm run lint

echo "Running unit tests..."
npm run test

echo "Running e2e tests..."
npm run e2e