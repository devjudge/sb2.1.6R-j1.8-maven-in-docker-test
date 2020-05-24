FROM maven:3.6-jdk-8-slim

ARG workspace="none"
ARG eval_type="none"

USER root

RUN apt-get update && apt-get install --assume-yes wget

# Pre build commands
RUN wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/backend-project/springboot/maven/2.x/pre-build-2.sh
RUN chmod 775 ./pre-build-2.sh
RUN sh pre-build-2.sh

RUN wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/backend-project/database/db-setup.sh
RUN chmod 775 ./db-setup.sh
RUN sh db-setup.sh

# Install Workspace for Java

RUN if [ $workspace = "theia" ] ; then \
	wget -O ./pre-build.sh https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/pre-build.sh \
    && chmod 775 ./pre-build.sh && sh pre-build.sh ; fi

WORKDIR /var/

RUN if [ $workspace = "theia" ] ; then \
	wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/build.sh \
    && chmod 775 ./build.sh && sh build.sh ; fi


WORKDIR /var/theia/

RUN if [ $workspace = "theia" ] ; then \
	wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/java/run.sh \
    && chmod 775 ./run.sh ; fi

COPY . /tmp/
WORKDIR /tmp/

EXPOSE 8080

# Build the app
#RUN wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/test-project/springboot/maven/2.x/build.sh
#RUN chmod 775 ./build.sh
#RUN sh build.sh


mvn clean install -DskipTests -Dpitest.skip=true

# Add extra docker commands here (if any)...

# Run the app
# RUN wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/test-project/springboot/maven/2.x/run.sh
# RUN chmod 775 ./run.sh
CMD sh run.sh "$eval_type"
