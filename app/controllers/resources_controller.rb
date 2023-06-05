class ResourcesController < ApplicationController

  require 'digest'
  before_action :set_resource, only: %i[ edit update destroy ]
  # before_action :set_resource, only: %i[ show edit update destroy ]
  before_action :sanitize_params, only: %i[ edit update ]
  attr_accessor :encrypted_file
  
  def new
    @resource = Resource.new
  end

  def create
    arguments = resource_params.except(:type).to_h.symbolize_keys
    arguments[:course_id] = session[:course_id]
     @resource=ResourceFactory.new.create_activity(resource_params[:type],resource_params, arguments)
  
    if @resource
     
     flash[:notice] = "#{resource_params[:resource_type]} successfully created."
     redirect_to course_path(session[:course_id])
    else
      flash[:error] = @resource.errors
      redirect_to course_path(session[:course_id])
    end
  
end

def show
  if @resource = klass.find(params[:id])  
  
  file_id = params[:id]
  uploaded_file = Resource.find(file_id)

  if @resource.hashfile==Digest::SHA256.hexdigest((@resource.encrypted_file))

  key=Key.find_by(resource_id: uploaded_file)
  decrypted_data = AESCrypt.decrypt(uploaded_file.encrypted_file,key.key)
#  redirect_to resource_path(@resource.id)
  else 
    flash[:notice]="The file has been manipulated. It is not the same as uploaded."   
    redirect_to course_path(session[:course_id])
   end
 end 

end


def decrypt
    
  @resource = klass.find(params[:id])
  uploaded_file = Resource.find(params[:id])
  
  key=Key.find_by(resource_id: uploaded_file)
  decrypted_data = AESCrypt.decrypt(uploaded_file.encrypted_file,key.key)   
  send_data decrypted_data,  filename: "#{@resource.title}", disposition: 'attachment'

  return @resource
end

  def update
    @resource = klass.find(params[:id])
   
      file_contents= File.read(resource_params[:encrypted_file])
      new_key = OpenSSL::Cipher.new('AES-256-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,new_key)
      if @resource.update(title: resource_params[:title], description: resource_params[:description], hyperlink: resource_params[:hyperlink], type: resource_params[:type], encrypted_file: encrypted_data.force_encoding('UTF-8'), hashfile:Digest::SHA256.hexdigest(encrypted_data))
    
        key=Key.find_by(resource_id: @resource.id)
        key.update_attribute(:key, new_key)
      
        flash[:notice] = "#{Resource.name} was successfully updated."
        redirect_to course_path(session[:course_id])
    else
      flash[:error] = @resource.errors
      redirect_to course_path(session[:course_id])
    end
  end

  def destroy
    key=Key.find_by(resource_id: @resource.id)
    key.destroy
    @resource.destroy
   
    flash[:notice] = "#{klass.name} was successfully destroyed."
    redirect_to course_path(session[:course_id])
  end

  private

  def set_resource
    @resource = klass.find(params[:id])
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
    params.require(klass.name.underscore.to_sym).permit(:title, :description, :hyperlink, :type, :course_id, :encrypted_file, :hashfile)
  end
  
end
