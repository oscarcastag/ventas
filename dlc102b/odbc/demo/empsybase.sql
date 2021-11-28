drop table EMP
go
create table EMP (
 FIRST_NAME                               char(8),
 LAST_NAME                                char(10),
 EMP_ID                                   char(6),
 HIRE_DATE                                datetime,
 SALARY                                   float,
 DEPT                                     char(4),
 EXEMPT                                   int,
 INTERESTS                                text
)
go
insert into EMP values
('Tyler',  'Bennett',  'E10297','1977/06/01', 32000.00,'D101',1,'')
go
insert into EMP values
('John',   'Rappl',    'E21437','1987/07/15', 47000.00,'D050',1,'')
go
insert into EMP values
('George', 'Woltman',  'E00127','1982/08/07', 53500.00,'D101',1,'')
go
insert into EMP values
('Adam',   'Smith',    'E63535','1988/01/15', 18000.00,'D202',0,'')
go
insert into EMP values
('David',  'McClellan','E04242','1982/07/27', 41500.00,'D101',1,'')
go
insert into EMP values
('Rich',   'Holcomb',  'E01234','1983/06/01', 49500.00,'D202',1,'')
go
insert into EMP values
('Nathan', 'Adams',    'E41298','1988/02/15', 21900.00,'D050',0,'')
go
insert into EMP values
('Richard','Potter',   'E43128','1986/04/12', 15900.00,'D101',0,'')
go
insert into EMP values
('David',  'Motsinger','E27002','1985/05/05', 19250.00,'D202',0,'')
go
insert into EMP values
('Tim',    'Sampair',  'E03033','1987/12/02', 27000.00,'D101',1,'')
go
insert into EMP values
('Kim',    'Arlich',   'E10001','1985/07/30', 57000.00,'D190',1,'')
go
insert into EMP values
('Timothy','Grove',    'E16398','1985/01/21', 29900.00,'D190',1,'')
go
exit
