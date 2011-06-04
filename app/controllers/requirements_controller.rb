class RequirementsController < ApplicationController
  load_resource :major
  load_resource :requirement_group, :through => :major
  load_and_authorize_resource :through => :requirement_group

  respond_to :js

  def create
    @requirement.save

    respond_with @requirement
  end

  def update
    @requirement.update_attributes params[:requirement]

    respond_with @requirement do |format|
      format.json
    end
  end

  def destroy
    @requirement.destroy

    respond_with @requirement
  end

end
