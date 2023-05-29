class ResourceFactory < ActivityFactory
  require 'aescrypt'
  require 'stringio'
  require 'digest'
  include ActiveModel::Model

  def initialize; end

  def create_activity(type, resource_params, **kwargs)
    case type
    when "Url"
    
      url=Url.new(title: kwargs[:title],description: kwargs[:description],hyperlink: kwargs[:hyperlink], course_id: kwargs[:course_id])
      # document.update(encrypted_file: resource_params[:encrypted_file])
      file_contents= File.read(resource_params[:encrypted_file])
      key = OpenSSL::Cipher.new('AES-128-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,key)
  
    url.encrypted_file=encrypted_data
    url.hashfile= Digest::SHA256.hexdigest(encrypted_data)
   
    if url.hashfile==Digest::SHA256.hexdigest(file_contents)
      url.save
      url.key= Key.create(key: key, resource_id: url.id)
      return  url
      else  
       puts "Key not saved"
      end
       
    when "Video"
      
      video=Video.new(title: kwargs[:title],description: kwargs[:description],hyperlink: kwargs[:hyperlink], course_id: kwargs[:course_id])
     
      file_contents = File.read(resource_params[:encrypted_file])
       #  file_contents = uploaded_file.read
      key = OpenSSL::Cipher.new('AES-128-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,key)
  
      video.encrypted_file=encrypted_data
      video.hashfile= Digest::SHA256.hexdigest(encrypted_data)
     
    if video.hashfile==Digest::SHA256.hexdigest(file_contents)
      video.save
      video.key= Key.create(key: key, resource_id: video.id)
      return  video
     else  
      puts "Key not saved"
     end
       
    when "Document"
      document=Document.new(title: kwargs[:title],description: kwargs[:description],hyperlink: kwargs[:hyperlink], course_id: kwargs[:course_id])
  
      file_contents= File.read(resource_params[:encrypted_file])
      key = OpenSSL::Cipher.new('AES-256-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,key)

      document.encrypted_file=encrypted_data.force_encoding('UTF-8')
      document.hashfile= Digest::SHA256.hexdigest(encrypted_data)
     
      if document.hashfile==Digest::SHA256.hexdigest(encrypted_data)
          document.save
          document.key= Key.create(key: key, resource_id: document.id)
   
     return  document
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
  params.require(:document).permit(:title,:description,:hyperlink,:course_id, :encrypted_file,:hashfile)
end