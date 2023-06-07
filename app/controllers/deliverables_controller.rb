class DeliverablesController < ApplicationController
  before_action :set_deliverable, only: %i[  edit update destroy ]
  before_action :sanitize_params, only: %i[ edit update ]
 
  require 'digest'
  
  def new
    @deliverable = Deliverable.new
  end

  def create
    arguments = deliverable_params.except(:deliverable_type).to_h.symbolize_keys
    arguments[:course_id] = session[:course_id]
    @deliverable = DeliverableFactory.new.create_activity(deliverable_params[:deliverable_type],deliverable_params, arguments)

    if @deliverable
      flash[:notice] = "#{deliverable_params[:deliverable_type]} successfully created."
      redirect_to course_path(session[:course_id])
     
    else
      flash[:error] = @deliverable.errors
      redirect_to course_path(session[:course_id])
    end
  end

  def show
    if @deliverable = klass.find(params[:id])  
      if @deliverable.hashfile==Digest::SHA256.hexdigest((@deliverable.encrypted_file))
  
        key=Key.find_by(deliverable_id: @deliverable.id)
        decrypted_data = AESCrypt.decrypt(@deliverable.encrypted_file,key.key)
      else 
        flash[:notice]="The file has been manipulated. It is not the same as uploaded."   
        redirect_to course_path(session[:course_id])
      end
    end 
  end
  def decrypt
    
    @deliverable = klass.find(params[:id])
  
    key=Key.find_by(deliverable_id: @deliverable)
    decrypted_data = AESCrypt.decrypt(@deliverable.encrypted_file,key.key)   
    send_data decrypted_data,  filename: "#{@deliverable.title}", disposition: 'attachment'
  
    return @deliverable
  end
  
    def update
      @deliverable = klass.find(params[:id])
     
        file_contents= File.read(deliverable_params[:encrypted_file])
        new_key = OpenSSL::Cipher.new('AES-256-CBC').random_key
        encrypted_data = AESCrypt.encrypt(file_contents,new_key)
        if @deliverable.update(title: deliverable_params[:title], description: deliverable_params[:description], instructions: deliverable_params[:instructions], type: deliverable_params[:type], encrypted_file: encrypted_data.force_encoding('UTF-8'), hashfile:Digest::SHA256.hexdigest(encrypted_data), weight: deliverable_params[:weight])
      
          key=Key.find_by(deliverable_id: @deliverable.id)
          key.update_attribute(:key, new_key)
        
          flash[:notice] = "#{Deliverable.name} was successfully updated."
          redirect_to course_path(session[:course_id])
      else
        flash[:error] = @deliverable.errors
        redirect_to course_path(session[:course_id])
      end
    end

  def destroy
    
    key=Key.find_by(deliverarable_id: @deliverable.id)
    key.destroy
    @deliverable.destroy
    flash[:notice] = "#{klass.name} was successfully destroyed."
    redirect_to course_path(session[:course_id])
  end

  private
  def set_deliverable
    @deliverable = klass.find(params[:id])
  end

  def sanitize_params
    if params.has_key? :quiz
      params[:deliverable] = params.delete :quiz
    elsif params.has_key? :assignment
      params[:deliverable] = params.delete :assignment
    elsif params.has_key? :tutorial
      params[:deliverable] = params.delete :tutorial
    end
  end

  def klass
    Object.const_get params[:controller].classify
  end

  def deliverable_params
    params.require(klass.name.underscore.to_sym).permit(:title, :instructions, :weight, :deliverable_type, :encrypted_file, :course_id, :hashfile)
  end
end
