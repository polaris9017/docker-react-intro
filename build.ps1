# PowerShell script converted from build.sh using Github Copilot
param (
    [Parameter(Mandatory=$true)][string]$username,
    [Parameter(Mandatory=$true)][string]$command
)

# Check if the command is either 'start' or 'stop'
if ($command -ne "start" -and $command -ne "stop") {
    Write-Host "Invalid command!"
    exit 1
}

# If the command is 'start', build and push the docker image, then apply the kubernetes configurations
if ($command -eq "start") {
    docker build -t $username/node-react-app .
    docker push $username/node-react-app:latest
    kubectl apply -f .\deployment.yaml
    kubectl apply -f .\service.yaml
}
# If the command is 'stop', delete the kubernetes service and deployment
elseif ($command -eq "stop") {
    kubectl delete svc svc-react-app
    kubectl delete deploy dpy-react-app
}