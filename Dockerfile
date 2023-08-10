FROM ubuntu:latest
RUN apt -y update && apt -y install software-properties-common && apt-add-repository --yes --update ppa:ansible/ansible && apt -y install ansible wget unzip
RUN apt -y install sshpass genisoimage nano vim
RUN wget https://releases.hashicorp.com/terraform/1.5.4/terraform_1.5.4_linux_amd64.zip
RUN unzip terraform_1.5.4_linux_amd64.zip
RUN cp terraform /usr/local/bin

RUN echo "" | echo "" | echo "" | ssh-keygen
RUN cat ~/.ssh/id_rsa.pub

ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" /dev/null

RUN sshpass -p hiyiir ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub root@172.24.20.3
RUN sshpass -p hiyiir ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub shoma@172.24.20.3
