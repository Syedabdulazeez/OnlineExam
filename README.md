# Application Versions
* Rails -> 6.1.7.3
* Ruby  -> 3.1.2
* Node  -> 16.20.1
* Yarn  -> 1.22.19
* NPM   -> 8.19.4
* Elastic Search -> 7.2.1

# The Functionality Implemented

## Users

* Users can sign up using Google and Facebook accounts.
* Users can also sign up/login via a one-time magic link sent to their email address.
* Users have a profile page where they can edit their education details, including college and department information.

## Dashboard

* Upon logging in, users are redirected to the dashboard page.
* The dashboard shows all upcoming and ongoing exams in which the user has registered.
* Each upcoming exam has a demo test button, which is disabled half an hour before the exam.
* If a user has already started an exam but closes and reopens the page, they should be able to resume the exam if the duration has not yet expired.

## Exam Registration

* Users need to register for an exam before they can appear for it.
* The registration page displays all upcoming exams with details such as subject, department, start time, and duration.
* The registration page includes search and filter options (by department, subject, etc.) as well as sorting functionality.
* After successful registration, users receive a confirmation email with exam details.
* Users also receive reminder emails 1 day and 2 hours before the exam, including a link to the dashboard page.

## Exam Details

* Clicking on an exam name from the registration page or dashboard redirects the user to the exam details page.
* The exam details page lists all relevant information about the exam.
* Clicking on the department name redirects the user to the department page, displaying subjects and relevant details.
* An animated scroll bar provides a snapshot of professors' profiles, including their names, photos, two-liner profile summaries, and links to their professional profiles (e.g., LinkedIn).
* Clicking on a subject name takes the user to the subject details page, showing all exams (past, present, and future) with registration indicators and the option to register.

## Leaderboard

* The leaderboard tab displays subject and department-wise performance for every exam.
* Performance is represented graphically (individual, average, highest) and numerically.
* The leaderboard includes two ranks: college-wise and overall.
* A button allows users to generate a performance report (PDF) based on the exam, which is sent to the candidate via email.

## Test Paper

* The admin can set separate question papers for actual exams and mock tests.
* Questions are displayed randomly for each student.

## Admin Panel

* The admin panel allows admin users to log in (similar to normal users).
* The first admin user is created from the backend, and subsequent admins can be added by existing admins.
* Admins can set up the entire application, including creating departments, subjects, exams, and question papers.
* Admins can view all students and candidates registered for exams.

Please note that this is a high-level overview of the functional requirements. Implementation details and specific features can be added based on your preferences and the technical feasibility of the project.
