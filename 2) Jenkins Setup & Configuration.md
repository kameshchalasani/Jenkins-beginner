# **🔧 Jenkins Setup & Configuration – Step-by-Step Guide** 🚀  

This guide covers:  
✅ **Jenkins Setup & Installation**  
✅ **Installing & Configuring Plugins**  
✅ **User Management & RBAC**  
✅ **Setting Up Nodes & Distributed Builds**  
✅ **Configuring System Tools (Java, Maven, Gradle, Docker)**  
✅ **Creating a Freestyle Job**  

---

## **1️⃣ Setting Up Jenkins**
### **🔹 Install Jenkins (Windows, Linux, Docker)**
Refer to my previous response for detailed **installation steps** for each OS.

### **🔹 Access Jenkins Web UI**
Once Jenkins is installed, open a browser and go to:  
```
http://localhost:8080
```
### **🔹 Unlock Jenkins**
Retrieve the **Admin Password** from:  
**Linux/Mac:**  
```sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
**Windows:**  
```
C:\ProgramData\Jenkins\.jenkins\secrets\initialAdminPassword
```
Enter the password in the browser to proceed.

---

## **2️⃣ Installing and Configuring Plugins**
### **🔹 Why Plugins?**
Jenkins supports over **1,800+ plugins** to integrate with **Git, Docker, Kubernetes, AWS, Slack, and more.**

### **🔹 Install Plugins via UI**
1️⃣ Go to **Manage Jenkins → Manage Plugins**  
2️⃣ Search & Install Plugins like:  
   - **Git Plugin** (for GitHub, GitLab integration)  
   - **Pipeline Plugin** (for CI/CD pipelines)  
   - **Blue Ocean** (for better UI)  
   - **Email Extension Plugin** (for notifications)  
3️⃣ Click **Apply & Restart Jenkins**  

### **🔹 Install Plugins via CLI**
Use Jenkins CLI to install plugins:
```sh
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin git docker-workflow
```
Restart Jenkins after plugin installation:
```sh
sudo systemctl restart jenkins
```

---

## **3️⃣ Setting Up Users & Role-Based Access Control (RBAC)**
By default, Jenkins allows **admin-level access** to all users. To improve security, set up **RBAC (Role-Based Access Control).**

### **🔹 Steps to Create Users**
1️⃣ Go to **Manage Jenkins → Manage Users**  
2️⃣ Click **Create User**, enter:  
   - **Username**  
   - **Password**  
   - **Full Name & Email**  
3️⃣ Click **Save**

### **🔹 Setup Role-Based Access Control (RBAC)**
1️⃣ Install **Role-based Authorization Strategy Plugin**  
2️⃣ Go to **Manage Jenkins → Configure Global Security**  
3️⃣ Select **Role-Based Strategy**  
4️⃣ Define roles (**Admin, Developer, Tester**)  
5️⃣ Assign users to roles and limit permissions  

Now, users will have **restricted access** based on their roles.

---

## **4️⃣ Managing Nodes & Distributed Builds**
Jenkins allows you to **add multiple nodes (agents) to distribute builds** for performance improvement.

### **🔹 Steps to Add a Jenkins Node (Agent)**
1️⃣ Go to **Manage Jenkins → Manage Nodes and Clouds**  
2️⃣ Click **New Node**  
3️⃣ Select **Permanent Agent** and enter:
   - **Node Name** (e.g., "Linux-Agent-1")  
   - **Remote Root Directory** (e.g., `/home/jenkins/`)  
   - **Launch Method** (via SSH or JNLP)  
4️⃣ Click **Save & Launch**

### **🔹 Configure Master-Agent Setup**
On **Agent Machine**, install **Jenkins Agent**:
```sh
wget http://JENKINS_MASTER:8080/jnlpJars/agent.jar
java -jar agent.jar -jnlpUrl http://JENKINS_MASTER:8080/computer/Linux-Agent-1/slave-agent.jnlp
```
🔹 **Now Jenkins will distribute builds across multiple agents!**  

---

## **5️⃣ Configuring System & Global Tools (Java, Maven, Gradle, Docker)**
To build Java, Maven, or Docker projects, configure global tools.

### **🔹 Configure Java**
1️⃣ Go to **Manage Jenkins → Global Tool Configuration**  
2️⃣ Under **JDK**, click **Add JDK**  
3️⃣ Enter Java home path:
   ```
   /usr/lib/jvm/java-11-openjdk-amd64
   ```

### **🔹 Configure Maven**
1️⃣ Install Maven:  
   ```sh
   sudo apt install maven -y
   ```
2️⃣ Go to **Global Tool Configuration**  
3️⃣ Under **Maven**, click **Add Maven**  
4️⃣ Enter name (e.g., `Maven-3.8.4`) and set path:
   ```
   /usr/share/maven
   ```

### **🔹 Configure Gradle**
1️⃣ Install Gradle:  
   ```sh
   sudo apt install gradle -y
   ```
2️⃣ In Jenkins, under **Global Tool Configuration**, add Gradle path:
   ```
   /usr/share/gradle
   ```

### **🔹 Configure Docker in Jenkins**
1️⃣ Install Docker on Jenkins machine:
   ```sh
   sudo apt install docker.io -y
   ```
2️⃣ Add **Jenkins user** to the **Docker group**:
   ```sh
   sudo usermod -aG docker jenkins
   ```
3️⃣ Restart Jenkins:
   ```sh
   sudo systemctl restart jenkins
   ```

Now, Jenkins can run **Docker-based builds & deployments!** 🚀  

---

## **6️⃣ Creating First Freestyle Job**
### **🔹 Step 1: Create a New Job**
1️⃣ Go to **Jenkins Dashboard → New Item**  
2️⃣ Enter a job name (e.g., `MyFirstJob`)  
3️⃣ Select **Freestyle Project** and click **OK**  

---

### **🔹 Step 2: Configure Job**
#### **A. Source Code Management (SCM)**
- Select **Git** (if using GitHub/GitLab)  
- Enter repository URL:  
  ```
  https://github.com/your-repo.git
  ```
- Add Git credentials if needed.  

#### **B. Build Triggers**
- Enable **"Poll SCM"** (`H/5 * * * *` to check every 5 mins)  
- Use **Webhooks** for GitHub auto-trigger  

#### **C. Build Steps**
- Click **Add Build Step → Execute Shell**  
- Enter a sample script:  
  ```sh
  echo "Hello, Jenkins!"
  mkdir test_folder
  touch test_file.txt
  ls -l
  ```
- Click **Save**  

---

### **🔹 Step 3: Run the Job**
1️⃣ Click **"Build Now"**  
2️⃣ Go to **Build History → Console Output**  
3️⃣ Check for **Success or Errors**  

---

## **🎯 Summary**
✔ **Installed Jenkins & Plugins**  
✔ **Configured Users & Role-Based Access Control**  
✔ **Set Up Nodes & Distributed Builds**  
✔ **Configured Java, Maven, Gradle, and Docker**  
✔ **Created a Freestyle Job & Ran It**  
