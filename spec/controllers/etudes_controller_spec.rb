require 'spec_helper'

# that an instance is receiving a specific message.

describe EtudesController do

  before(:each) { @projet = FactoryGirl.create(:projet) }
  # This should return the minimal set of attributes required to create a valid
  # Etude. As you add validations to Etude, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "stade" => "projet" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EtudesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all etudes as @etudes" do
      etude = @projet.etudes.create! valid_attributes
      get :index, {}, valid_session
      assigns(:projet_etudes).should eq([etude])
    end
  end

  describe "GET show" do
    it "assigns the requested etude as @etude" do
      etude = @projet.etudes.create! valid_attributes
      get :show, {:id => etude.to_param}, valid_session
      assigns(:etude).should eq(etude)
    end
  end

  describe "GET new" do
    it "assigns a new etude as @etude" do
      get :new, {}, valid_session
      assigns(:etude).should be_a_new(Etude)
    end
  end

  describe "GET edit" do
    it "assigns the requested etude as @etude" do
      etude = @projet.etudes.create! valid_attributes
      get :edit, {:id => etude.to_param}, valid_session
      assigns(:etude).should eq(etude)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Etude" do
        expect {
          post :create, {:etude => valid_attributes}, valid_session
        }.to change(Etude, :count).by(1)
      end

      it "assigns a newly created etude as @etude" do
        post :create, {:etude => valid_attributes}, valid_session
        assigns(:etude).should be_a(Etude)
        assigns(:etude).should be_persisted
      end

      it "redirects to the created etude" do
        post :create, {:etude => valid_attributes}, valid_session
        response.should redirect_to(Etude.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved etude as @etude" do
        # Trigger the behavior that occurs when invalid params are submitted
        Etude.any_instance.stub(:save).and_return(false)
        post :create, {:etude => { "stade" => "invalid value" }}, valid_session
        assigns(:etude).should be_a_new(Etude)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Etude.any_instance.stub(:save).and_return(false)
        post :create, {:etude => { "stade" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested etude" do
        etude = @projet.etudes.create! valid_attributes
        # Assuming there are no other etudes in the database, this
        # specifies that the Etude created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Etude.any_instance.should_receive(:update_attributes).with({ "stade" => "MyString" })
        put :update, {:id => etude.to_param, :etude => { "stade" => "MyString" }}, valid_session
      end

      it "assigns the requested etude as @etude" do
        etude = @projet.etudes.create! valid_attributes
        put :update, {:id => etude.to_param, :etude => valid_attributes}, valid_session
        assigns(:etude).should eq(etude)
      end

      it "redirects to the etude" do
        etude = @projet.etudes.create! valid_attributes
        put :update, {:id => etude.to_param, :etude => valid_attributes}, valid_session
        response.should redirect_to(etude)
      end
    end

    describe "with invalid params" do
      it "assigns the etude as @etude" do
        etude = @projet.etudes.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Etude.any_instance.stub(:save).and_return(false)
        put :update, {:id => etude.to_param, :etude => { "stade" => "invalid value" }}, valid_session
        assigns(:etude).should eq(etude)
      end

      it "re-renders the 'edit' template" do
        etude = @projet.etudes.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Etude.any_instance.stub(:save).and_return(false)
        put :update, {:id => etude.to_param, :etude => { "stade" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested etude" do
      etude = @projet.etudes.create! valid_attributes
      expect {
        delete :destroy, {:id => etude.to_param}, valid_session
      }.to change(Etude, :count).by(-1)
    end

    it "redirects to the etudes list" do
      etude = @projet.etudes.create! valid_attributes
      delete :destroy, {:id => etude.to_param}, valid_session
      response.should redirect_to(etudes_url)
    end
  end
end
