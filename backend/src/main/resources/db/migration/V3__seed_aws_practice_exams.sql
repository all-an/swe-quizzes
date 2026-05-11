-- AWS Cloud Practitioner practice quizzes
-- Based on the official exam pace: 65 questions / 90 min ≈ 83s per question
-- Each quiz: 15 questions × 83s = 1245s ≈ 20 min

INSERT INTO quiz (title, description, category_id, time_seconds) VALUES
    ('AWS Cloud Practitioner - Set 1', 'Cloud fundamentals, shared responsibility, and core services.', 1, 1245),
    ('AWS Cloud Practitioner - Set 2', 'CloudFront, IAM, pricing models, and storage.', 1, 1245),
    ('AWS Cloud Practitioner - Set 3', 'Organizations, databases, security, and best practices.', 1, 1245);

-- ============================================================
-- SET 1  (quiz_id = 4, questions 7–21)
-- ============================================================
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('AWS allows users to manage their resources using a web based user interface. What is the name of this interface?', 83, 4),
    ('Which of the following is an example of horizontal scaling in the AWS Cloud?', 83, 4),
    ('You have noticed that several critical Amazon EC2 instances have been terminated. Which of the following AWS services would help you determine who took this action?', 83, 4),
    ('Which statement is true regarding the AWS Shared Responsibility Model?', 83, 4),
    ('You have set up consolidated billing for several AWS accounts. One of the accounts has purchased a number of reserved instances for 3 years. Which of the following is true regarding this scenario?', 83, 4),
    ('A company has developed an eCommerce web application in AWS. What should they do to ensure that the application has the highest level of availability?', 83, 4),
    ('A company has an AWS Enterprise Support plan. They want quick and efficient guidance with their billing and account inquiries. Which of the following should the company use?', 83, 4),
    ('A Japanese company hosts their applications on Amazon EC2 instances in the Tokyo Region. The company has opened new branches in the United States, and the US users are complaining of high latency. What can the company do to reduce latency for the users in the US while minimizing costs?', 83, 4),
    ('An organization has a large number of technical employees who operate their AWS Cloud infrastructure. What does AWS provide to help organize them into teams and then assign the appropriate permissions for each team?', 83, 4),
    ('A company has decided to migrate its Oracle database to AWS. Which AWS service can help achieve this without negatively impacting the functionality of the source database?', 83, 4),
    ('Adjusting compute capacity dynamically to reduce cost is an implementation of which AWS cloud best practice?', 83, 4),
    ('What is the advantage of the AWS-recommended practice of decoupling applications?', 83, 4),
    ('Which of the following helps a customer view the Amazon EC2 billing activity for the past month?', 83, 4),
    ('What do you gain from setting up consolidated billing for five different AWS accounts under another master account?', 83, 4),
    ('One of the most important AWS best-practices to follow is the cloud architecture principle of elasticity. How does this principle improve your architecture''s design?', 83, 4);

