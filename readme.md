"This application is principally for to showcase how cloud application scaled across different geographical regions using dockers first, in which ELB can be used in managing traffics across, it is pricipally with dockers, the writeup is adapted from a couple of docker documentations referenced below"

# Use Case 1: Deploy a and scale application accross various VMs using docker.

##### Prequisites:

- Install Virtualization machine on your system (e.g. V.BOX or VMWARE)
- Install Dockers and test its function "with ```$ dockers ps``` " or ``` $ docker run hello-world ```
- Install docker-machine Dev, Test1 and Test2 on your PC, using the following command
 ``` $ docker-machine create --driver virtualbox dev ```

Where dev can be test1 and test2 for subsequent installations  

#### Containerize the application

The Dockerfile simply instructs the build to be from python image, copy contents of current directory to ./app directory, next, install the need packages as shwon in requiremens then expose the container port 80, (Its this port no that would be referenced when running the image. 
- First build it using the Docker command 
 ``` $ docker build -t osemikepractice . ```
This command "-t" means use a friendly tag "osemikepractice" and "." means use the Dockerfile information from the current directory to make the build. 
on running it the image would be available confirm this running 
```$ docker image ls ```

lets choose a random port number 7070 and run our recent build image.

``` $ docker run -d -p 7070:80 osemikepractice ```

check the application using ``` http://localhost:7070 ```













##### References
- https://docs.docker.com/get-started/
- https://blog.docker.com/2015/11/deploy-manage-cluster-docker-swarm/
- https://docs.docker.com/network/overlay-standalone.swarm/#run-an-application-on-your-network
- 
