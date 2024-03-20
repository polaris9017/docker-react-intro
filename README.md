# Docker, k8s를 활용한 Node.js-React App 배포

아래 과정에서 React App의 Production 빌드를 Docker container화 하고, Kubernetes로 배포하는 과정을 설명하고자 함

## Prerequisites

- Docker (Docker Hub에 로그인되어 있어야 함)
- Kubernetes (Docker Desktop에서 활성화)
- Bash(Unix 환경에서 필요)


## 과정

**(1, 2번은 수동으로 컨테이너 빌드 및 Dcoker Hub에 푸시하는 과정이므로 3번으로 건너뛰어도 무방함)**

1. **Dockerfile 로 이미지 빌드**

   ```bash
   docker build -t <본인 Docker Hub ID>/node-react-app .
   ```

2. **Docker Hub에 이미지 푸시**

   ```bash
   docker push <본인 Docker Hub ID>/node-react-app:latest
   ```

3. **어플리케이션 배포**

   아래 스크립트 실행 시 컨테이너 이미지 빌드 및 푸시, 그리고 k8s에 배포까지 자동으로 수행함

   ```bash
   # Unix 환경 (Mac, Linux, WSL, ...)
   ./build.sh <본인 Docker Hub ID> start
   ```
   ```shell
   # Windows 환경
   .\build.ps1 --username=<본인 Docker Hub ID> --command=start
   ```

4. **Stop the Application**

   위 3번 과정에서 start 인자 대신 stop을 넣어주면 배포된 어플리케이션을 중지함.\
   이때, k8s에서 배포된 어플리케이션의 모든 리소스가 삭제됨 

   ```bash
   # Unix 환경 (Mac, Linux, WSL, ...)
   ./build.sh <your-docker-hub-username> stop
   ```
   ```shell
   # Windows 환경
   .\build.ps1 --username=<본인 Docker Hub ID> --command=stop
   ```

## 참고

- 본 예시에서 사용된 NodePort의 port 번호는 최소 30000 이상으로, 실제 배포 시에는 LoadBalancer나 Ingress를 사용해야 함 ([참고 자료](https://sunrise-min.tistory.com/entry/Kubernetes-NodePort-vs-LoadBalancer-vs-Ingress))