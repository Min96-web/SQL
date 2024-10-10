/****************************************/
/* DB2-VT22-L4-departments     			*/
/* Senast ändrad: 2022-01-26 			*/
/****************************************/


USE lab4;
Drop table departments;
create table departments (
	id 			int primary key auto_increment,
	department 	varchar(50),
	manager 	int
);

insert into departments (department, manager) values 
('Accounting', 333),
('Business Development', 56),
('Support', 111),
('Training', 295),
('Design', 328),
('Human Resources', 33),
('Services', 204),
('Sales', 307),
('Research', 293),
('Legal', 385),
('Product Management', 415),
('Engineering', 377);

#[CONSTRAINT [symbol]] FOREIGN KEY
 #   [index_name] (col_name, ...)
  #  REFERENCES tbl_name (col_name,...)
   # [ON DELETE reference_option]
    #[ON UPDATE reference_option]

#reference_option:
 #   RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT
 

 select * from departments;
 ALTER TABLE departments ADD CONSTRAINT FK_departments_manager
 FOREIGN KEY departments(manager)
 REFERENCES employees(id)
 ON UPDATE CASCADE
 ON DELETE CASCADE