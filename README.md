## A Prometheus docker-compose stack
Here's a quick start to stand-up a [Prometheus](http://prometheus.io/) stack containing Prometheus server, container-exporter, and the Prometheus Dashboard.

##Pre-requisites
Before we get started installing the Prometheus stack. Ensure you install [docker-compose](https://docs.docker.com/compose/install/) on your Docker host machine.

##Installation & Configuration
Clone the project locally to your Docker host. 

If you would like to change which targets should be monitored or make configuration changes edit the [/prom/prometheus.yml](https://github.com/vegasbrianc/prometheus/blob/master/prom/prometheus.yml#L30) file. The targets section. The targets section is where you define which componets(data exporters) should be monitored by Prometheus. The names defined in this file are actually sourced from the service name in the docker-compose file. If you wish to change names of the services change the "container_name" parameter in the docker-compose.yml file. 

Once configurations are done let's start it up. From the /prometheus project directory run the following commands:

    $ docker-compose up
    $ docker-compose start

The Prometheus stack should now be running. To access the different components:

Prometheus: `http://<Host IP Address>:9090>` for example http://192.168.10.1:9090

Prometheus Dashboard: `http://<Host IP Address>:3000` for example http://192.168.10.1:3000

## Post Configuration
Now we need to connect the Prometheus Dashboard to the Prometheus installation. Access the Prom Dash as mentioned above. 
* Click the "Server" Menu at the top
* Click "New Server"
* Input desired name, Prometheus server IP and port (`http://<Host IP Address>:9090>` ) and select Prometheus for server type.

![PromDash New Server](https://github.com/vegasbrianc/prometheus/blob/master/New_server.png)

## Configure Dashboards
Let's create our first Dashboard. Head over up to the Dashboard menu. First, create a new directory. Next, create a new Dashboard.

Here's a quick Dashboard I put together as an example.

![PromDash Screenshot](https://github.com/vegasbrianc/prometheus/blob/master/Dashboard_example.png)

## ToDo
* Integrate and configure Alerting.
 
