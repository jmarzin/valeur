# -*- coding: utf-8 -*-
require 'mareva'

class IndirectsController < ApplicationController
  # GET /indirects/1
  # GET /indirects/1.json
  def show
    @etude = Etude.find(params[:id])
    @etude.lit_rentabilite
    @modif = Etude.modif_supp_apparents([@etude])[@etude._id][:modif]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /indirects/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @indirect = @etude.lit_direct_indirect('indirect')
  end

  # PUT /indirects/1
  # PUT /indirects/1.json
  def update
    @etude = Etude.find(params[:id])
    respond_to do |format|
      params[:indirect] = @etude.somme_pourcent(params[:indirect])
      if @etude.etude_rentabilite.indirect.update_attributes(params[:indirect])
        if params[:commit] then
          @etude.etude_rentabilite.a_calculer = true
          @etude.simplifie_indirect
          flash[:notice] = "Les coûts indirects ont bien été mis à jour."
          if params[:commit] == 'Actualiser' then
            @indirect = @etude.lit_direct_indirect('indirect')
            format.html { render action: "edit"}
            format.json { head :no_content }
          else
            @modif = Etude.modif_supp_apparents([@etude])[@etude._id][:modif]
            format.html { render action: "show"}
            format.json { head :no_content }
          end
        else
          @indirect = @etude.traite_touche(params)
          format.html { render action: "edit" }
          format.json { head :no_content }
        end
      else
        @indirect = @etude.lit_direct_indirect('indirect')
        flash[:notice] = "Problème de mise à jour des coûts indirects."
        format.html { render action: "edit", notice: '' }
        format.json { render json: @projet.errors }
      end
    end
  end
end
