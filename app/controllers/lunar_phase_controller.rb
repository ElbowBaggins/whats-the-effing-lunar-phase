# frozen_string_literal: true

class LunarPhaseController < ApplicationController # :nodoc:
  protect_from_forgery with: :exception
  helper LunarPhaseHelper
  def lunar_phase
    @exclamation = view_context.random_exclamation
    @lunar_phase_id = view_context.lunar_phase_tonight
    @lunar_phase = view_context.get_lunar_phase_name_from_id(@lunar_phase_id)
    @icon_name = view_context.get_lunar_icon_name_from_id(@lunar_phase_id)
    @quote = view_context.random_quote
  end
end