INSERT INTO answer (description, correct, question_id) VALUES
    -- Q7: AWS Management Console
    ('AWS CLI', FALSE, 7),
    ('AWS API', FALSE, 7),
    ('AWS SDK', FALSE, 7),
    ('AWS Management Console', TRUE, 7),
    -- Q8: Horizontal scaling
    ('Replacing an existing EC2 instance with a larger, more powerful one', FALSE, 8),
    ('Increasing the compute capacity of a single EC2 instance to address growing demands', FALSE, 8),
    ('Adding more RAM capacity to an EC2 instance', FALSE, 8),
    ('Adding more EC2 instances of the same size to handle an increase in traffic', TRUE, 8),
    -- Q9: CloudTrail
    ('Amazon Inspector', FALSE, 9),
    ('AWS CloudTrail', TRUE, 9),
    ('AWS Trusted Advisor', FALSE, 9),
    ('EC2 Instance Usage Report', FALSE, 9),
    -- Q10: Shared Responsibility
    ('Responsibilities vary depending on the services used', TRUE, 10),
    ('Security of the IaaS services is the responsibility of AWS', FALSE, 10),
    ('Patching the guest OS is always the responsibility of AWS', FALSE, 10),
    ('Security of the managed services is the responsibility of the customer', FALSE, 10),
    -- Q11: Consolidated billing
    ('The Reserved Instance discounts can only be shared with the master account', FALSE, 11),
    ('All accounts can receive the hourly cost benefit of the Reserved Instances', TRUE, 11),
    ('The purchased instances will have better performance than On-demand instances', FALSE, 11),
    ('There are no cost benefits from using consolidated billing; it is for informational purposes only', FALSE, 11),
    -- Q12: Highest availability
    ('Deploy the application across multiple Availability Zones and Edge locations', FALSE, 12),
    ('Deploy the application across multiple Availability Zones and subnets', FALSE, 12),
    ('Deploy the application across multiple Regions and Availability Zones', TRUE, 12),
    ('Deploy the application across multiple VPCs and subnets', FALSE, 12),
    -- Q13: Support Concierge
    ('AWS Health Dashboard', FALSE, 13),
    ('AWS Support Concierge', TRUE, 13),
    ('AWS Customer Service', FALSE, 13),
    ('AWS Operations Support', FALSE, 13),
    -- Q14: Reduce latency
    ('Applying the Amazon Connect latency-based routing policy', FALSE, 14),
    ('Registering a new US domain name to serve the users in the US', FALSE, 14),
    ('Building a new data center in the US and implementing a hybrid model', FALSE, 14),
    ('Deploying new Amazon EC2 instances in a Region located in the US', TRUE, 14),
    -- Q15: IAM user groups
    ('IAM roles', FALSE, 15),
    ('IAM users', FALSE, 15),
    ('IAM user groups', TRUE, 15),
    ('AWS Organizations', FALSE, 15),
    -- Q16: Database Migration Service
    ('AWS OpsWorks', FALSE, 16),
    ('AWS Database Migration Service', TRUE, 16),
    ('AWS Server Migration Service', FALSE, 16),
    ('AWS Application Discovery Service', FALSE, 16),
    -- Q17: Elasticity
    ('Build security in every layer', FALSE, 17),
    ('Parallelize tasks', FALSE, 17),
    ('Implement elasticity', TRUE, 17),
    ('Adopt monolithic architecture', FALSE, 17),
    -- Q18: Decoupling
    ('Allows treating an application as a single, cohesive unit', FALSE, 18),
    ('Reduces inter-dependencies so that failures do not impact other components of the application', TRUE, 18),
    ('Allows updates of any monolithic application quickly and easily', FALSE, 18),
    ('Allows tracking of any API call made to any AWS service', FALSE, 18),
    -- Q19: EC2 billing activity
    ('AWS Budgets', FALSE, 19),
    ('AWS Pricing Calculator', FALSE, 19),
    ('AWS Systems Manager', FALSE, 19),
    ('AWS Cost & Usage Reports', TRUE, 19),
    -- Q20: Consolidated billing benefit
    ('AWS services costs will be reduced to half the original price', FALSE, 20),
    ('The consolidated billing feature is just for organizational purpose', FALSE, 20),
    ('Each AWS account gets volume discounts', TRUE, 20),
    ('Each AWS account gets five times the free-tier services capacity', FALSE, 20),
    -- Q21: Elasticity principle
    ('By automatically scaling your on-premises resources based on changes in demand', FALSE, 21),
    ('By automatically scaling your AWS resources using an Elastic Load Balancer', FALSE, 21),
    ('By reducing interdependencies between application components wherever possible', FALSE, 21),
    ('By automatically provisioning the required AWS resources based on changes in demand', TRUE, 21);

