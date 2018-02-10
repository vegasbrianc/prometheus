# A Prometheus & Grafana docker-compose stack for Raspberry Pi

Here's a quick start for an ARM monitoring stack containing [Prometheus](http://prometheus.io/), Grafana, cAdvisor and Node scraper to monitor your Docker infrastructure. The images used are multi-arch for ARM32 and ARM64 and correctly fetched from DockerHub using metadata from your archtecture. 

# Pre-requisites
Before we get started installing the Prometheus stack. Ensure you [install](https://docs.docker.com/install/#server) the latest version of docker ~~and [docker swarm](https://docs.docker.com/engine/swarm/swarm-tutorial/)~~ on your Docker host machine.

    sudo apt-get update
    sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
    add-apt-repository \
      "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable"

    sudo apt-get update -y
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker $USER

Install docker-compose

    apt-get install -qy python-pip --no-install-recommends
    pip install pip --upgrade
    pip install docker-compose
    pip install --upgrade --force-reinstall docker-compose

# Installation & Configuration
Clone the project locally to your Docker host. 

    git clone https://github.com/carlosedp/arm-monitoring.git
    cd arm-monitoring

This deployment uses XXXXXX to provide external accessible dashboards thru Traefik, in case external access is not needed, remove all references to Traefik from the `docker-compose.yml` file:

From `networks:` section, remove:

  traefik:
    external:
      name: containermgmt_traefik
 
And from the Grafana and Portainer containers, remove the traefik labels and remove from `networks:` section:

    - traefik

If you would like to change which targets should be monitored or make configuration changes edit the `/prometheus/prometheus.yml` file. The targets section is where you define what should be monitored by Prometheus. The names defined in this file are actually sourced from the service name in the docker-compose file. If you wish to change names of the services you can add the "container_name" parameter in the `docker-compose.yml` file.

Once configurations are done let's start it up. From the cloned project directory run the following command:

    docker-compose up -d

To check the containers:

    docker-compose ps

os in case of using Docker Swarm (not tested)

    $ HOSTNAME=$(hostname) docker stack deploy -c docker-compose.yml prom

That's it the `docker stack deploy` command deploys the entire stack automagically. By default cAdvisor and node-exporter are set to Global deployment which means they will propogate to every docker host attached to the Swarm.

In order to check the status of the newly created stack:

    $ docker stack ps prom

View running services:

    $ docker service ls

View logs for a specific service

    $ docker service logs prom_<service_name>

## Portainer

[Portainer](https://portainer.io/) is also installed as part of the stack. You can access it using the URL `http://<Host IP Address>:9000` for example http://192.168.10.1:9000, Portainer will ask to create a new user. For install details, check the [official site](https://portainer.io/install.html).


## Grafana

The Grafana Dashboard is now accessible via: `http://<Host IP Address>:3000` for example http://192.168.10.1:3000

    username - admin
    password - admin (Password is stored in the `config.monitoring` env file)

## Post Configuration
Create the Prometheus Datasource in order to connect Grafana to Prometheus 
* Click the `Grafana` Menu at the top left corner (looks like a fireball)
* Click `Data Sources`
* Click the green button `Add Data Source`.

## Install Dashboard
There area a couple of dashboards for monitoring the infrastructure and Docker in the repository. Simply select from the Grafana menu -> Dashboards -> Import or import te default ones from Grafana website using the ID.

* [Docker Dashboard](https://grafana.net/dashboards/179).
* [Docker and System Monitoring](https://grafana.net/dashboards/893).
* [Node monitoring - Hardware](https://grafana.net/dashboards/1860).

## Alerting - Currently disabled
Alerting has been added to the stack with Slack integration. 2 Alerts have been added and are managed.

Alerts              - `prometheus/alert.rules`
Slack configuration - `alertmanager/config.yml`

The Slack configuration requires to build a custom integration.
* Open your slack team in your browser `https://<your-slack-team>.slack.com/apps`
* Click build in the upper right corner
* Choose Incoming Web Hooks link under Send Messages
* Click on the "incoming webhook integration" link
* Select which channel
* Click on Add Incoming WebHooks integration
* Copy the Webhook URL into the `alertmanager/config.yml` URL section
* Fill in Slack username and channel

View Prometheus alerts `http://<Host IP Address>:9090/alerts`
View Alert Manager `http://<Host IP Address>:9093`

### Test Alerts
A quick test for your alerts is to stop a service. Stop the node_exporter container and you should notice shortly the alert arrive in Slack. Also check the alerts in both the Alert Manager and Prometheus Alerts just to understand how they flow through the system.

High load test alert - `docker run --rm -it busybox sh -c "while true; do :; done"`

Let this run for a few minutes and you will notice the load alert appear. Then Ctrl+C to stop this container.

# Security Considerations
This project is intended to be a quick-start to get up and running with Docker and Prometheus. Security has not been implemented in this project. It is the users responsability to implement Firewall/IpTables and SSL.

Since this is a template to get started Prometheus and Alerting services are exposing their ports to allow for easy troubleshooting and understanding of how the stack works.

## Production Security:
Here are just a couple security considerations for this stack to help you get started.
* Remove the published ports from Prometheus and Alerting servicesi and only allow Grafana to be accessed
* Enable SSL for Grafana with a Proxy such as [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/) or [Traefik](https://traefik.io/) with Let's Encrypt
* Add user authentication via a Reverse Proxy [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/) or [Traefik](https://traefik.io/) for services cAdvisor, Prometheus, & Alerting as they don't support user authenticaiton
* Terminate all services/containers via HTTPS/SSL/TLS
