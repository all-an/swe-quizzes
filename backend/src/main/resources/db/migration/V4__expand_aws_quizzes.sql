-- Align existing AWS Fundamentals quiz and its questions to exam pace
UPDATE quiz     SET time_seconds = 2490 WHERE id = 1;
UPDATE question SET time_seconds = 83   WHERE quiz_id = 1;

-- Three new quiz sets from practice exams 3 & 4
INSERT INTO quiz (title, description, category_id, time_seconds) VALUES
    ('AWS Cloud Practitioner - Set 4', 'ELB, storage, IAM, support plans, and migration services.', 1, 1245),
    ('AWS Cloud Practitioner - Set 5', 'Pricing, regions, serverless, CAF, and cost management.', 1, 1245),
    ('AWS Cloud Practitioner - Set 6', 'Networking, databases, compliance, and cloud economics.', 1, 1245);

-- ============================================================
-- AWS FUNDAMENTALS — expand from 2 to 30 questions
-- 28 new questions (IDs 52–79), sourced from practice exams 3 & 4
-- ============================================================
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('Which AWS service can be used to store and reliably deliver messages across distributed systems?', 83, 1),
    ('Which of the following describes the payment model for customers that commit to using Amazon EC2 over a one or 3-year term?', 83, 1),
    ('A company is migrating its on-premises database to Amazon RDS. What should they do to ensure RDS costs are kept to a minimum?', 83, 1),
    ('What is the primary storage service used by Amazon RDS database instances?', 83, 1),
    ('A company is developing a new application using a microservices framework that has performance and latency issues. Which AWS Service should be used to troubleshoot these issues?', 83, 1),
    ('An application is hosted in Northern California. About 30% of traffic comes from Asia. What can be done to reduce latency for Asian users?', 83, 1),
    ('An organization runs many systems and uses many AWS products. Which service enables them to control how each developer interacts with these products?', 83, 1),
    ('Using Amazon EC2 falls under which of the following cloud computing models?', 83, 1),
    ('Which of the following is a best-practice when building applications on AWS?', 83, 1),
    ('What does Amazon Elastic Beanstalk provide?', 83, 1),
    ('What is the AWS service that performs automated network assessments of Amazon EC2 instances to check for vulnerabilities?', 83, 1),
    ('A company needs to host a database in Amazon RDS for at least three years. Which option would be the most cost-effective?', 83, 1),
    ('An application has experienced significant global growth and international users are complaining of high latency. Which AWS characteristic can help?', 83, 1),
    ('A company with business-critical workloads is unwilling to accept any downtime. Which best practice protects workloads in the event of a natural disaster?', 83, 1),
    ('What is the AWS tool that enables you to use scripts to manage all AWS services and resources?', 83, 1),
    ('A company has deployed a new web application on multiple EC2 instances. Which service should they use to distribute incoming HTTP traffic evenly?', 83, 1),
    ('Which AWS offering is a MySQL-compatible relational database service that can scale capacity automatically based on demand?', 83, 1),
    ('What is the AWS data warehouse service that supports a high level of query performance on large amounts of datasets?', 83, 1),
    ('Which of the following should be considered when performing a TCO analysis to compare running an application on AWS vs on-premises?', 83, 1),
    ('How are AWS customers billed for Linux-based Amazon EC2 usage?', 83, 1),
    ('A customer wants to provision another EC2 instance with a configuration identical to an existing one. How can this be achieved?', 83, 1),
    ('A company uses AWS Organizations to manage all of its AWS accounts. Which feature allows restricting what services and actions are allowed in each account?', 83, 1),
    ('Which of the following statements describes the AWS Cloud''s agility?', 83, 1),
    ('What is the connectivity option that uses IPSec to establish encrypted connectivity between an on-premises network and the AWS Cloud?', 83, 1),
    ('What is the minimum level of AWS support that provides 24x7 access to technical support engineers via phone and chat?', 83, 1),
    ('A media transcoding application in AWS is designed to recover quickly from hardware failures. Which instance type is the most cost-effective?', 83, 1),
    ('Which AWS Service provides the current status of all AWS Services in all AWS Regions?', 83, 1),
    ('Which AWS service or feature can be used to call AWS Services from different programming languages?', 83, 1);

