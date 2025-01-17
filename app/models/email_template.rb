# Copyright (c) Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

class EmailTemplate < ApplicationRecord

  has_paper_trail

  validates_uniqueness_of :name, :allow_blank => true
  validates :body, :presence => true 
  validates :to, :presence => true 
  validates :subject, :presence => true 

  BUILTIN_TEMPLATES = {
    "accomplishments:email_to_advisor" => {
      path: File.join("accomplishments", "mailer", "email_to_advisor.text.erb"),
      subject: I18n.t('notifications.accomplishment.email_to_advisor.subject'),
      to: "<%= var(:advisement).professor.email %>",
      variables: {
        record: "Accomplishment",
        advisement: "Advisement"
      }
    },
    "accomplishments:email_to_student" => {
      path: File.join("accomplishments", "mailer", "email_to_student.text.erb"),
      subject: I18n.t('notifications.accomplishment.email_to_student.subject'),
      to: "<%= var(:record).enrollment.student.email %>",
      variables: {
        record: "Accomplishment"
      }
    },
    "advisements:email_to_advisor" => {
      path: File.join("advisements", "mailer", "email_to_advisor.text.erb"),
      subject: I18n.t('notifications.advisement.email_to_advisor.subject'),
      to: "<%= var(:record).professor.email %>",
      variables: {
        record: "Advisement"
      }
    },
    "class_enrollments:email_to_advisor" => {
      path: File.join("class_enrollments", "mailer", "email_to_advisor.text.erb"),
      subject: I18n.t('notifications.class_enrollment.email_to_advisor.subject'),
      to: "<%= var(:advisement).professor.email %>",
      variables: {
        record: "ClassEnrollment",
        advisement: "Advisement"
      }
    },
    "class_enrollments:email_to_professor" => {
      path: File.join("class_enrollments", "mailer", "email_to_professor.text.erb"),
      subject: I18n.t('notifications.class_enrollment.email_to_professor.subject'),
      to: "<%= var(:record).course_class.professor.email %>",
      variables: {
        record: "ClassEnrollment"
      }
    },
    "class_enrollments:email_to_student" => {
      path: File.join("class_enrollments", "mailer", "email_to_student.text.erb"),
      subject: I18n.t('notifications.class_enrollment.email_to_student.subject'),
      to: "<%= var(:record).enrollment.student.email %>",
      variables: {
        record: "ClassEnrollment"
      }
    },
    "class_enrollment_requests:email_to_student" => {
      path: File.join("class_enrollment_requests", "mailer", "email_to_student.text.erb"),
      subject: I18n.t('notifications.class_enrollment_request.email_to_student.subject'),
      to: "<%= var(:record).class_enrollment.enrollment.student.email %>",
      variables: {
        record: "ClassEnrollmentRequest",
      }
    },
    "class_enrollment_requests:removal_email_to_student" => {
      path: File.join("class_enrollment_requests", "mailer", "removal_email_to_student.text.erb"),
      subject: I18n.t('notifications.class_enrollment_request.removal_email_to_student.subject'),
      to: "<%= var(:record).enrollment_request.enrollment.student.email %>",
      variables: {
        record: "ClassEnrollmentRequest",
      }
    },
    "course_classes:email_to_professor" => {
      path: File.join("course_classes", "mailer", "email_to_professor.text.erb"),
      subject: I18n.t('notifications.course_class.email_to_professor.subject'),
      to: "<%= var(:record).professor.email %>",
      variables: {
        record: "CourseClass"
      }
    },
    "deferrals:email_to_advisor" => {
      path: File.join("deferrals", "mailer", "email_to_advisor.text.erb"),
      subject: I18n.t('notifications.deferral.email_to_advisor.subject'),
      to: "<%= var(:advisement).professor.email %>",
      variables: {
        record: "Deferral",
        advisement: "Advisement"
      }
    },
    "deferrals:email_to_student" => {
      path: File.join("deferrals", "mailer", "email_to_student.text.erb"),
      subject: I18n.t('notifications.deferral.email_to_student.subject'),
      to: "<%= var(:record).enrollment.student.email %>",
      variables: {
        record: "Deferral"
      }
    },
    "enrollment_requests:email_to_student" => {
      path: File.join("enrollment_requests", "mailer", "email_to_student.text.erb"),
      subject: I18n.t('notifications.enrollment_request.email_to_student.subject'),
      to: "<%= var(:record).enrollment.student.email %>",
      variables: {
        record: "EnrollmentRequest",
        student_enrollment_url: "URL",
      }
    },
    "devise:confirmation_instructions" => {
      path: File.join("devise", "mailer", "confirmation_instructions.text.erb"),
      subject: I18n.t('devise.mailer.confirmation_instructions.subject'),
      to: "<%= @resource.unconfirmed_email || @resource.email %>",
      variables: {
        '@resourse' => "User"
      }
    },
    "devise:email_changed" => {
      path: File.join("devise", "mailer", "email_changed.text.erb"),
      subject: I18n.t('devise.mailer.email_changed.subject'),
      to: "<%= @resource.email %>",
      variables: {
        '@resourse' => "User"
      }
    },
    "devise:invitation_instructions" => {
      path: File.join("devise", "mailer", "invitation_instructions.text.erb"),
      subject: I18n.t('devise.mailer.invitation_instructions.subject'),
      to: "<%= @resource.email %>",
      variables: {
        '@resourse' => "User"
      }
    },
    "devise:password_change" => {
      path: File.join("devise", "mailer", "password_change.text.erb"),
      subject: I18n.t('devise.mailer.password_change.subject'),
      to: "<%= @resource.email %>",
      variables: {
        '@resourse' => "User"
      }
    },
    "devise:reset_password_instructions" => {
      path: File.join("devise", "mailer", "reset_password_instructions.text.erb"),
      subject: I18n.t('devise.mailer.reset_password_instructions.subject'),
      to: "<%= @resource.email %>",
      variables: {
        '@resourse' => "User"
      }
    },
    "devise:unlock_instructions" => {
      path: File.join("devise", "mailer", "unlock_instructions.text.erb"),
      subject: I18n.t('devise.mailer.unlock_instructions.subject'),
      to: "<%= @resource.email %>",
      variables: {
        '@resourse' => "User"
      }
    },
    "student_enrollments:email_to_student" => {
      path: File.join("student_enrollment", "mailer", "email_to_student.text.erb"),
      subject: I18n.t('notifications.student_enrollment.email_to_student.subject'),
      to: "<%= var(:record).enrollment.student.email %>",
      variables: {
        record: "EnrollmentRequest",
      }
    },
    "student_enrollments:email_to_advisor" => {
      path: File.join("student_enrollment", "mailer", "email_to_advisor.text.erb"),
      subject: I18n.t('notifications.student_enrollment.email_to_advisor.subject'),
      to: "<%= var(:advisement).professor.email %>",
      variables: {
        record: "EnrollmentRequest",
        advisement: "Advisement"
      }
    },
    "student_enrollments:removal_email_to_student" => {
      path: File.join("student_enrollment", "mailer", "removal_email_to_student.text.erb"),
      subject: I18n.t('notifications.student_enrollment.removal_email_to_student.subject'),
      to: "<%= var(:record).enrollment.student.email %>",
      variables: {
        record: "EnrollmentRequest",
      }
    },
    "student_enrollments:removal_email_to_advisor" => {
      path: File.join("student_enrollment", "mailer", "removal_email_to_advisor.text.erb"),
      subject: I18n.t('notifications.student_enrollment.removal_email_to_advisor.subject'),
      to: "<%= var(:advisement).professor.email %>",
      variables: {
        record: "EnrollmentRequest",
        advisement: "Advisement"
      }
    },
  }

  def self.devise_template(action)
    name = "devise:#{action}"
    self.load_template(name)
  end

  def self.load_template(name)
    template = EmailTemplate.find_by_name(name)
    if template.nil?
      template = EmailTemplate.new
      builtin = BUILTIN_TEMPLATES[name] 
      unless builtin.nil?
        template.subject = builtin[:subject]
        template.to = builtin[:to]
        template.body = File.read File.join(Rails.root, "app", "views", builtin[:path])
      end
    end
    template
  end

  def update_mailer_headers(headers)
    unless CustomVariable.redirect_email.nil?
      headers[:subject] = headers[:subject] + " (Originalmente para #{headers[:to]})"
      headers[:to] = CustomVariable.redirect_email
      headers[:skip_redirect] = true
    end
    headers[:skip_message] = ! self.enabled
    headers[:skip_footer] = true
  end

  def prepare_message(bindings)
    formatter = ERBFormatter.new(bindings)
    message = {
      :to => formatter.format(self.to),
      :subject => formatter.format(self.subject),
      :body => formatter.format(self.body),
      :skip_footer => true
    }
    self.update_mailer_headers(message)
    message
  end

end
