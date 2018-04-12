"This application is principal to showcase how cloud applications can be scaled across different geographical regions using dockers first, in which ELB can be used in managing traffics across, it is pricipally with dockers, the writeup is adapted from a couple of docker documentations referenced below"

![dockerswarm on aws cloud simple usecase](https://user-images.githubusercontent.com/17884787/38647160-ecbde85a-3db8-11e8-849d-600f782d8dc2.png)

# Use Case 1: Deploy an application and scale it accross various VMs using docker.

#### Prequisites:

- Install Virtualization machine on your system (e.g. V.BOX or VMWARE)
- Install Dockers and test its function "with ```$ dockers ps``` " or ``` $ docker run hello-world ```
- clone this repo using ``` $ git clone https://github.com/osaosemwen/containerdeployments ```
- Install docker-machine Dev, Test1 and Test2 on your PC, using the following command
 ``` $ docker-machine create --driver virtualbox dev ```
"Note if this line does not work do not panic, either simply change your ISP i.e. go to a different location or router or follow the instruction from the git hub docker machine issues, or from stackoverflow"
Where dev can be test1 and test2 for subsequent installations  
- Lastly, create an account on docker hub. 

#### Containerize the application

The Dockerfile simply instructs the build to be from python image, copy contents of current directory to ./app directory, next, install the need packages as shwon in requiremens then expose the container port 80, (Its this port no that would be referenced when running the image. 
- First build it using the Docker command
 
 ``` $ docker build -t osemikepractice . ```
This command "-t" means use a friendly tag "osemikepractice" and "." means use the Dockerfile information from the current directory to make the build. 
on running it the image would be available confirm this running 
```$ docker image ls ```

lets choose a random port number 7070 and run our recent build image in the background using "-d", and making reference "-p" to the exposed port 80 from the Dockerfile as shown below.

``` $ docker run -d -p 7070:80 osemikepractice ```

check the application using ``` http://localhost:7070 ```


![simpleapp](https://user-images.githubusercontent.com/17884787/38647581-016f714a-3dbb-11e8-96e7-5cee522dc4c1.png)


#### Push the Image to the cloud

login to your account on docker hub using 

``` $ docker login -u username ```
 
"Where username should be replaced with your username " you will next be promted to enter your password
Tag the image and push it straight to public repository.

``` $ docker tag image username/repository:tag ```

in my case osemike is my username hence:
 
 ``` $ docker tag osemikepractice osemike/osedockerpractice:v1 ```

The name the image "osemikepractice" would have on my repository would be "osedockerpractice"
  
push this new tagged image to the cloud using 

"docker push osemike/osedockerpractice:v1"

now lets stop the container image running. First get the container image using "``` $ docker ps ```" or ``` $ docker container ls ```

``` $ docker stop f849dc68f0c5 ```

lets run the same application pulling the image from the cloud repo and using port 5000 this time.

``` $ docker run -d -p 5000:80 osemike/osedockerpractice:v1 ```

check to see this image on your localhost is running using 

``` http://localhost:5000 ```, it would be practically the same application with a change on the image used

## Integrating Services into deployments with docker-compose
 
Services are functions which makes the conatiner behave properlly on production enevironments. Services in dockers are containers like application containers only without the image, hence to write a service its same thing as writing a dockercompose file for an application.  

Go to the file docker-compose-1.yml using your favorite, either VIM, nano, vi, emacs etc. change the image from 

" image: osemike/osedockerpractice:v1 " to that available on your docker hub registry.

This docker-compose.yml tells docker to pull the image from your docker hub registry, run the image under the web service with each image consuming 7% of the CPU, and scale the application over 7 instances each consuming 70MB of RAM, Map its port 5050 of the "web service" port to the containers port 80 
load balnce the "web container's" port 5050 over a load balanced network webtest and define this webtest network

#### Running the swarm of containers

First run 

``` $ docker swarm init ```

Next run 

``` $ docker stack deploy -c docker-compose-1.yml mikedockerspractice ```

This will scale the application web over 7 instances in the network environment webtest. Use the following to confirm your deployments.

```$ docker service ls ```

![docker service ls](https://user-images.githubusercontent.com/17884787/38653613-9d7a074e-3dd9-11e8-885b-9acbd1870e46.png)

#### Note
The docker swarm compose file instructs the swarm to auto configure another instance in case of any failure, this is why when you run 

``` $ docker service ps mikedockerpractise_web ```

you would have a display similar to that shown below: 

![mikepractceweb](https://user-images.githubusercontent.com/17884787/38653621-a4ac5918-3dd9-11e8-9aa1-0b6e5e92a2de.png)
you can practically test this first run ``` $ docker container ls -a ``` this lists all active containers including the 7 created on the docker swarm. Copy, Stop, kill and remove one of the images ID using the following lines: 

- ``` $ docker container stop imageid           # This stops the specified container ```
- ``` $ docker container kill imageid           # Forces shutdown of the specified container ```
- ``` $ docker container rm imageid             # Remove specified container from this machine ```

The swarm will auto-configure a new container so as to maintain 7 containers in the swarm.
#### Clean-up
Next clean up this deployment by:
- ``` $ docker stack rm mikedockerspractice  # This removes all 7 container deployed on the swarm ```
- ``` $ docker swarm leave --force  # This forces the swarm to be destroyed or vacate all VMs. ```
- ``` $ docker container ls ``` # to check for list of containers as well as confirm the dissolution of the swarm.

 







##### References
- https://docs.docker.com/get-started/
- https://blog.docker.com/2015/11/deploy-manage-cluster-docker-swarm/
- https://docs.docker.com/network/overlay-standalone.swarm/#run-an-application-on-your-network
