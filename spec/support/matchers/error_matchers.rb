#encoding: UTF-8
# Copyright (c) Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

RSpec::Matchers.define :have_error do |erro|

  def error_message(record, atributo, erro)
    translation_missing_message = "translation missing:"
    parameters = @parameters.blank? ?  {} : @parameters

    message = I18n.translate("errors.messages.#{erro}", **parameters)
    if message.include?(translation_missing_message)
      message = I18n.translate("activerecord.errors.models.#{record.class.to_s.underscore}.#{erro}", **parameters)
      message = message.include?(translation_missing_message) ? I18n.translate("activerecord.errors.models.#{record.class.to_s.underscore}.attributes.#{atributo}.#{erro}", **parameters) : message
    end
    return message
  end

  chain :on do |atributo|
    @atributo = atributo
  end

  chain :with_parameters do |parameters|
    @parameters = parameters
  end

  match do |record|
    unless @atributo
      raise "Deve incluir um atributo"
    end
    record.valid?
    mensagem = error_message(record, @atributo, erro.to_s)
    record.errors[@atributo].to_a.detect { |e| e == mensagem }
  end

  failure_message do |record|
    if @atributo
      %{Esperava que [#{record.errors[@atributo].join(', ')}] incluísse "#{error_message(record, @atributo, erro.to_s)}"}
    end
  end

  failure_message_when_negated do |record|
    if @atributo
      %{Esperava que [#{record.errors[@atributo].join(', ')}] não incluísse "#{error_message(record, @atributo, erro.to_s)}"}
    end
  end

  description do
    "deve incluir erro de '#{erro.to_s}'"
  end
end
