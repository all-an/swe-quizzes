INSERT INTO category (name, slug) VALUES
    ('AWS',     'aws'),
    ('Java',    'java'),
    ('Angular', 'angular');

INSERT INTO quiz (title, description, category_id, time_seconds) VALUES
    ('AWS Fundamentals',  'Test your AWS cloud knowledge.',          1, 300),
    ('Java Core',         'Core Java concepts and best practices.',  2, 300),
    ('Angular Basics',    'Angular framework fundamentals.',         3, 300);

-- AWS questions
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('What does S3 stand for?',                      30, 1),
    ('Which service is used for serverless compute?', 30, 1);

INSERT INTO answer (description, correct, question_id) VALUES
    ('Simple Storage Service', TRUE,  1),
    ('Super Secure Storage',   FALSE, 1),
    ('Scalable S3 Storage',    FALSE, 1),
    ('Lambda',                 TRUE,  2),
    ('EC2',                    FALSE, 2),
    ('Lightsail',              FALSE, 2);

-- Java questions
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('What is the default scope of a Spring Bean?', 30, 2),
    ('Which keyword prevents method overriding?',   30, 2);

INSERT INTO answer (description, correct, question_id) VALUES
    ('Singleton', TRUE,  3),
    ('Prototype', FALSE, 3),
    ('Request',   FALSE, 3),
    ('final',     TRUE,  4),
    ('static',    FALSE, 4),
    ('abstract',  FALSE, 4);

-- Angular questions
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('What decorator marks a root Angular component?', 30, 3),
    ('Which file bootstraps an Angular application?',  30, 3);

INSERT INTO answer (description, correct, question_id) VALUES
    ('@Component',   TRUE,  5),
    ('@NgModule',    FALSE, 5),
    ('@Directive',   FALSE, 5),
    ('main.ts',      TRUE,  6),
    ('app.module.ts',FALSE, 6),
    ('index.html',   FALSE, 6);
