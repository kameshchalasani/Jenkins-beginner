# **🚀 Jenkins as Code & Infrastructure Automation**  

This guide covers:  
✅ **Managing Jenkins with Configuration as Code (JCasC)**  
✅ **Automating Jenkins Setup with Ansible & Terraform**  
✅ **Using Jenkinsfile for Infrastructure Provisioning**  
✅ **Automating CI/CD Pipelines with Jenkins CLI & REST API**  

---

## **1️⃣ Managing Jenkins with Configuration as Code (JCasC)**
### **🔹 What is JCasC?**
Jenkins Configuration as Code (**JCasC**) allows you to define and manage Jenkins settings using YAML files instead of manually configuring it via the UI.  

✅ Automates Jenkins setup  
✅ Enables version control of configurations  
✅ Supports easy backups & rollbacks  

### **🔹 Installing JCasC Plugin**
1️⃣ Go to **Manage Jenkins → Plugin Manager**  
2️⃣ Install the **Configuration as Code** plugin  
3️⃣ Restart Jenkins  

### **🔹 Creating a JCasC Configuration File**
1️⃣ Generate a configuration template:  
   - Go to **Manage Jenkins → Configuration as Code**  
   - Click **View Configuration**  
   - Copy the YAML settings  

2️⃣ Example `jenkins.yaml`:  
```yaml
jenkins:
  systemMessage: "Welcome to Jenkins as Code!"
  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: "admin"
          password: "admin123"
  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: false
  jobs:
    - script: >
        pipeline {
            agent any
            stages {
                stage('Hello') {
                    steps {
                        echo 'Hello from JCasC!'
                    }
                }
            }
        }
```
4️⃣ Apply the configuration:  
   - Start Jenkins with:  
     ```sh
     docker run -d -p 8080:8080 -v $(pwd)/jenkins.yaml:/var/jenkins_home/casc.yaml jenkins/jenkins:lts
     ```

✔ Jenkins will now be **fully configured** from this YAML file at startup! 🎯  

---

## **2️⃣ Automating Jenkins Setup with Ansible & Terraform**  
### **🔹 Automating Jenkins Installation with Ansible**
**Ansible Playbook for Jenkins Setup (Ubuntu)**  
```yaml
- name: Install Jenkins
  hosts: jenkins_server
  become: yes
  tasks:
    - name: Install Java
      apt:
        name: openjdk-11-jdk
        state: present

    - name: Add Jenkins Repository Key
      apt_key:
        url: https://pkg.jenkins.io/debian/jenkins.io.key
        state: present

    - name: Add Jenkins Repository
      apt_repository:
        repo: "deb http://pkg.jenkins.io/debian-stable binary/"
        state: present

    - name: Install Jenkins
      apt:
        name: jenkins
        state: present

    - name: Start Jenkins Service
      service:
        name: jenkins
        state: started
        enabled: yes
```
✅ **Run the playbook:**  
```sh
ansible-playbook -i inventory jenkins-playbook.yml
```
---

### **🔹 Provisioning Jenkins with Terraform (AWS Example)**
**Terraform script to deploy Jenkins on AWS EC2**  
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  key_name      = "my-key"
  security_groups = ["jenkins-sg"]

  tags = {
    Name = "Jenkins-Server"
  }
}
```
✅ **Deploy with Terraform:**  
```sh
terraform init
terraform apply -auto-approve
```
✔ Jenkins server is now automatically provisioned! 🚀  

---

## **3️⃣ Using Jenkinsfile for Infrastructure Provisioning**  
Jenkins Pipelines can **provision infrastructure** using Terraform, Ansible, and Docker.  

### **🔹 Example: Jenkinsfile for Terraform Deployment**
```groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/my-org/terraform-infra.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
```
✔ This pipeline **automates infrastructure deployment** with Terraform! 🔥  

---

## **4️⃣ Automating CI/CD Pipelines with Jenkins CLI & REST API**  
### **🔹 Jenkins CLI Commands**
1️⃣ Install the Jenkins CLI:  
   ```sh
   wget http://localhost:8080/jnlpJars/jenkins-cli.jar
   ```
2️⃣ Get a list of jobs:  
   ```sh
   java -jar jenkins-cli.jar -s http://localhost:8080/ list-jobs
   ```
3️⃣ Trigger a build:  
   ```sh
   java -jar jenkins-cli.jar -s http://localhost:8080/ build my-pipeline
   ```
4️⃣ Get logs from a build:  
   ```sh
   java -jar jenkins-cli.jar -s http://localhost:8080/ console my-pipeline
   ```

---

### **🔹 Jenkins REST API for Automation**
✅ **Get all jobs:**  
```sh
curl -u admin:admin123 "http://localhost:8080/api/json?pretty=true"
```
✅ **Trigger a build:**  
```sh
curl -X POST -u admin:admin123 "http://localhost:8080/job/my-pipeline/build"
```
✅ **Get the last build status:**  
```sh
curl -u admin:admin123 "http://localhost:8080/job/my-pipeline/lastBuild/api/json"
```
✔ You can integrate **Jenkins API with DevOps scripts** for automation!  

---

## **🎯 Summary**
✔ **JCasC** – Manage Jenkins settings using YAML.  
✔ **Ansible & Terraform** – Automate Jenkins provisioning.  
✔ **Jenkinsfile for Infra** – Deploy AWS, Kubernetes, and Docker infra.  
✔ **Jenkins CLI & API** – Automate Jenkins with scripts.  
