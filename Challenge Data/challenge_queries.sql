-- number of employees about to retire grouped by job title (emp_no,first/last, title, from_date, salary)
drop table retirement_challenge;
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

select * from retirement_challenge;
				
-- Partition the data to show only most recent title per employee
SELECT emp_no, first_name, last_name, from_date, salary, title
INTO retiring_employees
  FROM
(SELECT emp_no, first_name, last_name, from_date, salary, title,
     ROW_NUMBER() OVER
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM retirement_challenge
  ) tmp WHERE rn = 1;	

select * from retiring_employees;

SELECT emp_no, first_name, last_name, from_date, salary, title
INTO retiring_title
FROM retiring_employees
ORDER BY title ASC;

select * from retiring_title;

-- Number of employees retiring per title
SELECT COUNT(retiring_employees.emp_no), retiring_employees.title
INTO titles_retiring_count
FROM retiring_employees
GROUP BY retiring_employees.title;

select * from titles_retiring_count;

-- number of titles retiring
SELECT
   title
INTO no_titles_retiring
FROM
   retiring_title
GROUP BY
   title;

select *from no_titles_retiring;
-- mentorship eligibility

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

select *from mentorship_program;

drop table mentorship_program;

SELECT emp_no, first_name, last_name, title, from_date, to_date
INTO mentorship_partitioned
  FROM
(SELECT emp_no, first_name, last_name, title, from_date, to_date,
     ROW_NUMBER() OVER
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM mentorship_program
  ) tmp WHERE rn = 1
  
select * from mentorship_partitioned;