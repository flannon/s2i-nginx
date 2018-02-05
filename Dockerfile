# centos/centos7
#FROM openshift/base-centos7
FROM centos:centos7 

MAINTAINER Flannon Jackson <flannon@flannon@nyu.edu>

ENV NGINX_VERSION=1.2.12

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building nginx" \
      io.k8s.display-name="nginx 1.2.12" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,webserver,html,nginx" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs nginx && \
    yum clean all -y

RUN sed -i 's/80/8080' /etc/nginx/nginx.conf
RUN sed -i 's/user nginx;//' /etc/nginx.conf

#(optional): Copy the builder files into /opt/app-root
COPY ./s2i/bin /opt/app-root/

#Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

#Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
