# Copyright (c) Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

module StudentsHelper
  def enrollments_column(record, column)
    return record.enrollments_number
  end

  def city_form_column(record, options)
    city_widget(
      record, options,
      country: :address_country, state: :address_state, city: :city,
      selected_city: record.city
    )
  end

  def birth_city_form_column(record, options)
    city = record.birth_city
    state = (city.nil? ? nil : city.state) || record.birth_state
    country = (state.nil? ? nil : state.country) || record.birth_country

    city_widget(
      record, options,
      country: :birth_country, state: :birth_state, city: :birth_city,
      selected_country: country,
      selected_state: state,
      selected_city: city
    )
  end

  def identity_issuing_place_form_column(record, options)
    identity_issuing_place_widget(
      record, options,
      text: record.identity_issuing_place
    )
  end

  def photo_form_column(record, options)
    config = ActiveScaffold::Config::Core.new(:student)
    render(:partial => "students/photo_widget", :locals => { 
      config: config,
      record: record,
      options: options,
      column: config.columns[:photo],
    })
  end
  
  def photo_show_column(record, column)
    return '-' if record.photo.blank?
    image_tag photo_student_path(record) + "?hash=#{record.photo_before_type_cast}", style: "width: 400px; height: 300px; Object-fit: contain; background-color: #f2f1f0;"
  end

  def permit_rs_browse_params
    [:page, :update, :utf8]
  end

end
