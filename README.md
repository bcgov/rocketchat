## TL;DR

The Rocket.Chat application is the primary communication tool for Platform Services and projects using either the [BCDevExchange Lab](https://bcdevexchange.org) or OpenShift Container Platform.. This repo contains all the components for deploying the Rocket.Chat application and its helper application Reggie. See the following documents for more information:

* [Rocket.Chat](./docs/rocketchat.md); and
* [Reggie](./docs/reggie.md).

## Project Structure

Find anything relevant to the project as a whole in the repo root such as OCP4 manifests; docker compose file; and development configuration. Each of the two main components to the project are listed below and have their own build and deployment documentation:

* [Rocket.Chat](./docs/rocketchat.md); and
* [Reggie](./docs/reggie.md).

## Architecture

The following diagram illustrations the configuration the different components needed to provide Rocket.Chat as a service to our wider community:

![Application Architecture](./docs/architecture.png "Application Architecture")


## Project Status / Goals / Roadmap

Additional features and fixes can be found in backlog; find it under issues in this repo.

## Getting Help or Reporting an Issue

If you find issues with this application suite please create an [issue](https://github.com/bcgov/secure-image-app/issues) describing the problem in detail.

## How to Contribute

Contributions are welcome. Please ensure they relate to an issue. See our 
[Code of Conduct](./CODE-OF-CONDUCT.md) that is included with this repo for important details on contributing to Government of British Columbia projects. 

## License

See the included [LICENSE](./LICENSE) file.