INSERT INTO answer (description, correct, question_id) VALUES
    -- Q52: SQS for message delivery
    ('Amazon Simple Queue Service', TRUE,  52),
    ('AWS Storage Gateway',         FALSE, 52),
    ('Amazon Simple Email Service', FALSE, 52),
    ('Amazon Simple Storage Service', FALSE, 52),
    -- Q53: EC2 reserved payment model
    ('Pay less as AWS grows',   FALSE, 53),
    ('Pay as you go',           FALSE, 53),
    ('Pay less by using more',  FALSE, 53),
    ('Save when you reserve',   TRUE,  53),
    -- Q54: RDS cost minimization
    ('Right-size before and after migration',               TRUE,  54),
    ('Use a Multi-Region Active-Passive architecture',      FALSE, 54),
    ('Combine On-demand Capacity Reservations with Saving Plans', FALSE, 54),
    ('Use a Multi-Region Active-Active architecture',       FALSE, 54),
    -- Q55: RDS primary storage
    ('Amazon Glacier', FALSE, 55),
    ('Amazon EBS',     TRUE,  55),
    ('Amazon EFS',     FALSE, 55),
    ('Amazon S3',      FALSE, 55),
    -- Q56: X-Ray for microservices
    ('AWS CodePipeline',  FALSE, 56),
    ('AWS X-Ray',         TRUE,  56),
    ('Amazon Inspector',  FALSE, 56),
    ('AWS CloudTrail',    FALSE, 56),
    -- Q57: CloudFront for Asian latency
    ('Replicate resources across multiple Availability Zones within the same region', FALSE, 57),
    ('Migrate the application to a hosting provider in Asia',                         FALSE, 57),
    ('Recreate the website content',                                                  FALSE, 57),
    ('Create a CDN using CloudFront so that content is cached at Edge Locations close to Asia', TRUE, 57),
    -- Q58: IAM for access control
    ('AWS Identity and Access Management', TRUE,  58),
    ('Amazon RDS',                         FALSE, 58),
    ('Network Access Control Lists',       FALSE, 58),
    ('Amazon EMR',                         FALSE, 58),
    -- Q59: EC2 cloud model
    ('IaaS & SaaS', FALSE, 59),
    ('IaaS',        TRUE,  59),
    ('SaaS',        FALSE, 59),
    ('PaaS',        FALSE, 59),
    -- Q60: Decouple applications
    ('Strengthen physical security by applying the principle of least privilege', FALSE, 60),
    ('Ensure that the application runs on hardware from trusted vendors',         FALSE, 60),
    ('Use IAM policies to maintain performance',                                  FALSE, 60),
    ('Decouple the components of the application so that they run independently', TRUE,  60),
    -- Q61: Elastic Beanstalk
    ('A PaaS solution to automate application deployment', TRUE,  61),
    ('A compute engine for Amazon ECS',                    FALSE, 61),
    ('A scalable file storage solution for AWS and on-premises servers', FALSE, 61),
    ('A NoSQL database service',                           FALSE, 61),
    -- Q62: Amazon Inspector
    ('Amazon Kinesis',                       FALSE, 62),
    ('Security groups',                      FALSE, 62),
    ('Amazon Inspector',                     TRUE,  62),
    ('AWS Network Access Control Lists',     FALSE, 62),
    -- Q63: RDS reserved 3 years
    ('Reserved instances - No Upfront',      FALSE, 63),
    ('Reserved instances - Partial Upfront', TRUE,  63),
    ('On-Demand instances',                  FALSE, 63),
    ('Spot Instances',                       FALSE, 63),
    -- Q64: Global reach for latency
    ('Elasticity',       FALSE, 64),
    ('Global reach',     TRUE,  64),
    ('Data durability',  FALSE, 64),
    ('High availability',FALSE, 64),
    -- Q65: Active-Active disaster recovery
    ('Replicate data across multiple Edge Locations and use CloudFront for automatic failover',         FALSE, 65),
    ('Deploy AWS resources across multiple Availability Zones within the same AWS Region',              FALSE, 65),
    ('Create point-in-time backups in another subnet and recover this data when a disaster occurs',     FALSE, 65),
    ('Deploy AWS resources to another AWS Region and implement an Active-Active disaster recovery strategy', TRUE, 65),
    -- Q66: AWS CLI
    ('AWS Console',         FALSE, 66),
    ('AWS Service Catalog', FALSE, 66),
    ('AWS OpsWorks',        FALSE, 66),
    ('AWS CLI',             TRUE,  66),
    -- Q67: Application Load Balancer
    ('AWS EC2 Auto Recovery',          FALSE, 67),
    ('AWS Auto Scaling',               FALSE, 67),
    ('AWS Network Load Balancer',      FALSE, 67),
    ('AWS Application Load Balancer',  TRUE,  67),
    -- Q68: Amazon Aurora MySQL-compatible
    ('Amazon Neptune',            FALSE, 68),
    ('Amazon Aurora',             TRUE,  68),
    ('Amazon RDS for SQL Server', FALSE, 68),
    ('Amazon RDS for PostgreSQL', FALSE, 68),
    -- Q69: Amazon Redshift data warehouse
    ('Amazon Redshift',  TRUE,  69),
    ('Amazon Kinesis',   FALSE, 69),
    ('Amazon DynamoDB',  FALSE, 69),
    ('Amazon RDS',       FALSE, 69),
    -- Q70: TCO analysis
    ('Application development', FALSE, 70),
    ('Market research',         FALSE, 70),
    ('Business analysis',       FALSE, 70),
    ('Physical hardware',       TRUE,  70),
    -- Q71: EC2 Linux billing
    ('EC2 instances will be billed on one second increments, with a minimum of one minute', TRUE,  71),
    ('EC2 instances will be billed on one hour increments, with a minimum of one day',     FALSE, 71),
    ('EC2 instances will be billed on one minute increments, with a minimum of one hour',  FALSE, 71),
    ('EC2 instances will be billed on one day increments, with a minimum of one month',    FALSE, 71),
    -- Q72: AMI for identical instance
    ('By creating an AWS Config template from the old instance and launching a new instance from it', FALSE, 72),
    ('By creating an EBS Snapshot of the old instance',                                               FALSE, 72),
    ('By installing Aurora on EC2 and launching a new instance from it',                              FALSE, 72),
    ('By creating an AMI from the old instance and launching a new instance from it',                 TRUE,  72),
    -- Q73: Service Control Policies
    ('IAM Principals',                        FALSE, 73),
    ('AWS Service Control Policies (SCPs)',   TRUE,  73),
    ('IAM policies',                          FALSE, 73),
    ('AWS Fargate',                           FALSE, 73),
    -- Q74: AWS Cloud agility
    ('AWS allows you to host your applications in multiple regions around the world', FALSE, 74),
    ('AWS provides customizable hardware at the lowest possible cost',                FALSE, 74),
    ('AWS allows you to provision resources in minutes',                              TRUE,  74),
    ('AWS allows you to pay upfront to reduce costs',                                FALSE, 74),
    -- Q75: Site-to-Site VPN
    ('Internet Gateway',      FALSE, 75),
    ('AWS IQ',                FALSE, 75),
    ('AWS Direct Connect',    FALSE, 75),
    ('AWS Site-to-Site VPN',  TRUE,  75),
    -- Q76: Business Support 24x7
    ('Enterprise Support', FALSE, 76),
    ('Developer Support',  FALSE, 76),
    ('Basic Support',      FALSE, 76),
    ('Business Support',   TRUE,  76),
    -- Q77: Spot for fault-tolerant media transcoding
    ('Reserved instances',  FALSE, 77),
    ('Spot Instances',      TRUE,  77),
    ('On-Demand instances', FALSE, 77),
    ('Dedicated instances', FALSE, 77),
    -- Q78: Service Health Dashboard
    ('AWS Service Health Dashboard',  TRUE,  78),
    ('AWS Management Console',        FALSE, 78),
    ('Amazon CloudWatch',             FALSE, 78),
    ('AWS Personal Health Dashboard', FALSE, 78),
    -- Q79: AWS SDK
    ('AWS Software Development Kit', TRUE,  79),
    ('AWS Command Line Interface',   FALSE, 79),
    ('AWS CodeDeploy',               FALSE, 79),
    ('AWS Management Console',       FALSE, 79);

