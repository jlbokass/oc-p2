# Frontend tests and Jest coverage

## Scope

The frontend test suite uses Jest for Angular services, Guards/interceptors and components.

The coverage configuration explicitly includes production files even when they are not imported by an existing test.

Covered categories:

```text
src/app/**/*.component.ts
src/app/core/service/*.service.ts
src/app/core/guard/*.guard.ts
src/app/core/interceptor/*.interceptor.ts
```

Spec files are excluded from the denominator.

`UserMockService` was a test helper stored in the production source tree. It is no longer required once `RegisterComponent` uses a local mock in its spec and should be removed.

## Run

From the workspace with the dedicated test Compose environment:

```bash
docker compose -f compose.test.yaml run --rm frontend-test   npm run test:coverage
```

From the frontend repository directly:

```bash
npm run test:coverage
```

## Coverage rule

The blocking metric is:

```text
Jest Lines >= 80 %
```

The other Jest metrics remain visible for diagnostic purposes:

- statements;
- branches;
- functions;
- lines.

A green test suite does not by itself prove sufficient coverage.

## Reports

HTML:

```text
coverage/index.html
```

LCOV:

```text
coverage/lcov.info
```

Terminal output includes the coverage summary.

The Jest run fails when global line coverage is below 80 %.

## Evidence

For the project evidence, keep:

- the tested frontend commit SHA;
- the Jest test result;
- the `Lines` percentage;
- the HTML report location.