-- ============================================================
-- SET 2  (quiz_id = 5, questions 22–36)
-- ============================================================
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('What does Amazon CloudFront use to distribute content to global users with low latency?', 83, 5),
    ('What does the "Principle of Least Privilege" refer to?', 83, 5),
    ('Which of the following does NOT belong to the AWS Cloud Computing models?', 83, 5),
    ('A company requires storing recorded interview videos that are only needed in the event of a legal issue. What is the most cost-effective service?', 83, 5),
    ('Which service provides DNS in the AWS cloud?', 83, 5),
    ('A company is deploying a new two-tier web application in AWS. Where should the most frequently accessed data be stored so that the application''s response time is optimal?', 83, 5),
    ('You want to run a questionnaire application for only one day (without interruption). Which Amazon EC2 purchase option should you use?', 83, 5),
    ('You are working on a project that involves creating thumbnails of millions of images. Consistent uptime is not an issue, and continuous processing is not required. Which EC2 buying option would be the most cost-effective?', 83, 5),
    ('Which of the following can be described as a global content delivery network (CDN) service?', 83, 5),
    ('Which of the following services allows customers to manage their agreements with AWS?', 83, 5),
    ('Your company has a data store application that requires access to a NoSQL database. Which AWS database offering would meet this requirement?', 83, 5),
    ('As part of the Enterprise support plan, who is the primary point of contact for ongoing support needs?', 83, 5),
    ('How can you view the distribution of AWS spending in one of your AWS accounts?', 83, 5),
    ('Which of the following must an IAM user provide to interact with AWS services using the AWS Command Line Interface (AWS CLI)?', 83, 5),
    ('You have AWS Basic support and have discovered that some AWS resources are being used maliciously. What should you do?', 83, 5);

INSERT INTO answer (description, correct, question_id) VALUES
    -- Q22: CloudFront distribution
    ('AWS Global Accelerator', FALSE, 22),
    ('AWS Regions', FALSE, 22),
    ('AWS Edge Locations', TRUE, 22),
    ('AWS Availability Zones', FALSE, 22),
    -- Q23: Least Privilege
    ('You should grant your users only the permissions they need when they need them and nothing more', TRUE, 23),
    ('All IAM users should have at least the necessary permissions to access the core AWS services', FALSE, 23),
    ('All trusted IAM users should have access to any AWS service in the respective AWS account', FALSE, 23),
    ('IAM users should not be granted any permissions to keep your account safe', FALSE, 23),
    -- Q24: Cloud Computing models
    ('Platform as a Service (PaaS)', FALSE, 24),
    ('Infrastructure as a Service (IaaS)', FALSE, 24),
    ('Software as a Service (SaaS)', FALSE, 24),
    ('Networking as a Service (NaaS)', TRUE, 24),
    -- Q25: Cost-effective video storage
    ('S3 Intelligent-Tiering', FALSE, 25),
    ('AWS Marketplace', FALSE, 25),
    ('Amazon S3 Glacier Deep Archive', TRUE, 25),
    ('Amazon EBS', FALSE, 25),
    -- Q26: DNS service
    ('Route 53', TRUE, 26),
    ('AWS Config', FALSE, 26),
    ('Amazon CloudFront', FALSE, 26),
    ('Amazon EMR', FALSE, 26),
    -- Q27: Frequently accessed data
    ('AWS OpsWorks', FALSE, 27),
    ('AWS Storage Gateway', FALSE, 27),
    ('Amazon EBS volume', FALSE, 27),
    ('Amazon ElastiCache', TRUE, 27),
    -- Q28: One-day application
    ('Reserved instances', FALSE, 28),
    ('Spot instances', FALSE, 28),
    ('Dedicated instances', FALSE, 28),
    ('On-demand instances', TRUE, 28),
    -- Q29: Thumbnail processing
    ('Reserved Instances', FALSE, 29),
    ('On-demand Instances', FALSE, 29),
    ('Dedicated Instances', FALSE, 29),
    ('Spot Instances', TRUE, 29),
    -- Q30: CDN service
    ('AWS VPN', FALSE, 30),
    ('AWS Direct Connect', FALSE, 30),
    ('AWS Regions', FALSE, 30),
    ('Amazon CloudFront', TRUE, 30),
    -- Q31: AWS agreements
    ('AWS Artifact', TRUE, 31),
    ('AWS Certificate Manager', FALSE, 31),
    ('AWS Systems Manager', FALSE, 31),
    ('AWS Organizations', FALSE, 31),
    -- Q32: NoSQL database
    ('Amazon Aurora', FALSE, 32),
    ('Amazon DynamoDB', TRUE, 32),
    ('Amazon Elastic Block Store', FALSE, 32),
    ('Amazon Redshift', FALSE, 32),
    -- Q33: Enterprise support contact
    ('AWS Identity and Access Management (IAM) user', FALSE, 33),
    ('Infrastructure Event Management (IEM) engineer', FALSE, 33),
    ('AWS Consulting Partners', FALSE, 33),
    ('Technical Account Manager (TAM)', TRUE, 33),
    -- Q34: View AWS spending
    ('By using Amazon VPC console', FALSE, 34),
    ('By contacting the AWS Support team', FALSE, 34),
    ('By using AWS Cost Explorer', TRUE, 34),
    ('By contacting the AWS Finance team', FALSE, 34),
    -- Q35: IAM CLI credentials
    ('Access keys', TRUE, 35),
    ('Secret token', FALSE, 35),
    ('UserID', FALSE, 35),
    ('User name and password', FALSE, 35),
    -- Q36: Malicious resource usage
    ('Contact the AWS Customer Service team', FALSE, 36),
    ('Contact the AWS Abuse team', TRUE, 36),
    ('Contact the AWS Concierge team', FALSE, 36),
    ('Contact the AWS Security team', FALSE, 36);

