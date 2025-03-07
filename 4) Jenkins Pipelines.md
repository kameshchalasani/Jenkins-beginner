# **🚀 Jenkins Pipelines (Declarative & Scripted) – Step-by-Step Guide**  

This guide covers:  
✅ **What is a Pipeline?**  
✅ **Difference Between Freestyle Jobs & Pipelines**  
✅ **Creating a Declarative Pipeline (Jenkinsfile)**  
✅ **Understanding Pipeline Stages, Steps & Agents**  
✅ **Pipeline Variables & Parameters**  
✅ **Using Scripted Pipelines for Advanced Workflows**  
✅ **Running Parallel Stages in Pipelines**  

---

## **1️⃣ What is a Pipeline in Jenkins?**
### **🔹 Definition**
A **Jenkins Pipeline** is an automation script written in **Groovy**, defining the complete CI/CD process as **code**.

### **🔹 Why Use Pipelines?**
✔ **Version Control** – Pipelines are stored in **Jenkinsfiles** inside the repo  
✔ **Automated Builds & Deployments** – Supports complex workflows  
✔ **Resilient & Reusable** – Can restart from the last successful step  

---

## **2️⃣ Difference Between Freestyle Jobs & Pipelines**
| Feature | **Freestyle Job** | **Pipeline Job** |
|----------|-----------------|------------------|
| **Configuration** | GUI-based | Code-based (Jenkinsfile) |
| **Flexibility** | Limited | Highly flexible |
| **Scalability** | Difficult to manage | Supports parallel execution |
| **Version Control** | Not stored in Git | Stored as **Jenkinsfile** in Git |

📌 **Use Pipelines for complex CI/CD workflows!**

---

## **3️⃣ Creating a Declarative Pipeline (Jenkinsfile)**
### **🔹 What is a Jenkinsfile?**
A **Jenkinsfile** is a script defining a Jenkins Pipeline, written in **Declarative or Scripted syntax**.

🔹 **Example Folder Structure in Git Repo:**
```
📂 MyProject
 ├── 📂 src
 ├── 📜 Jenkinsfile
 ├── 📜 pom.xml (Maven Project)
```

### **🔹 Steps to Create a Pipeline Job**
1️⃣ Open **Jenkins Dashboard → New Item**  
2️⃣ Enter **Job Name**, select **Pipeline**, and click **OK**  
3️⃣ In the **Pipeline Definition**, select **Pipeline script from SCM**  
4️⃣ Enter **Git Repository URL**  
5️⃣ Click **Save** & Run the Pipeline  

---

## **4️⃣ Understanding Pipeline Stages, Steps & Agents**
A **Jenkinsfile** consists of:  
🔹 **Agent** → Defines where the pipeline runs  
🔹 **Stages** → Represents different phases of the pipeline  
🔹 **Steps** → Actions performed in each stage  

### **🔹 Example: Declarative Pipeline**
```groovy
pipeline {
    agent any  // Run on any available Jenkins node
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
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'scp target/*.war user@server:/deployments'
            }
        }
    }
}
```
✔ **Stage 1:** Fetches code from Git  
✔ **Stage 2:** Builds the project using Maven  
✔ **Stage 3:** Runs unit tests  
✔ **Stage 4:** Deploys to a remote server  

---

## **5️⃣ Pipeline Variables & Parameters**
### **🔹 Defining Variables in Pipelines**
Variables help store reusable values.

🔹 **Example:**
```groovy
pipeline {
    agent any
    environment {
        APP_ENV = "staging"
    }
    stages {
        stage('Print Variable') {
            steps {
                echo "Deploying to $APP_ENV"
            }
        }
    }
}
```

### **🔹 Using Build Parameters**
🔹 **Steps to Add Parameters:**
1️⃣ Open **Pipeline Job → Configure**  
2️⃣ Check **"This project is parameterized"**  
3️⃣ Add **String Parameter** or **Choice Parameter**  

🔹 **Example: Using Parameters in a Pipeline**
```groovy
pipeline {
    agent any
    parameters {
        string(name: 'DEPLOY_ENV', defaultValue: 'dev', description: 'Deployment Environment')
    }
    stages {
        stage('Deploy') {
            steps {
                echo "Deploying to ${params.DEPLOY_ENV} environment"
            }
        }
    }
}
```

📌 **Now, Jenkins prompts for the environment before running the job!**

---

## **6️⃣ Using Scripted Pipelines for Advanced Workflows**
### **🔹 What is a Scripted Pipeline?**
- Uses **Groovy scripting** (more flexible)  
- Recommended for **complex, dynamic workflows**  
- Less readable than **Declarative Pipelines**  

🔹 **Example: Scripted Pipeline**
```groovy
node {
    stage('Checkout') {
        git 'https://github.com/user/repo.git'
    }
    
    stage('Build') {
        sh 'mvn clean package'
    }
    
    stage('Test') {
        try {
            sh 'mvn test'
        } catch (Exception e) {
            echo "Tests Failed!"
        }
    }
    
    stage('Deploy') {
        sh 'scp target/*.war user@server:/deployments'
    }
}
```

✔ **More control over error handling & conditions**  
✔ **Dynamic execution flow possible**  

---

## **7️⃣ Running Parallel Stages in Pipelines**
### **🔹 Why Use Parallel Execution?**
✔ **Speeds up builds** by running independent tasks in parallel  
✔ Useful for **running tests in different environments**  

🔹 **Example: Running Tests in Parallel**
```groovy
pipeline {
    agent any
    stages {
        stage('Parallel Testing') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'mvn test -Dtest=UnitTests'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'mvn test -Dtest=IntegrationTests'
                    }
                }
            }
        }
    }
}
```

✔ **Runs Unit Tests & Integration Tests at the same time!** 🚀  

---

## **🎯 Summary**
✔ **Freestyle Jobs** are GUI-based, **Pipelines** are script-based  
✔ **Declarative Pipelines** are structured, **Scripted Pipelines** are flexible  
✔ **Stages** group steps into logical blocks  
✔ **Variables & Parameters** allow dynamic inputs  
✔ **Parallel Stages** speed up execution  