-- ============================================================
-- SET 4  (quiz_id = 7, questions 80–94) — exam 4
-- ============================================================
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('How do Elastic Load Balancers (ELBs) improve the reliability of your application?', 83, 7),
    ('A company needs to migrate their website to AWS on hardware that is NOT shared with other AWS customers. Which EC2 option meets this requirement?', 83, 7),
    ('A customer needs to move approximately 60 Petabytes of images and videos to Amazon S3. Which AWS Service is the best choice for the transfer?', 83, 7),
    ('A company plans to migrate a large amount of archived data to AWS. The data must be maintained for 5 years and retrievable within 5 hours. What is the most cost-effective storage service?', 83, 7),
    ('Which AWS Service is used to manage user permissions?', 83, 7),
    ('Which support plan includes the AWS Support Concierge Service?', 83, 7),
    ('A company needs to track resource changes using the API call history. Which AWS service can help?', 83, 7),
    ('What is the AWS recommendation regarding access keys?', 83, 7),
    ('What is the AWS IAM feature that provides an additional layer of security on top of username and password authentication?', 83, 7),
    ('What is the benefit of using an API to access AWS Services?', 83, 7),
    ('A company is planning to migrate a database with high read/write activity to AWS. What is the best storage option?', 83, 7),
    ('How can AWS customers track and avoid over-spending on underutilized reserved instances?', 83, 7),
    ('What is the AWS service that provides five times the performance of a standard MySQL database?', 83, 7),
    ('What does AWS Service Catalog provide?', 83, 7),
    ('Which of the following AWS Services helps with planning application migration to the AWS Cloud?', 83, 7);

