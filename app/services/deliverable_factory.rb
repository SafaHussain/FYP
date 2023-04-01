class DeliverableFactory < ActivityFactory
  include ActiveModel::Model

  def initialize; end

  def create_activity(type,deliverable_params, **kwargs)
    case type
    when "Quiz"
      Quiz.find_or_create_by!(kwargs)
    when "Assignment"
      # Assignment.find_or_create_by!(kwargs)

      document=Assignment.new(title: kwargs[:title],instructions: kwargs[:instructions], course_id: kwargs[:course_id])
     
      uploaded_file= File.read(deliverable_params[:encrypted_file].tempfile)
      file_contents=uploaded_file
      key = OpenSSL::Cipher.new('AES-256-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,key)
  
      document.update_attribute(:encrypted_file, encrypted_data)
      uploaded_file = document
     if document.save
      # document.key=Key.create(key: key)
     else  
      puts "Key not saved"
     end



    when "Tutorial"
      Tutorial.find_or_create_by!(kwargs)
    else
      raise NotImplementedError
    end
  end
end
