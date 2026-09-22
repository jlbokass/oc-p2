# Backend tests and coverage

## Test stack

The backend test suite uses:

- JUnit 5;
- Mockito;
- Spring Boot Test / MockMvc;
- Testcontainers;
- MySQL 8.4;
- JaCoCo.

Service tests are unit tests. Controller tests are integration tests and use an isolated MySQL container.

## Run the backend verification

From the project workspace, using the dedicated test Compose environment:

```bash
docker compose -f compose.test.yaml run --rm backend-test mvn verify
```

From the backend repository directly, when the local environment provides the required Docker/Testcontainers configuration:

```bash
mvn verify
```

## Coverage rule

The blocking project metric is JaCoCo line coverage:

```text
LINE >= 80 %
```

Generated MapStruct implementation classes matching `*MapperImpl` are excluded.

The Maven `verify` phase fails when the configured line coverage is below 80 %.

## Report

After a successful run, the HTML report is available at:

```text
target/site/jacoco/index.html
```

The execution data is stored in:

```text
target/jacoco.exec
```

For project evidence, record the tested backend commit SHA together with the JaCoCo LINE percentage.
