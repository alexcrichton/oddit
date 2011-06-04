class RequirementGroupsController < ApplicationController
  load_resource :major
  load_and_authorize_resource :through => :major

  respond_to :js

  def create
    @requirement_group.save

    respond_with @requirement_group
  end

  def update
    @requirement_group.update_attributes params[:requirement_group]

    respond_with @requirement_group do |format|
      format.json
    end
  end

  def destroy
    @requirement_group.destroy

    respond_with @requirement_group
  end

end
