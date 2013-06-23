# -*- coding: utf-8 -*-
require 'mareva'

class GainsController < ApplicationController

  def autofocus
    valeur = ""
    if params[:commit] then
      valeur = params[:commit]
    else
      code = params.key('Insv')
      code = params.key('Ins^') if not code
      code = params.key('Sup') if not code
      m = /^(.)(\D*)(\d+)/.match(code)
      ligne = m[3]
      if m[1] == 's' then
        if ligne.to_i == @etude.etude_rentabilite.gain.details.count then
          ligne =  (ligne.to_i - 1).to_s
        end
      elsif m[1] == 'b' then
        ligne = ligne.succ
      end
      valeur = m[2]+ligne
    end
  end
  private :autofocus

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
      @auto = autofocus
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