-- ============================================================
-- SET 3  (quiz_id = 6, questions 37–51)
-- ============================================================
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('A global company with a large number of AWS accounts is seeking a way to centrally manage billing and security policies across all accounts. Which AWS Service will assist them?', 83, 6),
    ('Which service provides object-level storage in AWS?', 83, 6),
    ('A company is concerned about spending money on underutilized compute resources. Which AWS feature will automatically add/remove EC2 capacity to closely match required demand?', 83, 6),
    ('Which S3 storage class is best for data with unpredictable access patterns?', 83, 6),
    ('What is the AWS database service that allows you to upload data structured in key-value format?', 83, 6),
    ('Which of the following is NOT correct regarding Amazon EC2 On-demand instances?', 83, 6),
    ('What is the AWS feature that provides an additional level of security above the default authentication mechanism of usernames and passwords?', 83, 6),
    ('A company is expecting a surge in traffic to their web application. As part of their Enterprise Support plan, which of the following provides architectural and scaling guidance?', 83, 6),
    ('Your company decided to migrate to the AWS Cloud. Which of the following can help save time on database maintenance so you can focus on data architecture and performance?', 83, 6),
    ('Which of the following is a best-practice when designing solutions on AWS?', 83, 6),
    ('According to the AWS Acceptable Use Policy, which statement is true regarding penetration testing of EC2 instances?', 83, 6),
    ('Which service is used to ensure that messages between software components are not lost if one or more components fail?', 83, 6),
    ('What is the AWS service that provides a virtual network dedicated to your AWS account?', 83, 6),
    ('Your company is designing a new application that will store and retrieve photos and videos. Which service should you recommend as the underlying storage mechanism?', 83, 6),
    ('Which of the following is equivalent to a user name and password and is used to authenticate your programmatic access to AWS services and APIs?', 83, 6);