INSERT INTO answer (description, correct, question_id) VALUES
    -- Q80: ELB reliability
    ('By distributing traffic across multiple S3 buckets',     FALSE, 80),
    ('By replicating data to multiple availability zones',     FALSE, 80),
    ('By creating database Read Replicas',                     FALSE, 80),
    ('By ensuring that only healthy targets receive traffic',  TRUE,  80),
    -- Q81: Dedicated instances
    ('On-demand instances',   FALSE, 81),
    ('Spot instances',        FALSE, 81),
    ('Dedicated instances',   TRUE,  81),
    ('Reserved instances',    FALSE, 81),
    -- Q82: Snowmobile 60 PB
    ('Snowball',               FALSE, 82),
    ('S3 Transfer Acceleration', FALSE, 82),
    ('Snowmobile',             TRUE,  82),
    ('Amazon VPC',             FALSE, 82),
    -- Q83: S3 Glacier for archives
    ('Amazon S3 Glacier',  TRUE,  83),
    ('Amazon EFS',         FALSE, 83),
    ('Amazon S3 Standard', FALSE, 83),
    ('Amazon EBS',         FALSE, 83),
    -- Q84: IAM for user permissions
    ('Security Groups', FALSE, 84),
    ('Amazon ECS',      FALSE, 84),
    ('AWS IAM',         TRUE,  84),
    ('AWS Support',     FALSE, 84),
    -- Q85: Enterprise Support Concierge
    ('Premium Support',    FALSE, 85),
    ('Business Support',   FALSE, 85),
    ('Enterprise Support', TRUE,  85),
    ('Standard Support',   FALSE, 85),
    -- Q86: CloudTrail for API history
    ('AWS Config',          FALSE, 86),
    ('Amazon CloudWatch',   FALSE, 86),
    ('AWS CloudTrail',      TRUE,  86),
    ('AWS CloudFormation',  FALSE, 86),
    -- Q87: Access keys best practice
    ('Delete all access keys and use passwords instead', FALSE, 87),
    ('Only share them with trusted people',              FALSE, 87),
    ('Rotate them regularly',                            TRUE,  87),
    ('Save them within your application code',           FALSE, 87),
    -- Q88: MFA for IAM
    ('Key Pair',     FALSE, 88),
    ('Access Keys',  FALSE, 88),
    ('SDK',          FALSE, 88),
    ('MFA',          TRUE,  88),
    -- Q89: API benefit
    ('It improves the performance of AWS resources',           FALSE, 89),
    ('It reduces the time needed to provision AWS resources',  FALSE, 89),
    ('It reduces the number of developers necessary',          FALSE, 89),
    ('It allows for programmatic management of AWS resources', TRUE,  89),
    -- Q90: EBS for high read/write
    ('AWS Storage Gateway', FALSE, 90),
    ('Amazon S3',           FALSE, 90),
    ('Amazon EBS',          TRUE,  90),
    ('Amazon Glacier',      FALSE, 90),
    -- Q91: AWS Budgets for reserved instances
    ('Add all AWS accounts to an AWS Organization, enable Consolidated Billing, and turn off Reserved Instance sharing', FALSE, 91),
    ('Use Amazon Neptune to track usage patterns and sell unused reservations on the EC2 Reserved Instance Marketplace', FALSE, 91),
    ('Use AWS Budgets to track reserved instance usage and set up alert notifications when utilization drops below a threshold', TRUE, 91),
    ('Use Amazon CloudTrail to automatically check for unused reservations and get recommendations to reduce their bill', FALSE, 91),
    -- Q92: Aurora 5x MySQL
    ('Amazon Aurora',    TRUE,  92),
    ('Amazon Redshift',  FALSE, 92),
    ('Amazon DynamoDB',  FALSE, 92),
    ('Amazon Neptune',   FALSE, 92),
    -- Q93: Service Catalog
    ('It enables customers to quickly find descriptions and use cases for AWS services',            FALSE, 93),
    ('It enables customers to explore the different catalogs of AWS services',                      FALSE, 93),
    ('It simplifies organizing and governing commonly deployed IT services',                        TRUE,  93),
    ('It allows developers to deploy infrastructure on AWS using familiar programming languages',   FALSE, 93),
    -- Q94: Application Discovery Service
    ('AWS Snowball Migration Service',       FALSE, 94),
    ('AWS Application Discovery Service',   TRUE,  94),
    ('AWS DMS',                             FALSE, 94),
    ('AWS Migration Hub',                   FALSE, 94);

