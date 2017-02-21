class Comment
    include Mongoid::Document
    include Mongoid::Timestamps::Updated
    
    validates_presence_of :name, :body
    
    field :name, type: String
    field :body, type: String
    
    embedded_in :issues, inverse_of: :comments
end