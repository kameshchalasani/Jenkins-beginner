# **🚀 Advanced Jenkins Concepts**  

This guide covers:  
✅ **Running Jenkins in Docker Containers**  
✅ **Setting Up Jenkins Agents & Distributed Builds**  
✅ **Using Shared Libraries in Pipelines**  
✅ **Securing Jenkins (RBAC, Secrets, Credentials, SSL)**  
✅ **Performance Optimization & Troubleshooting**  

---

## **1️⃣ Running Jenkins in Docker Containers**
### **🔹 Why Run Jenkins in Docker?**
✔ Portable & easy to manage.  
✔ Avoids dependency conflicts.  
✔ Scales better with Kubernetes & cloud environments.  

### **🔹 Running Jenkins in a Docker Container**
1️⃣ Pull the Jenkins LTS image:  
   ```sh
   docker pull jenkins/jenkins:lts
   ```
2️⃣ Run the Jenkins container:  
   ```sh
   docker run -d -p 8080:8080 -p 50000:50000 --name jenkins -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
   ```
3️⃣ Get the initial admin password:  
   ```sh
   docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
4️⃣ Access Jenkins at **http://localhost:8080**  

---

## **2️⃣ Setting Up Jenkins Agents & Distributed Builds**
### **🔹 Why Use Agents?**
✔ Improves performance by offloading builds.  
✔ Supports multiple environments (Linux, Windows, macOS).  
✔ Enables parallel execution.  

### **🔹 Types of Jenkins Agents**
🔹 **Static Agents** – Manually configured machines.  
🔹 **Dynamic Agents** – Created on demand using Docker, Kubernetes, or cloud providers.  

### **🔹 Setting Up an SSH Agent**
1️⃣ Go to **Manage Jenkins → Manage Nodes & Clouds → New Node**  
2️⃣ Select **Permanent Agent**  
3️⃣ Configure:  
   - **# of executors** (parallel builds)  
   - **Remote root directory** (e.g., `/home/jenkins/`)  
   - **Launch method**: "Launch agent via SSH"  
4️⃣ Provide SSH credentials & test the connection.  

### **🔹 Connecting an Agent via Docker**
Run a Jenkins agent in Docker:  
```sh
docker run -d --rm --name jenkins-agent \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/inbound-agent
```
✔ **Agents allow parallel builds & distributed workloads**.  

---

## **3️⃣ Using Shared Libraries in Pipelines**
### **🔹 Why Use Shared Libraries?**
✔ Reuse pipeline code across multiple projects.  
✔ Standardize best practices.  
✔ Improve maintainability.  

### **🔹 Defining a Shared Library**
1️⃣ Create a Git repo with a structure:  
```
my-shared-library/
│── vars/
│   ├── example.groovy  # Global function
│── src/
│   ├── org/company/MyUtils.groovy  # Custom classes
│── resources/
```
2️⃣ Example `vars/example.groovy`:  
```groovy
def call(String name = 'DevOps') {
    echo "Hello, ${name}!"
}
```
3️⃣ In Jenkins, go to **Manage Jenkins → Configure System** → Add a new Global Pipeline Library.  
4️⃣ Use the library in a Jenkinsfile:  
```groovy
@Library('my-shared-library') _
example('Jenkins User')
```
✔ **Shared libraries make pipelines modular & reusable**.  

---

## **4️⃣ Securing Jenkins (RBAC, Secrets, Credentials, SSL)**
### **🔹 Role-Based Access Control (RBAC)**
1️⃣ Install the **Role-Based Authorization Strategy Plugin**  
2️⃣ Go to **Manage Jenkins → Configure Global Security**  
3️⃣ Create **Roles** (e.g., Admin, Developer, Viewer)  
4️⃣ Assign **Users to Roles** to restrict permissions.  

---

### **🔹 Managing Secrets & Credentials**
1️⃣ Go to **Manage Jenkins → Credentials → System**  
2️⃣ Store:  
   - **Username/password** (for Git, Docker, etc.)  
   - **SSH keys**  
   - **API tokens**  
   - **Secret files & environment variables**  
3️⃣ Use credentials in a pipeline:  
```groovy
pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('docker-credentials-id')
    }
    stages {
        stage('Login to Docker') {
            steps {
                sh 'echo $DOCKER_CREDENTIALS | docker login --username myuser --password-stdin'
            }
        }
    }
}
```
✔ **Prevents storing passwords in scripts!**  

---

### **🔹 Enabling SSL for Secure Jenkins Access**
1️⃣ Generate an SSL certificate:  
   ```sh
   openssl req -newkey rsa:2048 -nodes -keyout jenkins.key -x509 -days 365 -out jenkins.crt
   ```
2️⃣ Configure **Jenkins HTTPS** in `jenkins.xml`:  
   ```xml
   <arguments>--httpPort=-1 --httpsPort=8443 --httpsKeyStore=/var/lib/jenkins/jenkins.jks --httpsKeyStorePassword=password</arguments>
   ```
3️⃣ Restart Jenkins & access it at **https://your-server:8443**.  

✔ **SSL ensures secure communication with Jenkins**.  

---

## **5️⃣ Performance Optimization & Troubleshooting**
### **🔹 Performance Best Practices**
✔ **Use Agents** – Avoid running everything on the master node.  
✔ **Enable Incremental Builds** – Cache dependencies (Maven, Gradle, Docker layers).  
✔ **Use Parallel Stages** – Reduce build time.  

### **🔹 Example: Running Parallel Stages**
```groovy
pipeline {
    agent any
    stages {
        stage('Build & Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'mvn test'
                    }
                }
                stage('Code Analysis') {
                    steps {
                        sh 'sonar-scanner'
                    }
                }
            }
        }
    }
}
```
✔ **Executes tests & code analysis simultaneously**.  

---

### **🔹 Common Jenkins Issues & Fixes**
| Issue | Solution |
|------|---------|
| **High CPU Usage** | Increase memory, run agents, clean up old builds |
| **Slow Builds** | Use parallel stages, cache dependencies, reduce logs |
| **Failed Plugins** | Update plugins, restart Jenkins |
| **Disk Space Issues** | Clean up old builds (`Manage Jenkins → Disk Usage`) |

---

## **🎯 Summary**
✔ **Jenkins in Docker** – Easy setup & portability.  
✔ **Jenkins Agents** – Distributes workloads for faster builds.  
✔ **Shared Libraries** – Reusable pipeline code for consistency.  
✔ **Security** – RBAC, secrets management, and SSL encryption.  
✔ **Performance** – Parallel execution & incremental builds improve speed.  
