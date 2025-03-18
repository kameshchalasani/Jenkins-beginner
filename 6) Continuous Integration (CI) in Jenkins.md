# **🚀 Continuous Integration (CI) in Jenkins**  

This guide covers:  
✅ **Understanding Continuous Integration**  
✅ **Running Unit Tests in Pipelines**  
✅ **Automating Code Analysis with SonarQube**  
✅ **Generating Reports & Code Coverage Metrics**  
✅ **Managing Build Failures & Notifications (Email, Slack)**  

---

## **1️⃣ Understanding Continuous Integration (CI)**
### **🔹 What is CI?**
Continuous Integration (**CI**) is a DevOps practice where developers frequently merge their code changes into a shared repository, followed by **automated builds and tests** to ensure quality.

### **🔹 Why Use CI in Jenkins?**
✔ **Detects bugs early** – Code is tested automatically on every commit  
✔ **Reduces integration issues** – Developers work on the latest tested code  
✔ **Improves software quality** – Automated testing ensures consistency  

🔹 **Example CI Workflow in Jenkins:**
```
1️⃣ Developer pushes code to GitHub
2️⃣ Jenkins detects the change and triggers a build
3️⃣ Unit tests & code analysis run automatically
4️⃣ If the build fails, Jenkins notifies the team (Email, Slack)
5️⃣ If successful, Jenkins archives the build artifacts
```

---

## **2️⃣ Running Unit Tests in Pipelines**
### **🔹 Why Run Unit Tests in CI?**
✔ Ensures new code doesn’t break existing functionality  
✔ Provides fast feedback to developers  
✔ Helps maintain **high code quality**  

### **🔹 Example: Running JUnit Tests in a Jenkins Pipeline**
```groovy
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/user/repo.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }
    }
}
```
✔ **Stage 1:** Fetches code from Git  
✔ **Stage 2:** Builds the project  
✔ **Stage 3:** Runs unit tests using Maven  

---

## **3️⃣ Automating Code Analysis with SonarQube**
### **🔹 Why Use SonarQube?**
✔ Detects **code smells, security vulnerabilities, and bugs**  
✔ Provides **code coverage metrics**  
✔ Ensures adherence to coding standards  

### **🔹 Steps to Integrate SonarQube with Jenkins**
1️⃣ **Install SonarQube Plugin in Jenkins**  
   - Go to **Manage Jenkins → Manage Plugins → Available**  
   - Search for **SonarQube Scanner** and install it  
2️⃣ **Configure SonarQube Server in Jenkins**  
   - Go to **Manage Jenkins → Configure System → SonarQube Servers**  
   - Add **SonarQube Server URL & Authentication Token**  
3️⃣ **Define SonarQube Analysis in Jenkinsfile**
```groovy
pipeline {
    agent any
    environment {
        SONAR_URL = 'http://your-sonarqube-server:9000'
        SONAR_TOKEN = credentials('sonar-token')
    }
    stages {
        stage('Code Analysis') {
            steps {
                sh 'mvn sonar:sonar -Dsonar.host.url=$SONAR_URL -Dsonar.login=$SONAR_TOKEN'
            }
        }
    }
}
```
✔ Runs SonarQube analysis on every build  

---

## **4️⃣ Generating Reports & Code Coverage Metrics**
### **🔹 What is Code Coverage?**
✔ Code coverage measures **how much of your code is tested**  
✔ Tools like **JaCoCo** generate test coverage reports  

### **🔹 Example: Adding JaCoCo to a Jenkins Pipeline**
1️⃣ **Add JaCoCo Plugin in Jenkins**  
   - Go to **Manage Plugins → Install JaCoCo Plugin**  
2️⃣ **Update `pom.xml` to Include JaCoCo**  
```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.7</version>
    <executions>
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```
3️⃣ **Modify Jenkinsfile to Collect Code Coverage**  
```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Run Tests & Generate Report') {
            steps {
                sh 'mvn test jacoco:report'
                junit '**/target/surefire-reports/*.xml'
            }
        }
    }
    post {
        always {
            jacoco execPattern: '**/target/jacoco.exec'
        }
    }
}
```
✔ This pipeline generates a **JaCoCo report** in Jenkins  

---

## **5️⃣ Managing Build Failures & Notifications (Email, Slack)**
### **🔹 Why Send Notifications?**
✔ Notifies developers immediately if a build **fails**  
✔ Helps teams **fix issues faster**  

### **🔹 Setting Up Email Notifications in Jenkins**
1️⃣ **Install Mailer Plugin**  
   - Go to **Manage Jenkins → Plugins → Install "Mailer"**  
2️⃣ **Configure SMTP Server**  
   - Go to **Manage Jenkins → Configure System → Email Notification**  
   - Enter SMTP details (Gmail, Outlook, etc.)  
3️⃣ **Add Email Notification to Jenkinsfile**  
```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
    }
    post {
        failure {
            mail to: 'dev-team@example.com',
                 subject: "Build Failed: ${env.JOB_NAME}",
                 body: "Build ${env.BUILD_NUMBER} failed. Check Jenkins logs for details."
        }
    }
}
```
✔ Sends an **email alert** if the pipeline fails  

---

### **🔹 Setting Up Slack Notifications**
1️⃣ **Install Slack Notification Plugin**  
   - Go to **Manage Jenkins → Plugins → Install "Slack Notification"**  
2️⃣ **Generate a Slack Webhook**  
   - In Slack, go to **Apps & Integrations → Incoming Webhook**  
   - Get the **Webhook URL**  
3️⃣ **Configure Jenkinsfile to Send Slack Alerts**
```groovy
pipeline {
    agent any
    environment {
        SLACK_WEBHOOK = credentials('slack-webhook')
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
    post {
        success {
            slackSend channel: '#ci-cd',
                      message: "Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                      color: 'good'
        }
        failure {
            slackSend channel: '#ci-cd',
                      message: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                      color: 'danger'
        }
    }
}
```
✔ Sends **Slack notifications for build success/failure**  

---

## **🎯 Summary**
✔ **CI in Jenkins** automates builds, testing, and reporting  
✔ **Unit Tests** ensure code correctness  
✔ **SonarQube** analyzes code quality  
✔ **JaCoCo** measures test coverage  
✔ **Email & Slack** notify teams of build failures  
