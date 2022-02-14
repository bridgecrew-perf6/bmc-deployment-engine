FROM registry.apps.ocp.dev.ised-isde.canada.ca/ised-ci/centos:centos7

RUN adduser git -m  --home-dir /home/git

RUN usermod -aG wheel git

RUN yum -y upgrade && \
	yum -y update

RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	yum install -y ./epel-release-latest-*.noarch.rpm

RUN yum install -y python

RUN yum install git -y

RUN yum install ansible -y

RUN sed -i 's/#bin_ansible_callbacks = False/bin_ansible_callbacks = True/g' /etc/ansible/ansible.cfg

RUN sed -i 's/#callback_whitelist = timer, mail/callback_whitelist = profile_tasks/g' /etc/ansible/ansible.cfg

RUN sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg

RUN sed -i 's/#stdout_callback = skippy = False/stdout_callback = yaml/g' /etc/ansible/ansible.cfg

RUN wget curl https://packages.microsoft.com/config/rhel/7/prod.repo -o /etc/yum.repos.d/msprod.repo

RUN yum remove -y mssql-tools unixODBC-utf16-devel

RUN yum install -y mssql-tools unixODBC-devel

RUN yum install java -y

RUN yum install -y xmlstarlet jq dos2unix


RUN wget https://get.helm.sh/helm-v3.2.3-linux-amd64.tar.gz && \
	tar -zxvf helm-v3.2.3-linux-amd64.tar.gz && \
	mv linux-amd64/helm /usr/local/bin/helm

RUN mkdir /oc_cli && \
	wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.8.26/openshift-install-linux-4.8.26.tar.gz && \
	tar openshift-install-linux-4.8.26.tar.gz -C /oc_cli  && \
	mv /oc_cli/oc /usr/local/bin && \
	mv /oc_cli/kubectl /usr/local/bin && \
	rm -r /oc_cli
	
	
	
USER git

RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile 
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc 



RUN echo 'export PATH="$PATH:/usr/local/bin/"' >> ~/.bashrc

# Still need --> PV for BMC repo
# --> kubeconfig mounted

ENTRYPOINT ["/bin/bash"]