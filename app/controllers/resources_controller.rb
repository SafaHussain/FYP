class ResourcesController < ApplicationController
  before_action :set_resource, only: %i[ show edit update destroy ]
  before_action :sanitize_params, only: %i[ edit update ]
  attr_accessor :encrypted_file
  
  def new
    @resource = Resource.new
  end

  def create
    arguments = resource_params.except(:type).to_h.symbolize_keys
    arguments[:course_id] = session[:course_id]
    @resource = ResourceFactory.new.create_activity(resource_params[:type],resource_params, arguments)
    
    if @resource
    #  @resource = ResourceFactory.new.create_activity(resource_params[:resource_type], arguments)
    
     flash[:notice] = "#{resource_params[:resource_type]} successfully created."
     redirect_to course_path(session[:course_id])
    else
      flash[:error] = @resource.errors
      redirect_to course_path(session[:course_id])
    end
  
end
def decrypt
    
  @resource = klass.find(params[:id])
  file_id = params[:id]
  uploaded_file = Resource.find(file_id)
  
  key=Key.find_by(resource_id: uploaded_file)
  decrypted_data = AESCrypt.decrypt(uploaded_file.encrypted_file,key.key)   
send_data decrypted_data, title:@resource.title
end

  def update
    if @resource.update(resource_params)
      flash[:notice] = "#{Resource.name} was successfully updated."
      redirect_to course_path(session[:course_id])
    else
      flash[:error] = @resource.errors
      redirect_to course_path(session[:course_id])
    end
  end

  def destroy
    @resource.destroy
    flash[:notice] = "#{klass.name} was successfully destroyed."
    redirect_to course_path(session[:course_id])
  end

  private
  def set_resource
    @resource = klass.find(params[:id])
  #   file_id = params[:id]
  #  uploaded_file = Resource.find(file_id)
  #  key=Key.find_by(resource_id: uploaded_file)
  #  decrypted_data = AESCrypt.decrypt(uploaded_file.encrypted_file,key.key)   
 
  #  send_data decrypted_data, title: uploaded_file.title,description: uploaded_file.description,hyperlink:uploaded_file.hyperlink
  # ,encrypted_file: uploaded_file.encrypted_file
  end
  
  def sanitize_params
    if params.has_key? :video
      params[:resource] = params.delete :video
    elsif params.has_key? :url
      params[:resource] = params.delete :url
    elsif params.has_key? :document
      params[:resource] = params.delete :document
    end
  end

  def klass
    Object.const_get params[:controller].classify
  end

  def resource_params
    params.require(klass.name.underscore.to_sym).permit(:title, :description, :hyperlink, :type, :course_id, :encrypted_file)
  end
  
end
