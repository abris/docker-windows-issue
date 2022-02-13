# default container: williamyeh/ansible:ubuntu16.04
FROM ubuntu:18.04
WORKDIR /tmp
ENV MDSDEBUG yesplease
ENV SYMFONY_ENV dev
ADD . /tmp/

RUN apt update
RUN apt install -y software-properties-common
RUN apt-add-repository --yes --update ppa:ansible/ansible
RUN apt install ansible -y

RUN echo localhost > inventory
RUN ansible-galaxy install -r requirements.yml
RUN ansible-playbook -i inventory server.yml --connection=local

RUN mkdir -p /var/www/mydocsafe/current
WORKDIR /var/www/mydocsafe/current
CMD service apache2 start && tail -F /var/log/apache2/error.log
