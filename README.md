# Pewlett Hackard Analysis
## Purpose of Analysis

  The Pewlett Hackard Company is a large company with many employees who are of retirement age. Because of this, an analysis was conducted to determine the number of total employess per title who are retiring and the number of employees eligible for the mentorship program in the Pewlett Hackard Company employee database. The following report describes the steps taken to perform the analysis, as well as summarizing the results and recommendations.
## Summary of Analysis and Results

  The database consisted of many files, so the first step was to identify the relationships within the data files in order to determine the database keys. This was done by creating an Entity Relationship Diagram, or ERD (shown below). 
![ERD](https://github.com/oshadiw/Pewlett-Hackard-Analysis/blob/master/Challenge%20Data/EmployeeDB.png)

  As seen in the ERD, the primary keys linking the data sets are the employee number and department number. Using this information, the appropriate tables were created in PostgreSQL- 
```
   CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
```

Once the tables were created, the appropriate data was taken from each table to determine the current employees per title who are eligible for retirement. 
```
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	titles.title,
	de.from_date,
	s.salary
INTO retirement_challenge
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN titles
ON (titles.emp_no= e.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (de.to_date = '9999-01-01');
```

This data was then partitioned to exclude employees who worked under multiple titles in order to avoid duplicate counts. 
```
SELECT emp_no, first_name, last_name, from_date, salary, title
INTO retiring_employees
  FROM
(SELECT emp_no, first_name, last_name, from_date, salary, title,
     ROW_NUMBER() OVER
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM retirement_challenge
  ) tmp WHERE rn = 1;
  ```

  It was found that the total number of retirement-age employees is 72,458, with 7 different titles. The number of employees per title is shown below:
![table](https://github.com/oshadiw/Pewlett-Hackard-Analysis/blob/master/Challenge%20Data/no_employees_title.png)

  Finally, the company requested the number of current employees who are eligible to participate in a mentorship program. The qualifications for this program are current employees who were born between January 1, 1965 and December 31, 1965. This was found using the same method as finding the retirement-eligible employees, but changing the birthdate range:
```
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	titles.title,
	de.from_date,
	de.to_date
INTO mentorship_program
FROM employees as e
INNER JOIN titles
ON (titles.emp_no= e.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01');
```

  After this data was partitioned, it was found that 1,549 employees are eligible for the mentorship program. 
## Limitations and Further Recommendations

  
