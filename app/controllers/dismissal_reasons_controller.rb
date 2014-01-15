# encoding: utf-8
# Copyright (c) 2013 Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

class DismissalReasonsController < ApplicationController
  authorize_resource

  active_scaffold :dismissal_reason do |config|
    config.list.sorting = {:name => 'ASC'}
    config.create.label = :create_dismissal_reason_label
  	config.columns[:thesis_judgement].form_ui = :select
    config.columns[:thesis_judgement].options = {:options => DismissalReason::THESIS_JUDGEMENT, :include_blank => I18n.t("active_scaffold._select_")}

  end

end 