-- ============================================================
-- SET 5  (quiz_id = 8, questions 95–109) — exam 4
-- ============================================================
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('A company needs the most granular data about their AWS costs and usage. Which AWS offering provides this?', 83, 8),
    ('Which statement best describes the concept of an AWS Region?', 83, 8),
    ('A company discovered that multiple S3 buckets were deleted. Which can they use to determine who deleted the buckets?', 83, 8),
    ('What are AWS shared controls?', 83, 8),
    ('Which of the following is NOT a characteristic of Amazon EC2?', 83, 8),
    ('What is the AWS Compute service that executes code only when triggered by events?', 83, 8),
    ('What is the name of the virtual servers that AWS provides, similar to those offered by traditional IT distributors?', 83, 8),
    ('What is the framework created by AWS Professional Services that helps organizations design a road map to successful cloud adoption?', 83, 8),
    ('What tool can a company use to perform a cost-benefit analysis of moving their entire on-premises data center to AWS?', 83, 8),
    ('Which of the following activities supports the Operational Excellence pillar of the AWS Well-Architected Framework?', 83, 8),
    ('AWS recommends practices to help avoid unexpected charges. Which of the following is NOT one of these practices?', 83, 8),
    ('What is the AWS tool that can help a company visualize their AWS spending in the last few months?', 83, 8),
    ('Which AWS service can be used to send promotional SMS text messages to more than 200 countries worldwide?', 83, 8),
    ('What does AWS provide to reduce the cost of running Amazon EC2 instances?', 83, 8),
    ('Which AWS Group assists customers in achieving their desired business outcomes?', 83, 8);

