# Copyright (c) Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

module EnrollmentSearchHelperConcern

  @@config = YAML::load_file("#{Rails.root}/config/properties.yml")
  @@range = @@config["scholarship_year_range"]
  
  def custom_record_select(klass, record, options)
    remote_controller = active_scaffold_controller_for(klass).controller_path
    record_select_options = active_scaffold_input_text_options({}).merge(
      :controller => remote_controller
    )
    html = record_select_field(options[:name], klass.new, record_select_options)
    html = self.class.field_error_proc.call(html, self) if record.errors[options[:name]].any?
    html
  end

  def custom_enrollment_number_search_column(record, options)
    custom_record_select(Enrollment, record, options)
  end

  def custom_student_search_column(record, options)
    custom_record_select(Student, record, options)
  end

  def custom_enrollment_level_search_column(record, options)
    select :search, :enrollment_level, options_for_klass(Level), {:include_blank => as_(:_select_)}, options
  end

  def custom_enrollment_status_search_column(record, options)
    select :search, :enrollment_status, options_for_klass(EnrollmentStatus), {:include_blank => as_(:_select_)}, options
  end

  def custom_admission_date_search_column(record, options)
    local_options = {
        :discard_day => true,
        :start_year => Time.now.year - @@range,
        :end_year => Time.now.year + @@range,
        :include_blank => true,
        :prefix => options[:name]
    }

    select_date record[:admission_date], options.merge(local_options)
  end

  def custom_scholarship_durations_active_search_column(record, options)
    select :search, :scholarship_durations_active, options_for_select([["Sim", 1], ["Não", 0]]), {:include_blank => as_(:_select_)}, options
  end

  def custom_advisor_search_column(record, options)
    custom_record_select(Professor, record, options)
  end

  def custom_has_advisor_search_column(record, options)
    select :search, :has_advisor, options_for_select([["Sim", 1], ["Não", 0]]), {:include_blank => as_(:_select_)}, options
  end

  def custom_professor_search_column(record, options)
    custom_record_select(Professor, record, options)
  end

  def custom_course_type_search_column(record, options)
    select :search, :course_type, options_for_klass(CourseType), {:include_blank => as_(:_select_)}, options
  end

  protected

  def options_for_klass(klass)
    options_for_select(klass.all.collect { |record| [record.to_label, record.id] })
  end

end