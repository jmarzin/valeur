# -*- coding: utf-8 -*-
require 'mareva'
require 'autofocus'
class GainsController < ApplicationController


include Autofocus 

  # GET /gains/1
  # GET /gains/1.json
  def show
    @etude = Etude.find(params[:id])
    @etude.lit_rentabilite
    @modif = Etude.modif_supp_apparents([@etude])[@etude._id][:modif]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /gains/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @rentabilite=@etude.lit_rentabilite
    @gain=@etude.lit_direct_indirect('gain')
  end

  # PUT /gains/1
  # PUT /gains/1.json
  def update
    @etude = Etude.find(params[:id])
    respond_to do |format|
      @auto = autofocus(params,@etude.etude_rentabilite.gain.details.count)
      ("0".."4").each { |i| params[:gain][:etp_reparts_attributes][i] = @etude.somme_pourcent(params[:gain][:etp_reparts_attributes][i]) }
      if @etude.etude_rentabilite.gain.update_attributes(params[:gain])
        if params[:commit] then
          @etude.etude_rentabilite.a_calculer = true
          @etude.simplifie_gain
          flash[:notice] = "Les impacts sur les gains métier ont bien été mis à jour."
          if params[:commit].capitalize == 'Actualiser' then
            @gain = @etude.lit_direct_indirect('gain')
            format.html { render action: "edit"}
            format.json { head :no_content }
          else
            @modif = Etude.modif_supp_apparents([@etude])[@etude._id][:modif]
            format.html { render action: "show"}
            format.json { head :no_content }
          end
        else
          @gain = @etude.traite_touche(params)
          format.html { render action: "edit" }
          format.json { head :no_content }
        end
      else
        @gain = @etude.lit_direct_indirect('gain')
        flash[:notice] = "Problème de mise à jour des gains métier."
        format.html { render action: "edit", notice: '' }
        format.json { render json: @projet.errors }
      end
    end
  end
end
