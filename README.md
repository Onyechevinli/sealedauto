##############STEPS TO DEPOLY NODE.JS WEB APP TO AZURE ON ACR, AKS#############

--------------------------------------------------------------------------

Absolutely ✅ — I’ll give you:

✅ Simple Node.js Web App (Express)
✅ Dockerfile
✅ Kubernetes Deployment + Service YAML
✅ Step-by-step deployment to Azure using ACR + AKS
✅ Commands ready to copy and run 🚀
Incase you encounter any issue while running the steps, make use of any AI assistant to guide and coorect you along the way.


✅ 1️ Create a Simple Node.js Web App
OPEN VS CODE.

📌 Inside a new folder: ClearWork

📌 Create the following file accordingly:
 sealedauto/
├── package.json
├── server.js
├── public/
│   ├── styles.css
│   └── script.js
└── views/
    ├── about.ejs
    ├── contact.ejs
    └── index.ejs
------------------------------------------------------------

📌 Create package.json, then after, MAKE SURE YOU SAVE 


Install dependencies:
--------------------------------------------
npm init
npm install express ejs
--------------------------------------------


Test locally:
--------------------------------------------
node server.js
----------------------------------------

Open browser → http://localhost:3000
 

✅ 2️ Create Dockerfile



Build and test locally:
-------------------------------------------------------------
docker build -t sealed-auto:v1 .
docker images
docker run -p 3000:3000 sealed-auto:v1
-------------------------------------------------------------
Open browser → http://localhost:3000



✅ 3️ Create ACR (Azure Container Registry)
-------------------------------------------------------------
az login
az group create -n sealedauto-rg -l eastus
az acr create -n sealedautoacr -g sealedauto-rg --sku Basic
-------------------------------------------------------------



Get login server name:
-------------------------------------------------------------
az acr show -n sealedautoacr --query "loginServer" -o tsv
-----------------------------------------------------------------------



Tag image for ACR:
------------------------------------------------------------------------
docker tag sealed-auto:v1 sealedautoacr.azurecr.io/sealed-auto:v1
-------------------------------------------------------------------------




Login + Push:
------------------------------------------------
az acr login --name sealedautoacr
docker push sealedautoacr.azurecr.io/sealed-auto:v1
-----------------------------------------------------------------------



✅ 4️ Create AKS Cluster connected to ACR
----------------------------------------------------------------------------------------------------------------------------------------------
az aks create --resource-group sealedauto-rg --name sealedauto-aks --node-count 1 --node-vm-size standard_B2s --generate-ssh-keys --attach-acr sealedautoacr
----------------------------------------------------------------------------------------------------------------------------------------------



Get credentials:
---------------------------------------------------
az aks get-credentials -g sealedauto-rg -n sealedauto-aks
----------------------------------------------------



✅ 5️ Kubernetes Deployment + Service

Create file: deployment.yaml
---------------------------------------------------------------------------
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sealed-auto-deployment
  namespace: default
  labels:
    app: sealed-auto
spec:
  replicas: 2
  selector:
    matchLabels:
      app: sealed-auto
  template:
    metadata:
      labels:
        app: sealed-auto
    spec:
      containers:
        - name: sealed-auto
          image: sealedautoacr.azurecr.io/sealed-auto:v1
          ports:
            - containerPort: 3000
          env:
            - name: NODE_ENV
              value: "production"
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 250m
              memory: 256Mi
      imagePullSecrets:
        - name: acr-auth
---
apiVersion: v1
kind: Service
metadata:
  name: sealed-auto-service
  namespace: default
spec:
  type: LoadBalancer
  selector:
    app: sealed-auto
  ports:
    - port: 80
      targetPort: 3000
      protocol: TCP

--------------------------------------------------------------------------



⚙️ Step-by-Step Deployment Guide
1️⃣ Make sure you’re connected to AKS
--------------------------------------------------------------------
az aks get-credentials --resource-group sealedauto-rg --name sealedauto-aks
--------------------------------------------------------------------
kubectl get nodes
--------------------------------------------------------------------



You should see your AKS node listed.

2️⃣ Create the ACR pull secret (for private registry)

If you attached your ACR using --attach-acr when creating AKS, skip this step.
Otherwise, create a secret manually:
----------------------------------------------------
az acr credential show -n sealedautoacr
------------------------------------------------

