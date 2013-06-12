# -*- coding: utf-8 -*-
require 'mareva'

class FonctionsController < ApplicationController
  # GET /fonctions/1
  # GET /fonctions/1.json
  def show
    @etude = Etude.find(params[:id])
    @etude.lit_rentabilite
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /fonctions/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @fonction=@etude.lit_fonction
  end

  # PUT /fonctions/1
  # PUT /fonctions/1.json
  def update
    @etude = Etude.find(params[:id])
    respond_to do |format|
      params[:fonction] = @etude.somme_pourcent(params[:fonction])
      if @etude.etude_rentabilite.fonction.update_attributes(params[:fonction])
        if params[:commit] then
          @etude.simplifie_fonction
          flash[:notice] = "Les impacts sur les coûts de fonctionnement ont bien été mis à jour."
          if params[:commit] == 'Actualiser' then
            @fonction = @etude.lit_fonction
            format.html { render action: "edit"}
            format.json { head :no_content }
          else
            format.html { render action: "show"}
            format.json { head :no_content }
          end
        else
          @fonction = @etude.traite_touche(params)
          format.html { render action: "edit" }
          format.json { head :no_content }
        end
      else
        @fonction = @etude.lit_fonction
        flash[:notice] = "Problème de mise à jour des impacts sur les coûts de fonctionnement."
        format.html { render action: "edit", notice: '' }
        format.json { render json: @projet.errors }
      end
    end
  end
end
