# Dockerfile, Now this is the default.You don't have to choose that,but if you don't choose it, you have to pass it to the build argument.
# the first thing is to do a from command, and we're going to use a Maven image because we need Maven, and I don't really want to install it as part of this. We're going to create a builder based on this.
# I don't care how big this image is really, because I'm not going to ship this to production
FROM maven:3.8.5-openjdk-11-slim as BUILDER
#  Now I'm going to set an argument here, and this is just a standard practice that I employ across all of my builds. This allows me to have control over version changes in one place instead of multiple, if it applies. In this case, it's not really going to make a difference.
ARG VERSION=0.0.1-SNAPSHOT
#  here.  we're going to set our work there, and in this case, we're going to call it /*build*/.
# And we're going to copy from our local directory the POM XML into the build directory in our image.
# Likewise, we're going to copy source into the build directory as well in a source location.
WORKDIR /build/
COPY pom.xml /build/
COPY src /build/src/
# the command to cause Maven to create an application.jar file?
RUN mvn clean package
#  I'm going to copy target/booting-web-. then here's where I'm going to use that version value then'.jar'
 #And that's the pattern that Maven based Spring Boot artifacts build in.
 # And I'm going to copy it to the same location, but I'm going to rename it to be application.jar
COPY target/booting-web-${VERSION}.jar target/application.jar
# Now I'm going to set up my actual final image. So this time I will use openJDK:11.0.8-jre-slim.
#So I'm going to use a slim version of the JRE image instead of a JDK.
FROM openjdk:11.0.8-jre-slim
#  I'm going to set up a workdir here. /*app*/.
#And now I'm going to copy from the /*builder*/ in /*build*/ /*target/application.jar*/ to the /*app*/ directory.
WORKDIR /app/
COPY --from=BUILDER /build/target/application.jar /app/
#And now I'll set a command of Java -jar /app/application.jar and that's it.
#We're done. 
CMD java -jar /app/application.jar
# So let's hop over to a terminal.
# in terminal at booting-web directory i will write "docker build -t booting-web ." So what I'm saying here is build a Docker image tagged with booting web, and that'll let us see it running later, and just build the current Dockerfile.
# Now, before I hit enter, there's two things I want to tell you.
# First of all, there's going to be a lot of output and time that this takes to build these images,
#especially if it's your first time. So I encourage you to read through the output and understand what's going.
