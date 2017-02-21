require_relative "models/issue.rb"
require_relative "models/comment.rb"
require_relative "models/project.rb"

class App < Sinatra::Base
    enable :sessions
    register Sinatra::Flash
    register Sinatra::Partial
    use Rack::MethodOverride
    
    post "/issues/:id/comments" do
        @issue = Issue.find params[:id]
        if @issue.comments.create params[:comment]
            redirect "/issues/#{params[:id]}"
        else
            render "/issues/#{params[:id]}"
        end
            
    end
    
    get "/" do
        redirect "/issues"
    end
    

    get "/issues/" do
        redirect "/issues"
    end
    
    get "/issues" do
        total_issues = 10
        
        if is_numeric? params[:page]
            current_page = params[:page].to_i
            if current_page <= 0 
                redirect "/issues?page=1"
            end
        else
            redirect "/issues?page=1"
        end
        
        @issues = Issue.limit(total_issues).skip((current_page - 1) * total_issues).all
        
        last_page = Issue.count / total_issues
        last_page += Issue.count % total_issues ? 1 : 0
        
        if current_page > last_page
            redirect "/issues?page=1"
        end
        
        @pagination = OpenStruct.new({
            current_page: current_page,
            last_page: last_page
        })
        haml :"issues/index"
    end
    
    get "/issues/new" do
        
        @issue = Issue.new
        haml :"issues/new"
    end

    get "/issues/:id" do
        @issue = Issue.find params[:id]
        haml :"/issues/show"
    end
    
    post "/issues" do
        @issue = Issue.new params[:issue]
        if @issue.save
           redirect "/issues"
        else
           haml :"issues/new"       
        end
    end
    
    get "/issues/:id/edit" do
        @issue = Issue.find params[:id]
        haml :"issues/edit" 
    end
    
    put "/issues/:id" do
        @issue = Issue.find params[:id]
        if @issue.update_attributes params[:issue]
           redirect "/issues"
        else
            haml :"issues/edit"
        end    
    end
    
    get "/issues/:id/delete" do
        @issue = Issue.find params[:id]
        if @issue.remove
           redirect "/issues"
        end        
    end
    
    #============= Projects =====================
    
    get "/projects/" do
        redirect "/projects"
    end

    get "/projects" do
        total_projects = 5
        
        if is_numeric? params[:page]
            current_page = params[:page].to_i
            if current_page <= 0 
                redirect "/projects?page=1"
            end
        else
            redirect "/projects?page=1"
        end
        
        @projects = Project.limit(total_projects).skip((current_page - 1) * total_projects).all
        
        last_page = Project.count / total_projects
        last_page += Project.count % total_projects ? 1 : 0
        
        if current_page > last_page
            redirect "/projects?page=1"
        end
        
        @pagination = OpenStruct.new({
            current_page: current_page,
            last_page: last_page
        })
        haml :"projects/index"
    end    
    
    get "/projects/new" do
        @project = Project.new
        haml :"projects/new"
    end
    
    post "/projects" do
        @project = Project.new params[:project]
        if @project.save
           redirect "/projects"
        else
           haml :"projects/new"       
        end
    end
    
    get "/projects/:id" do
        @project = Project.find params[:id]
        haml :"/projects/show"
    end
    
    get "/projects/:id/edit" do
        @project = Project.find params[:id]
        haml :"projects/edit" 
    end
    
    put "/projects/:id" do
        @project = Project.find params[:id]
        if @project.update_attributes params[:project]
           redirect "/projects"
        else
            haml :"projects/edit"
        end    
    end
    
    get "/projects/:id/delete" do
        @project = Project.find params[:id]
        if @project.remove
           redirect "/projects"
        end        
    end
    
    private
        def is_numeric?(obj) 
           obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
        end    
end 