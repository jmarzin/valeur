# -*- coding: utf-8 -*-
require 'mareva'

class RentabilitesController < ApplicationController
  # GET /rentabilites/1
  # GET /rentabilites/1.json
  def show
    @etude = Etude.find(params[:id])
    @rentabilite = @etude.lit_rentabilite
    @rentabilite = @etude.calcule_rentabilite if @rentabilite.a_calculer
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end
end