INSERT INTO answer (description, correct, question_id) VALUES
    -- Q95: Cost & Usage Report
    ('Amazon Machine Image',     FALSE, 95),
    ('AWS Cost Explorer',        FALSE, 95),
    ('AWS Cost & Usage Report',  TRUE,  95),
    ('Amazon CloudWatch',        FALSE, 95),
    -- Q96: AWS Region definition
    ('An AWS Region is a geographical location with a collection of Edge locations',          FALSE, 96),
    ('An AWS Region is a virtual network dedicated only to a single AWS customer',            FALSE, 96),
    ('An AWS Region is a geographical location with a collection of Availability Zones',      TRUE,  96),
    ('An AWS Region represents the country where the AWS infrastructure exists',              FALSE, 96),
    -- Q97: CloudTrail for deleted S3 buckets
    ('SNS logs',         FALSE, 97),
    ('SQS logs',         FALSE, 97),
    ('CloudWatch Logs',  FALSE, 97),
    ('CloudTrail logs',  TRUE,  97),
    -- Q98: AWS shared controls definition
    ('Controls that are solely the responsibility of the customer based on the application they are deploying', FALSE, 98),
    ('Controls that a customer inherits from AWS',                                                              FALSE, 98),
    ('Controls that apply to both the infrastructure layer and customer layers',                                FALSE, 98),
    ('Controls that the customer and AWS collaborate together upon to secure the infrastructure',               TRUE,  98),
    -- Q99: EC2 not serverless
    ('Amazon EC2 is considered a Serverless Web Service',              TRUE,  99),
    ('Amazon EC2 eliminates the need to invest in hardware upfront',   FALSE, 99),
    ('Amazon EC2 can launch as many or as few virtual servers as needed', FALSE, 99),
    ('Amazon EC2 offers scalable computing',                           FALSE, 99),
    -- Q100: Lambda event-triggered
    ('AWS Lambda',          TRUE,  100),
    ('Amazon CloudWatch',   FALSE, 100),
    ('AWS Transit Gateway', FALSE, 100),
    ('Amazon EC2',          FALSE, 100),
    -- Q101: EC2 Instances name
    ('Amazon EBS Snapshots',   FALSE, 101),
    ('Amazon VPC',             FALSE, 101),
    ('AWS Managed Servers',    FALSE, 101),
    ('Amazon EC2 Instances',   TRUE,  101),
    -- Q102: AWS CAF
    ('AWS Secrets Manager', FALSE, 102),
    ('AWS WAF',             FALSE, 102),
    ('AWS CAF',             TRUE,  102),
    ('Amazon EFS',          FALSE, 102),
    -- Q103: TCO Calculator
    ('AWS Cost Explorer',    FALSE, 103),
    ('AWS TCO Calculator',   TRUE,  103),
    ('AWS Budgets',          FALSE, 103),
    ('AWS Pricing Calculator', FALSE, 103),
    -- Q104: CloudFormation for Operational Excellence
    ('Using AWS Trusted Advisor to find underutilized resources',           FALSE, 104),
    ('Using AWS CloudTrail to record user activities',                      FALSE, 104),
    ('Using AWS CloudFormation to manage infrastructure as code',           TRUE,  104),
    ('Deploying an application in multiple Availability Zones',             FALSE, 104),
    -- Q105: Not a recommended practice
    ('Deleting unused EBS volumes after terminating an EC2 instance',       FALSE, 105),
    ('Deleting unused AutoScaling launch configuration',                    TRUE,  105),
    ('Deleting unused Elastic Load Balancers',                              FALSE, 105),
    ('Releasing unused Elastic IPs after terminating an EC2 instance',      FALSE, 105),
    -- Q106: Cost Explorer visualization
    ('AWS Cost Explorer',       TRUE,  106),
    ('AWS Pricing Calculator',  FALSE, 106),
    ('AWS Budgets',             FALSE, 106),
    ('AWS Consolidated Billing',FALSE, 106),
    -- Q107: SNS for SMS
    ('Amazon Simple Email Service (Amazon SES)',       FALSE, 107),
    ('Amazon Simple Storage Service (Amazon S3)',      FALSE, 107),
    ('Amazon Simple Notification Service (Amazon SNS)', TRUE, 107),
    ('Amazon Simple Queue Service (Amazon SQS)',       FALSE, 107),
    -- Q108: Per-second EC2 billing
    ('Low monthly instance maintenance costs', FALSE, 108),
    ('Low-cost instance tagging',              FALSE, 108),
    ('Per-second instance billing',            TRUE,  108),
    ('Low instance start-up fees',             FALSE, 108),
    -- Q109: AWS Professional Services
    ('AWS Security Team',          FALSE, 109),
    ('AWS Professional Services',  TRUE,  109),
    ('AWS Trusted Advisor',        FALSE, 109),
    ('AWS Concierge Support Team', FALSE, 109);

