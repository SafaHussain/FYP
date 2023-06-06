class DeliverableFactory < ActivityFactory
  include ActiveModel::Model

  def initialize; end

  def create_activity(type,deliverable_params, **kwargs)
    case type
    when "Quiz"
      # Quiz.find_or_create_by!(kwargs)
    
      quiz=Quiz.new(title: kwargs[:title],instructions: kwargs[:instructions], course_id: kwargs[:course_id])
     
      uploaded_file= File.read(deliverable_params[:encrypted_file])
      file_contents=uploaded_file
      key = OpenSSL::Cipher.new('AES-256-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,key)
  
      quiz.update_attribute(:encrypted_file, encrypted_data)
      if quiz.hashfile==Digest::SHA256.hexdigest(encrypted_data)
        quiz.save
        quiz.key= Key.create(key: key, deliverable_id: quiz.id)
        return  quiz
        else  
      puts "Key not saved"
     end
    
    
    when "Assignment"
      # Assignment.find_or_create_by!(kwargs)

      document=Assignment.new(title: kwargs[:title],instructions: kwargs[:instructions], course_id: kwargs[:course_id])
      
      uploaded_file= File.read(deliverable_params[:encrypted_file])
      file_contents=uploaded_file
      key = OpenSSL::Cipher.new('AES-256-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,key)
  
      document.update_attribute(:encrypted_file, encrypted_data)
      document.encrypted_file=encrypted_data
      document.hashfile= Digest::SHA256.hexdigest(encrypted_data)
     
      if document.hashfile==Digest::SHA256.hexdigest(encrypted_data)
        document.save
        document.key= Key.create(key: key, deliverable_id: document.id)
        return  document
        else  
      puts "Key not saved"
     end



    when "Tutorial"

      tutorial=Tutorial.new(title: kwargs[:title],instructions: kwargs[:instructions], course_id: kwargs[:course_id])
      
      uploaded_file= File.read(deliverable_params[:encrypted_file])
      file_contents=uploaded_file
      key = OpenSSL::Cipher.new('AES-256-CBC').random_key
      encrypted_data = AESCrypt.encrypt(file_contents,key)
  
      tutorial.update_attribute(:encrypted_file, encrypted_data)
      tutorial.encrypted_file=encrypted_data
      tutorial.hashfile= Digest::SHA256.hexdigest(encrypted_data)
     
      if tutorial.hashfile==Digest::SHA256.hexdigest(encrypted_data)
        tutorial.save
        tutorial.key= Key.create(key: key, deliverable_id: tutorial.id)
        return tutorial
      else  
        puts "Key not saved"
      end
    else
      raise NotImplementedError
    end
  end
end
