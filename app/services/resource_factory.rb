class ResourceFactory < ActivityFactory
  require 'aescrypt'
  require 'stringio'
  include ActiveModel::Model

  def initialize; end

  def create_activity(type, resource_params, **kwargs)
    case type
    when "Url"
    
      url=Url.new(title: kwargs[:title],description: kwargs[:description],hyperlink: kwargs[:hyperlink], course_id: kwargs[:course_id])
      # document.update(encrypted_file: resource_params[:encrypted_file])
      uploaded_file= File.read(resource_params[:encrypted_file].tempfile)
 
     file_contents=uploaded_file
    #  file_contents = uploaded_file.read
     key = OpenSSL::Cipher.new('AES-128-CBC').random_key
    encrypted_data = AESCrypt.encrypt(file_contents,key)
  
    url.update_attribute(:encrypted_file, encrypted_data)
    url.save
       
    when "Video"
      
      video=Video.new(title: kwargs[:title],description: kwargs[:description],hyperlink: kwargs[:hyperlink], course_id: kwargs[:course_id])
      uploaded_file= File.read(resource_params[:encrypted_file].tempfile)
 
     file_contents=uploaded_file
    #  file_contents = uploaded_file.read
     key = OpenSSL::Cipher.new('AES-128-CBC').random_key
    encrypted_data = AESCrypt.encrypt(file_contents,key)
  
    video.update_attribute(:encrypted_file, encrypted_data)
    video.save 
       
    when "Document"
      document=Document.new(title: kwargs[:title],description: kwargs[:description],hyperlink: kwargs[:hyperlink], course_id: kwargs[:course_id])
     
      uploaded_file= File.read(resource_params[:encrypted_file].tempfile)
      file_contents=uploaded_file
      key = OpenSSL::Cipher.new('AES-256-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,key)
  
      document.update_attribute(:encrypted_file, encrypted_data)
      uploaded_file = document
     if document.save
     
     document.key= Key.create(key: key, resource_id: document.id)
   
      debugger
     else  
      puts "Key not saved"
     end
         else
      raise NotImplementedError
    end
  end
end
private
def document_params
  params.require(:document).permit(:title,:description,:hyperlink,:course_id, :encrypted_file)
end