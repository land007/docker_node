FROM land007/debian-build:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN apt-get update && apt-get install -y python && apt-get clean
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ENV NVM_DIR=/root/.nvm
#ENV SHIPPABLE_NODE_VERSION=v8.11.1
#ENV SHIPPABLE_NODE_VERSION=v9.11.1
ENV SHIPPABLE_NODE_VERSION=v10.13.0
RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install -g node-gyp && npm install socket.io && npm install ws && npm install express && npm install http-proxy && npm install bagpipe && npm install -g supervisor
#RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install gulp babel  jasmine mocha serial-jasmine serial-mocha aws-test-worker -g
#RUN . $HOME/.nvm/nvm.sh && npm install pty.js
RUN . $HOME/.nvm/nvm.sh && which node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/node /usr/bin/node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/supervisor /usr/bin/supervisor
ENV PATH $PATH:/root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin

ADD check.sh /
RUN sed -i 's/\r$//' /check.sh && chmod a+x /check.sh
# Define working directory.
#RUN mkdir /node
ADD node /node
RUN ln -s $HOME/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/lib/node_modules /node
RUN sed -i 's/\r$//' /node/start.sh && chmod a+x /node/start.sh
RUN ln -s /node ~/ && ln -s /node /home/land007
RUN mv /node /node_
WORKDIR /node
VOLUME ["/node"]

CMD /check.sh /node ; /etc/init.d/ssh start ; /node/start.sh
EXPOSE 80/tcp

#docker stop node ; docker rm node ; docker run -it --privileged -v ~/docker/node:/node -p 80:80 --name node land007/node:latest
