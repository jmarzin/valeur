# -*- coding: utf-8 -*-
require 'mareva'
require 'autofocus'
class FonctionsController < ApplicationController
  # GET /fonctions/1
  # GET /fonctions/1.json

include Autofocus

  def show
    @etude = Etude.find(params[:id])
    @etude.lit_rentabilite
    @modif = Etude.modif_supp_apparents([@etude])[@etude._id][:modif]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /fonctions/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @rentabilite=@etude.lit_rentabilite
    @fonction=@etude.lit_fonction
  end

  # PUT /fonctions/1
  # PUT /fonctions/1.json
  def update
    @etude = Etude.find(params[:id])
    respond_to do |format|
      @auto = autofocus(params,@etude.etude_rentabilite.fonction.situations[0].details.count,@etude.etude_rentabilite.fonction.situations[1].details.count)
      params[:fonction][:situations_attributes]["0"] = @etude.somme_pourcent(params[:fonction][:situations_attributes]["0"])
      params[:fonction][:situations_attributes]["1"] = @etude.somme_pourcent(params[:fonction][:situations_attributes]["1"])
      if @etude.etude_rentabilite.fonction.update_attributes(params[:fonction])
        if params[:commit] then
          @etude.etude_rentabilite.a_calculer = true
          @etude.simplifie_fonction
          flash[:notice] = "Les impacts sur les coûts de fonctionnement ont bien été mis à jour."
          if params[:commit].capitalize == 'Actualiser' then
            @fonction = @etude.lit_fonction
            format.html { render action: "edit"}
            format.json { head :no_content }
          else
            @modif = Etude.modif_supp_apparents([@etude])[@etude._id][:modif]
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
