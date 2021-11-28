create table EMP (                                      \
 FIRST_NAME                               CHAR(8),      \
 LAST_NAME                                CHAR(10),     \
 EMP_ID                                   CHAR(6),      \
 HIRE_DATE                                DATE,         \
 SALARY                                   DECIMAL(9,2), \
 DEPT                                     CHAR(4),      \
 EXEMPT                                   SMALLINT,     \
 INTERESTS                                CLOB(500)     \
)
insert into emp values \
('Tyler',  'Bennett',  'E10297','01/06/1977', 32000.00,'D101',1, NULL)
insert into emp values \
('John',   'Rappl',    'E21437','07/15/1987', 47000.00,'D050',1, NULL)
insert into emp values \
('George', 'Woltman',  'E00127','08/07/1982', 53500.00,'D101',1, NULL)
insert into emp values \
('Adam',   'Smith',    'E63535','01/15/1988', 18000.00,'D202',0, NULL)
insert into emp values \
('David',  'McClellan','E04242','07/27/1990', 41500.00,'D101',1, NULL)
insert into emp values \
('Rich',   'Holcomb',  'E01234','06/01/1992', 49500.00,'D202',1, NULL)
insert into emp values \
('Nathan', 'Adams',    'E41298','02/15/1988', 21900.00,'D050',0, NULL)
insert into emp values \
('Richard','Potter',   'E43128','04/12/1997', 15900.00,'D101',0, NULL)
insert into emp values \
('David',  'Motsinger','E27002','05/05/1989', 19250.00,'D202',0, NULL)
insert into emp values \
('Tim',    'Sampair',  'E03033','12/02/1901', 27000.00,'D101',1, NULL)
insert into emp values \
('Kim',    'Arlich',   'E10001','07/30/2000', 57000.00,'D190',1, NULL)
insert into emp values \
('Timothy','Grove',    'E16398','01/21/2001', 29900.00,'D190',1, NULL)
