# healthcheck-test
Healthcheck integration test container


Used to check a healthcheck endpoint during integration tests on another container.  For best results use with compose:

```

services:
  yourapp:
  build: .

  healthcheck_test:
    image: therepo:healthecheck_test
    environment:
      TARGET_HOST: 'yourapp'


```

Variables:

* **TARGET_HOST**:  `string` **Required** the host to health check
* **TARGET_PORT**: `int` the port to health check [Default: `9097`]
* **TARGET_PATH**: `string` the path to health check [Default: `/health/`]
* **TARGET_USE_HTTPS**: `bool` use http or https [Default: `False`]
* **TARGET_TIMEOUT**: `int` the timeout, in seconds, to wait for the health check [Default: `1`]
