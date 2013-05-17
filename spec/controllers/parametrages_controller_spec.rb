require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ParametragesController do

  # This should return the minimal set of attributes required to create a valid
  # Parametrage. As you add validations to Parametrage, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "ministere" => "MyString" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ParametragesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all parametrages as @parametrages" do
      parametrage = Parametrage.all.first
      get :index, {}, valid_session
      assigns(:parametrages).should eq([parametrage])
    end
  end

  describe "GET show" do
    it "assigns the requested parametrage as @parametrage" do
      parametrage = Parametrage.create! valid_attributes
      get :show, {:id => parametrage.to_param}, valid_session
      assigns(:parametrage).should eq(parametrage)
    end
  end

  describe "GET new" do
    it "assigns a new parametrage as @parametrage" do
      get :new, {}, valid_session
      assigns(:parametrage).should be_a_new(Parametrage)
    end
  end

  describe "GET edit" do
    it "assigns the requested parametrage as @parametrage" do
      parametrage = Parametrage.create! valid_attributes
      get :edit, {:id => parametrage.to_param}, valid_session
      assigns(:parametrage).should eq(parametrage)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Parametrage" do
        expect {
          post :create, {:parametrage => valid_attributes}, valid_session
        }.to change(Parametrage, :count).by(1)
      end

      it "assigns a newly created parametrage as @parametrage" do
        post :create, {:parametrage => valid_attributes}, valid_session
        assigns(:parametrage).should be_a(Parametrage)
        assigns(:parametrage).should be_persisted
      end

      it "redirects to the created parametrage" do
        post :create, {:parametrage => valid_attributes}, valid_session
        response.should redirect_to(Parametrage.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved parametrage as @parametrage" do
        # Trigger the behavior that occurs when invalid params are submitted
        Parametrage.any_instance.stub(:save).and_return(false)
        post :create, {:parametrage => { "ministere" => "invalid value" }}, valid_session
        assigns(:parametrage).should be_a_new(Parametrage)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Parametrage.any_instance.stub(:save).and_return(false)
        post :create, {:parametrage => { "ministere" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested parametrage" do
        parametrage = Parametrage.create! valid_attributes
        # Assuming there are no other parametrages in the database, this
        # specifies that the Parametrage created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Parametrage.any_instance.should_receive(:update_attributes).with({ "ministere" => "MyString" })
        put :update, {:id => parametrage.to_param, :parametrage => { "ministere" => "MyString" }}, valid_session
      end

      it "assigns the requested parametrage as @parametrage" do
        parametrage = Parametrage.create! valid_attributes
        put :update, {:id => parametrage.to_param, :parametrage => valid_attributes}, valid_session
        assigns(:parametrage).should eq(parametrage)
      end

      it "redirects to the parametrage" do
        parametrage = Parametrage.create! valid_attributes
        put :update, {:id => parametrage.to_param, :parametrage => valid_attributes}, valid_session
        response.should redirect_to(parametrage)
      end
    end

    describe "with invalid params" do
      it "assigns the parametrage as @parametrage" do
        parametrage = Parametrage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Parametrage.any_instance.stub(:save).and_return(false)
        put :update, {:id => parametrage.to_param, :parametrage => { "ministere" => "invalid value" }}, valid_session
        assigns(:parametrage).should eq(parametrage)
      end

      it "re-renders the 'edit' template" do
        parametrage = Parametrage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Parametrage.any_instance.stub(:save).and_return(false)
        put :update, {:id => parametrage.to_param, :parametrage => { "ministere" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested parametrage" do
      parametrage = Parametrage.create! valid_attributes
      expect {
        delete :destroy, {:id => parametrage.to_param}, valid_session
      }.to change(Parametrage, :count).by(-1)
    end

    it "redirects to the parametrages list" do
      parametrage = Parametrage.create! valid_attributes
      delete :destroy, {:id => parametrage.to_param}, valid_session
      response.should redirect_to(parametrages_url)
    end
  end

end