INSERT INTO answer (description, correct, question_id) VALUES
    -- Q37: Central billing management
    ('AWS Organizations', TRUE, 37),
    ('AWS Trusted Advisor', FALSE, 37),
    ('IAM User Groups', FALSE, 37),
    ('AWS Config', FALSE, 37),
    -- Q38: Object-level storage
    ('Amazon EBS', FALSE, 38),
    ('Amazon Instance Store', FALSE, 38),
    ('Amazon EFS', FALSE, 38),
    ('Amazon S3', TRUE, 38),
    -- Q39: Auto Scaling
    ('AWS Elastic Load Balancer', FALSE, 39),
    ('AWS Budgets', FALSE, 39),
    ('AWS Auto Scaling', TRUE, 39),
    ('AWS Cost Explorer', FALSE, 39),
    -- Q40: S3 storage class
    ('Amazon S3 Intelligent-Tiering', TRUE, 40),
    ('Amazon S3 Glacier Flexible Retrieval', FALSE, 40),
    ('Amazon S3 Standard', FALSE, 40),
    ('Amazon S3 Standard-Infrequent Access', FALSE, 40),
    -- Q41: Key-value database
    ('Amazon DynamoDB', TRUE, 41),
    ('Amazon Aurora', FALSE, 41),
    ('Amazon Redshift', FALSE, 41),
    ('Amazon RDS', FALSE, 41),
    -- Q42: On-demand instances
    ('You have to pay a start-up fee when launching a new instance for the first time', TRUE, 42),
    ('The on-demand instances follow the AWS pay-as-you-go pricing model', FALSE, 42),
    ('With on-demand instances, no longer-term commitments or upfront payments are needed', FALSE, 42),
    ('When using on-demand Linux instances, you are charged per second based on an hourly rate', FALSE, 42),
    -- Q43: MFA
    ('Encrypted keys', FALSE, 43),
    ('Email verification', FALSE, 43),
    ('AWS KMS', FALSE, 43),
    ('AWS MFA', TRUE, 43),
    -- Q44: Infrastructure Event Management
    ('AWS Knowledge Center', FALSE, 44),
    ('AWS Health Dashboard', FALSE, 44),
    ('Infrastructure Event Management', TRUE, 44),
    ('AWS Support Concierge Service', FALSE, 44),
    -- Q45: Database maintenance
    ('Amazon RDS', TRUE, 45),
    ('Amazon Redshift', FALSE, 45),
    ('Amazon DynamoDB', FALSE, 45),
    ('Amazon CloudWatch', FALSE, 45),
    -- Q46: Design best practice
    ('Invest heavily in architecting your environment, as it is not easy to change your design later', FALSE, 46),
    ('Use AWS reservations to reduce costs when testing your production environment', FALSE, 46),
    ('Automate wherever possible to make architectural experimentation easier', TRUE, 46),
    ('Provision a large compute capacity to handle any spikes in load', FALSE, 46),
    -- Q47: Penetration testing
    ('Penetration testing is not allowed in AWS', FALSE, 47),
    ('Penetration testing is performed automatically by AWS to determine vulnerabilities in your AWS infrastructure', FALSE, 47),
    ('Penetration testing can be performed by the customer on their own instances without prior authorization from AWS', TRUE, 47),
    ('AWS customers are only allowed to perform penetration testing on services managed by AWS', FALSE, 47),
    -- Q48: Message queue
    ('Amazon SQS', TRUE, 48),
    ('Amazon SES', FALSE, 48),
    ('AWS Direct Connect', FALSE, 48),
    ('Amazon Connect', FALSE, 48),
    -- Q49: Virtual network
    ('AWS VPN', FALSE, 49),
    ('AWS Subnets', FALSE, 49),
    ('AWS Dedicated Hosts', FALSE, 49),
    ('Amazon VPC', TRUE, 49),
    -- Q50: Photo/video storage
    ('Amazon EBS', FALSE, 50),
    ('Amazon SQS', FALSE, 50),
    ('Amazon S3', TRUE, 50),
    ('Amazon Instance store', FALSE, 50),
    -- Q51: Programmatic access credentials
    ('Instance Password', FALSE, 51),
    ('Key pairs', FALSE, 51),
    ('Access Keys', TRUE, 51),
    ('MFA', FALSE, 51);
