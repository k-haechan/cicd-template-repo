# 통합 인프라 관리 (AWS & GitHub)

Terraform을 사용하여 AWS와 GitHub 인프라를 통합적으로 프로비저닝하고 관리하는 프로젝트입니다.

## 주요 기능

- AWS 리소스(VPC, EC2, RDS, S3, CloudFront 등) 생성 및 관리
- GitHub 리소스(Repository, Secrets, Variables, Branch Rules) 생성 및 관리
- GitHub Actions 워크플로우를 통한 CI/CD 파이프라인 구성

## 사전 준비 사항 (Prerequisites)

- [Terraform](https://www.terraform.io/downloads.html) v1.0.0 이상
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS 계정 및 Access Key 설정 (환경 변수 또는 `~/.aws/credentials` 파일)

## 시작하기 (Getting Started)

1.  **저장소 복제 (Clone Repository)**
    ```bash
    git clone <repository_url>
    cd dev-ops-template
    ```

2.  **변수 파일 설정 (Configure Variables)**
    `terraform.tfvars.example` 파일을 복사하여 `terraform.tfvars` 파일을 생성하고, 환경에 맞게 변수 값을 수정합니다.
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```
    `terraform.tfvars` 파일에는 민감한 정보가 포함될 수 있으며, `.gitignore`에 의해 버전 관리에서 제외됩니다.

    **주요 입력 변수:**
    - `project`: 프로젝트 이름 (예: `sns`)
    - `domain`: 서비스 도메인 (예: `example.com`)
    - `email`: 관리자 이메일 (예: `admin@example.com`)
    - `github_owner`: GitHub 소유자 (조직 또는 사용자 이름)

3.  **Terraform 초기화 (Initialize Terraform)**
    필요한 프로바이더와 모듈을 다운로드합니다.
    ```bash
    terraform init
    ```

## 사용법 (Usage)

1.  **실행 계획 확인 (Plan)**
    인프라 변경 사항을 미리 확인합니다.
    ```bash
    terraform plan
    ```

2.  **인프라 생성 및 변경 (Apply)**
    계획을 확인한 후, 실제 인프라에 적용합니다.
    ```bash
    terraform apply
    ```

3.  **인프라 삭제 (Destroy)**
    생성된 모든 리소스를 삭제합니다.
    ```bash
    terraform destroy
    ```

## 프로젝트 구조

- `main.tf`: 전체 인프라를 관리하는 최상위 파일
- `variables.tf`: 공통으로 사용되는 변수 정의
- `terraform.tfvars.example`: 변수 파일 예시
- `modules/`: 모듈화된 인프라 구성
  - `aws/`: AWS 리소스 관련 모듈 (VPC, EC2, RDS 등)
  - `github/`: GitHub 리소스 관련 모듈 (Repository, Workflows 등)
- `workflows/`: GitHub Actions 워크플로우 원본 파일

## 보안

- `terraform.tfstate` 파일은 인프라의 상태를 저장하므로 민감한 정보를 포함할 수 있습니다. 로컬에 저장되며, 원격 상태 저장(Remote State)을 사용하는 것을 권장합니다.
- `terraform.tfvars` 파일에는 비밀번호, API 키 등 민감한 정보가 포함되므로, Git으로 관리해서는 안 됩니다. 본 프로젝트의 `.gitignore` 설정에 이미 포함되어 있습니다. 