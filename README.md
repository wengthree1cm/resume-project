# Cloud Resume — S3 + CloudFront + Lambda Counter

A lightweight, extensible online resume/portfolio. The frontend is **static HTML/CSS/JS** hosted on **Amazon S3** and accelerated by **Amazon CloudFront**. The backend implements a **visitor counter** with **API Gateway + AWS Lambda + DynamoDB** (optional **SES** for a contact form). This project currently uses the **default CloudFront domain** (no custom domain/Route 53 yet).

**Live Demo**
- https://d142g2ii1hj9c0.cloudfront.net/

---

## About the project

This project is my submission for the Cloud Resume Challenge, showcasing my skills in AWS services and GitHub Actions. I've created a static React resume website using AWS services such as S3 for storage, AWS CloudFront for content delivery, Certificate Manager for SSL/TLS certificates, AWS Lambda for serverless functions, and DynamoDB for database management.
For the CI/CD process, I've implemented GitHub Actions workflows for both the frontend and backend. The workflows use Terraform to manage infrastructure as code, enabling automated deployment and scaling of the application.
Overall, this project demonstrates my proficiency in leveraging AWS services and implementing CI/CD pipelines using GitHub Actions for building modern web applications.

---

## 🧭 Architecture

![Architecture](frontend/assets/architecture.png)

---

## 🔧 Built With

- [![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)](https://developer.mozilla.org/docs/Web/HTML)
- [![CSS3](https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white)](https://developer.mozilla.org/docs/Web/CSS)
- [![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)](https://developer.mozilla.org/docs/Web/JavaScript)
- [![Amazon S3](https://img.shields.io/badge/Amazon%20S3-569A31?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/s3/)
- [![AWS CloudFront](https://img.shields.io/badge/AWS%20CloudFront-FF9900?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/cloudfront/)
- [![Amazon API Gateway](https://img.shields.io/badge/Amazon%20API%20Gateway-FF4F8B?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/apigateway/)
- [![AWS Lambda](https://img.shields.io/badge/AWS%20Lambda-FF9900?logo=aws-lambda&logoColor=white)](https://docs.aws.amazon.com/lambda/)
- [![Amazon DynamoDB](https://img.shields.io/badge/Amazon%20DynamoDB-4053D6?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/dynamodb/)
- [![Amazon SES (optional)](https://img.shields.io/badge/Amazon%20SES%20(optional)-232F3E?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/ses/)
- [![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](https://docs.github.com/actions)

---

## 🗺️ Roadmap

- [x] Host static site on **S3**
- [x] Serve over HTTPS via **CloudFront**
- [x] Implement **visitor counter** (API Gateway → Lambda → DynamoDB)
- [x] Enable **CORS** for public API calls
- [x] Add **deployment step** to sync S3 + CloudFront invalidation
- [ ] Add **custom domain** with **ACM** + **Route 53**
- [ ] Add **contact form** (API + Lambda + **SES**)
- [ ] Add **analytics/geo visualization** and simple dashboard
- [ ] Improve **project search / tag filters**
- [ ] Optimize **Lighthouse** performance scores

