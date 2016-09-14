USE moviedb;

CREATE TABLE IF NOT EXISTS employees (
 email varchar(50) NOT NULL PRIMARY KEY,
 password varchar(20) NOT NULL,
 fullname varchar(100) DEFAULT ""
);

INSERT INTO employees VALUES('root@admin.com', 'cs122b', 'admin');