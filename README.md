# Gilded Rose

This is the Gilded Rose kata in Rescript with Jest. I copied the initial code from https://github.com/emilybache/GildedRose-Refactoring-Kata/tree/main/rescript.

This is my take on the refactoring.
Focus here is to have "atomic" commits and leverage Rescript's type system to make the code more reliable with successive small refactors.

Up to commit #5adefec6, the refactor consists mostly of "strangling" the old application by catching the logic for each type of item with a switch case and handling them in the new code, which is safer and simpler than changing the old code.

## Getting started

Install dependencies

```sh
yarn install
```

## Running tests

To run all tests

```sh
yarn test
```

To run all tests in watch mode

```sh
yarn test:watch
```

To start developing
```sh
yarn dev:rescript
```

To run the TextTest file
```sh
yarn texttest [days]
```
