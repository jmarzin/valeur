# -*- coding: utf-8 -*-
require 'mareva'
require 'autofocus'

class DirectsController < ApplicationController

include Autofocus

  # GET /directs/1
  # GET /directs/1.json
  def show
    @etude = Etude.find(params[:id])
    @etude.lit_rentabilite
    @modif = Etude.modif_supp_apparents([@etude])[@etude._id][:modif]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /directs/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @direct = @etude.lit_direct_indirect('direct')
  end

  # PUT /directs/1
  # PUT /directs/1.json
  def update
    @etude = Etude.find(params[:id])
    respond_to do |format|
      @auto = autofocus(params,@etude.etude_rentabilite.direct.details.count,0)
      if @etude.etude_rentabilite.direct.update_attributes(params[:direct])
        if params[:commit] then
          @etude.etude_rentabilite.a_calculer = true
          @etude.simplifie_direct
          flash[:notice] = "Les coûts directs ont bien été mis à jour."
          if params[:commit].capitalize == 'Actualiser' then
            @direct = @etude.lit_direct_indirect('direct')
            format.html { render action: "edit"}
            format.json { head :no_content }
          else
            @modif = Etude.modif_supp_apparents([@etude])[@etude._id][:modif]
            format.html { render action: "show"}
            format.json { head :no_content }
          end
        else
          @direct = @etude.traite_touche(params)
          format.html { render action: "edit" }
          format.json { head :no_content }
        end
      else
        flash[:notice] = "Problème de mise à jour des coûts directs."
        format.html { render action: "edit", notice: '' }
        format.json { render json: @projet.errors }
      end
    end
  end
end
