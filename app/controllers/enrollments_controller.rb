# encoding: utf-8
# Copyright (c) 2013 Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

class EnrollmentsController < ApplicationController

  authorize_resource
  include NumbersHelper
  include ApplicationHelper
  helper :class_enrollments
  helper :advisements
  helper :scholarship_durations

  active_scaffold :enrollment do |config|

    config.action_links.add 'to_pdf', :label => I18n.t('active_scaffold.to_pdf'), :page => true, :type => :collection, :parameters => {:format => :pdf}
    config.action_links.add 'academic_transcript_pdf', :label => I18n.t('pdf_content.enrollment.academic_transcript.link'), :page => true, :type => :member, :parameters => {:format => :pdf}
    config.action_links.add 'grades_report_pdf', :label => I18n.t('pdf_content.enrollment.grades_report.link'), :page => true, :type => :member, :parameters => {:format => :pdf}

    config.columns.add :scholarship_durations_active, :active, :professor, :phase, :delayed_phase, :course_class_year_semester
    config.columns.add :listed_advisors, :listed_accomplishments, :listed_deferrals, :listed_scholarships, :listed_class_enrollments
    config.columns.add :phase_due_dates

    config.list.columns = [:enrollment_number, :student, :enrollment_status, :level, :admission_date, :dismissal]
    config.list.sorting = {:enrollment_number => 'ASC'}
    
    config.create.label = :create_enrollment_label
    config.update.label = :update_enrollment_label
    config.actions.swap :search, :field_search

    config.field_search.columns = [:enrollment_number, :student, :level, :enrollment_status, :admission_date, :active, :scholarship_durations_active, :professor, :delayed_phase, :course_class_year_semester]

    
    config.columns[:accomplishments].allow_add_existing = false;
    config.columns[:accomplishments].search_sql = ""
    config.columns[:active].search_sql = ""
    config.columns[:active].search_ui = :select
    config.columns[:admission_date].options = {:format => :monthyear}
    config.columns[:admission_date].search_sql = "enrollments.admission_date"
    config.columns[:course_class_year_semester].search_sql = ""
    config.columns[:delayed_phase].search_sql = ""
    config.columns[:delayed_phase].search_ui = :select
    config.columns[:dismissal].clear_link
    config.columns[:dismissal].sort_by :sql => 'dismissals.date'
    config.columns[:enrollment_number].search_sql = "enrollments.enrollment_number"
    config.columns[:enrollment_number].search_ui = :text
    config.columns[:enrollment_status].clear_link
    config.columns[:enrollment_status].form_ui = :select
    config.columns[:enrollment_status].form_ui = :select
    config.columns[:enrollment_status].search_sql = "enrollment_statuses.id"
    config.columns[:enrollment_status].search_ui = :select
    config.columns[:level].clear_link
    config.columns[:level].form_ui = :select
    config.columns[:level].search_sql = "levels.id"
    config.columns[:level].search_ui = :select
    config.columns[:professor].includes = {:advisements => :professor}
    config.columns[:professor].search_sql = "professors.name"
    config.columns[:professor].search_ui = :text
    config.columns[:research_area].form_ui = :record_select
    config.columns[:scholarship_durations_active].search_sql = ""
    config.columns[:scholarship_durations_active].search_ui = :select
    config.columns[:student].form_ui = :record_select
    config.columns[:student].search_ui = :record_select

    columns = [
      :enrollment_number, 
      :student,
      :admission_date, 
      :enrollment_status,
      :level,  
      :research_area,
      :thesis_title,
      :thesis_defense_date,
      :obs, 

      :advisements, 
      :scholarship_durations,
      :accomplishments, 
      :deferrals, 
      :thesis_defense_committee_participations, 
      :dismissal, 
      :class_enrollments
    ]
    create_columns = columns.dup.delete_if { |x| [:accomplishments, :deferrals].include? x }

    config.create.columns = create_columns
    config.update.columns = columns
    config.show.columns = columns + [:phase_due_dates]
  end
  record_select :per_page => 10, :search_on => [:enrollment_number], :order_by => 'enrollment_number', :full_text_search => true

  #def self.condition_for_course_type(column, value, like_pattern)
  #  return [] if value[:year].empty? and value[:semester].empty? and value[:course].empty?
  #  ['(?, ?, ?) IN (%{search_sql})', value[:course], value[:year], value[:semester]]
  #end

  def self.condition_for_course_class_year_semester_column(column, value, like_pattern)
    return [] if value[:year].empty? and value[:semester].empty? and value[:course].empty?
    columns = { :year => '`course_classes`.`year`', 
                :semester => '`course_classes`.`semester`', 
                :course => '`courses`.`id`'}
    select = []
    condition = []
    result = []
    columns.each do |key, selection|
      unless value[key].empty?
        select << selection
        condition << "?"
        result << value[key]
      end
    end

    search_sql = ClassEnrollment.joins(course_class: {course: :course_type})
      .where('`class_enrollments`.`enrollment_id` = `enrollments`.`id`')
      .select(select)
      .to_sql


    ["(#{condition.join(', ')}) IN (#{search_sql})"] + result
  end

  def self.condition_for_admission_date_column(column, value, like_pattern)
    month = value[:month].empty? ? 1 : value[:month]
    year = value[:year].empty? ? 1 : value[:year]

    if year != 1
      date1 = Date.new(year.to_i, month.to_i)
      date2 = Date.new(month.to_i==12 ? year.to_i + 1 : year.to_i, (month.to_i % 12) + 1)

      ["DATE(#{column.search_sql.last}) >= ? and DATE(#{column.search_sql.last}) < ?", date1, date2]
    end
  end

  def self.condition_for_scholarship_durations_active_column(column, value, like_pattern)
    query_active_scholarships = "select enrollment_id from scholarship_durations where DATE(scholarship_durations.end_date) >= DATE(?) AND  (scholarship_durations.cancel_date is NULL OR DATE(scholarship_durations.cancel_date) >= DATE(?))"
    case value
      when '0' then
        sql = "enrollments.id not in (#{query_active_scholarships})"
      when '1' then
        sql = "enrollments.id in (#{query_active_scholarships})"
      else
        sql = ""
    end

    [sql, Time.now, Time.now]
  end

  def self.condition_for_active_column(column, value, like_pattern)
    query_inactive_enrollment = "select enrollment_id from dismissals where DATE(dismissals.date) <= DATE(?)"
    case value
      when 'not_active' then
        sql = "enrollments.id in (#{query_inactive_enrollment})"
      when 'active' then
        sql = "enrollments.id not in (#{query_inactive_enrollment})"
      else
        sql = ""
    end

    [sql, Time.now]
  end

  def self.condition_for_delayed_phase_column(column, value, like_pattern)
    return "" if value[:phase].blank?
    date = value.nil? ? value : Date.parse("#{value[:year]}/#{value[:month]}/#{value[:day]}")
    phase = value[:phase] == "all" ? Phase.all : [Phase.find(value[:phase])]
    enrollments_ids = Enrollment.with_delayed_phases_on(date, phase)
    query_delayed_phase = enrollments_ids.blank? ? "1 = 2" : "enrollments.id in (#{enrollments_ids.join(',')})"
    query_delayed_phase
  end

  def self.condition_for_accomplishments_column(column, value, like_pattern)
    return "" if value[:phase].blank?
    date = value.nil? ? value : Date.parse("#{value[:year]}/#{value[:month]}/#{value[:day]}")
    phase = value[:phase] == "all" ? nil : value[:phase]
    if (value[:phase] == "all")
      enrollments_ids = Enrollment.with_all_phases_accomplished_on(date)
      query = enrollments_ids.blank? ? "1 = 2" : "enrollments.id in (#{enrollments_ids.join(',')})"
    else
      query = "enrollments.id in (select enrollment_id from accomplishments where DATE(conclusion_date) <= DATE('#{date}') and phase_id = #{phase})"
    end
    query
  end


  def to_pdf

    each_record_in_page {}
    enrollments_list = find_page(:sorting => active_scaffold_config.list.user.sorting).items
    @enrollments = enrollments_list.map do |enrollment|
      [
          enrollment.student[:name],
          enrollment[:enrollment_number],
          enrollment[:admission_date],
          if enrollment.dismissal
            enrollment.dismissal[:date]
          end
      ]
    end

    @search = search_params

    respond_to do |format|
      format.pdf do
        send_data render_to_string, :filename => I18n.t("pdf_content.enrollment.to_pdf.filename"), :type => 'application/pdf'
      end
    end
  end

  def academic_transcript_pdf
    @enrollment = Enrollment.find(params[:id])

    @class_enrollments = @enrollment.class_enrollments
      .where(:situation => I18n.translate("activerecord.attributes.class_enrollment.situations.aproved"))
      .joins(:course_class)
      .order("course_classes.year", "course_classes.semester")

    @accomplished_phases = @enrollment.accomplishments.order(:conclusion_date)

    respond_to do |format|
      format.pdf do
        send_data render_to_string, :filename => "#{I18n.t('pdf_content.enrollment.academic_transcript.title')} -  #{@enrollment.student.name}.pdf", :type => 'application/pdf'
      end
    end
  end

  def grades_report_pdf
    @enrollment = Enrollment.find(params[:id])

    @class_enrollments = @enrollment.class_enrollments
      .where(:situation => I18n.translate("activerecord.attributes.class_enrollment.situations.aproved"))
      .joins(:course_class)
      .order("course_classes.year", "course_classes.semester")


    @accomplished_phases = @enrollment.accomplishments.order(:conclusion_date)

    @deferrals = @enrollment.deferrals.order(:approval_date)


    respond_to do |format|
      format.pdf do
        send_data render_to_string, :filename => "#{I18n.t('pdf_content.enrollment.grades_report.title')} -  #{@enrollment.student.name}.pdf", :type => 'application/pdf'
      end
    end
  end

  def total_time_with_deferrals(phase)

    durations = deferral_type.phase.phase_durations
    phase_duration = durations.select { |duration| duration.level_id == enrollment.level.id}[0]

    total_time = phase_duration.duration

    deferrals = enrollment.deferrals.select { |deferral| deferral.deferral_type.phase == deferral_type.phase}
    for deferral in deferrals
      if approval_date >= deferral.approval_date
        deferral_duration = deferral.deferral_type.duration
        (total_time.keys | deferral_duration.keys).each do |key|
          total_time[key] += deferral_duration[key].to_i
        end
      end
    end

    total_time
  end

  def after_create_save(record)
    PhaseDuration.where(:level_id => record.level_id).each do |phase_duration|
      due_date = phase_duration.phase.calculate_end_date(record.admission_date, phase_duration.deadline_semesters, phase_duration.deadline_months, phase_duration.deadline_days)

      PhaseCompletion.create(:enrollment_id=>record.id, :phase_id=>phase_duration.phase.id, :completion_date=>nil, :due_date=>due_date)
    end
  end

  def after_update_save(record)
    PhaseCompletion.where(:enrollment_id => record.id).destroy_all

    PhaseDuration.where(:level_id => record.level_id).each do |phase_duration|
      completion_date = nil

      phase_accomplishment = record.accomplishments.where(:phase_id => phase_duration.phase_id)[0]
      completion_date = phase_accomplishment.conclusion_date unless phase_accomplishment.nil?

      phase_deferrals = record.deferrals.select { |deferral| deferral.deferral_type.phase == phase_duration.phase}
      if phase_deferrals.empty?
        due_date = phase_duration.phase.calculate_end_date(record.admission_date, phase_duration.deadline_semesters, phase_duration.deadline_months, phase_duration.deadline_days)
      else
        total_time = phase_duration.duration
        phase_deferrals.each do |deferral|
          deferral_duration = deferral.deferral_type.duration
          (total_time.keys | deferral_duration.keys).each do |key|
            total_time[key] += deferral_duration[key].to_i
          end
        end
        due_date = phase_duration.phase.calculate_end_date(record.admission_date, total_time[:semesters], total_time[:months], total_time[:days])
      end

      PhaseCompletion.create(:enrollment_id=>record.id, :phase_id=>phase_duration.phase.id, :completion_date=>completion_date, :due_date=>due_date)
    end
  end
end
