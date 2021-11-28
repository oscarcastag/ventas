create table EMP (
 FIRST_NAME                               CHAR(8),
 LAST_NAME                                CHAR(10),
 EMP_ID                                   CHAR(6),
 HIRE_DATE                                DATE,
 SALARY                                   NUMBER(9,2),
 DEPT                                     CHAR(4),
 EXEMPT                                   NUMBER(3),
 INTERESTS                                LONG
);
insert into emp values
('Tyler',  'Bennett',  'E10297',to_date('1977/06/01','YYYY/MM/DD'), 32000.00,'D101',1, NULL);
insert into emp values
('John',   'Rappl',    'E21437',to_date('1987/07/15','YYYY/MM/DD'), 47000.00,'D050',1, NULL);
insert into emp values
('George', 'Woltman',  'E00127',to_date('1982/08/07','YYYY/MM/DD'), 53500.00,'D101',1, NULL);
insert into emp values
('Adam',   'Smith',    'E63535',to_date('1988/01/15','YYYY/MM/DD'), 18000.00,'D202',0, NULL);
insert into emp values
('David',  'McClellan','E04242',to_date('1982/07/27','YYYY/MM/DD'), 41500.00,'D101',1, NULL);
insert into emp values
('Rich',   'Holcomb',  'E01234',to_date('1983/06/01','YYYY/MM/DD'), 49500.00,'D202',1, NULL);
insert into emp values
('Nathan', 'Adams',    'E41298',to_date('1988/02/15','YYYY/MM/DD'), 21900.00,'D050',0, NULL);
insert into emp values
('Richard','Potter',   'E43128',to_date('1986/04/12','YYYY/MM/DD'), 15900.00,'D101',0, NULL);
insert into emp values
('David',  'Motsinger','E27002',to_date('1985/05/05','YYYY/MM/DD'), 19250.00,'D202',0, NULL);
insert into emp values
('Tim',    'Sampair',  'E03033',to_date('1987/12/02','YYYY/MM/DD'), 27000.00,'D101',1, NULL);
insert into emp values
('Kim',    'Arlich',   'E10001',to_date('1985/07/30','YYYY/MM/DD'), 57000.00,'D190',1, NULL);
insert into emp values
('Timothy','Grove',    'E16398',to_date('1985/01/21','YYYY/MM/DD'), 29900.00,'D190',1, NULL);
