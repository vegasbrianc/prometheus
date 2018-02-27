# Contents

- Introduction
  - [Overview](#a-prometheus--grafana-demo)
  - [Pre-requisites](#pre-requisites)
  - [Installation & Configuration](#installation--configuration)
  	- [Post Configuration](#post-configuration)
  	- [Alerting](#alerting)
  	- [Test Alerts](#test-alerts)
  	- [Import Dashboard](#import-dashboard)
  - [Security Considerations](#security-considerations)
  - [Troubleshooting](#troubleshooting)
  	- [Mac Users](#mac-users)

# A Prometheus & Grafana demo
Here's a quick start using only docker and docker-compose to start-up a [Prometheus](http://prometheus.io/) demo on your local machine containing Prometheus, Grafana, cadvisor and node-exporter to monitor your Docker infrastructure and machine.

<img src="https://github.com/steiniche/prometheus/raw/master/images/Dashboard.png" width="400" heighth="400">

# Pre-requisites
Before we get started installing the Prometheus demo. Ensure you install the latest version of docker and [docker-compose](https://docs.docker.com/compose/install/) on your machine.

# Installation & Configuration
Clone the project locally to your machine. 

If you would like to change which targets should be monitored or make configuration changes edit the `prometheus.yml` file. 
The targets section is where you define what should be monitored by Prometheus. The names defined in this file are sourced from the service name in the docker-compose file. If you wish to change names of the services you can add the "container_name" parameter in the `docker-compose.yml` file.

This project contains sane defaults meaning that you can just go ahead and start it up by running the foloowing command:

    $ docker-compose up -d

The Grafana Dashboard is now accessible via: `http://localhost:3000`

	username - admin
	password - foobar (Password is stored in the `config.monitoring` env file)

## Post Configuration
Now we need to create the Prometheus Datasource in order to connect Grafana to Prometheus 
* Click the `Grafana` Menu at the top left corner (looks like a fireball)
* Click `Data Sources`
* Click the green button `Add Data Source`.

<img src="https://github.com/steiniche/prometheus/raw/master/images/Add_Data_Source.png" width="400" heighth="400">

## Alerting
Alerting has been added to the stack with Slack integration. 2 Alerts have been added and are managed:

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

View Prometheus alerts `http://localhost:9090/alerts`
View Alert Manager `http://localhost:9093`

### Test Alerts
A quick test for your alerts is to stop a service. Stop the node_exporter container and you should notice shortly the alert arrive in Slack. Also check the alerts in both the Alert Manager and Prometheus Alerts just to understand how they flow through the system.

High load test alert - `docker run --rm -it busybox sh -c "while true; do :; done"`

Let this run for a few minutes and you will notice the load alert appear. Then Ctrl+C to stop this container.

## Import Dashboard
There are Dashboard templates included in this demo within the `dashboard` folder, simply import them into grafana.

<img src="https://github.com/steiniche/prometheus/raw/master/images/Import_Dashboard.png" width="400" heighth="400">

The dashboards are intended to help you get started with monitoring using Prometheus.

Docker Dashboard based on cadvisor data - `dashboards/docker.json`
Alerting Dashboard - `dashboards/high-load-dashboard.json`
Prometheus 2 Dashboard - `dashboards/high-load-dashboard.json`
System monitoring Dashboard based on node exporter - `dashboards/system-monitoring.json`

# Security Considerations
This project is intended to be a quick-start to get up and running with Docker and Prometheus. Security has not been implemented in this project. It is the users responsability to implement sensible security practices.

# Troubleshooting
It appears some people have reported no data appearing in Grafana. If this is happening to you be sure to check the time range being queried within Grafana to ensure it is using Today's date with current time.

## Mac Users
The node-exporter does not run the same as Mac and Linux. Node-Exporter is not designed to run on Mac and in fact cannot collect metrics from the Mac OS due to the differences between Mac and Linux OS's. I recommend you comment out the node-exporter section in the `docker-compose.yml` file and instead just use the cAdvisor. 