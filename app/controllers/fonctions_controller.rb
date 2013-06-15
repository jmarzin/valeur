# -*- coding: utf-8 -*-
require 'mareva'

class FonctionsController < ApplicationController
  # GET /fonctions/1
  # GET /fonctions/1.json
  def autofocus
    valeur = ""
    if params[:commit] then
      valeur = params[:commit]
    else
      code = params.key('Insv')
      code = params.key('Ins^') if not code
      code = params.key('Sup') if not code
      m = /^(.)(\D*)(\d+)/.match(code)
      if m[1] == 's' then
        if m[2] == 'actuelle' then
          if m[3].to_i == @etude.etude_rentabilite.fonction.situations[0].details.count then
            m[3] = m[3].prec
          end
        elsif m[3].to_i == @etude.etude_rentabilite.fonction.situations[1].details.count then
          m[3] =  (m[3].to_i - 1).to_s
        end
      elsif m[1] == 'b' then
        m[3] = m[3].succ
      end
      valeur = m[2]+m[3]
    end
  end
  private :autofocus

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
    @rentabilite=@etude.lit_rentabilite
    @fonction=@etude.lit_fonction
  end

  # PUT /fonctions/1
  # PUT /fonctions/1.json
  def update
    @etude = Etude.find(params[:id])
    respond_to do |format|
      @auto = autofocus
      params[:fonction][:situations_attributes]["0"] = @etude.somme_pourcent(params[:fonction][:situations_attributes]["0"])
      params[:fonction][:situations_attributes]["1"] = @etude.somme_pourcent(params[:fonction][:situations_attributes]["1"])
      if @etude.etude_rentabilite.fonction.update_attributes(params[:fonction])
        if params[:commit] then
          @etude.simplifie_fonction
          flash[:notice] = "Les impacts sur les coûts de fonctionnement ont bien été mis à jour."
          if params[:commit].capitalize == 'Actualiser' then
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