-- ============================================================
-- SET 6  (quiz_id = 9, questions 110–124) — exam 2 (unused)
-- ============================================================
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('What does Amazon ElastiCache provide?', 83, 9),
    ('What is the AWS service that enables you to manage all of your AWS accounts from a single master account?', 83, 9),
    ('Which of the following EC2 instance purchasing options supports the Bring Your Own License (BYOL) model for almost every BYOL scenario?', 83, 9),
    ('Which of the following is one of the benefits of moving infrastructure from an on-premises data center to AWS?', 83, 9),
    ('Which AWS Service can be used to establish a dedicated, private network connection between AWS and your datacenter?', 83, 9),
    ('You are working on two projects that require completely different network configurations. Which AWS service or feature will allow you to isolate resources and network configurations?', 83, 9),
    ('Which of the following services can help protect your web applications from SQL injection and other vulnerabilities in your application code?', 83, 9),
    ('An organization needs to analyze and process a large number of data sets. Which AWS service should they use?', 83, 9),
    ('What is the AWS service that provides you the highest level of control over the underlying virtual infrastructure?', 83, 9),
    ('What are the default security credentials required to access the AWS management console for an IAM user account?', 83, 9),
    ('In your on-premises environment, you can create as many virtual servers as you need from a single template. What can you use to perform the same in AWS?', 83, 9),
    ('Which statement best describes the operational excellence pillar of the AWS Well-Architected Framework?', 83, 9),
    ('Which of the following is NOT a benefit of using AWS Edge Locations?', 83, 9),
    ('Which of the following services allows you to run containerized applications on a cluster of EC2 instances?', 83, 9),
    ('Which of the following services will help businesses ensure compliance in AWS?', 83, 9);

