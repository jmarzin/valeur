# -*- coding: utf-8 -*-
require 'mareva'

class DirectsController < ApplicationController
  # GET /directs/1
  # GET /directs/1.json
  def show
    @etude = Etude.find(params[:id])
    @strategy = @etude.lit_strategie

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @strategy }
    end
  end

  # GET /directs/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @direct = @etude.lit_direct
    @natures = Etude.liste_natures
    @annees = @etude.liste_annees
  end

  # PUT /directs/1
  # PUT /directs/1.json
  def update
    binding.pry
    @etude = Etude.find(params[:id])
    respond_to do |format|
      if @etude.etude_rentabilite.direct.update_attributes(params[:direct])
        binding.pry
        @etude.simplifie_direct
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
