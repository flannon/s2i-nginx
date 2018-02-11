
## Creating a basic S2I builder image and application container 

This repository, along with https://github.com/flannon/static-site, implements an example showing the full cycle of s2i deployment.  To run the static site you can do the following,

     make
     oc new-app flannon/s2i-nginx~https://github.com/flannon/static-site --name mysite
     oc expose svc/static-site


#### Getting started

This assumes you have a version of OpenShift greater than 3.6 running and that you've logged in.


#### Makefile

Running `make` will create the builder image called flannon/s2i-nginx and deploy it to the OpenShift docker registry.  When make finishes you can check the builder image,

    docker images | grep flannon/s2i-nginx


#### Building the application image
The application image combines the builder image with the applications source code, which, in this case, is the static website at https://github.com/flannon/static-site.git. Running new-app against the builder image with the source repository

     oc new-app flannon/s2i-nginx~https://github.com/flannon/static-site --name mysite

will tart a container from the builder image; inject the contents of source repository into the build container according to the instructions  in the assemble script; make the application image from the current state of the builder container; and finally start the application container, which presents all the resources assembled during the build processes. 


#### Making the applicaiton available

In order to access the application you'll need to open it's service port,

     oc expose svc/static-site

Once you've exposed the port you can run

     oc status
     
to get the URL of the static site, or check the project folder in the OpenShift console.  



