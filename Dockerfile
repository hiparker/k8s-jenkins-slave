FROM openjdk:8u222-jre
MAINTAINER parker
LABEL description=Jenkins-Slave

# 设置环境常量
ENV TZ=Asia/Shanghai

# 切换为上海时区
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

WORKDIR /home/jenkins-slave
ADD agent.jar /home/jenkins-slave

RUN apt-get update && apt-get install -y libltdl7.*
RUN apt-get install git -y
RUN apt-get install ansible -y
RUN apt-get install sshpass -y
RUN sed -i 's/#host_key_checking = False/host_key_checking = False/' /etc/ansible/ansible.cfg


CMD exec java -Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=true -cp /home/jenkins-slave/agent.jar hudson.remoting.jnlp.Main -headless -url ${JENKINS_URL} -workDir ${JENKINS_AGENT_WORKDIR} ${JENKINS_SECRET} ${JENKINS_AGENT_NAME}
