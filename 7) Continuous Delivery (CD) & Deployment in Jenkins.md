# **🚀 Continuous Delivery (CD) & Deployment in Jenkins**  

This guide covers:  
✅ **What is Continuous Delivery & Deployment?**  
✅ **Deploying Applications to Staging & Production**  
✅ **Using Jenkins with Docker & Kubernetes**  
✅ **Implementing Blue-Green Deployment & Canary Releases**  
✅ **Deploying to AWS, Azure, and Google Cloud**  

---

## **1️⃣ What is Continuous Delivery & Deployment?**
### **🔹 Continuous Delivery (CD)**
✔ Automates the process of **building, testing, and preparing software** for release.  
✔ The software is **ready to deploy at any time**, but deployment is **manually approved**.  

### **🔹 Continuous Deployment**
✔ Extends Continuous Delivery by **automating the deployment process** to production.  
✔ Every code change that passes tests **is deployed automatically** without manual intervention.  

🔹 **CI/CD Pipeline Flow:**  
```
1️⃣ Code Commit (GitHub, GitLab, Bitbucket)
2️⃣ Jenkins CI runs builds and tests
3️⃣ If successful, CD stage prepares release artifacts
4️⃣ Deployment (Manual approval for Continuous Delivery)
5️⃣ Continuous Deployment pushes directly to production
```

---

## **2️⃣ Deploying Applications to Staging & Production**
### **🔹 Why Use Staging?**
✔ Prevents **breaking production** by testing in a near-production environment.  
✔ Ensures that the **latest version runs correctly** before public release.  

### **🔹 Example Jenkinsfile for Staging & Production Deployment**
```groovy
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "my-app:latest"
    }
    stages {
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
        stage('Staging Deployment') {
            steps {
                sh 'docker run -d -p 8080:8080 $DOCKER_IMAGE'
            }
        }
        stage('Approval for Production') {
            steps {
                input message: 'Deploy to Production?', ok: 'Deploy'
            }
        }
        stage('Production Deployment') {
            steps {
                sh 'docker run -d -p 80:8080 $DOCKER_IMAGE'
            }
        }
    }
}
```
✔ **Deploys to Staging first**, requires **manual approval** for Production.  

---

## **3️⃣ Using Jenkins with Docker & Kubernetes**
### **🔹 Why Use Docker?**
✔ **Ensures consistency** – Runs the same environment across all stages.  
✔ **Simplifies deployment** – No dependency conflicts.  

### **🔹 Why Use Kubernetes?**
✔ **Scales applications** easily across multiple nodes.  
✔ **Manages deployments & rollbacks** automatically.  

### **🔹 Deploying with Docker in Jenkins**
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
        stage('Deploy with Docker') {
            steps {
                sh 'docker run -d -p 8080:8080 my-app:latest'
            }
        }
    }
}
```
✔ **Builds, pushes, and runs a Docker container** from Jenkins.  

---

### **🔹 Deploying with Kubernetes in Jenkins**
1️⃣ **Install Kubernetes Plugin in Jenkins**  
   - Manage Jenkins → Manage Plugins → Install **Kubernetes CLI Plugin**  
2️⃣ **Configure Kubernetes Cluster Credentials in Jenkins**  
3️⃣ **Jenkinsfile to Deploy to Kubernetes**
```groovy
pipeline {
    agent any
    environment {
        K8S_NAMESPACE = "production"
        DEPLOYMENT_NAME = "my-app"
        IMAGE_NAME = "my-app:latest"
    }
    stages {
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml --namespace=$K8S_NAMESPACE
                kubectl rollout status deployment/$DEPLOYMENT_NAME --namespace=$K8S_NAMESPACE
                '''
            }
        }
    }
}
```
✔ **Uses `kubectl` to deploy to Kubernetes**.  

---

## **4️⃣ Implementing Blue-Green Deployment & Canary Releases**
### **🔹 What is Blue-Green Deployment?**
✔ Runs **two identical production environments** (Blue & Green).  
✔ Users **switch between versions without downtime**.  

🔹 **Blue-Green Deployment Workflow:**
```
1️⃣ Deploy new app version (Green) alongside the old one (Blue)
2️⃣ Test the Green environment
3️⃣ Switch traffic to Green if successful
4️⃣ Remove Blue (old version)
```

🔹 **Example Jenkinsfile for Blue-Green Deployment**
```groovy
pipeline {
    agent any
    environment {
        BLUE_SERVICE = "my-app-blue"
        GREEN_SERVICE = "my-app-green"
    }
    stages {
        stage('Deploy Green') {
            steps {
                sh 'kubectl apply -f k8s/green-deployment.yaml'
            }
        }
        stage('Switch Traffic to Green') {
            steps {
                sh 'kubectl patch svc my-app-service -p "{\\"spec\\": {\\"selector\\": {\\"app\\": \\"green\\"}}}"'
            }
        }
        stage('Remove Blue') {
            steps {
                sh 'kubectl delete deployment my-app-blue'
            }
        }
    }
}
```
✔ **Switches traffic to the new version (Green) without downtime**.  

---

### **🔹 What is Canary Deployment?**
✔ **Releases a new version gradually** to a subset of users.  
✔ If stable, rollout to 100% of users.  

🔹 **Canary Deployment Steps:**
1️⃣ Deploy v2 to **10% of users**  
2️⃣ Monitor logs, error rates  
3️⃣ If stable, increase to **50% → 100%**  

🔹 **Example Jenkinsfile for Canary Release**
```groovy
pipeline {
    agent any
    stages {
        stage('Deploy Canary (10%)') {
            steps {
                sh 'kubectl apply -f k8s/canary-10.yaml'
            }
        }
        stage('Monitor') {
            steps {
                sleep(time: 60, unit: 'SECONDS')
            }
        }
        stage('Rollout 100%') {
            steps {
                sh 'kubectl apply -f k8s/canary-100.yaml'
            }
        }
    }
}
```
✔ **Deploys incrementally, ensuring stability**.  

---

## **5️⃣ Deploying to AWS, Azure, and Google Cloud**
### **🔹 Deploying to AWS (ECS)**
```groovy
pipeline {
    agent any
    stages {
        stage('Deploy to AWS ECS') {
            steps {
                sh 'aws ecs update-service --cluster my-cluster --service my-app --force-new-deployment'
            }
        }
    }
}
```

---

### **🔹 Deploying to Azure (AKS)**
```groovy
pipeline {
    agent any
    stages {
        stage('Deploy to Azure AKS') {
            steps {
                sh 'az aks update --resource-group my-rg --name my-aks-cluster --set enableRBAC=true'
            }
        }
    }
}
```

---

### **🔹 Deploying to Google Cloud (GKE)**
```groovy
pipeline {
    agent any
    stages {
        stage('Deploy to GKE') {
            steps {
                sh 'gcloud container clusters get-credentials my-cluster --zone us-central1-a'
                sh 'kubectl apply -f k8s/deployment.yaml'
            }
        }
    }
}
```

---

## **🎯 Summary**
✔ **CD automates deployment, but Continuous Deployment eliminates manual approval**  
✔ **Docker & Kubernetes** help scale deployments  
✔ **Blue-Green & Canary deployments** reduce downtime  
✔ **Jenkins integrates with AWS, Azure, GCP** for cloud deployment  
