# 🕵️‍♀️ ProxyCrypt

ProxyCrypt is a lightweight HTTPS wrapper for a non-encrypted reversed-proxy with a random self-signed encryption certificate key. It acts as an SSL/TLS termination for upstream services, relieving them of the computational requirements of encryption (not to mention the woeful practice of including keystores in their Docker images).

This [fork from the original](https://github.com/NASA-PDS/proxycrypt) adds support for serving static assets and multimedia for [Django](https://www.djangoproject.com)- and [Wagtail](https://wagtail.org)-based applications.

ProxyCrypt itself does not include a certificate or keystore. Instead, it generates a random self-signed certificate on each startup. This means:

-   Better separation of concerns: application containers and processes can focus on their applications, not on encryption.
-   A single TLS stack can be presented to an outside composition or swarm, enabling tighter focus on vulnerabilities instead of chasing them around multiple implementations in multiple containers/processes.
-   Private keystores shouldn't appear in images in public image/container registries since anyone can grab a copy and masquerade as your own service.
    -   Generating and storing keystores at image build time also doesn't give a good way to support certificate revocation.
-   This approach should also satisfy the JPL requirement of having at least self-signed certificates on all host-accessible services
    -   And at JPL, this requirement extends to `localhost`¹!

It's powered by [Nginx](https://nginx.org/) and [Alpine](https://www.alpinelinux.org/), which is why ProxyCrypt is so lightweight 🪶.


## 🏃‍♀️ Building and Running

To build the ProxyCrypt image, run:

    docker image build --tag edrndocker/proxycrypt --file docker/Dockerfile .

Or just make a push to `main` and let Github Actions handle it.

To run it, put it in your Docker Composition/Swarm/etc., and set these environment variables as needed:

| Variable         | Use                                                                     | Default            |
|:-----------------|:------------------------------------------------------------------------|:-------------------|
| `PROXY_URL`      | Upstream service in the composition/swarm/etc.                          | (unset, required)  |
| `PROXY_PATH`     | URL path from which the service should be called, e.g. /exposed-path/³  | (unset, required)  |
| `PROXY_PORT`     | port used by the proxy, as seen by the user                             | (unset, required)  |
| `CERT_CN`        | Common name for the random certificate, such as `www.myservice.io`      | `localhost`        |
| `CERT_DAYS`      | How many days before the random certificate expires                     | `365`              |
| `PROXY_REDIRECT` | How to rewrite Location and Refresh headers if necessary                | (unset, required)² |

You should also map these two filesystem locations as volumes:

-   The Wagtail `media` directory to `/app/media`
-   The Django `static` directory to `/app/static`

You can run it locally for testing purposes. Suppose you've got a non-SSL service on TCP port, say, 9200 on your rig. You can run:

    docker container run --env PROXY_URL=http://host.docker.internal:9200/ --env PROXY_PATH=/exposed-path/ --publish 8888:443 --volume ${HOME}/Desktop:/app/static --volume ${HOME}/Downloads:/app/media --rm edrndocker/proxycrypt --detach

and get an `https` version of that service on port 8888:

    curl --insecure https://localhost:8888/exposed-path

You'll need the `--insecure` (or its equivalent in other applications) since it's a self-signed key. You can also try to access your Desktop files as "static" assets:

    curl --insecure https://localhost:8888/exposed-path/static/some-file

and your Downloads directory as "media" files:

    curl --insecure https://localhost:8888/exposed-path/media/some-other-file


## 👥 Contributing

Within the Early Detection Research Network, we value the health of our community as much as the code. Towards that end, we ask that you read and practice what's described in these documents:

-   Our [contributor's guide](https://github.com/EDRN/.github/blob/main/CONTRIBUTING.md) delineates the kinds of contributions we accept.
-   Our [code of conduct](https://github.com/EDRN/.github/blob/main/CODE_OF_CONDUCT.md) outlines the standards of behavior we practice and expect by everyone who participates with our software.


### 🔢 Versioning

We use the [SemVer](https://semver.org/) philosophy for versioning this software.


## 📃 License

The project is licensed under the [Apache version 2](LICENSE.md) license.


## 👣 Footnotes

¹Just wait: they're going to demand TLS on Unix Domain Sockets next! 😝

²See the [Nginx documentation on `proxy_redirect`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_redirect) for more information. Unsure where to start? Try using the word `default`.

³This must end in a `/`. If you want to match just the root URI, then use a single `/`
