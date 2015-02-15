require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'uri'

require_relative 'models/taskwarrior'

set :port, 4488
also_reload 'app/models/taskwarrior.rb'
also_reload 'app/models/task.rb'
also_reload 'app/models/project.rb'

get '/' do
  tw               = TaskWarrior.new
  @all_tasks_count = tw.tasks.count
  @tasks           = tw.tasks
  @projects        = tw.projects
  @project_name    = 'all'

  haml :index
end

get '/project/:project' do
  tw               = TaskWarrior.new
  @all_tasks_count = tw.tasks.count
  @tasks           = tw.find_project(params[:project]).pending_tasks
  @projects        = tw.projects
  @project_name    = params[:project]

  haml :index
end

get '/task/:uuid/done' do
  tw = TaskWarrior.new
  task = tw.find_task_by_uuid(params[:uuid])
  task.complete!
  redirect to("/project/#{task.project.name}")
end
