FROM       ubuntu:14.04
MAINTAINER Carlos José Vaz <carlosjvaz@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# update repositories
RUN apt-get -y update

# install system deps
RUN apt-get -y -qq install \
        linux-headers-generic \
        python-software-properties \
        software-properties-common

# install utils programs
RUN apt-get -y -qq install build-essential \
                       make \
                       cmake \
                       vim \
                       git \
                       sudo \
                       zip \
                       bzip2 \
                       fontconfig \
                       curl \
                       vim \
                       python-dev \
                       ruby-dev

# prepare locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen --purge --lang en_US \
    && locale-gen --purge --lang pt_BR \
    && locale-gen

##### PYTHON ####
# install virtualenv
RUN apt-get -y -qq install python-setuptools
RUN easy_install pip
RUN pip install virtualenv virtualenvwrapper

##### PHP #####
# install PHP without apache
RUN apt-get install php5-cli php5-gd php5-mbstring \
            php5-mysql php5-pgsql php5-ldap php5-imap \
            php5-sqlite php5-mcrypt

#### JAVA #####
# install java8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get -y update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y install oracle-java8-installer && apt-get clean
RUN update-java-alternatives -s java-8-oracle

# install maven
ENV MAVEN_VERSION 3.3.1
ENV M2_HOME /opt/maven
ENV M2      /opt/maven/bin
ENV PATH $M2:$PATH
RUN cd /tmp && \
    wget http://ftp.unicamp.br/pub/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && tar zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && mv apache-maven-$MAVEN_VERSION /opt/maven \
    && rm apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && ln -s /opt/maven/bin/mvn /usr/bin/mvn

##### NODE ######
# install Node.js v0.12 and NPM v2.9.1
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs
RUN npm install -g npm@2.9.1 && npm cache clear

# install yeoman, bower, grunt e gulp
RUN npm install -g yo bower grunt-cli gulp

# install yeoman generators
RUN npm install -g generator-karma@1.0.0 \
                   generator-angular@0.11.1 \
                   generator-gulp-angular@0.11.0 \
                   generator-jhipster@2.10.1

##### RUBY ######
# install ruby, sass and compass
RUN apt-get install -y -qq ruby-dev make
RUN gem install sass compass --no-ri --no-rdoc


##### USER ######
# create user developer
RUN echo 'root:developer' |chpasswd
RUN groupadd developer && useradd developer -s /bin/bash -m -g developer -G developer && adduser developer sudo
RUN echo 'developer:developer' |chpasswd
RUN mkdir /home/developer/projects && chown developer:developer /home/developer/projects

# Define working directory.
VOLUME ["/home/developer/projects"]
WORKDIR /home/developer

# expose the working directory, the Tomcat port, the Grunt server port, the SSHD port and run SSHD
EXPOSE 8080 3000 3001

CMD ["/bin/bash"]