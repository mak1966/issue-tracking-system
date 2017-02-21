class Project
    include Mongoid::Document
    include Mongoid::Timestamps::Updated
    
    validates_presence_of :name, :description
    
    field :name, type: String
    field :description, type: String
    
    has_many :issues, dependent: :delete
end