FROM land007/debian-build:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN apt-get update && apt-get install -y python ca-certificates && apt-get clean
RUN update-ca-certificates -f
#RUN curl -x http:// -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ADD install.sh /root/
RUN chmod +x /root/install.sh && /root/install.sh
ENV NVM_DIR=/root/.nvm
#ENV SHIPPABLE_NODE_VERSION=v8.11.1
#ENV SHIPPABLE_NODE_VERSION=v8.14.0
#ENV SHIPPABLE_NODE_VERSION=v9.11.1
#ENV SHIPPABLE_NODE_VERSION=v9.11.2
#ENV SHIPPABLE_NODE_VERSION=v10.13.0
#ENV SHIPPABLE_NODE_VERSION=v10.14.1
ENV SHIPPABLE_NODE_VERSION=v10.20.0
#ENV SHIPPABLE_NODE_VERSION=v14.3.0
#ENV SHIPPABLE_NODE_VERSION=v14.15.0
ENV NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist
#RUN . $HOME/.nvm/nvm.sh && nvm ls-remote |grep v10.20
RUN curl https://nodejs.org/dist
RUN . $HOME/.nvm/nvm.sh && nvm ls-remote
#RUN echo 'export SHIPPABLE_NODE_VERSION=v9.11.2' >> /etc/profile && \
RUN echo 'export SHIPPABLE_NODE_VERSION=v10.20.0' >> /etc/profile && \
	. $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && cd / && npm init -y && npm install -g node-gyp supervisor http-server && npm install socket.io ws express cors http-proxy bagpipe eventproxy chokidar request nodemailer await-signal log4js moment && \
#RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install gulp babel  jasmine mocha serial-jasmine serial-mocha aws-test-worker -g && \
#RUN . $HOME/.nvm/nvm.sh && cd / && npm install pty.js
	. $HOME/.nvm/nvm.sh && which node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/node /usr/bin/node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/supervisor /usr/bin/supervisor
ENV PATH $PATH:/root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin
RUN echo 'export PATH=$PATH:/root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin' >> /etc/profile

# Define working directory.
#RUN mkdir /node
ADD node /node
RUN ln -s $HOME/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/lib/node_modules /node && \
	ln -s /node ~/ && ln -s /node /home/land007 && \
	mv /node /node_
WORKDIR /node
VOLUME ["/node"]

RUN echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/node" >> /.image_names && \
	echo "land007/node" > /.image_name

RUN apt-get install -y dos2unix
RUN dos2unix /root/.nvm/versions/node/v10.20.0/lib/node_modules/supervisor/lib/cli-wrapper.js

EXPOSE 80/tcp
RUN echo "/check.sh /node" >> /start.sh && \
#	echo "/usr/bin/nohup supervisor -w /node/ /node/server.js > /node/node.out 2>&1 &" >> /start.sh
	echo "supervisor -w /node/ -i node_modules /node/server.js" >> /start.sh

#docker build -t land007/node .
#docker rm -f node; docker run -it --privileged -v ~/docker/node3:/node -p 20080:80 -p 20081:20081 -p 20082:20082 -p 20000:20022 --name node land007/node:latest
#docker rm -f node; docker run -it --rm --name node land007/node:latest
#> docker buildx build --platform linux/amd64,linux/arm64/v8,linux/arm/v7 -t land007/node --push .
#> docker buildx build --platform linux/amd64,linux/arm/v7 -t land007/node --push .
