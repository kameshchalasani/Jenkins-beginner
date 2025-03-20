# **🚀 Jenkins Integration with DevOps Tools**  

This guide covers:  
✅ **Jenkins + Git (GitHub, GitLab, Bitbucket)**  
✅ **Jenkins + Docker & Kubernetes**  
✅ **Jenkins + Ansible & Terraform (Infrastructure as Code)**  
✅ **Jenkins + Maven, Gradle, npm**  
✅ **Jenkins + JIRA, Slack, Email Notifications**  

---

## **1️⃣ Jenkins + Git (GitHub, GitLab, Bitbucket)**
### **🔹 Why Integrate Jenkins with Git?**
✔ Automatically trigger builds when code changes.  
✔ Enables Continuous Integration (CI) and version control tracking.  
✔ Works with GitHub, GitLab, Bitbucket, and other Git providers.  

### **🔹 Setting Up Git Integration in Jenkins**
1️⃣ Install **Git Plugin**:  
   - Go to **Manage Jenkins** → **Manage Plugins** → Install **Git Plugin**  
2️⃣ Configure Git in Jenkins:  
   - Go to **Manage Jenkins** → **Global Tool Configuration** → Add Git executable path.  
3️⃣ Connect Jenkins with GitHub/GitLab:  
   - Generate a **Personal Access Token (PAT)** from GitHub/GitLab.  
   - Add it in Jenkins under **Manage Jenkins → Credentials**.  

### **🔹 Example: Jenkinsfile for Git Integration**
```groovy
pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/user/repo.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
```
✔ **Jenkins pulls the latest code from GitHub/GitLab/Bitbucket and builds it**.  

---

## **2️⃣ Jenkins + Docker & Kubernetes**
### **🔹 Why Use Docker & Kubernetes in Jenkins?**
✔ **Docker** ensures consistency across environments.  
✔ **Kubernetes** helps scale applications and manage containerized workloads.  

### **🔹 Setting Up Docker Integration in Jenkins**
1️⃣ Install **Docker Pipeline Plugin**:  
   - Manage Jenkins → Manage Plugins → Install **Docker Pipeline Plugin**  
2️⃣ Configure Docker in Jenkins:  
   - Manage Jenkins → Global Tool Configuration → Add Docker installation path.  
3️⃣ Grant Jenkins user permission to run Docker commands:  
   ```sh
   sudo usermod -aG docker jenkins
   ```

### **🔹 Example: Build and Push Docker Image**
```groovy
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "my-app:latest"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-app:latest .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub', url: '']) {
                    sh 'docker push my-app:latest'
                }
            }
        }
    }
}
```
✔ **Builds and pushes a Docker image from Jenkins**.  

---

### **🔹 Deploying to Kubernetes with Jenkins**
1️⃣ Install **Kubernetes CLI Plugin** in Jenkins.  
2️⃣ Configure Kubernetes Cluster Credentials in Jenkins.  
3️⃣ Use `kubectl` commands in a pipeline:  

```groovy
pipeline {
    agent any
    stages {
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl rollout status deployment/my-app
                '''
            }
        }
    }
}
```
✔ **Deploys the application to Kubernetes using Jenkins**.  

---

## **3️⃣ Jenkins + Ansible & Terraform (Infrastructure as Code)**
### **🔹 Why Use Ansible & Terraform?**
✔ **Ansible** automates configuration management.  
✔ **Terraform** manages cloud infrastructure as code.  

### **🔹 Running Ansible Playbooks in Jenkins**
1️⃣ Install **Ansible Plugin** in Jenkins.  
2️⃣ Configure **Ansible installation path** in Global Tool Configuration.  
3️⃣ Run an Ansible playbook from Jenkins:  

```groovy
pipeline {
    agent any
    stages {
        stage('Run Ansible Playbook') {
            steps {
                ansiblePlaybook playbook: 'deploy.yml', inventory: 'inventory.ini'
            }
        }
    }
}
```
✔ **Jenkins executes Ansible to configure servers**.  

---

### **🔹 Running Terraform in Jenkins**
1️⃣ Install **Terraform Plugin** in Jenkins.  
2️⃣ Add **Terraform binary path** in Global Tool Configuration.  
3️⃣ Use Terraform in a pipeline:  

```groovy
pipeline {
    agent any
    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
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
✔ **Jenkins provisions cloud resources using Terraform**.  

---

## **4️⃣ Jenkins + Maven, Gradle, npm**
### **🔹 Why Integrate Build Tools?**
✔ **Maven/Gradle**: Java-based project builds.  
✔ **npm**: JavaScript package management.  

### **🔹 Using Maven in Jenkins**
1️⃣ Install **Maven Plugin** in Jenkins.  
2️⃣ Configure **Maven path** in Global Tool Configuration.  
3️⃣ Example Jenkinsfile for Maven:
```groovy
pipeline {
    agent any
    stages {
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
```

### **🔹 Using Gradle in Jenkins**
```groovy
pipeline {
    agent any
    stages {
        stage('Build with Gradle') {
            steps {
                sh './gradlew build'
            }
        }
    }
}
```

### **🔹 Using npm in Jenkins**
```groovy
pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
    }
}
```
✔ **Jenkins handles Java & JavaScript project builds**.  

---

## **5️⃣ Jenkins + JIRA, Slack, Email Notifications**
### **🔹 Why Integrate Notifications?**
✔ **JIRA**: Track builds & deployments.  
✔ **Slack/Email**: Get alerts for build failures/success.  

### **🔹 Setting Up JIRA Integration**
1️⃣ Install **JIRA Plugin** in Jenkins.  
2️⃣ Configure JIRA credentials in **Manage Jenkins → Credentials**.  
3️⃣ Update JIRA issue status from Jenkins:  
```groovy
pipeline {
    agent any
    stages {
        stage('Update JIRA') {
            steps {
                jiraNewIssue site: 'JIRA_SITE', issueType: 'Bug', summary: 'Build Failed', description: 'Fix the build error'
            }
        }
    }
}
```
✔ **Creates a JIRA issue if a build fails**.  

---

### **🔹 Sending Slack Notifications**
1️⃣ Install **Slack Notification Plugin**.  
2️⃣ Configure Slack Webhook URL in **Manage Jenkins**.  
3️⃣ Send a Slack message from Jenkinsfile:  
```groovy
pipeline {
    agent any
    post {
        success {
            slackSend channel: '#builds', message: 'Build Success ✅'
        }
        failure {
            slackSend channel: '#builds', message: 'Build Failed ❌'
        }
    }
}
```
✔ **Sends Slack messages on success/failure**.  

---

### **🔹 Sending Email Notifications**
1️⃣ Configure SMTP settings in **Manage Jenkins → Configure System**.  
2️⃣ Use `emailext` to send emails:  
```groovy
pipeline {
    agent any
    post {
        always {
            emailext to: 'team@example.com',
                     subject: 'Build Notification',
                     body: 'The build has completed.'
        }
    }
}
```
✔ **Notifies team members about build status**.  

---

## **🎯 Summary**
✔ **Jenkins integrates with Git, Docker, Kubernetes, Ansible, Terraform, Maven, and npm**.  
✔ **Automates infrastructure provisioning with Terraform & Ansible**.  
✔ **Sends notifications via Slack, JIRA, and Email**.  
