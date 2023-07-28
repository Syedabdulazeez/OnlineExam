# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Department names
department_names = %w[CSE ECE EEE Civil Mech]

# Create departments
departments = department_names.map do |name|
  Department.create!(department_name: name, created_at: Time.current, updated_at: Time.current)
end

# Subjects for each department
departments.each do |department|
  2.times do |i|
    Subject.create!(
      department_id: department.id,
      subject_name: "#{department.department_name} Subject #{i + 1}",
      created_at: Time.current,
      updated_at: Time.current
    )
  end
end

# Create exams for each subject
Subject.all.each do |subject|
  3.times do |i|
    @start = if i == 1
               Time.current + 25.hours # Start time for demo exam (current time + 25 hours)
             else
               Time.current + 1.second # Start time for actual exams (current time +1 second)
             end

    Exam.create!(
      subject_id: subject.id,
      start_time: @start,
      duration: 60, # Assuming each exam has a duration of 1 hours (in minutes)
      created_at: Time.current,
      updated_at: Time.current,
      exam_name: "#{subject.subject_name} Exam #{i + 1}",
      is_demo: i.zero? # Marking the first exam as a demo exam
    )
  end
end

# Create questions for each exam
Exam.all.each do |exam|
  10.times do |i|
    Question.create!(
      exam_id: exam.id,
      question_text: "Question #{i + 1} for #{exam.exam_name}",
      created_at: Time.current,
      updated_at: Time.current,
      answer1: 'Answer 1',
      answer2: 'Answer 2',
      answer3: 'Answer 3',
      answer4: 'Answer 4',
      correct_answer: rand(1..4) # Randomly assign correct answer between 1 to 4
    )
  end
end
# Create a normal user
User.create!(
  username: 'user1',
  email: 'normal_user@example.com',
  password: '1234',
  password_confirmation: '1234',
  created_at: Time.current,
  updated_at: Time.current,
  college: 'Example College',
  department: 'Example Department'
)

# Create an admin user
User.create!(
  username: 'admin',
  email: 'admin_user@example.com',
  password: '1234',
  password_confirmation: '1234', 
  created_at: Time.current,
  updated_at: Time.current,
  college: 'Example College',
  department: 'Example Department',
  admin: true
)

# Find the user with the username 'user1'
user = User.find_by(username: 'user1')

# Register the user for the latest exam created for each subject
Subject.all.each do |subject|
  latest_exam = subject.exams.order(created_at: :desc).first

  Registration.create!(
    user_id: user.id,
    exam_id: latest_exam.id,
    created_at: Time.current,
    updated_at: Time.current
  )
end

# Find the user with the username 'user1'
user = User.find_by(username: 'user1')

# Create performance records for each exam registered by the user
user.registrations.each do |registration|
  exam = registration.exam
  marks_obtained = rand(0..100) # Assuming random marks obtained between 0 and 100

  ExamPerformance.create!(
    user_id: user.id,
    exam_id: exam.id,
    marks_obtained:,
    created_at: Time.current,
    updated_at: Time.current
  )
end

# Professor data
professors_data = [
  { name: 'Professor 1', department_id: 1, summary: 'Summary 1. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor1' },
  { name: 'Professor 2', department_id: 1, summary: 'Summary 2. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor2' },
  { name: 'Professor 3', department_id: 1, summary: 'Summary 3. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor3' },
  { name: 'Professor 4', department_id: 2, summary: 'Summary 1. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor4' },
  { name: 'Professor 5', department_id: 2, summary: 'Summary 2. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor5' },
  { name: 'Professor 6', department_id: 2, summary: 'Summary 3. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor6' },
  { name: 'Professor 7', department_id: 3, summary: 'Summary 1. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor7' },
  { name: 'Professor 8', department_id: 3, summary: 'Summary 2. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor8' },
  { name: 'Professor 9', department_id: 3, summary: 'Summary 3. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor9' },
  { name: 'Professor 10', department_id: 4, summary: 'Summary 1. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor10' },
  { name: 'Professor 11', department_id: 4, summary: 'Summary 2. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor11' },
  { name: 'Professor 12', department_id: 4, summary: 'Summary 3. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor12' },
  { name: 'Professor 13', department_id: 5, summary: 'Summary 1. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor13' },
  { name: 'Professor 14', department_id: 5, summary: 'Summary 2. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor14' },
  { name: 'Professor 15', department_id: 5, summary: 'Summary 3. This is the first line.\nThis is the second line. ',
    linkedin_link: 'https://www.linkedin.com/professor15' }
]

# Create professors for each department
professors_data.each do |professor_data|
  Professor.create!(
    name: professor_data[:name],
    department_id: professor_data[:department_id],
    summary: professor_data[:summary],
    linkedin_link: professor_data[:linkedin_link],
    created_at: Time.current,
    updated_at: Time.current
  )
end

Exam.__elasticsearch__.delete_index!

Exam.all.each do |exam|
  exam.__elasticsearch__.index_document
end
