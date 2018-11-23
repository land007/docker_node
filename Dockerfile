FROM land007/debian:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ENV NVM_DIR=/root/.nvm
#ENV SHIPPABLE_NODE_VERSION=v8.11.1
#ENV SHIPPABLE_NODE_VERSION=v9.11.1
ENV SHIPPABLE_NODE_VERSION=v10.13.0
RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install supervisor -g
#RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install gulp babel  jasmine mocha serial-jasmine serial-mocha aws-test-worker -g
RUN . $HOME/.nvm/nvm.sh && which node
RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/node /usr/bin/node
RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/supervisor /usr/bin/supervisor

#RUN . $HOME/.nvm/nvm.sh && npm install pty.js

# Define working directory.
#RUN mkdir /node
ADD node /node
WORKDIR /node
RUN ln -s /node ~/
RUN ln -s /node /home/land007
RUN mv /node /node_
VOLUME ["/node"]
ADD check.sh /
RUN sed -i 's/\r$//' /check.sh
RUN chmod a+x /check.sh

CMD /check.sh /node ; /etc/init.d/ssh start ; supervisor -w /node/ /node/main.js
EXPOSE 80/tcp

#docker stop node ; docker rm node ; docker run -it --privileged -v ~/docker/node:/node -p 80:80 --name node land007/node:latest