Copy the username and password, then create the secret:

kubectl create secret docker-registry acr-auth --docker-server=sealedautoacr.azurecr.io --docker-username=sealedautoacr --docker-password=<password>

3️⃣ Apply the deployment and service
kubectl apply -f deployment.yaml

4️⃣ Check status
kubectl get pods
kubectl get svc


You’ll see an external IP under the EXTERNAL-IP column for your service after a few minutes.
# If you see <pending>, wait a bit and run the command again or run the following command to watch:

🧩 1️⃣ Check AKS cluster’s resource group

When you create an AKS cluster (e.g. nodejs-aks), Azure actually creates a managed resource group — named like:
---------------------------------------------------
MC_<yourResourceGroup>_<clusterName>_<region>
------------------------------------------------------

Run this to see it:
---------------------------------------------------------
az aks show -g sealedauto-rg -n sealedauto-aks --query nodeResourceGroup -o tsv
------------------------------------------------------------

You’ll get something like:
------------------------------------------
MC_sealedauto-rg_sealedauto-aks_eastus
----------------------------------------


🧩 2️⃣ Check if the Load Balancer IP is being created

Now check for pending public IPs:
-------------------------------------------------------------
az network public-ip list -g <the_output_above> -o table

az network public-ip list -g MC_sealedauto-rg_sealedauto-aks_eastus -o table
-------------------------------------------------------------------

If there’s no IP, the AKS service controller may not have permission or a subnet issue but if it gives out an IP eg; 51.8.41.109, then you’re good to go!

use a YAML patch file instead (safer for Windows):

Create a file named patch.yaml with this content:
----------------------------------------------------
spec:
  loadBalancerIP: 51.8.41.109
------------------------------------------------------

Apply it:
-----------------------------------------------------------------
kubectl patch svc sealed-auto-service --patch-file patch.yaml
-----------------------------------------------------------------

After that, run:
-------------------------------------------
kubectl get svc sealed-auto-service
--------------------------------------------

You should see:

EXTERNAL-IP   51.8.41.109


PUSHING THE PROJECT TO GITHUB

🧩 STEP 1 — Initialize Git in your Project Folder

In VS Code’s terminal (inside your project root folder, e.g. ClearWork):

git init


This creates a local .git repository.

🧩 STEP 2 — Add Your Files to Git
git add .


That stages all files in your folder for commit.

🧩 STEP 3 — Commit the Files
git commit -m "Initial commit"


This saves the current version to your local repo.

🧩 STEP 4 — Create a GitHub Repository

Go to https://github.com/new

Give it a name, e.g. ClearWork

Choose Public or Private

Do not initialize with a README (since you already have files locally)

Click Create Repository

GitHub will show you a page with instructions to push existing code — keep that open.

🧩 STEP 5 — Connect Your Local Repo to GitHub

From VS Code terminal, copy and run the commands GitHub shows, or manually:

git remote add origin https://github.com/<your-username>/<repo-name>.git


Example:

git remote add origin https://github.com/vincentumeokoli/Sealedauto.git

🧩 STEP 6 — Push to GitHub
git branch -M main
git push -u origin main


If prompted, sign in to GitHub or paste a Personal Access Token (PAT) instead of your password.

🔒 (GitHub no longer accepts passwords over HTTPS).

🧩 STEP 7 — Verify

Go to your GitHub repository URL:

https://github.com/<your-username>/<repo-name>


🎉 You should now see all your VS Code files online.

✅ Future updates

When you make new changes later:

git add .
git commit -m "Updated Node.js app"
git push


Step 5 – If files are large (> 50 MB)

Use Git LFS to store them efficiently:

git lfs install
git lfs track "*.zip" "*.tar.gz" "*.mp4" "*.exe"
git add .gitattributes
git add .
git commit -m "Move large files to Git LFS"
git push origin main

sealedauto-aks             = kubernetes service
sealedautoacr             = container registry
57169d62                   = public ip address
aks-agentpool-213....nsg     = network security group
aks-nodepool1-4148....-vmss = virtual machine scale set
aks-vnet-21319.....          = virtual network
kubernetes                   = load balancer
sealedauto-aks-agentpool     = managed identity