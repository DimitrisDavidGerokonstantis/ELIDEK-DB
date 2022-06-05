SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS ELIDEK;
CREATE SCHEMA ELIDEK;
USE ELIDEK;

--
-- Table structure for table `project`
--

CREATE TABLE project (
  project_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  org_name VARCHAR(100) DEFAULT NULL,
  title VARCHAR(120) NOT NULL,
  summary TEXT DEFAULT NULL,
  grant_amount INT UNSIGNED DEFAULT NULL,
  starting_date DATE DEFAULT NULL,
  ending_date DATE DEFAULT NULL,
  evaluation_id INT UNSIGNED NOT NULL,
  executive_id INT UNSIGNED NOT NULL,
  program_id INT UNSIGNED NOT NULL,
  PRIMARY KEY  (project_id),
  FOREIGN KEY (org_name) REFERENCES organisation(org_name) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (evaluation_id) REFERENCES evaluation(evaluation_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (executive_id) REFERENCES executive(executive_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (program_id) REFERENCES program(program_id) ON DELETE RESTRICT ON UPDATE CASCADE
 );

CREATE INDEX idx_Pr_projID ON project(project_id);
CREATE INDEX idx_Pr_evalID ON project(evaluation_id);
CREATE INDEX idx_Pr_execID ON project(executive_id);
CREATE INDEX idx_Pr_programID ON project(program_id);
CREATE INDEX idx_Pr_orgName ON project(org_name);

--
-- Table structure for table `researcher`
--

CREATE TABLE researcher(
  res_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  gender varchar(10) DEFAULT NULL,
  birth_date DATE DEFAULT NULL,
  org_name VARCHAR(100) DEFAULT NULL,
  check(gender in('Male','Female','Other')),
  PRIMARY KEY  (res_id),
  FOREIGN KEY (org_name) REFERENCES organisation(org_name) ON DELETE RESTRICT ON UPDATE CASCADE
  );
  
CREATE INDEX idx_Res_resID ON researcher(res_id);  
CREATE INDEX idx_Res_name ON researcher(first_name, last_name); 
CREATE INDEX idx_Res_orgName ON researcher(org_name); 
  
--
-- Table structure for table `organisation`
--
  
CREATE TABLE organisation(
  org_name VARCHAR(100) NOT NULL,
  abbreviation VARCHAR(30) NOT NULL,
  street VARCHAR(30) NOT NULL,
  street_number INT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) NOT NULL,
  city VARCHAR(30) NOT NULL,
  PRIMARY KEY  (org_name)
  );
  
  CREATE INDEX idx_Org_orgName ON organisation(org_name); 
  
  
CREATE TABLE corporation(
  corp_name VARCHAR(100) NOT NULL,
  private_equity_funds INT UNSIGNED DEFAULT NULL, 
  PRIMARY KEY (corp_name),
  FOREIGN KEY (corp_name) REFERENCES organisation(org_name) ON DELETE CASCADE ON UPDATE CASCADE
  );
  
  
  CREATE TABLE university(
  univ_name VARCHAR(100) NOT NULL,
  minedu_budget INT UNSIGNED DEFAULT NULL, 
  PRIMARY KEY (univ_name),
  FOREIGN KEY (univ_name) REFERENCES organisation(org_name) ON DELETE CASCADE ON UPDATE CASCADE
  );


CREATE TABLE research_centre(
  rc_name VARCHAR(100) NOT NULL,
  private_budget INT UNSIGNED DEFAULT NULL, 
  minedu_budget INT UNSIGNED DEFAULT NULL, 
  PRIMARY KEY (rc_name),
  FOREIGN KEY (rc_name) REFERENCES organisation(org_name) ON DELETE CASCADE ON UPDATE CASCADE
  );


CREATE TABLE organisation_phone_numbers(
  org_name VARCHAR(100) NOT NULL,
  phone_number VARCHAR(15) NOT NULL,
  PRIMARY KEY (org_name,phone_number),
  FOREIGN KEY (org_name) REFERENCES organisation(org_name) ON DELETE CASCADE ON UPDATE CASCADE
  );  


CREATE TABLE administrates(
  project_id INT UNSIGNED NOT NULL,
  res_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (project_id),
  FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (res_id) REFERENCES researcher(res_id) ON DELETE RESTRICT ON UPDATE CASCADE
  );  
    
  
  
CREATE TABLE works_on(
  workson_id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
  project_id INT UNSIGNED NOT NULL,
  res_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (project_id, res_id),
  FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (res_id) REFERENCES researcher(res_id) ON DELETE RESTRICT ON UPDATE CASCADE
  );
  
CREATE TABLE evaluation(
  evaluation_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  res_id INT UNSIGNED NOT NULL,
  eval_date DATE DEFAULT NULL,
  grade INT UNSIGNED DEFAULT NULL,
  check(grade <= 100 AND grade>= 0),
  PRIMARY KEY (evaluation_id, res_id),
  FOREIGN KEY (res_id) REFERENCES researcher(res_id) ON DELETE RESTRICT ON UPDATE CASCADE
  );
 
CREATE INDEX idx_Eval_EvalID ON evaluation(evaluation_id);
CREATE INDEX idx_Eval_ResID ON evaluation(res_id);
  
  
CREATE TABLE deliverable(
  project_id INT UNSIGNED NOT NULL,
  del_summary TEXT DEFAULT NULL,
  del_title VARCHAR(150) NOT NULL,
  deliver_date DATE DEFAULT NULL,
  PRIMARY KEY (project_id, del_title),
  FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE RESTRICT ON UPDATE CASCADE
  );
CREATE INDEX idx_Del_ProjID ON deliverable(project_id);
  
  
  
CREATE TABLE executive(
  executive_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  PRIMARY KEY  (executive_id)
  );
CREATE INDEX idx_Exec_execID ON executive(executive_id);
  
  
CREATE TABLE program(
  program_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  prog_name VARCHAR(100) DEFAULT NULL,
  directorate VARCHAR(50) NOT NULL,
  PRIMARY KEY  (program_id)
  );
CREATE INDEX idx_Prog_progID ON program(program_id);

  

CREATE TABLE scientific_field(
  field_name VARCHAR(150) NOT NULL,
  PRIMARY KEY  (field_name)
  );
  
CREATE TABLE concerns(
  project_id INT UNSIGNED NOT NULL,
  field_name VARCHAR(150) NOT NULL,
  PRIMARY KEY  (field_name,project_id),
  FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (field_name) REFERENCES scientific_field(field_name) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 
-- views
-- 
CREATE VIEW Projects_Per_Researcher AS
    ((select res.first_name, res.last_name,'Administrator' as Researcher_Role, proj.title as proj_title  
    from
    researcher as res inner join administrates as adm on res.res_id=adm.res_id
    inner join project as proj on adm.project_id = proj.project_id)
    
    union
    
	(select res.first_name, res.last_name,'Worker' as Researcher_Role, proj.title as proj_title  
    from
    researcher as res inner join works_on as wo on res.res_id=wo.res_id
    inner join project as proj on wo.project_id = proj.project_id)
    
    union
    
	(select res.first_name, res.last_name,'Evaluator' as Researcher_Role, proj.title as proj_title 
    from
    researcher as res inner join evaluation as eval on res.res_id=eval.res_id
    inner join project as proj on eval.evaluation_id = proj.evaluation_id)
    )
    order by last_name, first_name;
    
--
-- a view on which scientific fields each organisation has/had projects on 
--
CREATE VIEW Organisations_Scientific_Fields AS
    (select org.org_name, sf.field_name  
    from
    organisation as org inner join project as proj on proj.org_name=org.org_name
    inner join concerns as con on con.project_id = proj.project_id
    inner join scientific_field as sf on sf.field_name = con.field_name)
    order by org.org_name;



DELIMITER //
create trigger Worker_Not_An_Evaluator
before insert on evaluation
for each row
begin
	IF (new.evaluation_id, new.res_id) in
				(select evaluation_id, res_id 
                from works_on as wor inner join project as proj on wor.project_id=proj.project_id
                ) 
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='A worker of a project cannot evaluate that';
	END IF;
 end //  
DELIMITER ; 


DELIMITER //
create trigger Evaluator_Not_A_Worker
before insert on works_on
for each row
begin
	IF (new.project_id, new.res_id) in
				(select project_id, res_id 
                from 
					project as proj inner join evaluation as eval on eval.evaluation_id=proj.evaluation_id
				)
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='The evaluator of a project cannot work on that';
	END IF; 
 end //  
DELIMITER ; 


DELIMITER //
create trigger Working_In_Valid_Project
before insert on works_on
for each row
begin
	IF (new.project_id, new.res_id) not in
				(select project_id, res_id 
                from 
					project as proj inner join researcher as res on res.org_name=proj.org_name
				)
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='It is not valid to work in a project of another organization';
	END IF; 
 end //  
DELIMITER ; 


DELIMITER //
create trigger Working_In_Valid_Project_Update
before update on works_on
for each row
begin
	IF (new.project_id, new.res_id) not in
				(select project_id, res_id 
                from 
					project as proj inner join researcher as res on res.org_name=proj.org_name
				)
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='It is not valid to work in a project of another organization';
	END IF; 
 end //  
DELIMITER ; 
    
    
DELIMITER //
create trigger Administrator_Not_An_Evaluator
before insert on evaluation
for each row
begin
	IF (new.evaluation_id, new.res_id) in
				(select evaluation_id, res_id 
                from administrates as adm inner join project as proj on adm.project_id=proj.project_id
                ) 
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='The administrator of a project cannot evaluate that';
	END IF;
 end //  
DELIMITER ;  


DELIMITER //
create trigger Evaluator_Not_An_Administrator
before insert on administrates
for each row
begin
	IF (new.project_id, new.res_id) in
				(select project_id, res_id 
                from 
					project as proj inner join evaluation as eval on eval.evaluation_id=proj.evaluation_id
				)
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='The evaluator of a project cannot administrate it';
	END IF; 
 end //  
DELIMITER     
	

DELIMITER //
create trigger Administrating_A_Valid_Project
before insert on administrates
for each row
begin
	IF (new.project_id, new.res_id) not in
				(select project_id, res_id 
                from 
					project as proj inner join researcher as res on res.org_name=proj.org_name
				)
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='It is not valid to administrate a project of another organization';
	END IF; 
 end //  
DELIMITER ;


DELIMITER //
create trigger Administrating_A_Valid_Project_Update
before update on administrates
for each row
begin
	IF (new.project_id, new.res_id) not in
				(select project_id, res_id 
                from 
					project as proj inner join researcher as res on res.org_name=proj.org_name
				)
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='It is not valid to administrate a project of another organization';
	END IF; 
 end //  
DELIMITER ;



DELIMITER //
create trigger Worker_Not_An_Administrator
before insert on administrates
for each row
begin
	IF (new.project_id, new.res_id) in (select project_id, res_id from works_on)
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='The Administrator of a project cannot be a worker on it';
	END IF; 
 end //  
DELIMITER ;


DELIMITER //
create trigger Administrator_Not_A_Worker
before insert on works_on
for each row
begin
	IF (new.project_id, new.res_id) in (select project_id, res_id from administrates)
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='A worker of a project cannot be administrator of it';
	END IF; 
 end //  
DELIMITER ;    
 

DELIMITER //
create trigger Evaluator_Not_Member_Of_The_Organization
after insert on evaluation
for each row
begin
	IF new.res_id in
				(select r.res_id 
					from researcher r where r.org_name =
						(select p.org_name
							from project p
                            where p.evaluation_id = new.evaluation_id
                        )
                )
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='The evaluator cannot be member of the same organization';
	END IF; 
 end //  
DELIMITER ;   


DELIMITER //
create trigger Invalid_Deliver_Date
before insert on deliverable
for each row
begin
	IF new.deliver_date > (
		select ending_date
        from project
        where project_id = new.project_id
    )
	THEN SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=30001, MESSAGE_TEXT='The Project has been inactive before that date';
	END IF; 
 end //  
DELIMITER ;  

 
 
 
 
 
 
 
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

