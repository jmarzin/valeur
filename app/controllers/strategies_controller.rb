# -*- coding: utf-8 -*-
require 'mareva'

class StrategiesController < ApplicationController
  # GET /strategies/1
  # GET /strategies/1.json
  def show
    @etude = Etude.find(params[:id])
    @strategy = @etude.lit_strategie

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @strategy }
    end
  end

  # GET /strategies/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @strategy = @etude.lit_strategie
  end

  # PUT /strategies/1
  # PUT /strategies/1.json
  def update
    @etude = Etude.find(params[:id])
    @strategy = @etude.calcul_strategie(params)
    respond_to do |format|
      if @etude.save
        flash[:notice] = "La stratégie a bien été mise à jour."
        format.html { render action: "edit"}
        format.json { head :no_content }
      else
        flash[:notice] = "Problème de mise à jour de la stratégie."
        format.html { render action: "edit", notice: '' }
        format.json { render json: @projet.errors }
      end
    end
  end
end
