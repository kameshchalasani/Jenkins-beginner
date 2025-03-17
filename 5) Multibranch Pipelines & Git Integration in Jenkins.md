# **🚀Multibranch Pipelines & Git Integration in Jenkins **  

This guide covers:  
✅ **What is a Multibranch Pipeline?**  
✅ **How Jenkins Detects & Runs Pipelines for Different Branches**  
✅ **Setting Up Multibranch Pipeline with GitHub/GitLab**  
✅ **Using Webhooks for Automatic Pipeline Triggers**  
✅ **Handling Feature Branches & Pull Requests**  

---

## **1️⃣ What is a Multibranch Pipeline?**
### **🔹 Definition**
A **Multibranch Pipeline** in Jenkins **automatically detects, creates, and runs pipelines for each branch** in a Git repository.

### **🔹 Why Use a Multibranch Pipeline?**
✔ **Automated CI/CD for Multiple Branches** – No need to manually create jobs for each branch  
✔ **Supports Feature Branches & PRs** – Runs different pipelines for development, staging, and production  
✔ **Git Integration** – Automatically picks up new branches and Jenkinsfiles  

🔹 **Example Workflow:**
```
📂 MyProject (GitHub Repo)
 ├── 📂 feature/login-feature
 ├── 📂 feature/cart-functionality
 ├── 📂 develop
 ├── 📂 main
 ├── 📜 Jenkinsfile (in each branch)
```
✔ Jenkins automatically runs **different pipelines for each branch**  

---

## **2️⃣ How Jenkins Detects & Runs Pipelines for Different Branches**
### **🔹 How It Works**
1️⃣ Jenkins **scans the Git repository** for branches containing a `Jenkinsfile`.  
2️⃣ It **creates separate pipeline jobs** for each branch.  
3️⃣ When code is pushed, **Jenkins triggers the pipeline for that specific branch**.  

🔹 **Example Branch-Based Pipelines:**
| **Branch Name** | **Pipeline Triggered** |
|---------------|------------------|
| `develop` | Run CI/CD for development |
| `feature/new-api` | Run tests for feature branch |
| `main` | Deploy to production |

✔ **Jenkins will detect new branches automatically** and delete pipelines for branches that are removed.

---

## **3️⃣ Setting Up a Multibranch Pipeline with GitHub/GitLab**
### **🔹 Steps to Create a Multibranch Pipeline**
1️⃣ **Open Jenkins Dashboard → New Item**  
2️⃣ **Enter a Job Name** (e.g., `MyProject-Multibranch`)  
3️⃣ **Select "Multibranch Pipeline" → Click OK**  
4️⃣ **Go to "Branch Source" → Select Git or GitHub**  
5️⃣ **Enter Repository URL** (e.g., `https://github.com/user/repo.git`)  
6️⃣ **Add Credentials** (GitHub Access Token or SSH Key)  
7️⃣ **Define Branch Discovery Strategy**  
   - **All branches** – Jenkins will detect and build all branches  
   - **Filter by name** – Build only `main` and `develop` branches  
8️⃣ **Set up Build Configuration**  
   - Select **"Jenkinsfile"** as the build script  
   - Define the script path (if not in root)  
9️⃣ **Save & Apply**  

✔ Jenkins will **scan the repository and create pipeline jobs for each branch**.

---

## **4️⃣ Using Webhooks for Automatic Pipeline Triggers**
### **🔹 Why Use Webhooks?**
✔ **Faster Builds** – Triggers Jenkins **immediately** when code is pushed  
✔ **Efficient** – No need for periodic SCM polling  

### **🔹 Setting Up GitHub Webhook for Jenkins**
1️⃣ **Go to GitHub Repo → Settings → Webhooks**  
2️⃣ Click **"Add Webhook"**  
3️⃣ **Enter the Payload URL** (Jenkins URL for webhooks):  
   ```
   http://JENKINS_SERVER:8080/github-webhook/
   ```
4️⃣ **Select "Just the push event"**  
5️⃣ **Click Save**  

🔹 **Now, every Git push will trigger the Jenkins pipeline immediately!** 🚀  

---

## **5️⃣ Handling Feature Branches & Pull Requests**
### **🔹 Why Handle Feature Branches?**
✔ **Run Tests on Feature Branches Before Merging**  
✔ **Prevent Bugs from Reaching `main` or `develop`**  

### **🔹 Configure Jenkins to Detect Feature Branches**
1️⃣ **Go to Multibranch Pipeline Configuration**  
2️⃣ **In "Branch Sources", enable "Discover Branches"**  
3️⃣ Set Strategy to:  
   - **Include all branches** (if you want Jenkins to build all)  
   - **Only build feature/* branches** (`feature/*` wildcard)  

---

### **🔹 Handling Pull Requests (PRs) in Jenkins**
1️⃣ **Enable "Discover pull requests from origin"**  
2️⃣ Set PR Strategy:  
   - **Build all PRs** (for continuous testing)  
   - **Only build PRs from trusted branches**  

🔹 **Example: Build only PRs from "develop" and "main"**
```groovy
pipeline {
    agent any
    stages {
        stage('PR Validation') {
            when { branch 'PR-*' }  // Run only on PRs
            steps {
                sh 'mvn test'
            }
        }
    }
}
```
✔ Now, **only PRs** will trigger Jenkins builds!  

---

## **🎯 Summary**
✔ **Multibranch Pipelines** automatically detect and build different branches  
✔ **Jenkins scans GitHub/GitLab** and creates separate jobs for each branch  
✔ **Webhooks** enable automatic triggers on code push  
✔ **Feature Branches & PRs** are handled separately for CI validation  

🚀 **Next Steps:** Want to integrate **Docker, Kubernetes, or AWS with Jenkins Pipelines?** Let me know! 😊