INSERT INTO answer (description, correct, question_id) VALUES
    -- Q110: ElastiCache
    ('In-memory caching for read-heavy applications',                          TRUE,  110),
    ('An Ehcache compatible in-memory data store',                             FALSE, 110),
    ('An online software store that allows customers to launch pre-configured software', FALSE, 110),
    ('A domain name system in the cloud',                                      FALSE, 110),
    -- Q111: AWS Organizations
    ('AWS WAF',              FALSE, 111),
    ('AWS Trusted Advisor',  FALSE, 111),
    ('AWS Organizations',    TRUE,  111),
    ('Amazon Config',        FALSE, 111),
    -- Q112: Dedicated Hosts BYOL
    ('Dedicated Instances', FALSE, 112),
    ('Dedicated Hosts',     TRUE,  112),
    ('On-demand Instances', FALSE, 112),
    ('Reserved Instances',  FALSE, 112),
    -- Q113: Reduced CapEx
    ('Free support for all enterprise customers',                   FALSE, 113),
    ('Automatic data protection',                                   FALSE, 113),
    ('Reduced Capital Expenditure (CapEx)',                         TRUE,  113),
    ('AWS holds responsibility for managing customer applications', FALSE, 113),
    -- Q114: AWS Direct Connect
    ('AWS Direct Connect',   TRUE,  114),
    ('Amazon CloudFront',    FALSE, 114),
    ('AWS Snowball',         FALSE, 114),
    ('Amazon Route 53',      FALSE, 114),
    -- Q115: VPC for network isolation
    ('Internet gateways',   FALSE, 115),
    ('Virtual Private Cloud', TRUE, 115),
    ('Security Groups',     FALSE, 115),
    ('Amazon CloudFront',   FALSE, 115),
    -- Q116: AWS WAF for SQL injection
    ('Amazon Cognito', FALSE, 116),
    ('AWS IAM',        FALSE, 116),
    ('Amazon Aurora',  FALSE, 116),
    ('AWS WAF',        TRUE,  116),
    -- Q117: Amazon EMR for big data
    ('Amazon EMR',  TRUE,  117),
    ('Amazon MQ',   FALSE, 117),
    ('Amazon SNS',  FALSE, 117),
    ('Amazon SQS',  FALSE, 117),
    -- Q118: EC2 highest control
    ('Amazon Redshift',  FALSE, 118),
    ('Amazon DynamoDB',  FALSE, 118),
    ('Amazon EC2',       TRUE,  118),
    ('Amazon RDS',       FALSE, 118),
    -- Q119: IAM console credentials
    ('MFA',                    FALSE, 119),
    ('Security tokens',        FALSE, 119),
    ('A user name and password', TRUE, 119),
    ('Access keys',            FALSE, 119),
    -- Q120: AMI for virtual server template
    ('IAM',               FALSE, 120),
    ('An internet gateway', FALSE, 120),
    ('EBS Snapshot',      FALSE, 120),
    ('AMI',               TRUE,  120),
    -- Q121: Operational Excellence pillar
    ('The ability of a system to recover gracefully from failure',          FALSE, 121),
    ('The efficient use of computing resources to meet requirements',       FALSE, 121),
    ('The ability to monitor systems and improve supporting processes and procedures', TRUE, 121),
    ('The ability to manage datacenter operations more efficiently',        FALSE, 121),
    -- Q122: Edge Location NOT a benefit
    ('Edge locations are used by CloudFront to cache the most recent responses',                          FALSE, 122),
    ('Edge locations are used by CloudFront to improve your end users'' experience when uploading files', FALSE, 122),
    ('Edge locations are used by CloudFront to distribute traffic across multiple instances to reduce latency', TRUE, 122),
    ('Edge locations are used by CloudFront to distribute content to global users with low latency',      FALSE, 122),
    -- Q123: ECS for containers
    ('Amazon ECS',          TRUE,  123),
    ('AWS Data Pipeline',   FALSE, 123),
    ('AWS Cloud9',          FALSE, 123),
    ('AWS Personal Health Dashboard', FALSE, 123),
    -- Q124: CloudTrail for compliance
    ('CloudFront',            FALSE, 124),
    ('CloudEndure Migration', FALSE, 124),
    ('CloudWatch',            FALSE, 124),
    ('CloudTrail',            TRUE,  124);
