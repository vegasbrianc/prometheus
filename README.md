# A Prometheus & Grafana docker-compose stack
Here's a quick start to stand-up a [Prometheus](http://prometheus.io/) stack containing Prometheus, Grafana and Node scraper to monitor your Docker infrastructure. A big shoutout to [philicious](https://github.com/philicious) for kicking this project off!

##Pre-requisites
Before we get started installing the Prometheus stack. Ensure you install the latest version of docker and [docker-compose](https://docs.docker.com/compose/install/) on your Docker host machine. This has also been tested with Docker for Mac and it works well.

##Installation & Configuration
Clone the project locally to your Docker host. 

If you would like to change which targets should be monitored or make configuration changes edit the [/prometheus/prometheus.yml](https://github.com/vegasbrianc/prometheus/blob/version-2/prometheus/prometheus.yml) file. The targets section is where you define what should be monitored by Prometheus. The names defined in this file are actually sourced from the service name in the docker-compose file. If you wish to change names of the services you can add the "container_name" parameter in the `docker-compose.yml` file.

Once configurations are done let's start it up. From the /prometheus project directory run the following command:

    $ docker-compose up -d


That's it. docker-compose builds the entire Grafa and Prometheus stack automagically. 

The Grafana Dashboard is now accessible via: `http://<Host IP Address>:3000` for example http://192.168.10.1:3000

username - admin
password - foobar (Password is stored in the `config.monitoring` env file)

## Post Configuration
Now we need to create the Prometheus Datasource in order to connect Grafana to Prometheus 
* Click the `Grafana` Menu at the top left corner (looks like a fireball)
* Click `Data Sources`
* Click the green button `Add Data Source`.

<img src="https://github.com/vegasbrianc/prometheus/blob/version-2/images/Add_Data_Source.png" width="400" heighth="400">

## Alerting
Alerting has been added to the stack with Slack integration. 2 Alerts have been added and are managed 

Alerts              - `prometheus/alert.rules`
Slack configuration - `alertmanager/config.yml`

The Slack configuration requires to build a custom integration.
* Open your slack team in your browser `https://<your-slack-team>.slack.com/apps`
* Click build in the upper right corner
* Make a Custom integration
* Choose Incoming Web Hooks
* Select which channel
* Click on Add Incoming WebHooks integration
* Copy the Webhook URL into the `alertmanager/config.yml` URL section
* Fill in Slack username and channel

View Prometheus alerts `http://<Host IP Address>:9090/alerts`
View Alert Manager `http://<Host IP Address>:9093`

### Test Alerts
A quick test for your alerts is to stop a service. Stop the node_exporter container and you should notice shortly the alert arrive in Slack. Also check the alerts in both the Alert Manager and Prometheus Alerts just to understand how they flow through the system.

High load test alert - `docker run --rm -it busybox sh -c "while true; do :; done"``

Let this run for a few minutes and you will notice the load alert appear.

## Install Dashboard
I created a Dashboard template which is available on [Grafana Docker Dashboard](https://grafana.net/dashboards/179). Simply download the dashboard and select from the Grafana menu -> Dashboards -> Import

This dashboard is intended to help you get started with monitoring. If you have any changes you would like to see in the Dashboard let me know so I can update Grafana site as well.

Here's the Dashboard Template

![Grafana Dashboard](https://github.com/vegasbrianc/prometheus/blob/version-2/images/Dashboard.png)

Grafana Dashboard - `dashboards/Grana_Dashboad.json`
Alerting Dashboard - `dashboards/System_Monitoring.json`

## Troubleshooting
It appears some people have reported no data appearing in Grafana. If this is happening to you be sure to check the time range being queried within Grafana to ensure it is using Today's date with current time.
